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
	import org.hamcrest.core.both;

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
		/**
		 * Pre initialized collecctions.
		 * Can be disposed manualy only.
		 */
		private var _fixedCollections:Vector.<EntitiesCollection>;
		private var _allocatedClones:Vector.<EntitiesCollection>;
		private var _freeClones:Vector.<EntitiesCollection>;

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
			_fixedCollections = new <EntitiesCollection>[];
			_allocatedClones = new <EntitiesCollection>[];
			_freeClones = new <EntitiesCollection>[];
			//initialize base collection without any filltration, that contains all entities
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
			//get bitwis mask for new collection
			var bits:uint = getBits(types);
			var collection:EntitiesCollection;
			if(!_initialized)
			{
				if (_baseCollections[bits] == null)
					_baseCollections[bits] = new EntitiesCollection(_allocationSize,
																this.collectionDisposed);
				collection = _baseCollections[bits];
				//must return only depended clones!
				collection = collection.dependedClone() as EntitiesCollection;
				//add clone to fixed list for manualy disposing
				_fixedCollections[_fixedCollections.length] = collection;
			}
			else
				collection = this.clonedCollection(bits);

			return collection;
		}

		/**
		 * @inheritDoc
		 */
		public function tick(time:Number):void
		{
			if(!_initialized)
				_initialized = true;
			//free all allocated collections
			while(_allocatedClones.length > 0)
			{
				var collection:EntitiesCollection = _allocatedClones[_allocatedClones.length-1];
				collection.clear();
				_freeClones[_freeClones.length] = collection;
				_allocatedClones.length--;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function dispose():void
		{
			_initialized = false;
			for each(var collection:EntitiesCollection in _baseCollections)
				collection.dispose();
			while(_allocatedClones.length > 0)
			{
				collection = _allocatedClones[_allocatedClones.length - 1];
				collection.dispose();
				_allocatedClones.length--;
			}
			while(_freeClones.length > 0)
			{
				collection = _freeClones[_freeClones.length - 1];
				collection.dispose();
				_freeClones.length--;
			}

			_allocatedClones = null;
			_baseCollections = null;
			_freeClones = null;
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
				var n:uint = collectionBits & bits;
				if ((bits & collectionBits) == collectionBits)
				{
					/*
				  	 * If entities [removes from]/[added to] base collection,
				  	 * depeneded clones are also will updated
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

		private function clonedCollection(bits:uint):EntitiesCollection
		{
			var collection:EntitiesCollection;
			var baseCollection:EntitiesCollection = _baseCollections[bits] != null ?
					_baseCollections[bits] : _baseCollections [0x0];
			//
			if (_freeClones.length == 0)
			{
				//create new clone
				collection = baseCollection.dependedClone() as EntitiesCollection;
			}
			else
			{
				//get existing clone
				collection = _freeClones[_freeClones.length - 1];
				_freeClones.length--;//delete from free clones
				_baseCollections.dependedClone(collection);
			}

			_allocatedClones[_allocatedClones.length] = collection;
			collection.bits = bits;
			return collection;
		}

		private function collectionDisposed(collection:EntitiesCollection):void
		{
			if(!_initialized)return;//
			//check in fixed
			var index:int = _fixedCollections.indexOf(collection);
			if(index > -1)
				_fixedCollections.splice(index, 1);
			else
			{
				//check in allocated
				index = _allocatedClones.indexOf(collection);
				_allocatedClones.splice(index, 1);
			}
			//save collection to new once
			_freeClones[_freeClones.length] = collection;
			//in other cases do not do anything
		}
//} endregion PRIVATE\PROTECTED METHODS ================================================================================
//======================================================================================================================
//{region											GETTERS/SETTERS

//} endregion GETTERS/SETTERS ==========================================================================================

	}
}
