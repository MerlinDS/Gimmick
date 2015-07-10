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

package org.gimmick.collections
{

	import flexunit.framework.Assert;

	import org.gimmick.core.IEntity;
	import org.gimmick.utils.TestEntity;

	public class EntitiesCollectionTest
	{

		private var _entity:IEntity;
		private var _collection:EntitiesCollection;
		private var _copy:EntitiesCollection;
		//======================================================================================================================
//{region											PUBLIC METHODS
		public function EntitiesCollectionTest()
		{
		}

		[Before]
		public function setUp():void
		{
			_entity = new TestEntity();
			_collection = new EntitiesCollection();
			_copy = _collection.dependedClone() as EntitiesCollection;
		}

		[After]
		public function tearDown():void
		{
			_copy.dispose();
			_collection.dispose();
			_collection = null;
			_copy = null;
		}

		[Test]
		public function testPush():void
		{
			_collection.push(_entity);
			//also entity must be added to copy
		}

		[Test]
		public function testHasId():void
		{
			this.testPush();
			Assert.assertTrue(_collection.hasId(_entity.id));
			Assert.assertFalse(_collection.hasId('bad id'));
			Assert.assertTrue(_copy.hasId(_entity.id));
			Assert.assertFalse(_copy.hasId('bad id'));
		}

		[Test]
		public function testHasEntity():void
		{
			this.testPush();
			Assert.assertTrue(_collection.hasEntity(_entity));
			Assert.assertTrue(_copy.hasEntity(_entity));
			var entity:TestEntity = new TestEntity();
			Assert.assertFalse(_collection.hasEntity(entity));
			Assert.assertFalse(_copy.hasEntity(entity));
		}

		[Test]
		public function testGetById():void
		{
			this.testPush();
			Assert.assertNotNull(_collection.getById(_entity.id));
			Assert.assertNull(_collection.getById('bad id'));
			Assert.assertNotNull(_copy.getById(_entity.id));
			Assert.assertNull(_copy.getById('bad id'));
		}

		[Test]
		public function testPop():void
		{
			this.testPush();
			_collection.pop(_entity);
			//also entity must be removed from copy
			Assert.assertFalse(_collection.hasEntity(_entity));
			Assert.assertFalse(_copy.hasEntity(_entity));
		}

		[Test]
		public function testClear():void
		{
			this.testPush();
			_copy.clear();
			Assert.assertFalse(_copy.hasEntity(_entity));
			//copy does not dispose parent content
			Assert.assertTrue(_collection.hasEntity(_entity));
			this.testPush();
			_collection.clear();
			//also must clear all copies
			Assert.assertFalse(_collection.hasEntity(_entity));
			Assert.assertFalse(_copy.hasEntity(_entity));
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
