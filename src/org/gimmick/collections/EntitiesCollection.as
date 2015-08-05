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

	import org.gimmick.core.IEntity;

	/**
	 * Collection of entities.
	 * Do not provide sorted entities list
	 */
	public class EntitiesCollection implements IEntities
	{
		//linked list
		/** Cicled linked list where head == tail */
		private var _list:EntityNode;//need link for depnded collection
		/** cusrsor of iterator **/
		private var _cursor:EntityNode;
		/** end of iterator **/
		private var _finish:EntityNode;
		private var _end:Boolean;
		/**
		 * Entity loced by iterator.
		 * When node with enity was removed from list, cursor will poits to next node.
		 * But link to current entity will be abale, till execution of next() method
		 **/
		private var _current:IEntity;
		/** Map of entities where key is Id of entity, values is node in linked list*/
		private var _map:Dictionary;
		//other
		/** allocated memory size for entitiyes**/
		[Deprecated]
		private var _allocationSize:int;
		private var _bits:uint;
		/**
		 * Flag for indication that this instance depended to other one
		 */
		private var _isDepended:Boolean;
		private var _disposingCallback:Function;
		//======================================================================================================================
//{region											PUBLIC METHODS
		/**
		 * Constructor
		 * @param allocationSize Size of initial allocations
		 * @param disposingCallback Will be executed after collection disposing
		 */
		public function EntitiesCollection(allocationSize:int = 100, disposingCallback:Function = null)
		{
			_allocationSize = allocationSize;
			_disposingCallback = disposingCallback;
			_map = new Dictionary(true);
			//do not need to allocate this
			_list = new EntityNode();
			_list.next = _list;
		}
		/**
		 * @inheritDoc
		 */
		public function dependedClone(clone:IEntities = null):IEntities
		{
			var c:EntitiesCollection = clone as EntitiesCollection;
			if(c == null)
			{
				//create new clone based on current data
				c = new EntitiesCollection(0);
			}
			c._allocationSize = _allocationSize;
			c._disposingCallback = _disposingCallback;
			c._isDepended = true;
			c._list = _list;
			c._bits = _bits;
			c._map = _map;
			return c;
		}

		/**
		 * Push Entity to collection
		 * @param entity Instance of entity
		 */
		[Inline]
		public final function push(entity:IEntity):void
		{
			if(_map[entity.id] != null)
			//nothing to do in entity was already added
				return;
			//add new node to linked list
			var node:EntityNode = EntityNode.allocateNode(entity);
			if(_list.next == _list)//linked list is empty
			{
				//set as head and tail to itself
				_list.next = node;
				node.next = node;
				node.prev = node;
			}
			else
			{
				//insert node to list
				var head:EntityNode = _list.next;
				node.next = head.next;
				head.next = node;
				node.prev = head;
				node.next.prev = node;
			}
			//add to map
			_map[entity.id] = node;
		}

		/**
		 * Remove Entity from collection
		 * @param entity Instance of entity
		 */
		[Inline]
		public final function remove(entity:IEntity):void
		{
			var node:EntityNode = _map[entity.id];
			if(node == null)
			//nothing to do in entity was already removed
				return;
			var next:EntityNode = node.next;
			var prev:EntityNode = node.prev;
			if(node == next && node == prev)
			{
				//it was a last node
				_list.next = _list;
				_cursor = _list;
				_finish = _list;
			}
			else
			{
				next.prev = prev;
				prev.next = next;
				//update holder
				if(_list.next == node)_list.next = prev;
				//update cursor position
				if(_cursor == node)_cursor = prev;
				if(_finish == node)_finish = prev;
			}
			//delete entity from collection
			_map[entity.id] = null;
			EntityNode.freeNode(node);
		}

		/**
		 * @inheritDoc
		 */
		[Inline]
		public final function hasId(entityId:String):Boolean
		{
			return _map[entityId] != null;
		}

		/**
		 * @inheritDoc
		 */
		[Inline]
		public final function hasEntity(entity:IEntity):Boolean
		{
			return _map[entity.id] != null;
		}
		/**
		 * @inheritDoc
		 */
		//[Inline]
		public final function getById(entityId:String):IEntity
		{
			var entity:IEntity;
			var node:EntityNode = _map[entityId];
			if(node != null)
				entity = node.entity;
			return entity;
		}
		/**
		 * @inheritDoc
		 */
		public function dispose():void
		{
			if(_list == null)
				return; //already disposed
			//free nodes
			var node:EntityNode;
			_cursor = _list.next;
			while(_cursor != null && _cursor.allocated)
			{
				node = _cursor;
				_cursor = _cursor.next;
				EntityNode.freeNode(node);
			}
			//delete links
			_list.next = null;
			_current = null;
			_cursor = null;
			_list = null;
			_map = null;
			_bits = 0x0;
			//execute callback
			if(_disposingCallback is Function)
				_disposingCallback.call(null, this);
			_disposingCallback = null;
		}

		/**
		 * @inheritDoc
		 */
		[Inline]
		public final function begin():IEntities
		{
			_cursor = _finish = _list.next;//set start to first item
			_finish = _finish.prev;//set finish to last item
			_current = _cursor.entity;//if list is empty will return null
			//find first item for bits
			while(_bits > 0x0 && _current != null
				&& (_current.bits & _bits) != _bits){
				_cursor = _cursor.next;
				_current = _cursor.entity;
			}

			_end = false;
			return this;
		}
		/**
		 * @inheritDoc
		 */
		[Inline]
		public final function end():Boolean
		{
			var end:Boolean = _end;
			_end = _cursor == _finish;//this was last node
			return end/* || _current == _list*/;
		}

		/**
		 * @inheritDoc
		 */
		[Inline]
		public final function next():void
		{
			do{
				_cursor = _cursor.next;
				_current = _cursor.entity;
			}
			while(_bits > 0x0 && _current != null
				&& (_current.bits & _bits) != _bits);
		}

		/**
		 * @inheritDoc
		 */
		[Inline]
		public final function forEach(callback:Function, thisObject:Object = null):void
		{
			var next:EntityNode = null;
			var cursor:EntityNode = _list.next;
			do{
				if(cursor == null)
				{
					/*
					 * Item under cursor was deleted in previous iteration.
					 * Try to point cursor to next item in list,
					 * that was previously saved.
					 */
					if(next == null || !next.allocated)break;
					cursor = next;
				}
				/*
				 * Save link to next node.
				 * Item upder cursor can be removed on this iteration.
				 */
				next = cursor.next;
				//execute user's method
				callback.call(thisObject, cursor.entity, this);
				//point cursor to next item in list
				cursor = cursor.next;
			}while(cursor != _list.next);
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
		public final function set bits(value:uint):void
		{
			_bits = value;
		}

		/**
		 * @inheritDoc
		 */
		[Inline]
		public final function get current():IEntity
		{
			return _current;
		}

		/**
		 * @inheritDoc
		 */
		[Inline]
		public final function get empty():Boolean
		{
			return _list == null || _list.next == _list;
		}

		/**
		 * @inheritDoc
		 */
		[Inline]
		public final function get isDisposed():Boolean
		{
			return _list == null;
		}

//} endregion GETTERS/SETTERS ==========================================================================================
	}
}