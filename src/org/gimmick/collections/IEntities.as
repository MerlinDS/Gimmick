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

	public interface IEntities extends ICollectionIterator
	{
		//======================================================================================================================
//{region											PUBLIC METHODS
		/**
		 * Crate copy of IEntities.
		 * Created copy will works with parent content, but asses of disposing of content will be denied.
		 * @return Instance of new copy.
		 */
		function dependedClone():IEntities;
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
//} endregion PUBLIC METHODS ===========================================================================================
//======================================================================================================================
//{region										PRIVATE\PROTECTED METHODS

//} endregion PRIVATE\PROTECTED METHODS ================================================================================
//======================================================================================================================
//{region											GETTERS/SETTERS
		/**
		 * Update filtration bitwise mask for collection.
		 * Don't do this without big necessity.
		 * Will be automatically updated by engine
		 * @param value New filtration bitwise mask
		 */
		function set bits(value:uint):void;
//} endregion GETTERS/SETTERS ==========================================================================================
	}
}
