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

	/**
	 * Unit test for SystemManager
	 */
	public class SystemManagerTest
	{

		private var _testSystem:TestSystem;
		private var _systemManager:SystemManager;
		//======================================================================================================================
//{region											PUBLIC METHODS
		public function SystemManagerTest()
		{
		}

		[Before]
		public function setUp():void
		{
			_testSystem = new TestSystem();
			_systemManager = new SystemManager();
			_systemManager.initialize();
		}

		[After]
		public function tearDown():void
		{
			_systemManager.dispose();
			_systemManager = null;
		}

		//normal tests
		[Test]
		public function testAddSystem():void
		{
			_systemManager.addSystem(_testSystem, 1);
		}

		[Test]
		public function testAddExistingSystem():void
		{
			this.testActivateSystem();//system need to be initialized and activated
			var newSystem:TestSystem = new TestSystem();
			_systemManager.addSystem(newSystem, 1);
			Assert.assertFalse(_testSystem.activated);
		}

		[Test]
		public function testRemoveSystem():void
		{
			this.testActivateSystem();
			_systemManager.removeSystem(TestSystem);
			Assert.assertFalse(_testSystem.activated);
			Assert.assertFalse(_testSystem.initialized);
		}

		[Test]
		public function testActivateSystem():void
		{
			this.testAddSystem();
			Assert.assertFalse(_testSystem.activated);
			_systemManager.activateSystem(TestSystem);
			Assert.assertTrue(_testSystem.activated);
		}

		[Test]
		public function testDeactivateSystem():void
		{
			this.testActivateSystem();
			_systemManager.deactivateSystem(TestSystem);
			Assert.assertFalse(_testSystem.activated);
		}

		[Test]
		public function testTick():void
		{
			this.testActivateSystem();
			Assert.assertEquals(0, _testSystem.ticksCount);
			_systemManager.tick(0);
			Assert.assertEquals(1, _testSystem.ticksCount);
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
//} endregion PUBLIC METHODS ===========================================================================================
//======================================================================================================================
//{region										PRIVATE\PROTECTED METHODS

//} endregion PRIVATE\PROTECTED METHODS ================================================================================
//======================================================================================================================
//{region											GETTERS/SETTERS

//} endregion GETTERS/SETTERS ==========================================================================================
	}
}

import org.gimmick.core.IEntitySystem;

class TestSystem implements IEntitySystem
{

	public var ticksCount:int;
	public var initialized:Boolean;
	public var activated:Boolean;

	public function tick(time:Number):void
	{
		if(this.initialized && this.activated)
			ticksCount++;
	}

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