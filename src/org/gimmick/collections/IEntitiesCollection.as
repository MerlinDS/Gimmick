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
	 * Interface for entities collection.
	 * Contains iterator of entities.
	 */
	public interface IEntitiesCollection
	{
		//======================================================================================================================
//{region											PUBLIC METHODS
		/**
		 * Get new collection for set of types
		 * @param types Types of the components
		 * @return new IEntitiesCollection
		 */
		function getCollection(...types):IEntitiesCollection;

		/**
		 * Dispose collection. Prepare collection for GC
		 */
		function dispose():void;
		/* iterator */
		/**
		 * Set cursor to begin of collection
		 */
		function begin():void;

		/**
		 * Flag that indicate tail of entities collection
		 * @return True if cursor pointed to tail on entities collection. False in other case.
		 */
		function end():Boolean;

		/**
		 * Move cursor to nest entity in entities collection
		 */
		function next():void;
//} endregion PUBLIC METHODS ===========================================================================================
//======================================================================================================================
//{region										PRIVATE\PROTECTED METHODS

//} endregion PRIVATE\PROTECTED METHODS ================================================================================
//======================================================================================================================
//{region											GETTERS/SETTERS
		/**
		 * Get entity from collection that under cursor
		 */
		function get current():IEntity;

		/**
		 * Get types that create collection
		 */
		function get collectionTypes():Array;
//} endregion GETTERS/SETTERS ==========================================================================================
	}
}
