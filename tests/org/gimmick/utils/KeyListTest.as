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

/**
 * Created by MerlinDS on 01.07.2015.
 */
package org.gimmick.utils
{

	import flexunit.framework.Assert;

	/**
	 * Test case for Key List
	 */
	public class KeyListTest
	{


		//======================================================================================================================
//{region											PUBLIC METHODS
		public function KeyListTest()
		{
		}

		[Test]
		public function testRemove():void
		{

		}

		[Test]
		public function testAdd():void
		{
			var list:KeyList = new KeyList();
			var obj:Object = {test:0};
			list.add(0, obj);
			list.add(1, {test:1});
			list.add(2, {test:2});
			var result:* = list.get(0);
			Assert.assertNotNull(result);
			Assert.assertEquals(obj, result);
			list.remove(1);
			Assert.assertNull(list.get(1));
		}

		[Test]
		public function testGet():void
		{

		}

		[Test]
		public function testLength():void
		{

		}

		[Test]
		public function testDispose():void
		{

		}

		[Test]
		public function testKeys():void
		{

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
