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
		private var _internalClone:EntitiesCollection;
		private var _externalClone:EntitiesCollection;

		private var _disposeCount:int;
		//======================================================================================================================
//{region											PUBLIC METHODS
		public function EntitiesCollectionTest()
		{
		}

		[Before]
		public function setUp():void
		{
			_entity = new TestEntity();
			_collection = new EntitiesCollection(10, this.disposingCallback);
			_internalClone = _collection.dependedClone() as EntitiesCollection;
			_externalClone = new EntitiesCollection(0);
			_collection.dependedClone(_externalClone);
		}

		[After]
		public function tearDown():void
		{
			_externalClone.dispose();
			_internalClone.dispose();
			_collection.dispose();
			Assert.assertEquals(3, _disposeCount);
			_disposeCount = 0;
			_collection = null;
			_internalClone = null;
			_externalClone = null;
		}

		[Test]
		public function testPush():void
		{
			_collection.push(_entity);
			//also entity must be added to clones
		}

		[Test]
		public function testHasId():void
		{
			this.testPush();
			Assert.assertTrue(_collection.hasId(_entity.id));
			Assert.assertFalse(_collection.hasId('bad id'));
			Assert.assertTrue(_internalClone.hasId(_entity.id));
			Assert.assertFalse(_internalClone.hasId('bad id'));
			Assert.assertTrue(_externalClone.hasId(_entity.id));
			Assert.assertFalse(_externalClone.hasId('bad id'));
		}

		[Test]
		public function testHasEntity():void
		{
			this.testPush();
			Assert.assertTrue(_collection.hasEntity(_entity));
			Assert.assertTrue(_internalClone.hasEntity(_entity));
			Assert.assertTrue(_externalClone.hasEntity(_entity));
			var entity:TestEntity = new TestEntity();
			Assert.assertFalse(_collection.hasEntity(entity));
			Assert.assertFalse(_internalClone.hasEntity(entity));
			Assert.assertFalse(_externalClone.hasEntity(entity));
		}

		[Test]
		public function testGetById():void
		{
			this.testPush();
			Assert.assertNotNull(_collection.getById(_entity.id));
			Assert.assertNull(_collection.getById('bad id'));
			Assert.assertNotNull(_internalClone.getById(_entity.id));
			Assert.assertNull(_internalClone.getById('bad id'));
			Assert.assertNotNull(_externalClone.getById(_entity.id));
			Assert.assertNull(_externalClone.getById('bad id'));
		}

		[Test]
		public function testPop():void
		{
			this.testPush();
			_collection.remove(_entity);
			//also entity must be removed from copy
			Assert.assertFalse(_collection.hasEntity(_entity));
			Assert.assertFalse(_internalClone.hasEntity(_entity));
			Assert.assertFalse(_externalClone.hasEntity(_entity));
		}

		[Test]
		public function testClear():void
		{
			this.testPush();
			_internalClone.clear();
			_externalClone.clear();
			Assert.assertFalse(_externalClone.hasEntity(_entity));
			Assert.assertFalse(_internalClone.hasEntity(_entity));
			//copy does not dispose parent content
			Assert.assertTrue(_collection.hasEntity(_entity));
			this.testPush();
			_collection.clear();
			//also must clear all copies
			Assert.assertFalse(_collection.hasEntity(_entity));
			Assert.assertFalse(_internalClone.hasEntity(_entity));
			Assert.assertFalse(_externalClone.hasEntity(_entity));
		}
//} endregion PUBLIC METHODS ===========================================================================================
//======================================================================================================================
//{region										PRIVATE\PROTECTED METHODS

		private function disposingCallback(collection:IEntities):void
		{
			Assert.assertNotNull(collection);
			_disposeCount++;
		}
//} endregion PRIVATE\PROTECTED METHODS ================================================================================
//======================================================================================================================
//{region											GETTERS/SETTERS

//} endregion GETTERS/SETTERS ==========================================================================================
	}
}
