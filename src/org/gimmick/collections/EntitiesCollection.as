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
		private var _allocationSize:int;
		private var _content:Vector.<IEntity>;
		/**
		 * Hash map of collection indexes.
		 * Key = Id of entity
		 * Value = Index in content list of entity
		 */
		private var _hashMap:Dictionary = new Dictionary(true);

		private var _splits:Vector.<int>;

		private var _length:BindableLength;
		private var _cursor:int;
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

			_length = new BindableLength();
			_content = new <IEntity>[];
			_splits = new <int>[];
			_hashMap = new Dictionary(true);
			_cursor = 0;
			this.increaseSize();
		}
		/**
		 * @inheritDoc
		 */
		public function dependedClone(clone:IEntities = null):IEntities
		{
			this.defragContent();
			var c:EntitiesCollection = clone as EntitiesCollection;
			if(c == null)
			{
				//create new clone based on current data
				c = new EntitiesCollection(0);
			}
			c._allocationSize = _allocationSize;
			c._disposingCallback = _disposingCallback;
			c._splits = new <int>[];
			c._content = _content;
			c._hashMap = _hashMap;
			c._length = _length;
			c._isDepended = true;
			return c;
		}

		/**
		 * Push Entity to collection
		 * @param entity Instance of entity
		 */
		[Inline]
		public final function push(entity:IEntity):void
		{
			//Add new entity only in case if it was not added previously
			if(_hashMap[entity.id] == null)
			{
				if(_length.value == _content.length)
					this.increaseSize();
				_hashMap[entity.id] = _length.value;//set index of entity in content list
				_content[_length.value++] = entity;//add to content list
			}
			//if node was already added do nothing
		}

		/**
		 * Remove Entity from collection
		 * @param entity Instance of entity
		 */
		[Inline]
		public final function remove(entity:IEntity):void
		{
			//Remove entity only in case if it was added previously
			if(_hashMap[entity.id] != null)
			{
				var index:int = _hashMap[entity.id];
				_content[index] = null;//delete instance of content
				if(index <= _cursor)//save index for future content defragmentation
					_splits.push(index);
				else
				{
					//get content from end of list and push it to empty place
					var lastIndex:int = --_length.value;
					_content[index] = _content[lastIndex];
					_content[lastIndex] = null;
				}
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
		//[Inline]
		public final function getById(entityId:String):IEntity
		{
			var entity:IEntity;
			if(_hashMap[entityId] != null)
			{
				var index:int = _hashMap[entityId];
				entity = _content[index];
			}
			return entity;
		}
		/**
		 * @inheritDoc
		 */
		public function dispose():void
		{
			_hashMap = null;
			_content = null;
			_splits = null;
			_length = null;
			_cursor = 0;
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
			this.defragContent();
			_cursor = 0;
			if(_bits > 0x0)
				while(_cursor < _length.value && (_content[_cursor].bits & _bits) != _bits)
					_cursor++;
			return this;
		}

		/**
		 * @inheritDoc
		 */
		[Inline]
		public final function end():Boolean
		{
			return _cursor >= _length.value;
		}

		/**
		 * @inheritDoc
		 */
		[Inline]
		public final function next():void
		{
			if(_bits > 0x0)
			{
				do _cursor++;
				while(_cursor < _length.value && (_content[_cursor].bits & _bits) != _bits);
			}else
				_cursor++;

		}

		/**
		 * @inheritDoc
		 */
//		[Inline] //- could not be inline
		public final function forEach(callback:Function, thisObject:Object = null):void
		{
			this.defragContent();
			for(_cursor = 0; _cursor < _length.value; _cursor++)
			{
				var entity:IEntity = _content[_cursor];
				if(_bits > 0x0 && (entity.bits & _bits) != _bits)continue;
				callback.call(thisObject, entity, this);
			}
		}
//} endregion PUBLIC METHODS ===========================================================================================
//======================================================================================================================
//{region										PRIVATE\PROTECTED METHODS
		/**
		 * Increase size of collection
		 * @param fromClean If this flag equals true, clear content and increase collection as new.
		 */
		private function increaseSize(fromClean:Boolean = false):void
		{
			_content.fixed = false;
			if(fromClean)
				_content.length = 0;
			_content.length = _content.length + _allocationSize;
			_content.fixed = true;
		}

		/**
		 * Defragmentation of the collection
		 */
		private final function defragContent():void
		{
			if(_splits == null)return;//was disposed
			while(_splits.length > 0)
			{
				var lastIndex:int = --_length.value;
				_content[_splits.pop()] = _content[lastIndex];
				_content[lastIndex] = null;
			}
		}
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
			return _content[_cursor];
		}

		/**
		 * @inheritDoc
		 */
		[Inline]
		public final function get empty():Boolean
		{
			if(_splits == null)return true;//collection was disposed
			this.defragContent();
			return _length.value == 0;
		}

		/**
		 * @inheritDoc
		 */
		[Inline]
		public final function get isDisposed():Boolean
		{
			return _splits == null;
		}

//} endregion GETTERS/SETTERS ==========================================================================================
	}
}
/**
 * @private
 */
class BindableLength{
	public var value:int;
}