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
		 * Comtaince all collections of entities.
		 * key - bits of collection mask
		 * value - vector of one type collections,
		 * where firts element is collection and other one is it's depended clones
		 */
		private var _collectionsMap:Dictionary;
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
		public function initialize():void
		{
			_collectionsMap = new Dictionary(true);
			//initialize base collection without any filltration (contains all entities)
			_collectionsMap[0x0] = new EntitiesCollection();
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
				bits = entity.bits;
				_collectionsMap[0x0].push(entity);
			}else
				bits = componentType.bit;
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
				_collectionsMap[0x0].pop(entity);
			}else
				bits = componentType.bit;
			this.updateCollections(entity, bits, false);
		}


		/**
		 * @inheritDoc
		 */
		public function getEntities(types:Array):IEntities
		{
			var bits:uint = 0x0;
			while(types.length > 0)bits |= types.pop();
			var collection:IEntities = _collectionsMap[bits];
			if(collection == null)
			{
				collection = _collectionsMap[0x0];
			}
			return collection;
		}

		/**
		 * @inheritDoc
		 */
		public function tick(time:Number):void
		{
		}

		/**
		 * @inheritDoc
		 */
		public function dispose():void
		{
			for each(var collection:IEntities in _collectionsMap)
				collection.dispose();
			_collectionsMap = null;
		}

//} endregion PUBLIC METHODS ===========================================================================================
//======================================================================================================================
//{region										PRIVATE\PROTECTED METHODS
		[Inline]
		private final function updateCollections(entity:IEntity, bits:uint, push:Boolean):void
		{
			for (var collectionBits:uint in _collectionsMap)
			{
				//collection included current entity
				if (bits & collectionBits)
				{
					/*
				  	 * If entities [removes from]/[added to] base collection,
				  	 * depeneded clones are also will updated
				  	*/
					if(push)
						_collectionsMap[collectionBits].push(entity);
					else
						_collectionsMap[collectionBits].pop(entity);
				}
			}
		}

//} endregion PRIVATE\PROTECTED METHODS ================================================================================
//======================================================================================================================
//{region											GETTERS/SETTERS

//} endregion GETTERS/SETTERS ==========================================================================================

	}
}
