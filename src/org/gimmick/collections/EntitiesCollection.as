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
	 * Concrete entities collection
	 */
	public class EntitiesCollection implements IEntitiesCollection
	{

		private var _parent:IEntitiesCollection;
		//
		private var _head:CollectionNode;
		private var _tail:CollectionNode;

		/**
		 * Hash map of collection nodes.
		 * Key = Id of entity
		 * Value = CollectionNode that contains entity
		 */
		private var _hashMap:Dictionary;
		//======================================================================================================================
//{region											PUBLIC METHODS
		/**
		 * Constructor
		 * @param parent Parent entities collection. Collection can be a part of other collection
		 */
		public function EntitiesCollection(parent:IEntitiesCollection = null)
		{
			_parent = parent;
			this.clear();
		}

		/**
		 * @inheritDoc
		 */
		public function push(entity:IEntity):void
		{
			//Add new entity only in case if it was not added previously
			if(_hashMap[entity.id] == null)
			{
				var node:CollectionNode = CollectionNode.allocateNode();
				node.entity = entity;
				//add to linked list
				if(_head == null)
					_head = node;
				else
				{
					node.prev = _tail;
					_tail.next = node;
				}
				_tail = node;
				//add to hash map
				_hashMap[entity.bits] = node;
			}
			//if node was already added do nothing
		}

		/**
		 * @inheritDoc
		 */
		public function pop(entity:IEntity):void
		{
			var node:CollectionNode = _hashMap[entity.id];
			//Remove entity only in case if it was added previously
			if(node != null)
			{
				var next:CollectionNode = node.next;
				var prev:CollectionNode = node.prev;
				if(next != null)//set previous link to next node
					next.prev = prev;
				if(prev != null)//set next node link to previous node
					prev.next = next;
				CollectionNode.freeNode(node);
				//remove from has map
				_hashMap[entity.id] = null;
			}
			//if node was not added do nothing
		}

		/**
		 * @inheritDoc
		 */
		[Inline]
		public final function hasId(entityId:String):Boolean
		{
			return _hashMap[entityId] != null;
		}

		/**
		 * @inheritDoc
		 */
		[Inline]
		public final function hasEntity(entity:IEntity):Boolean
		{
			return _hashMap[entity.id] != null;
		}

		/**
		 * @inheritDoc
		 */
		public function getById(entityId:String):IEntity
		{
			var node:CollectionNode = _hashMap[entityId];
			return node != null ? node.entity : null;
		}

		/**
		 * @inheritDoc
		 */
		public function clear():void
		{
			_hashMap = new Dictionary(true);
			//free all nodes
			var next:CollectionNode;
			var node:CollectionNode = _head;
			while(node != null)
			{
				next = node.next;
				CollectionNode.freeNode(node);
				node = next;
			}
			//clean links
			_head = null;
			_tail = null;
		}

		/**
		 * @inheritDoc
		 */
		public function dispose():void
		{
			this.clear();
			_hashMap = null;
			_parent = null;
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
		public function get iterator():ICollectionIterator
		{
			var iterator:ICollectionIterator = _parent.iterator;
//			iterator.target(_head, _tail);
			return iterator;
		}

//} endregion GETTERS/SETTERS ==========================================================================================
	}
}
