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

package org.gimmick.core
{

	/**
	 * Public interface of all Entities in Gimmick.
	 * User can get only object with this interface but not an Entity directly.
	 */
	public interface IEntity
	{
//======================================================================================================================
//{region											PUBLIC METHODS
		/**
		 * Add component to Entity. If component with similar type was already added new component will replace it.
		 * @param component Instance of the component
		 * @return Instance of the component. For chaining.
		 */
		function add(component:Object):*;

		/**
		 * Check i
		 * @param componentType
		 * @return
		 */
		function has(componentType:Class):Boolean;

		/**
		 * Get instance of the component for Entity. If component was not added to Entity or was removed
		 * this method will return null.
		 * @param componentType Type of the component
		 * @return Instance of the component.
		 */
		function get(componentType:Class):*;

		/**
		 * Remove component from Entity.
		 * @param componentType Type of the component
		 */
		function remove(componentType:Class):void;

		/**
		 * Get list of all components for Entity
		 * @return List of all components for Entity
		 */
		function getComponents():Array;
//} endregion PUBLIC METHODS ===========================================================================================
//======================================================================================================================
//{region										PRIVATE\PROTECTED METHODS

//} endregion PRIVATE\PROTECTED METHODS ================================================================================
//======================================================================================================================
//{region											GETTERS/SETTERS
		/**
		 * Name of the Entity
		 */
		function get name():String;
		/**
		 * Unique id of the Entity
		 */
		function get id():String;
//} endregion GETTERS/SETTERS ==========================================================================================
	}
}
