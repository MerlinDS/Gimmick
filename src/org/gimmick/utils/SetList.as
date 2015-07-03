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
	 * List with set of unique keys and values
	 */
	public class SetList
	{

		/**
		 * Contains free indexes of the values list.
		 * Will be filled when value removed from values list.
		 */
		private var _freeIndexes:Vector.<int>;
		private var _values:Vector.<Object>;
		private var _map:Object;
//======================================================================================================================
//{region											PUBLIC METHODS
		/**
		 * Constructor.
		 */
		public function SetList()
		{
			//initialize free indexes with first free index
			_freeIndexes = new <int>[0];
			//initialize list with empty space
			_values = new <Object>[null];
			_map = {};
		}

		/**
		 * Add value to list
		 * @param key Key linked to item
		 * @param value Instance of item
		 */
		[Inline]
		public final function addValue(key:String, value:Object):void
		{
			var index:int = _map[key] != null ? _map[key] : -1;
			if(index < 0)//was not added previously
				index = _freeIndexes.pop();
			_values[index] = value;
			_map[key] = index;
			if(_freeIndexes.length == 0)
			{
				//expand freeIndexes for next adding
				_freeIndexes[0] = _values.length;
				_values[_values.length] = null;
			}
		}

		/**
		 * Get value by key
		 * @param key Key linked to item
		 * @return Instance of item
		 */
		[Inline]
		public final function getValue(key:String):*
		{
			var value:Object = null;
			var index:int = _map[key] != null ? _map[key] : -1;
			if(index >= 0 && index < _values.length)value = _values[index];
			return value;
		}

		/**
		 * Remove item and key from list
		 * @param key Key linked to item
		 */
		[Inline]
		public final function removeValue(key:String):void
		{
			var index:int = _map[key] != null ? _map[key] : -1;
			if(index >= 0 && index < _values.length)
			{
				_values[index] = null;
				_freeIndexes.push(index);
				_map[key] = null;
			}
		}

		/**
		 * Clear list from content
		 */
		[Inline]
		public function clear():void
		{
			if(_freeIndexes != null
					&& _values != null)
			{
				_freeIndexes.length = 0;
				_values.length = 0;
			}
		}
		/**
		 * Free memory from list
		 */
		[Inline]
		public final function dispose():void
		{

			_freeIndexes = null;
			_map = null;
			_values = null;
		}
//} endregion PUBLIC METHODS ===========================================================================================
//======================================================================================================================
//{region										PRIVATE\PROTECTED METHODS
//} endregion PRIVATE\PROTECTED METHODS ================================================================================
//======================================================================================================================
//{region											GETTERS/SETTERS

		/**
		 * Length of list
		 */
		[Inline]
		public final function get length():int
		{
			return _values.length - _freeIndexes.length;
		}
//} endregion GETTERS/SETTERS ==========================================================================================        
	}
}
