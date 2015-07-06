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

	import org.flexunit.Assert;
	import org.gimmick.collections.IEntities;
	import org.gimmick.core.IEntity;
	import org.gimmick.utils.TestConfig;

	public class EntitiesManagerTest
	{

		private var _bits:uint;
		private var _entities:Vector.<IEntity>;
		private var _entitiesManager:EntitiesManager;
		//======================================================================================================================
//{region											PUBLIC METHODS
		public function EntitiesManagerTest()
		{
		}

		[Before]
		public function setUp():void
		{
			var testConfig:TestConfig = new TestConfig();
			_bits = testConfig.componentTypeManager.getType(TestComponent).bit;
			_entities = new <IEntity>[
				new TestEntity(0x0),
				new TestEntity(_bits),
				new TestEntity(_bits | (_bits << 1)),
				new TestEntity(_bits << 1),
				new TestEntity(_bits),
				new TestEntity(_bits << 1)
			];
			_entitiesManager = new EntitiesManager();
			_entitiesManager.initialize();

		}

		[After]
		public function tearDown():void
		{
			_entitiesManager.dispose();
			_entitiesManager = null;
		}

		[Test]
		public function testAddEntity():void
		{
			for(var i:int = 0; i < _entities.length; i++)
				_entitiesManager.addEntity(_entities[i]);
		}

		[Test]
		public function testRemoveEntity():void
		{
			for(var i:int = 0; i < _entities.length; i++)
				_entitiesManager.removeEntity(_entities[i]);
		}

		[Test]
		public function testChangeEntityActivation():void
		{
			this.testAddEntity();
			var i:int = _entities.length;
			var collection:IEntities = _entitiesManager.entities;
			//for start all entities are not active
			for(collection.begin(); !collection.end(); collection.next())
				i--;//bad iteration, all entities are passive, collection has no iterations
			Assert.assertEquals(_entities.length, i);
			//set all entities as activated
			for(i = 0; i < _entities.length; i++)
			{
				var entity:IEntity = _entities[0];
				entity.active = true;
				_entitiesManager.changeEntityActivity(entity);
			}
			//test active entities
			for(collection.begin(); !collection.end(); collection.next())
				i--;
			//All entities in list was activated
			Assert.assertEquals(0, i);

		}

		[Test]
		public function testGetCollection():void
		{
			var collection:IEntities = _entitiesManager.entities;
			for(collection.begin(); !collection.end(); collection.next()){}
		}

		[Test]
		public function testGetEntity():void
		{
			for(var i:int = 0; i < _entities.length; i++)
			{
				var entity:IEntity = _entities[i];
				//no matter which bitwise mask or active flag has entity
				Assert.assertNotNull(_entitiesManager.getEntity(entity.id));
				Assert.assertEquals(entity, _entitiesManager.getEntity(entity.id));
			}
			Assert.assertNull(_entitiesManager.getEntity('not added entity'));
		}

		[Test]
		public function testGetBitsCollection():void
		{
			var collection:IEntities = _entitiesManager.getEntities(TestComponent);
			var i:int;
			var entities:Vector.<TestEntity> = new <TestEntity>[];
			for(i = 0; i < _entities.length; i++)
			{
				if(_entities[i].bits & _bits)
					entities.push(_entities[i]);
			}
			//
			i = 0;
			for(collection.begin(); !collection.end(); collection.next())
			{
				Assert.assertEquals("Bad bits " + collection.current.bits, entities[i++], collection.current);
			}
			Assert.assertEquals("Not all entities was iterate", entities.length, i);
		}

//For future
		[Test(description="Not yet implemented")]
		public function testAddToCollection():void
		{
			_entitiesManager.addToCollection(_entities[0], null);
		}

		[Test(description="Not yet implemented")]
		public function testRemoveFromCollection():void
		{
			_entitiesManager.removeFromCollection(_entities[0], null);
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

import org.gimmick.core.IEntity;
import org.gimmick.utils.getUniqueId;

class TestComponent{}

class TestEntity implements IEntity
{

	private var _bits:uint;
	private var _id:String;
	private var _active:Boolean;
	public function TestEntity(bits:uint){
		_bits = bits;
		_id = getUniqueId();
	}
	public function add(component:Object):*{return null;}
	public function has(component:Class):Boolean{return false;}
	public function get(component:Class):*{return null;}
	public function remove(component:Class):void{}
	public function get name():String{return "";}
	public function get id():String{return _id;}
	public function get components():Array{return null;}
	public function set active(value:Boolean):void{_active = value;}
	public function get active():Boolean{return _active;}
	public function get bits():uint{return _bits;}
}