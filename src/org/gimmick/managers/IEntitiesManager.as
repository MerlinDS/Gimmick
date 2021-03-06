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

	import org.gimmick.collections.IEntities;
	import org.gimmick.core.ComponentType;
	import org.gimmick.core.IEntity;

	/**
	 * Manager for entities collections.
	 */
	public interface IEntitiesManager extends IGimmickManager
	{
		//======================================================================================================================
//{region											PUBLIC METHODS
		/**
		 * Add entity to entities collections
		 * @param entity Entity instance
		 * @param componentType (default = null) Type of the linked component.
		 * If componentType field equals null, will added to base collection.
		 */
		function addEntity(entity:IEntity, componentType:ComponentType = null):void;

		/**
		 * Remove entity from collections
		 * @param entity Instance of the entity
		 * @param componentType (default = null) Type of the linked component.
		 * If componentType field equals null, will removed entity from all collections.
		 */
		function removeEntity(entity:IEntity, componentType:ComponentType = null):void;

		/**
		 * Create entities collection.
		 * @param types Bitwise mask for filtering entities collection
		 * @return IEntities - New instance of entities collection
		 *
		 * @see org.gimmick.collections.IEntities EntitiesCollection
		 */
		function getEntities(types:Array):IEntities;

		/**
		 * Method for manager looping
		 * @param time Time from the previous tick in microseconds
		 *
		 * @see org.gimmick.core.GimmickEngine.tick() Gimmick.tick() looping method
		 */
		function tick(time:Number):void;


//} endregion PUBLIC METHODS ===========================================================================================
//======================================================================================================================
//{region										PRIVATE\PROTECTED METHODS

//} endregion PRIVATE\PROTECTED METHODS ================================================================================
//======================================================================================================================
//{region											GETTERS/SETTERS
//} endregion GETTERS/SETTERS ==========================================================================================
	}
}
