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

	public class CollectionIterator implements ICollectionIterator
	{
		private var _cursor:CollectionNode;
		private var _collection:EntitiesCollection;
		//======================================================================================================================
//{region											PUBLIC METHODS
		/**
		 * Constructor
		 */
		public function CollectionIterator()
		{
		}

		/**
		 * @inheritDoc
		 */
		[Inline]
		public final function begin():ICollectionIterator
		{
			_cursor = _collection._head;
			return this;
		}

		/**
		 * @inheritDoc
		 */
		[Inline]
		public final function end():Boolean
		{
			return _cursor == null;
		}

		/**
		 * @inheritDoc
		 */
		[Inline]
		public final function next():void
		{
			_cursor = _cursor.next;
		}
//} endregion PUBLIC METHODS ===========================================================================================
//======================================================================================================================
//{region										PRIVATE\PROTECTED METHODS

//} endregion PRIVATE\PROTECTED METHODS ================================================================================
//======================================================================================================================
//{region											GETTERS/SETTERS
		/**
		 * @inheritDoc
		 */
		[Inline]
		public final function get current():IEntity
		{
			return _cursor != null ? _cursor.entity : null;
		}

		/**
		 * @inheritDoc
		 */
		public function get collection():IEntitiesCollection
		{
			return _collection;
		}

		/**
		 * Internal method for set new collection to iterator
		 */
		internal function set targetCollection(collection:EntitiesCollection):void
		{
			//do nothing if collection was not changed
			if(_collection != collection)
			{
				_collection = collection;
				if(_collection != null)this.begin();
				else _cursor = null;
			}
		}
//} endregion GETTERS/SETTERS ==========================================================================================
	}
}
