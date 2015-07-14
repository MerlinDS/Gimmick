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

	public interface IEntities
	{
		//======================================================================================================================
//{region											PUBLIC METHODS
		/**
		 * Crate copy of IEntities.
		 * Created copy will works with parent content, but asses of disposing of content will be denied.
		 * @param clone Pre created instance of the clone
		 * @return Instance of new copy.
		 */
		function dependedClone(clone:IEntities = null):IEntities;
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
		//iterator
		/**
		 * Method for iterations. Move internal cursor to first element of collection.
		 * @return Current collection
		 */
		function begin():IEntities;

		/**
		 * Method for iterations. Flag of the end of collection that indicate end of iteration.
		 * @return True if internal cursor points to last element of collection. In other return false.
		 */
		function end():Boolean;

		/**
		 * Method for iterations. Move internal cursor to next element of collection.
		 */
		function next():void;

		/**
		 * Iterate through each entity in collection
		 * @param callback The function to run on each entity in collection.This function is invoked with two arguments:
		 * the current entity from the collection, and the collection object:
		 * @param thisObject (default=null) The object that the identifier this in the callback function refers to when the function is called.
		 */
		function forEach(callback:Function, thisObject:Object = null):void;
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
		/**
		 * Return entity that under internal cursor.
		 */
		function get current():IEntity;

		/**
		 * Check for collection emptiness.
		 * If true - collection has not elements. In other case false
		 */
		function get empty():Boolean;

		/**
		 * True - collection was disposed, collection could not be used any more.
		 * False - collection was not disposed.
		 */
		function get isDisposed():Boolean;
//} endregion GETTERS/SETTERS ==========================================================================================
	}
}
