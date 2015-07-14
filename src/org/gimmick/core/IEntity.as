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
	 *
	 * @see org.gimmick.core.GimmickEngine#createEntity() Use Gimmick.createEntity() method for creating new Entity
	 * @see org.gimmick.core.GimmickEngine#disposeEntity() Use Gimmick.disposeEntity() method for disposing exist Entity
	 *
	 * @example
	 * <listing version="3.0">
	 *     var entity:IEntity = Gimmick.createEntity('Entity name');
	 *     entity.add(new SomeComponent());//create and link component to entity
	 *     //...
	 *     if(entity.has(SomeComponent))//has method faster that get, use has method for check linkage of the component
	 *     {
	 *     		var component:SomeComponent = entity.get(SomeComponent);//Get instance of the component
	 *     		entity.remove(SomeComponent);//Component doesn't linked to entity an more.
	 *     }
	 *     //...
	 *     Gimmick.disposeEntity(entity);//remove entity from Gimmick (entity will be prepared for GC automatically)
	 * </listing>
	 */
	public interface IEntity
	{
//======================================================================================================================
//{region											PUBLIC METHODS
		/**
		 * Add component to Entity. If component with similar type was already added new component will replace it.
		 *
		 * @param component Instance of the component.
		 * @return Instance of the component that was added to entity. For chaining.
		 *
		 * @see org.gimmick.core.Component Abstract Component super class
		 *
		 * @example
		 * <listing version="3.0">
		 *     var entity:IEntity = Gimmick.createEntity('Entity name');
		 *     var component:SomeComponent = entity.add(new SomeComponent());
		 * </listing>
		 */
		function add(component:Component):*;

		/**
		 * Check if component was linked to Entity
		 * @param component Component Class
		 * @return True if component was linked to Entity, and false in other case
		 */
		function has(component:Class):Boolean;

		/**
		 * Get instance of the component for Entity. If component was not added to Entity or was removed
		 * this method will return null.
		 * @param component Component Class
		 * @return Instance of the component.
		 *
		 * @see org.gimmick.core.Component Abstract Component super class
		 */
		function get(component:Class):*;

		/**
		 * Remove component from Entity.
		 * @param component Component Class
		 */
		function remove(component:Class):void;

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
		/**
		 * Bitwise mask of all components linked to entity
		 */
		function get bits():uint;
		/**
		 * List of all components that constance current Entity
		 * WARNING: It is a slow method. Use it in great need
		 */
		function get components():Array;

//} endregion GETTERS/SETTERS ==========================================================================================
	}
}
