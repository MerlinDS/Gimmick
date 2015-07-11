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
		private var _preinit:Array;
		private var _postinit:Array;

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
			_entitiesManager.tick(0);
			var i:int, n:int;
			n = _entities.length;
			for(i = 0; i < n; i++)
				_entities[i] = this.getType(_entities[i]);
			n = _postinit.length;
			for(i = 0; i < n; i++)
				_postinit[i] = this.getType(_postinit[i]);
			n = _preinit.length;
			for(i = 0; i < n; i++)
				_preinit[i] = this.getType(_preinit[i]);
		}

		[After]
		public function tearDown():void
		{
			_componentTypeManager.dispose();
			_componentTypeManager = null;
			_entitiesManager.dispose();
			_entitiesManager = null;
		}


//} endregion PUBLIC METHODS ===========================================================================================
//======================================================================================================================
//{region										PRIVATE\PROTECTED METHODS
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
//} endregion PRIVATE\PROTECTED METHODS ================================================================================
//======================================================================================================================
//{region											GETTERS/SETTERS
		public static function get _testData():Array
		{
			var array:Array = [];
			var entities:Array = [/**Entities*/[/**Components*/], [], []];
			var preinit:Array = [/**PreInit collections**/[/**Components*/]];
			var postinit:Array = [/**PreInit collections**/[/**Components*/]];
			array.push([entities, preinit, postinit]);
			//-----
			entities = [[TestComponent_0, TestComponent_1] /* - one entity*/];
			preinit = [[TestComponent_1]/* - one collection */];
			postinit = [[TestComponent_0]/* - one collection */];
			array.push([entities, preinit, postinit]);
			//-----
			entities = [[TestComponent_0],[TestComponent_1],[TestComponent_0, TestComponent_1]];
			preinit = [[TestComponent_1, TestComponent_0], [TestComponent_1]];
			postinit = [[TestComponent_0]/* - one collection */];
			array.push([entities, preinit, postinit]);
			//-----
			entities = [[TestComponent_0],[TestComponent_1],[TestComponent_0, TestComponent_2],[TestComponent_1, TestComponent_2]];
			preinit = [[TestComponent_1, TestComponent_0], [TestComponent_1, TestComponent_2], [TestComponent_0]];
			postinit = [[TestComponent_0], [TestComponent_1, TestComponent_0], [TestComponent_1, TestComponent_2]];
			array.push([entities, preinit, postinit]);
			//-----
			entities = [[TestComponent_0],[TestComponent_1],[],[TestComponent_1, TestComponent_2]];
			preinit = [[TestComponent_1, TestComponent_0], [TestComponent_1, TestComponent_2], [TestComponent_0]];
			postinit = [[TestComponent_0], [TestComponent_1, TestComponent_0], []];
			array.push([entities, preinit, postinit]);
			return array;
		}
//} endregion GETTERS/SETTERS ==========================================================================================
	}
}