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

package org.gimmick.utils
{

	/**
	 *
	 */
	public class KeyList//TODO: May be need other name for this class?
	{

		private var _values:Vector.<Object>;
		private var _keys:Vector.<int>;

		private var _length:int;
//======================================================================================================================
//{region											PUBLIC METHODS
		/**
		 * Constructor.
		 */
		public function KeyList()
		{
			_length = 0;
			_values = new <Object>[];
			_keys = new <int>[];
		}

		/**
		 * Add item to list
		 * @param key Key linked to item
		 * @param value Instance of item
		 */
		[Inline]
		public final function add(key:int, value:Object):void
		{
			//TODO slow method
			var index:int = _keys.indexOf(key);
			if(index < 0)
			{
				_keys[_length] = key;
				_values[_length] = value;
				_length++;
			}else
			{
				_values[index] = value;
			}
		}

		/**
		 * Get item by key
		 * @param key Key linked to item
		 * @return Instance of item
		 */
		[Inline]
		public final function get(key:int):Object
		{
			//TODO crete performance test for this method
			var index:int = _keys[key];
			if(index >= 0)return _values[index];
			return null;
		}

		/**
		 * Remove item and key from list
		 * @param key Key linked to item
		 */
		[Inline]
		public final function remove(key:int):void
		{
			//TODO very slow method
			var index:int = _keys[key];
			_keys.splice(index, 1);
			_values.splice(index, 1);
			_length--;
		}

		/**
		 * Free memory from list content
		 */
		[Inline]
		public final function dispose():void
		{
			_keys.length = 0;
			_values.length = 0;
			_length = 0;
			_keys = null;
			_values = null;
		}
//} endregion PUBLIC METHODS ===========================================================================================
//======================================================================================================================
//{region										PRIVATE\PROTECTED METHODS
		/**
		 * Get keys list
		 */
		[Inline]
		public final function get keys():Vector.<int>
		{
			return _keys;
		}

		/**
		 * Length of list
		 */
		[Inline]
		public final function get length():int
		{
			return _length;
		}
//} endregion PRIVATE\PROTECTED METHODS ================================================================================
//======================================================================================================================
//{region											GETTERS/SETTERS

//} endregion GETTERS/SETTERS ==========================================================================================        
	}
}
