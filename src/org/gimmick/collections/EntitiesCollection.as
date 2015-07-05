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

	import org.gimmick.core.IEntity;

	public class EntitiesCollection implements IEntitiesCollection
	{

		private var _bits:uint;
		private var _cursor:int;
		private var _entities:Vector.<IEntity>;
		private var _parent:EntitiesCollection;
		//======================================================================================================================
//{region											PUBLIC METHODS
		public function EntitiesCollection(entities:Vector.<IEntity>, bits:uint,
										   parent:EntitiesCollection = null)
		{
			_entities = entities;
			_parent = parent;
			_bits = bits;
		}

		[Inline]
		public final function begin():void
		{
			_cursor = 0;
			if((_entities[_cursor].bits & _bits) == false)
				this.next();
		}

		[Inline]
		public final function end():Boolean
		{
			return _cursor >= _entities.length;
		}

		[Inline]
		public final function next():void
		{
			_cursor++;
			while(_cursor < _entities.length &&
				(_entities[_cursor].bits & _bits) == false
			)_cursor++;
		}

		public function getCollection(...types):IEntitiesCollection
		{
			var collection:EntitiesCollection;
			if(_parent == null)
				throw new Error("Parent of this collection is null! Something goes wrong!");
			return _parent.getCollection.apply(this, types);
		}

		public function dispose():void
		{
			_bits = 0x0;
			_cursor = 0;
			_entities = null;
			_parent = null;
		}
//} endregion PUBLIC METHODS ===========================================================================================
//======================================================================================================================
//{region										PRIVATE\PROTECTED METHODS
//} endregion PRIVATE\PROTECTED METHODS ================================================================================
//======================================================================================================================
//{region											GETTERS/SETTERS

		[Inline]
		public final function get current():IEntity
		{
			return _entities[ _cursor ] as IEntity;
		}
//} endregion GETTERS/SETTERS ==========================================================================================
	}
}
