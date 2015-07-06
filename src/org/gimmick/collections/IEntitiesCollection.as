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

	/**
	 * Interface of entities collection.
	 */
	public interface IEntitiesCollection
	{
//======================================================================================================================
//{region											PUBLIC METHODS
		//list methods
		/**
		 * Push Entity to collection
		 * @param entity Instance of entity
		 */
		function push(entity:IEntity):void;

		/**
		 * Pop Entity from collection
		 * @param entity Instance of entity
		 */
		function pop(entity:IEntity):void;

		/**
		 * Check if collection contains entity with id
		 * @param entityId Entity Id
		 * @return True if collection contains such entity. False in other case
		 */
		function hasId(entityId:String):Boolean;

		/**
		 * Check if collection contains entity
		 * @param entity Instance of entity
		 * @return True if collection contains such entity. False in other case
		 */
		function hasEntity(entity:IEntity):Boolean;
		/**
		 * Get entity from collection by id
		 * @param entityId Entity Id
		 * @return Instance of entity if collection contains such entity. Null in other case
		 */
		function getById(entityId:String):IEntity;

		/**
		 * Dispose collection and prepare it for GC
		 */
		function dispose():void;
//} endregion PUBLIC METHODS ===========================================================================================
//======================================================================================================================
//{region										PRIVATE\PROTECTED METHODS
		function get iterator():ICollectionIterator;
//} endregion PRIVATE\PROTECTED METHODS ================================================================================
//======================================================================================================================
//{region											GETTERS/SETTERS

//} endregion GETTERS/SETTERS ==========================================================================================
	}
}
