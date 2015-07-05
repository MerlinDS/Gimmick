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

	import org.gimmick.collections.EntitiesCollection;
	import org.gimmick.collections.IEntitiesCollection;
	import org.gimmick.core.*;
	import org.gimmick.utils.SetList;

	/**
	 * Manager for controlling of entities
	 */
	internal class EntitiesManager extends EntitiesCollection implements IEntitiesManager
	{

		private var _activeEntities:SetList;
		private var _passiveEntities:SetList;

		private var _collectionPool:Vector.<EntitiesCollection>;
		private var _existCollections:Vector.<EntitiesCollection>;
//======================================================================================================================
//{region											PUBLIC METHODS
		public function EntitiesManager()
		{
			super (null);
		}

		/**
		 * @inheritDoc
		 */
		public function initialize():void
		{
			_passiveEntities = new SetList();
			_activeEntities = new SetList();

		}

		/**
		 * @inheritDoc
		 */
		public function addEntity(entity:IEntity):void
		{
			_passiveEntities.addValue(entity.id, entity);
		}
		/**
		 * Remove entity
		 * @param entity Instance of the entity
		 */
		public function removeEntity(entity:IEntity):void
		{

		}

		public function changeEntityActivity(entity:IEntity):void
		{

		}


		public function addToFilter(entity:IEntity, componentType:ComponentType):void
		{

		}

		public function removeFromFilter(entity:IEntity, componentType:ComponentType):void
		{

		}

		public function get collection():IEntitiesCollection
		{
			return this;
		}

//} endregion PUBLIC METHODS ===========================================================================================
//======================================================================================================================
//{region										PRIVATE\PROTECTED METHODS

//} endregion PRIVATE\PROTECTED METHODS ================================================================================
//======================================================================================================================
//{region											GETTERS/SETTERS

//} endregion GETTERS/SETTERS ==========================================================================================

	}
}
