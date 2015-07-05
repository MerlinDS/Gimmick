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

	public class EntitiesCollectionTest extends EntitiesCollection
	{

		private var _bits:uint;
		private var _collection:IEntitiesCollection;
		private var _entities:Vector.<IEntity>;
		//======================================================================================================================
//{region											PUBLIC METHODS
		public function EntitiesCollectionTest()
		{
			super (null, 0x0);
		}

		[Before]
		public function setUp():void
		{
			_bits = 0x1;
			_entities = new <IEntity>[
				new TestEntity(0x0),
				new TestEntity(_bits),
				new TestEntity(_bits | (_bits << 1)),
				new TestEntity(_bits << 1),
				new TestEntity(_bits),
				new TestEntity(_bits << 1)
			];
			_collection = new EntitiesCollection(_entities, _bits, this);
		}

		[After]
		public function tearDown():void
		{
			_collection.dispose();
			_collection = null;
			_entities.length = 0;
			_entities = null;
			_bits = 0x0;
		}

		[Test]
		public function testGetCollection():void
		{
			var entityCollection:IEntitiesCollection = _collection.getCollection();
			Assert.assertNotNull(entityCollection);
			Assert.assertEquals(_collection, entityCollection);

		}

		[Test]
		public function testIteration():void
		{
			var i:int;
			var entities:Vector.<TestEntity> = new <TestEntity>[];
			for(i = 0; i < _entities.length; i++)
			{
				if(_entities[i].bits & _bits)
					entities.push(_entities[i]);
			}
			//
			i = 0;
			for(_collection.begin(); !_collection.end(); _collection.next())
			{
				Assert.assertEquals("Bad bits "+_collection.current.bits, entities[i++], _collection.current);
			}
			Assert.assertEquals("Not all entities was iterate", entities.length, i);
		}
//} endregion PUBLIC METHODS ===========================================================================================
//======================================================================================================================
//{region										PRIVATE\PROTECTED METHODS

		override public function getCollection(...types):IEntitiesCollection
		{
			return _collection;
		}

//} endregion PRIVATE\PROTECTED METHODS ================================================================================
//======================================================================================================================
//{region											GETTERS/SETTERS

//} endregion GETTERS/SETTERS ==========================================================================================
	}
}

import org.gimmick.core.IEntity;
//class TestComponent{}
class TestEntity implements IEntity
{

	private var _bits:uint;
	public function TestEntity(bits:uint){_bits = bits;}
	public function add(component:Object):*{return null;}
	public function has(component:Class):Boolean{return false;}
	public function get(component:Class):*{return null;}
	public function remove(component:Class):void{}
	public function get name():String{return "";}
	public function get id():String{return "";}
	public function get components():Array{return null;}
	public function set active(value:Boolean):void{}
	public function get active():Boolean{return false;}
	public function get bits():uint{return _bits;}
}