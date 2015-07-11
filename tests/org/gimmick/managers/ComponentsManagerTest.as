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

	import flexunit.framework.Assert;

	import org.gimmick.core.Component;

	import org.gimmick.core.ComponentType;
	import org.gimmick.utils.TestComponent_0;
	import org.gimmick.utils.TestComponent_1;
	import org.gimmick.utils.TestComponent_2;
	import org.gimmick.utils.TestConfig;

	import org.gimmick.utils.TestEntity;

	public class ComponentsManagerTest
	{

		private var _manager:ComponentsManager;
		private var _entity:TestEntity;
		private var _componentTypes:Vector.<ComponentType>;
		private var _components:Vector.<Component>;
		private var _notAddedComponentType:ComponentType;
//======================================================================================================================
//{region											PUBLIC METHODS
		public function ComponentsManagerTest()
		{
		}

		[Before]
		public function setUp():void
		{
			var config:TestConfig = new TestConfig();
			_entity = new TestEntity();
			_manager = new ComponentsManager();
			_components = new <Component>[
					new TestComponent_0(),
					new TestComponent_1(),
					new TestComponent_2()
			];
			_componentTypes = new <ComponentType>[
				config.componentTypeManager.getType(_components[0]),
				config.componentTypeManager.getType(_components[1]),
				config.componentTypeManager.getType(_components[2])
			];
			_notAddedComponentType = config.componentTypeManager.getType(Component);
			_manager.initialize(5);
		}

		[After]
		public function tearDown():void
		{
			_manager.dispose();
			_manager = null;
			_componentTypes = null;
		}

		[Test]
		public function testAddComponent():void
		{
			for(var i:int = 0; i < _components.length; ++i)
				_manager.addComponent(_entity, _componentTypes[i], _components[i]);
		}

		[Test]
		public function testGetComponents():void
		{
			this.testAddComponent();
			var components:Array = _manager.getComponents(_entity);
			for(var i:int = 0; i < _components.length; ++i)
				Assert.assertFalse(components.indexOf(_components[i]) < 0);

			Assert.assertTrue(components.indexOf(_notAddedComponentType < 0));
		}

		[Test]
		public function testGetComponent():void
		{
			this.testAddComponent();
			for(var i:int = 0; i < _components.length; ++i)
				Assert.assertEquals(_components[i], _manager.getComponent(_entity, _componentTypes[i]));
			Assert.assertNull(_manager.getComponent(_entity, _notAddedComponentType));
		}

		[Test]
		public function testRemoveComponent():void
		{
			this.testAddComponent();
			for(var i:int = 0; i < _componentTypes.length; ++i)
			{
				_manager.removeComponent(_entity, _componentTypes[i]);
				Assert.assertNull(_manager.getComponent(_entity, _componentTypes[i]));
			}

		}

		[Test]
		public function testRemoveComponents():void
		{
			this.testAddComponent();
			_manager.removeComponents(_entity);
			Assert.assertEquals(0, _manager.getComponents(_entity).length);
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
