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

	import org.gimmick.core.IEntity;
	import org.gimmick.utils.TestConfig;
	import org.gimmick.utils.TestEntity;

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
			Assert.fail('Test not implemented yet');
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
class TestComponent{}