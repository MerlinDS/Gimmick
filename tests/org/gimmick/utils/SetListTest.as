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
	public class SetListTest
	{

		private var _values:Object;
		private var _length:int;
		private var _setList:SetList;
		//======================================================================================================================
//{region											PUBLIC METHODS
		public function SetListTest()
		{
		}

		[Before]
		public function setUp():void
		{
			_length = 0;
			_values = {
				1:{value:1},
				2:{value:2},
				3:{value:3}
			};
			_setList = new SetList();
		}

		[After]
		public function tearDown():void
		{
			_length = 0;
			_values = null;
			_setList.dispose();
			_setList = null;
		}

		[Test(order=1)]
		public function testAdd():void
		{

			Assert.assertEquals("Length not equals", _length, _setList.length);
			for(var key:String in _values)
			{
				_setList.addValue(key, _values[key]);
				_length++;
			}
			Assert.assertEquals("Length not equals after adding", _length, _setList.length);
			//set adding to same key
			_setList.addValue("1", {value:_length});
			Assert.assertEquals("Length not equals after replacing", _length, _setList.length);
			_setList.addValue("1", _values[1]);//return ald value for else tests
		}

		[Test(order=2)]
		public function testGet():void
		{
			this.testAdd();
			for(var key:String in _values)
			{
				var result:Object = _setList.getValue(key);
				Assert.assertNotNull("Value is null for key" + key, result);
				Assert.assertEquals("Value not equals for key" + key, _values[key], result);
			}
			Assert.assertNull("Value must be a null for int.MAX_VALUE", _setList.getValue("EMPTY"));
		}

		[Test(order=3)]
		public function testRemove():void
		{
			this.testAdd();
			Assert.assertEquals("Length not equals before removing", _length, _setList.length);
			for(var key:String in _values)
			{
				_setList.removeValue(key);
				_length--;
				var result:Object = _setList.getValue(key);
				Assert.assertNull("Value must be a null for key" + key, result);
				Assert.assertEquals("Length not equals", _length, _setList.length);
			}
			_length = 0;
			Assert.assertEquals("Length not equals after removing all", _length, _setList.length);
		}

		[Test(order=4)]
		public function testAddAfterRemove():void
		{
			this.testRemove();
			for(var key:String in _values)
			{
				_setList.addValue(key, _values[key]);
				_length++;
			}
			Assert.assertEquals("Length not equals after adding", _length, _setList.length);
		}

		[Test(order=5)]
		public function testClear():void
		{
			this.testAdd();
			_setList.clear();
			Assert.assertEquals("Length not equals after removing all", 0, _setList.length);
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
