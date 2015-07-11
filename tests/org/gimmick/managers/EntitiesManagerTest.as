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

	import flash.utils.getTimer;

	import flexunit.framework.Assert;

	import org.gimmick.collections.IEntities;

	import org.gimmick.core.ComponentType;

	import org.gimmick.core.IEntity;
	import org.gimmick.utils.TestConfig;
	import org.gimmick.utils.TestEntity;

	[RunWith("org.flexunit.runners.Parameterized")]
	public class EntitiesManagerTest
	{

		[Parameters]
		public static var testData:Array = [
			[ [/**Entities*/[/**Components*/], [], []], [/**PreInit collection**/], [/**PostInit collection**/] ],
			[ [[TestComponent0, TestComponent1]], [TestComponent1], [TestComponent0] ]
		];


		private var _entities:Array;
		private var _preinit:Array;
		private var _postinit:Array;

		private var _preinitCollection:IEntities;

		private var _componentTypeManager:ComponentTypeManager;
		private var _entitiesManager:EntitiesManager;
		//======================================================================================================================
//{region											PUBLIC METHODS
		public function EntitiesManagerTest(entities:Array, preinit:Array, postinit:Array)
		{
			_entities = entities;
			_postinit = postinit;
			_preinit = preinit;
		}

		[Before]
		public function setUp():void
		{
			var testConfig:TestConfig = new TestConfig();
			_componentTypeManager = testConfig.componentTypeManager;
			_entitiesManager = new EntitiesManager();
			_entitiesManager.initialize(testConfig.maxEntities);
			//initialize collection befor start of looping
			_preinitCollection = _entitiesManager.getEntities(_preinit);
			_entitiesManager.tick(0);
		}

		[After]
		public function tearDown():void
		{
			_componentTypeManager.dispose();
			_componentTypeManager = null;
			_entitiesManager.dispose();
			_entitiesManager = null;
		}

		[Test]
		public function testAddNewEntity():void
		{
			for(var i:int = 0; i < _entities.length; i++)
				_entitiesManager.addEntity(new TestEntity());

		}

		[Test]
		public function preinitializeCollections():void
		{
			for(var i:int = 0; i < _preinit.length; i++)
			{
				var entities:IEntities = _entitiesManager.getEntities(_preinit[i]);
				Assert.assertNotNull(entities);
			}
		}

		[Test]
		public function testAddComponent2EmptyEntities():void
		{
			for(var i:int = 0; i < _entities.length; i++)
			{
				var components:Array = _entities[i];
				var entity:IEntity = new TestEntity();
				_entitiesManager.addEntity(entity);
				for(var j:int = 0; j < components.length; j++)
				{
					if(components[j] == null)continue;
					var componentType:ComponentType = _componentTypeManager.getType( components[j] );
					_entitiesManager.addEntity(entity, componentType);
				}
			}
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

import org.gimmick.core.Component;
import org.gimmick.utils.TestEntity;

class TestComponent0 extends Component{}
class TestComponent1 extends Component{}