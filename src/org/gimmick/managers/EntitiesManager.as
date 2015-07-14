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

package org.gimmick.managers
{

	import flash.utils.Dictionary;

	import org.gimmick.collections.EntitiesCollection;
	import org.gimmick.collections.IEntities;
	import org.gimmick.core.ComponentType;
	import org.gimmick.core.IEntity;

	/**
	 * Manager for controlling of entities
	 */
	internal class EntitiesManager implements IEntitiesManager
	{

		/**
		 * Dict of base collections.
		 * key - bits of collection mask
		 * value - base collection linked to this mask
		 */
		private var _baseCollections:Dictionary;
		private var _dependedCollections:Vector.<EntitiesCollection>;
		private var _dependedLength:int;

		private var _initialized:Boolean;
		private var _allocationSize:int;
//======================================================================================================================
//{region											PUBLIC METHODS
		/**
		 * Constructor
		 */
		public function EntitiesManager()
		{
			super ();
		}

		/**
		 * @inheritDoc
		 */
		public function initialize(allocationSize:int = 1):void
		{
			_allocationSize = allocationSize;
			_baseCollections = new Dictionary(true);
			_dependedCollections = new <EntitiesCollection>[];
			//initialize base collection without any filtration, that contains all entities
			this.getEntities([]);
		}

		/**
		 * @inheritDoc
		 */
		public function addEntity(entity:IEntity, componentType:ComponentType = null):void
		{
			var bits:uint;
			if(componentType == null)
			{
				//add to base collection
				_baseCollections[0x0].push(entity);
			}else
				bits = entity.bits | componentType.bit;
			this.updateCollections(entity, bits, true);
		}
		/**
		 * @inheritDoc
		 */
		public function removeEntity(entity:IEntity, componentType:ComponentType = null):void
		{

			var bits:uint;
			if(componentType == null)
			{
				//remove from all collection
				bits = entity.bits;
				_baseCollections[0x0].remove(entity);
			}else
				bits = entity.bits | componentType.bit;
			this.updateCollections(entity, bits, false);
		}


		/**
		 * @inheritDoc
		 */
		public function getEntities(types:Array):IEntities
		{
			//get bitwise mask for new collection
			var bits:uint = getBits(types);
			var collection:EntitiesCollection;
			if(!_initialized)
			{
				if (_baseCollections[bits] == null)
					_baseCollections[bits] = new EntitiesCollection(_allocationSize,
																this.collectionDisposing);
			}
			collection = _baseCollections[bits];
			collection = collection.dependedClone() as EntitiesCollection;
			_dependedCollections[_dependedLength++] = collection;
			return collection;
		}

		/**
		 * @inheritDoc
		 */
		public function tick(time:Number):void
		{
			if(!_initialized)
				_initialized = true;
		}

		/**
		 * @inheritDoc
		 */
		public function dispose():void
		{
			_initialized = false;
			for each(var collection:EntitiesCollection in _baseCollections)
				collection.dispose();
			while(_dependedLength > 0)
				_dependedCollections[--_dependedLength].dispose();
			_dependedCollections = null;
			_baseCollections = null;
		}

//} endregion PUBLIC METHODS ===========================================================================================
//======================================================================================================================
//{region										PRIVATE\PROTECTED METHODS
		[Inline]
		private final function updateCollections(entity:IEntity, bits:uint, push:Boolean):void
		{
			for (var collectionBits:uint in _baseCollections)
			{
				//base collection updates by caller
				if(collectionBits == 0x0)continue;
				//entities bits contains all of collection bits
				if ((bits & collectionBits) == collectionBits)
				{
					/*
				  	 * If entities [removes from]/[added to] base collection,
				  	 * depended clones are also will updated
				  	*/
					if(push)
						_baseCollections[collectionBits].push(entity);
					else
						_baseCollections[collectionBits].remove(entity);
				}
			}
		}

		[Inline]
		private final function getBits(types:Array):uint
		{
			var bits:uint = 0x0;
			while (types.length > 0)
			{
				//types must contains ComponentType
				var componentType:ComponentType = types[types.length - 1];
				bits |= componentType.bit;
				types.length--;//delete last element
			}
			return bits;
		}

		private function collectionDisposing(collection:EntitiesCollection):void
		{
			if(!_initialized)return;
			var index:int = _dependedCollections.indexOf(collection);
			_dependedCollections.splice(index, 1);
			_dependedLength--;
		}
//} endregion PRIVATE\PROTECTED METHODS ================================================================================
//======================================================================================================================
//{region											GETTERS/SETTERS

//} endregion GETTERS/SETTERS ==========================================================================================

	}
}
