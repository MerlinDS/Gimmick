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

		private var _group_0:String = "group_0";
		private var _group_1:String = "group_1";

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
			/*while(TestIdleSystem.EXECUTION_ORDER.length > 0)
				TestIdleSystem.EXECUTION_ORDER.pop();
			_systemManager.dispose();
			_entities.dispose();
			_entities = null;
			_processingSystem = null;
			_systemManager = null;*/
		}

		//normal tests
		[Test]
		public function testAddSystem():void
		{
			_systemManager.addSystem(_tickSystem, 1);
			Assert.assertTrue(_tickSystem.initialized);
			_systemManager.addSystem(_processingSystem, 2, _group_0, _group_1);
			Assert.assertTrue(_processingSystem.initialized);
			_systemManager.addSystem(_idleSystem, 3, _group_0);
			Assert.assertTrue(_idleSystem.initialized);
		}

		[Test]
		public function testActivateGroup_0():void
		{
			this.testAddSystem();
			TestIdleSystem.EXECUTION_ORDER.length = 0;
			//no systems was activated
			_systemManager.tick(0);
			Assert.assertFalse(_processingSystem.activated);
			Assert.assertFalse(_idleSystem.activated);
			Assert.assertFalse(_tickSystem.activated);
			Assert.assertEquals(0, TestIdleSystem.EXECUTION_ORDER.length);
			_systemManager.activateGroup(_group_0);
			//systems will be activated during first iteration
			_systemManager.tick(0);
			//all systems of group must be activated
			Assert.assertTrue(_processingSystem.activated);
			Assert.assertTrue(_idleSystem.activated);
			//_idleSystem system not iterate, only _processingSystem iterate
			Assert.assertEquals(1, TestIdleSystem.EXECUTION_ORDER.length);
			//but systems that not in current group can must be not activated
			Assert.assertFalse(_tickSystem.activated);
		}

		[Test]
		public function testActivateGroup_1():void
		{
			TestIdleSystem.EXECUTION_ORDER.length = 0;
			this.testActivateGroup_0();
			_systemManager.activateGroup(_group_1);
			/*
			 * Now only _processingSystem will be active
			 * But event till tick it will be deactivated to
			 */
			Assert.assertFalse(_processingSystem.activated);
			Assert.assertFalse(_idleSystem.activated);
			_systemManager.tick(0);
			Assert.assertTrue(_processingSystem.activated);
			Assert.assertEquals(1, TestIdleSystem.EXECUTION_ORDER.length);
		}

		[Test(description="Add existing system to the same group")]
		public function testAddExistingSystem0():void
		{
			this.testActivateGroup_0();//system need to be initialized and activated
			var entities:EntitiesCollection = new EntitiesCollection(2);
			entities.push(new TestEntity());
			entities.push(new TestEntity());
			var newSystem:TestProcessingSystem = new TestProcessingSystem(entities);
			_systemManager.addSystem(newSystem, 1, _group_0);
			Assert.assertTrue(newSystem.initialized);
			Assert.assertFalse(_processingSystem.initialized);
			Assert.assertFalse(_processingSystem.activated);
			Assert.assertFalse(newSystem.activated);
			Assert.assertTrue(_entities.isDisposed);//entities from previous system
			_systemManager.tick(0);
			Assert.assertTrue(newSystem.activated);
			_systemManager.activateGroup(_group_1);//newSystem not in this group
			_systemManager.tick(0);
			Assert.assertFalse(newSystem.activated);
		}

		[Test(description="Add existing system to same group but to the tail")]
		public function testAddExistingSystem1():void
		{
			this.testActivateGroup_0();//system need to be initialized and activated
			var entities:EntitiesCollection = new EntitiesCollection(2);
			entities.push(new TestEntity());
			entities.push(new TestEntity());
			var newSystem:TestProcessingSystem = new TestProcessingSystem(entities);
			_systemManager.addSystem(newSystem, 1, _group_1);
			Assert.assertTrue(newSystem.initialized);
			Assert.assertFalse(_processingSystem.initialized);
			Assert.assertFalse(_processingSystem.activated);
			Assert.assertFalse(newSystem.activated);
			Assert.assertTrue(_entities.isDisposed);//entities from previous system
			_systemManager.tick(0);
			Assert.assertFalse(newSystem.activated);
			_systemManager.activateGroup(_group_1);//newSystem in this group
			_systemManager.tick(0);
			Assert.assertTrue(newSystem.activated);
		}

		[Test(description="Add existing system to other group")]
		public function testAddExistingSystem2():void
		{
			this.testActivateGroup_0();//system need to be initialized and activated
			var newSystem:TestIdleSystem = new TestIdleSystem();
			_systemManager.addSystem(newSystem, 1, _group_1);
			Assert.assertTrue(newSystem.initialized);
			Assert.assertFalse(_idleSystem.initialized);
			Assert.assertFalse(_idleSystem.activated);
			Assert.assertFalse(newSystem.activated);
			_systemManager.tick(0);
			Assert.assertFalse(newSystem.activated);
			_systemManager.activateGroup(_group_1);//newSystem in this group
			_systemManager.tick(0);
			Assert.assertTrue(newSystem.activated);
		}



		[Test]
		public function testAddingSystemsWithPriority():void
		{
			TestIdleSystem.EXECUTION_ORDER.length = 0;
			var systems:Array = [
				new ThirdSystem(), 3,
				new FirstSystem(), 1,
				new SecondSystem(), 2,
				new TestProcessingSystem(_entities), 1
			];
			for(var i:int = 0; i < systems.length / 2; i++)
			{
				_systemManager.addSystem(systems[i * 2], systems[i * 2 + 1], _group_0);
			}
			_systemManager.activateGroup(_group_0);
			_systemManager.tick(0);
			Assert.assertEquals(systems[2], TestIdleSystem.EXECUTION_ORDER[ 0 ]);
			Assert.assertEquals(systems[6], TestIdleSystem.EXECUTION_ORDER[ 1 ]);
			Assert.assertEquals(systems[4], TestIdleSystem.EXECUTION_ORDER[ 2 ]);
			Assert.assertEquals(systems[0], TestIdleSystem.EXECUTION_ORDER[ 3 ]);

		}

		[Test]
		public function testRemoveSystem():void
		{
			this.testActivateGroup_0();
			_systemManager.removeSystem(TestProcessingSystem);
			Assert.assertFalse(_processingSystem.activated);
			Assert.assertFalse(_processingSystem.initialized);
		}

		[Test]
		public function testActivateSystem():void
		{
			this.testAddSystem();
			Assert.assertFalse(_processingSystem.activated);
			Assert.assertFalse(_tickSystem.activated);
			_systemManager.activateGroup(_group_0);
			_systemManager.activateSystem(TestSystem);
			_systemManager.tick(0);
			Assert.assertTrue(_tickSystem.activated);
			Assert.assertTrue(_processingSystem.activated);
		}

		[Test]
		public function testDeactivateSystem():void
		{
			this.testActivateSystem();
			TestIdleSystem.EXECUTION_ORDER.length = 0;
			_systemManager.deactivateSystem(TestSystem);
			Assert.assertFalse(_tickSystem.activated);
			_systemManager.deactivateSystem(TestProcessingSystem);
			Assert.assertFalse(_processingSystem.activated);
			_systemManager.tick(0);
			Assert.assertEquals(0, TestIdleSystem.EXECUTION_ORDER.length);
		}

		[Test]
		public function testTick():void
		{
			_systemManager.addSystem(_tickSystem, 1, _group_0);
			_systemManager.activateGroup(_group_0);
			_tickSystem.ticksCount = 0;
			Assert.assertEquals(0, _tickSystem.ticksCount);
			_systemManager.tick(0);
			Assert.assertEquals(1, _tickSystem.ticksCount);
		}

		[Test]
		public function testProcess():void
		{
			this.testActivateGroup_0();
			_processingSystem.ticksCount = 0;
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
import org.gimmick.core.IIdleSystem;
import org.gimmick.core.IProcessingSystem;

class TestIdleSystem implements IIdleSystem
{

	public static const EXECUTION_ORDER:Vector.<IIdleSystem> = new <IIdleSystem>[];

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
