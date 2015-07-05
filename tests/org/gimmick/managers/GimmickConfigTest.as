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

	import org.gimmick.utils.TestComfig;

	public class GimmickConfigTest
	{

		//======================================================================================================================
//{region											PUBLIC METHODS
		public function GimmickConfigTest()
		{
		}

		[Test]
		public function testEntityManager():void
		{
			var testConfig:TestComfig = new TestComfig();
			var config:GimmickConfig = new GimmickConfig();
			Assert.assertNotNull("Empty manager", config.entitiesManager);
			Assert.assertNotNull("External manager", testConfig.entitiesManager);
		}

		[Test]
		public function testSystemManager():void
		{
			var testConfig:TestComfig = new TestComfig();
			var config:GimmickConfig = new GimmickConfig();
			Assert.assertNotNull("Empty manager", config.systemManager);
			Assert.assertNotNull("External manager", testConfig.systemManager);
		}

		[Test]
		public function testComponentsManager():void
		{
			var config:GimmickConfig = new GimmickConfig();
			var testConfig:TestComfig = new TestComfig();
			Assert.assertNotNull("Empty manager", config.componentsManager);
			Assert.assertNotNull("External manager", testConfig.systemManager);
		}

		[Test]
		public function testComponentTypeManager():void
		{
			var config:GimmickConfig = new GimmickConfig();
			Assert.assertNotNull("Empty manager", config.componentTypeManager);
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
