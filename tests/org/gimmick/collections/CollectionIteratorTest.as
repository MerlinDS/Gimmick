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

	public class CollectionIteratorTest extends EntitiesCollection
	{
		private var _entities:Vector.<IEntity>;
		private var _iterator:CollectionIterator;
		//======================================================================================================================
//{region											PUBLIC METHODS
		public function CollectionIteratorTest()
		{
		}

//} endregion PUBLIC METHODS ===========================================================================================
//======================================================================================================================
//{region										PRIVATE\PROTECTED METHODS
		[Before]
		public function setUp():void
		{
			_entities = new <IEntity>[
				new TestEntity(),
				new TestEntity(),
				new TestEntity(),
				new TestEntity(),
				new TestEntity()
			];
			for(var i:int = 0; i < _entities.length; i++)
				this.push(_entities[i]);
			_iterator = new CollectionIterator();
			_iterator.targetCollection = this;

		}

		[After]
		public function tearDown():void
		{
			_iterator.targetCollection = null;
			_entities.length = 0;
			_entities = null;
			this.dispose();
		}

		[Test]
		public function testIterations():void
		{
			var i:int = _entities.length;
			for(_iterator.begin(); !_iterator.end(); _iterator.next())
			{
				Assert.assertNotNull(_iterator.current);
				i--;
			}

			Assert.assertEquals(0, i);
		}

		[Test]
		public function testCollection():void
		{
			Assert.assertNotNull(_iterator.collection);
			Assert.assertEquals(this, _iterator.collection);
		}
//} endregion PRIVATE\PROTECTED METHODS ================================================================================
//======================================================================================================================
//{region											GETTERS/SETTERS

//} endregion GETTERS/SETTERS ==========================================================================================

	}
}