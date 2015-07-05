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

	import org.gimmick.core.ComponentType;
	import org.gimmick.core.IEntity;

	public interface IEntitiesManager extends IGimmickManager
	{
		//======================================================================================================================
//{region											PUBLIC METHODS
		/**
		 *
		 * @param entity
		 */
		function addEntity(entity:IEntity):void;
		/**
		 * Remove entity
		 * @param entity Instance of the entity
		 */
		function removeEntity(entity:IEntity):void;
		/**
		 *
		 * @param entity
		 */
		function changeEntityActivity(entity:IEntity):void;
		/**
		 *
		 * @param entity
		 * @param componentType
		 */
		function addToFilter(entity:IEntity, componentType:ComponentType):void;
		/**
		 *
		 * @param entity
		 * @param componentType
		 */
		function removeFromFilter(entity:IEntity, componentType:ComponentType):void;
		/**
		 *
		 * @param components
		 */
		function getEntities(components:Array):void;
//} endregion PUBLIC METHODS ===========================================================================================
//======================================================================================================================
//{region										PRIVATE\PROTECTED METHODS

//} endregion PRIVATE\PROTECTED METHODS ================================================================================
//======================================================================================================================
//{region											GETTERS/SETTERS

//} endregion GETTERS/SETTERS ==========================================================================================
	}
}