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

	import org.gimmick.managers.IComponentTypeManager;

	/**
	 * Test case for ComponentTypeManager
	 */
	public class ComponentTypeManagerTest
	{

		private var _componentTypeManager:IComponentTypeManager;
		//======================================================================================================================
//{region											PUBLIC METHODS
		public function ComponentTypeManagerTest()
		{
		}

		[Before]
		public function setUp():void
		{
			_componentTypeManager = new GimmickConfig().componentTypeManager;
			_componentTypeManager.initialize(30);
		}

		[After]
		public function tearDown():void
		{
			_componentTypeManager.dispose();
			_componentTypeManager = null;
		}

		[Test]
		public function testGetType():void
		{
			var componentType:ComponentType = _componentTypeManager.getType(TestComponent);
			Assert.assertNotNull("ComponentType was not created", componentType);
			Assert.assertEquals("ComponentType index is bad", 0, componentType.index);
			Assert.assertEquals("ComponentType bit is bad", 0x1, componentType.bit);
			componentType = _componentTypeManager.getType(OtherTestComponent);
			Assert.assertNotNull("ComponentType was not created", componentType);
			Assert.assertEquals("ComponentType index is bad", 1, componentType.index);
			Assert.assertEquals("ComponentType bit is bad", 0x2, componentType.bit);
			Assert.assertEquals("Last bit is bad", 0x2, _componentTypeManager.lastBit);
		}

		[Test]
		public function testGetTypeByBit():void
		{
			var componentType:ComponentType = _componentTypeManager.getType(TestComponent);
			Assert.assertEquals(componentType, _componentTypeManager.getTypeByBit(componentType.bit));
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
class TestComponent{}
class OtherTestComponent{}