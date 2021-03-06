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

	import org.gimmick.core.Component;
	import org.gimmick.core.ComponentType;
	import org.gimmick.core.IEntity;

	/**
	 * Interface for component managers
	 */
	public interface IComponentsManager extends IGimmickManager
	{
		//======================================================================================================================
//{region											PUBLIC METHODS
		/**
		 * Link component instance to entity
		 * @param entity Instance of the entity
		 * @param componentType ComponentType of component
		 * @param component Instance of the component
		 */
		function addComponent(entity:IEntity, componentType:ComponentType, component:Component):void;
		/**
		 * Remove link of component from entity
		 * @param entity Instance of the entity
		 * @param componentType Type of the component
		 */
		function removeComponent(entity:IEntity, componentType:ComponentType):void;
		/**
		 * Get component linked to Entity
		 * @param entity Instance of the entity
		 * @param componentType Type of the component
		 * @return Component instance if it was linked to Entity. In other case will return null
		 *
		 * @see org.gimmick.core.ComponentManager.addComponent() Before getting linked component you need to add component link to entity
		 */
		function getComponent(entity:IEntity, componentType:ComponentType):*;
		/**
		 * Gather all components of the entity to list and return it
		 * @param entity Instance of the entity
		 * @return List of all components of the entity
		 */
		function getComponents(entity:IEntity):Array;
		/**
		 * Remove all components linked to <code>Entity</code>
		 * @param entity Instance of the entity
		 */
		function removeComponents(entity:IEntity):void;
//} endregion PUBLIC METHODS ===========================================================================================
//======================================================================================================================
//{region										PRIVATE\PROTECTED METHODS

//} endregion PRIVATE\PROTECTED METHODS ================================================================================
//======================================================================================================================
//{region											GETTERS/SETTERS

//} endregion GETTERS/SETTERS ==========================================================================================
	}
}
