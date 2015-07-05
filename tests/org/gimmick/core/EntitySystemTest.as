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

package org.gimmick.core
{

	import flexunit.framework.Assert;

	import org.gimmick.managers.GimmickConfig;

	/**
	 * Test case for EntitySystem
	 */
	public class EntitySystemTest extends EntitySystem
	{

		private var _initialized:Boolean;
		private var _disposed:Boolean;
		private var _activated:Boolean;
		private var _activationCount:int;
		//======================================================================================================================
//{region											PUBLIC METHODS
		public function EntitySystemTest()
		{
			super();
		}


		[Test]
		public function testInitialization():void
		{
			this.entities = new GimmickConfig().entityManager;
			Assert.assertTrue(_initialized);
			Assert.assertNotNull(this.entities);
		}


		[Test]
		public function testDisposing():void
		{
			this.entities = null;
			Assert.assertTrue(_disposed);
			Assert.assertNull(this.entities);
		}

		[Test]
		public function testActivation():void
		{
			Assert.assertFalse(_activated);
			Assert.assertFalse(this.active);
			this.active = true;
			Assert.assertTrue(_activated);
			Assert.assertTrue(this.active);
			this.active = true;
			Assert.assertEquals(1, _activationCount);
		}

		[Test]
		public function testDeactivation():void
		{
			this.testActivation();
			this.active = false;
			Assert.assertFalse(_activated);
			Assert.assertFalse(this.active);
		}
//} endregion PUBLIC METHODS ===========================================================================================
//======================================================================================================================
//{region										PRIVATE\PROTECTED METHODS

		override protected function initialize():void
		{
			_initialized = true;
		}

		override protected function dispose():void
		{
			_disposed = true;
		}

		override protected function activate():void
		{
			_activated = true;
			_activationCount++;
		}

		override protected function deactivate():void
		{
			_activated = false;
		}

//} endregion PRIVATE\PROTECTED METHODS ================================================================================
//======================================================================================================================
//{region											GETTERS/SETTERS

//} endregion GETTERS/SETTERS ==========================================================================================

	}
}
