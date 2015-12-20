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

	import flash.utils.Dictionary;

	import org.flexunit.Assert;
	import org.gimmick.core.Component;
	import org.gimmick.utils.getUniqueId;

	public class ComponentsCollectionTest
	{
		private var _values:Dictionary;
		private var _collection:ComponentsCollection;
		//======================================================================================================================
//{region											PUBLIC METHODS
		public function ComponentsCollectionTest()
		{
		}

		[Before]
		public function setUp():void
		{
			_values = new Dictionary(true);
			_values[getUniqueId()] = new TestComponent(1);
			_values[getUniqueId()] = new TestComponent(2);
			_values[getUniqueId()] = new TestComponent(3);
			_collection = new ComponentsCollection(2);
		}

		[After]
		public function tearDown():void
		{
			_values = null;
			_collection.dispose();
			_collection = null;
		}

		[Test]
		public function testPush():void
		{
			for(var key:String in _values)
				_collection.push(key, _values[key]);
		}

		[Test]
		public function testHas():void
		{
			this.testPush();
			for(var id:String in _values)
			{
				Assert.assertTrue(_collection.has(id));
			}
			Assert.assertFalse(_collection.has("EMPTY"));
		}

		[Test]
		public function testGet():void
		{
			this.testPush();
			for(var id:String in _values)
			{
				var result:TestComponent = _collection.get(id) as TestComponent;
				Assert.assertNotNull("Value is null for id" + id, result);
				Assert.assertEquals("Value not equals for id" + id, _values[id], result);
			}
			Assert.assertNull("Value must be a null", _collection.get("EMPTY"));
		}

		[Test]
		public function testRemove():void
		{
			this.testPush();
			for(var id:String in _values)
			{
				_collection.remove(id);
				var result:TestComponent = _collection.get(id) as TestComponent;
				Assert.assertNull("Value must be a null for id" + id, result);
				Assert.assertFalse(_collection.has(id));
			}
		}

		[Test]
		public function testRemoveWithAdding():void
		{
			var firstID:String = getUniqueId();
			var secondID:String = getUniqueId();
			var firstComponent:Component = new Component();
			var secondComponent:Component = new Component();
			_collection.push(firstID, firstComponent);
			_collection.push(secondID, secondComponent);
			_collection.remove(firstID);
			Assert.assertFalse(_collection.has(firstID));
			Assert.assertEquals(secondComponent, _collection.get(secondID));

		}

		[Test]
		public function testClear():void
		{
			this.testPush();
			_collection.clear();
			for(var id:String in _values)
			{
				Assert.assertFalse(_collection.has(id));
				Assert.assertNull(_collection.get(id));
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

class TestComponent extends Component
{
	public var value:int;

	public function TestComponent(value:int)
	{
		this.value = value;
	}
}