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

	public class CollectionIteratorTest
	{
		private var _bits:uint;
		private var _entities:Vector.<IEntity>;
		private var _iterator:EntitiesCollection;
		private var _forEachCount:int;
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
			_bits = 0x1;
			_entities = new <IEntity>[
				new TestEntity(_bits << 1),
				new TestEntity(_bits),
				new TestEntity(_bits << 1 | _bits),
				new TestEntity(_bits << 1),
				new TestEntity(_bits),
				new TestEntity(_bits << 1)
			];
			_iterator = new EntitiesCollection(5);//for size increasing test
			for(var i:int = 0; i < _entities.length; i++)
				_iterator.push(_entities[i]);

		}

		[After]
		public function tearDown():void
		{
			_iterator.bits = 0x0;
			_entities.length = 0;
			_entities = null;
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
		public function testIterationsWithExcludes():void
		{
			var entities:Vector.<IEntity> = new <IEntity>[];
			for(var i:int = 0; i < _entities.length; i++)
			{
				if(_entities[i].bits & _bits)
					entities.push(_entities[i]);
			}
			i = 0;
			_iterator.bits = _bits;
			for(_iterator.begin(); !_iterator.end(); _iterator.next())
			{
				Assert.assertNotNull(_iterator.current);
				Assert.assertEquals(entities[i++], _iterator.current);
			}
			Assert.assertEquals(entities.length, i);
		}

		[Test(description="iterate collection with under cursor deleting")]
		public function testIterationWithD1():void
		{
			var i:int = _entities.length;
			for(_iterator.begin(); !_iterator.end(); _iterator.next())
			{
				_iterator.remove(_iterator.current);
//				Assert.assertNotNull(_iterator.current); Inplement this in need
				i--;
			}
			Assert.assertEquals(0, i);
		}

		[Test(description="iterate collection with deleting last component")]
		public function testIterationWithD2():void
		{
			var i:int = _entities.length;
			for(_iterator.begin(); !_iterator.end(); _iterator.next())
			{
				_iterator.remove(_entities[--i]);
				Assert.assertNotNull(_iterator.current);
			}
			Assert.assertEquals(_entities.length / 2 , i);
		}

		[Test(description="iterate collection with deleting after cursor")]
		public function testIterationWithD3():void
		{
			var i:int = 0;
			for(_iterator.begin(); !_iterator.end(); _iterator.next())
			{
				Assert.assertNotNull(_iterator.current);
				if(i > 0)
					_iterator.remove(_entities[i - 1]);
				i++;
			}
			Assert.assertEquals(_entities.length, i);
			i = 1;
			for(_iterator.begin(); !_iterator.end(); _iterator.next())
			{
				Assert.assertNotNull(_iterator.current);
				i--;
			}
			Assert.assertEquals(0, i);
		}

		[Test]
		public function testForEach():void
		{
			_forEachCount = 0;
			_iterator.bits = 0x0;
			_iterator.forEach(this.forEachCallback, this);
			Assert.assertEquals(_entities.length, _forEachCount);
		}

//} endregion PRIVATE\PROTECTED METHODS ================================================================================
//======================================================================================================================
//{region											GETTERS/SETTERS
		private function forEachCallback(entity:IEntity, entities:IEntities):void
		{
			Assert.assertNotNull(entity);
			Assert.assertEquals(_iterator, entities);
			_forEachCount++;
		}

//} endregion GETTERS/SETTERS ==========================================================================================

	}
}
