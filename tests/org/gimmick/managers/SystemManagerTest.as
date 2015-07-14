/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2015 Andrew Salomatin (MerlinDS)
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

package org.gimmick.managers
{

	import flexunit.framework.Assert;

	import org.gimmick.collections.EntitiesCollection;

	import org.gimmick.collections.IEntities;
	import org.gimmick.utils.TestEntity;

	import org.gimmick.utils.getInstanceClass;

	/**
	 * Unit test for SystemManager
	 */
	public class SystemManagerTest
	{

		private var _entities:EntitiesCollection;
		private var _tickSystem:TestSystem;
		private var _processingSystem:TestProcessingSystem;
		private var _idleSystem:TestIdleSystem;
		private var _systemManager:SystemManager;
		//======================================================================================================================
//{region											PUBLIC METHODS
		public function SystemManagerTest()
		{
		}

		[Before]
		public function setUp():void
		{
			_entities = new EntitiesCollection(2);
			_entities.push(new TestEntity());
			_entities.push(new TestEntity());
			_processingSystem = new TestProcessingSystem(_entities);
			_tickSystem = new TestSystem();
			_idleSystem = new TestIdleSystem();
			_systemManager = new SystemManager();
			_systemManager.initialize(4);
		}

		[After]
		public function tearDown():void
		{
			while(TestIdleSystem.EXECUTION_ORDER.length > 0)
				TestIdleSystem.EXECUTION_ORDER.pop();
			_systemManager.dispose();
			_entities.dispose();
			_entities = null;
			_processingSystem = null;
			_systemManager = null;
		}

		//normal tests
		[Test]
		public function testAddSystem():void
		{
			_systemManager.addSystem(_tickSystem, 1);
			_systemManager.addSystem(_processingSystem, 2);
			_systemManager.addSystem(_idleSystem, 3);
		}

		[Test]
		public function testAddExistingSystem():void
		{
			this.testActivateSystem();//system need to be initialized and activated
			var newSystem:TestSystem = new TestSystem();
			_systemManager.addSystem(newSystem, 1);
			Assert.assertFalse(_tickSystem.activated);
		}

		[Test]
		public function testAddingSystemsWithPriority():void
		{
			var systems:Array = [
				new ThirdSystem(), 3,
				new FirstSystem(), 1,
				new SecondSystem(), 2,
				new TestProcessingSystem(_entities), 4
			];
			for(var i:int = 0; i < systems.length / 2; i++)
			{
				_systemManager.addSystem(systems[i * 2], systems[i * 2 + 1]);
				_systemManager.activateSystem(getInstanceClass(systems[i * 2]));
			}
			_systemManager.tick(0);
			for(i = 0; i < systems.length / 2; i++)
			{
				Assert.assertEquals(systems[i * 2], TestIdleSystem
						.EXECUTION_ORDER[ systems[i * 2 + 1] - 1 ]);
			}
		}

		[Test]
		public function testRemoveSystem():void
		{
			this.testActivateSystem();
			_systemManager.removeSystem(TestSystem);
			Assert.assertFalse(_tickSystem.activated);
			Assert.assertFalse(_tickSystem.initialized);
			_systemManager.removeSystem(TestProcessingSystem);
			Assert.assertFalse(_processingSystem.activated);
			Assert.assertFalse(_processingSystem.initialized);
		}

		[Test]
		public function testActivateSystem():void
		{
			this.testAddSystem();
			Assert.assertFalse(_tickSystem.activated);
			_systemManager.activateSystem(TestSystem);
			Assert.assertTrue(_tickSystem.activated);
			Assert.assertFalse(_processingSystem.activated);
			_systemManager.activateSystem(TestProcessingSystem);
			Assert.assertTrue(_processingSystem.activated);
		}

		[Test]
		public function testDeactivateSystem():void
		{
			this.testActivateSystem();
			_systemManager.deactivateSystem(TestSystem);
			Assert.assertFalse(_tickSystem.activated);
			_systemManager.deactivateSystem(TestProcessingSystem);
			Assert.assertFalse(_processingSystem.activated);
		}

		[Test]
		public function testTick():void
		{
			this.testActivateSystem();
			Assert.assertEquals(0, _tickSystem.ticksCount);
			_systemManager.tick(0);
			Assert.assertEquals(1, _tickSystem.ticksCount);
		}

		[Test]
		public function testProcess():void
		{
			this.testActivateSystem();
			Assert.assertEquals(0, _processingSystem.ticksCount);
			_systemManager.tick(0);
			Assert.assertEquals(2, _processingSystem.ticksCount);
		}

		//error tests

		[Test(expects="ArgumentError")]
		public function testRemoveError():void
		{
			_systemManager.removeSystem(TestSystem);
		}

		[Test(expects="ArgumentError")]
		public function testActivateError():void
		{
			_systemManager.activateSystem(TestSystem);
		}

		[Test(expects="ArgumentError")]
		public function testDeactivateError():void
		{
			_systemManager.deactivateSystem(TestSystem);
		}

		[Test(expects="ArgumentError")]
		public function testAddProcessingError():void
		{
			var badSystem:TestProcessingSystem = new TestProcessingSystem(null);
			_systemManager.addSystem(badSystem);
		}
//} endregion PUBLIC METHODS ===========================================================================================
//======================================================================================================================
//{region										PRIVATE\PROTECTED METHODS

//} endregion PRIVATE\PROTECTED METHODS ================================================================================
//======================================================================================================================
//{region											GETTERS/SETTERS

//} endregion GETTERS/SETTERS ==========================================================================================
	}
}

import org.flexunit.Assert;
import org.gimmick.collections.IEntities;
import org.gimmick.core.IEntity;
import org.gimmick.core.IEntitySystem;
import org.gimmick.core.IIdelSystem;
import org.gimmick.core.IProcessingSystem;

class TestIdleSystem implements IIdelSystem
{

	public static const EXECUTION_ORDER:Vector.<IIdelSystem> = new <IIdelSystem>[];

	public var initialized:Boolean;
	public var activated:Boolean;
	public var ticksCount:int;

	public function initialize():void
	{
		this.initialized = true;
	}

	public function dispose():void
	{
		this.initialized = false;
	}

	public function activate():void
	{
		this.activated = true;
	}

	public function deactivate():void
	{
		this.activated = false;
	}
}

class TestSystem extends TestIdleSystem implements IEntitySystem
{
	public function tick(time:Number):void
	{
		if(this.initialized && this.activated)
		{
			ticksCount++;
			EXECUTION_ORDER.push(this);
		}
	}
}

class TestProcessingSystem extends TestIdleSystem implements IProcessingSystem
{

	private var _entities:IEntities;

	public function TestProcessingSystem(entities:IEntities)
	{
		_entities = entities;
	}

	public function process(entity:IEntity, entities:IEntities):void
	{
		Assert.assertEquals(_entities, entities);
		_entities.hasEntity(entity);
		this.ticksCount++;
		if(EXECUTION_ORDER.indexOf(this) < 0)
			EXECUTION_ORDER.push(this);
	}

	public function get targetEntities():IEntities
	{
		return _entities;
	}
}

class FirstSystem extends TestSystem{}
class SecondSystem extends TestSystem{}
class ThirdSystem extends TestSystem{}
