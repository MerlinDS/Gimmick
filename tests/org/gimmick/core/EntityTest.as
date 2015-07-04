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

	import org.gimmick.managers.ComponentsManager;
	import org.gimmick.managers.FiltersManager;

	/**
	 * Test case for basic methods of the Entity class
	 * For deep tests find in ComponentsManagerTest and FiltersManagerTest
	 */
	public class EntityTest
	{

		private var _entity:Entity;
		private var _entityName:String;
		private var _testComponent:TestComponent;
		//======================================================================================================================
//{region											PUBLIC METHODS
		public function EntityTest()
		{
		}

		[Before]
		public function setUp():void
		{
			_entityName = "Test entity";
			_entity = new Entity(_entityName);
			_testComponent = new TestComponent();
			_entity.componentTypeManager = new ComponentTypeManager();
			_entity.componentsManager = new ComponentsManager();
			_entity.filtersManager = new FiltersManager();
		}

		[After]
		public function tearDown():void
		{
			_entity.dispose();
			_entity = null;

		}

		[Test(order=1)]
		public function testAdd():void
		{
			_entity.add(_testComponent);
			//More tests in ComponentsManagerTest and FiltersManagerTest
		}

		[Test(description='will works correctly only after ComponentsManager code implementation')]
		public function testGet():void
		{
			this.testAdd();
			Assert.assertNull(_entity.get(NotAddedTestComponent));
			Assert.assertNotNull(_entity.get(TestComponent));
			Assert.assertEquals(_testComponent, _entity.get(TestComponent));
			//More tests in ComponentsManagerTest and FiltersManagerTest
		}


		[Test]
		public function testId():void
		{
			Assert.assertNotNull(_entity.id);
		}

		[Test(description='will works correctly only after ComponentsManager code implementation')]
		public function testComponents():void
		{
			Assert.assertNotNull(_entity.components);
			//More tests in ComponentsManagerTest
		}

		[Test]
		public function testHas():void
		{
			this.testAdd();
			Assert.assertFalse(_entity.has(NotAddedTestComponent));
			Assert.assertTrue(_entity.has(TestComponent));
		}

		[Test]
		public function testBits():void
		{
			Assert.assertEquals(0x0, _entity.bits);
			this.testAdd();
			Assert.assertEquals(0x1, _entity.bits);
			this.testRemove();
			Assert.assertEquals(0x0, _entity.bits);
		}

		[Test(description='will works correctly only after ComponentsManager code implementation')]
		public function testRemove():void
		{
			this.testAdd();
			_entity.remove(TestComponent);
			Assert.assertFalse(_entity.has(TestComponent));
			_entity.remove(NotAddedTestComponent);
		}

		[Test]
		public function testName():void
		{
			Assert.assertNotNull(_entity.name);
			Assert.assertEquals(_entityName, _entity.name);
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
class NotAddedTestComponent{}