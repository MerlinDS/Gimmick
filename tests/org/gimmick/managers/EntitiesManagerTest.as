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

	import flash.debugger.enterDebugger;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	import flexunit.framework.Assert;

	import org.gimmick.collections.IEntities;

	import org.gimmick.core.ComponentType;

	import org.gimmick.core.IEntity;
	import org.gimmick.utils.TestComponent_0;
	import org.gimmick.utils.TestComponent_1;
	import org.gimmick.utils.TestComponent_2;
	import org.gimmick.utils.TestConfig;
	import org.gimmick.utils.TestEntity;

	[RunWith("org.flexunit.runners.Parameterized")]
	public class EntitiesManagerTest
	{

		[Parameters]
		public static var testData:Array = _testData;

		private var _entities:Array;
		//
		private var _preinitedCollections:Dictionary;
		private var _addedEntities:Vector.<TestEntity>;

		private var _componentTypeManager:ComponentTypeManager;
		private var _entitiesManager:EntitiesManager;
		//======================================================================================================================
//{region											PUBLIC METHODS
		public function EntitiesManagerTest(entities:Array)
		{
			_entities = entities;
		}

		[Before]
		public function setUp():void
		{
			var testConfig:TestConfig = new TestConfig();
			_componentTypeManager = testConfig.componentTypeManager;
			_entitiesManager = new EntitiesManager();
			_entitiesManager.initialize(testConfig.maxEntities);
			_preinitedCollections = new Dictionary(true);
			_addedEntities = new <TestEntity>[];
			var i:int, n:int;
			n = _entities.length;
			for(i = 0; i < n; i++)
				_entities[i] = this.getType(_entities[i]);
		}

		[After]
		public function tearDown():void
		{
			_preinitedCollections = null;
			_componentTypeManager.dispose();
			_componentTypeManager = null;
			_entitiesManager.dispose();
			_entitiesManager = null;
		}

		[Test(order=1)]
		public function initializeCollections():void
		{
			for(var i:int = 0; i < _entities.length; i++)
			{
				var bits:uint = this.getBits(_entities[i]);
				//initialize collection
				var entities:IEntities = _entitiesManager.getEntities(_entities[i].concat());
				Assert.assertNotNull(entities);
				//on initialization will be returned base collection
				_preinitedCollections[bits] = entities;
			}
			//after initialize collections, notify manager that initializations was finished
			_entitiesManager.tick(0);
		}

		[Test(order=2)]
		public function addNewEntities():void
		{
			this.initializeCollections();
			for(var i:int = 0; i < _entities.length; i++)
			{
				var entity:TestEntity = new TestEntity();
				_addedEntities.push(entity);
				_entitiesManager.addEntity(entity);
			}
		}

		[Test(order=3)]
		public function updateEntities():void
		{
			this.addNewEntities();
			for(var i:int = 0; i < _entities.length; i++)
			{
				var entity:TestEntity = _addedEntities[i];
				var components:Array = _entities[i];
				for(var j:int = 0; j < components.length; j++)
				{
					var componentType:ComponentType = components[j];
					entity.bits |= componentType.bit;
					_entitiesManager.addEntity(entity, componentType);
				}
				var entities:IEntities = _preinitedCollections[entity.bits];
				Assert.assertNotNull(entities);
				Assert.assertTrue(entities.hasEntity(entity));
			}
		}

		[Test(order=4)]
		public function testDependedEntities():void
		{
			this.updateEntities();
			var collections:Vector.<IEntities> = new <IEntities>[];
			for(var i:int = 0; i < _entities.length; i++)
			{
				var entity:TestEntity = _addedEntities[i];
				//For on demand getting collection will return depended clon of the base collection
				var entities:IEntities = _entitiesManager.getEntities(_entities[i].concat());
				Assert.assertNotNull(entities);
				Assert.assertTrue(_preinitedCollections[entity.bits] != entities);
				Assert.assertTrue(entities.hasEntity(entity));
				collections.push(entities);
			}
			//free depended collections
			_entitiesManager.tick(0);
			for(i = 0; i < collections.length; i++)
			{
				entities = collections[i];
				for(entities.begin(); !entities.end(); entities.next())
					Assert.fail('legth of collection must equals 0');
			}
		}

		[Test(order=5)]
		public function disposeEntitiesCollections():void
		{
			this.updateEntities();
			for each(var entities:IEntities in _preinitedCollections)
			{
				entities.dispose();
			}
		}

		[Test(order=6)]
		public function testRemoveEntity():void
		{
			this.updateEntities();
			var base:IEntities = _entitiesManager.getEntities([]);//base collection, containse all entities
			for(var i:int = 0; i < _entities.length; i++)
			{
				var entity:TestEntity = _addedEntities[i];
				var components:Array = _entities[i];
				for(var j:int = 0; j < components.length; j++)
				{
					var componentType:ComponentType = components[j];
					_entitiesManager.removeEntity(entity, componentType);
					entity.bits = entity.bits &~ componentType.bit;
					this.checkInCollections(entity, componentType.bit);
					Assert.assertTrue(base.hasEntity(entity));
				}
				_entitiesManager.removeEntity(entity);
				Assert.assertFalse(base.hasEntity(entity));

			}
		}
//} endregion PUBLIC METHODS ===========================================================================================
//======================================================================================================================
//{region										PRIVATE\PROTECTED METHODS
		private function checkInCollections(entity:TestEntity, removedBit:uint):void
		{
			for(var mask:uint in _preinitedCollections)
			{
				if(mask & removedBit)
				{
					var entitis:IEntities = _preinitedCollections[mask];
					Assert.assertFalse(entitis.hasEntity(entity));
				}
			}
		}

		private function getType(types:Array):Array
		{
			if(types != null)
			{
				var n:int = types.length;
				for(var i:int = 0; i < n; i++)
				{
					types[i] = _componentTypeManager.getType(types[i]);
				}
			}
			return types;
		}

		private function getBits(types:Array):uint
		{
			var bits:uint = 0x0;
			if(types != null)
			{
				var n:int = types.length;
				for(var i:int = 0; i < n; i++)
				{
					bits |= _componentTypeManager.getType(types[i]).bit;
				}
			}
			return bits;
		}
//} endregion PRIVATE\PROTECTED METHODS ================================================================================
//======================================================================================================================
//{region											GETTERS/SETTERS
		public static function get _testData():Array
		{
			var array:Array = [];
			var entities:Array = [/**Entities*/[/**Components*/]];
			array.push([entities]);
			//-----
			entities = [[TestComponent_0] /* - one entity*/];
			array.push([entities]);
			//-----
			entities = [[TestComponent_0, TestComponent_1], [TestComponent_0]];
			array.push([entities]);
			//-----
			entities = [[TestComponent_0, TestComponent_1], [],
				[TestComponent_2, TestComponent_0], [TestComponent_1, TestComponent_1]];
			array.push([entities]);
			return array;
		}
//} endregion GETTERS/SETTERS ==========================================================================================
	}
}