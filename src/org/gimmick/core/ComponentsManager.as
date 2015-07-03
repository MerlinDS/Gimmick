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

	internal class ComponentsManager
	{

//======================================================================================================================
//{region											PUBLIC METHODS
		public function ComponentsManager()
		{
		}

		/**
		 * Link component instance to entity
		 * @param entity Instance of the entity
		 * @param componentType ComponentType of component
		 * @param component Instance of the component
		 */
		public function addComponent(entity:Entity, componentType:ComponentType, component:Object):void
		{

		}

		/**
		 * Remove link of component from entity
		 * @param entity Instance of the entity
		 * @param componentType Type of the component
		 */
		public function removeComponent(entity:Entity, componentType:ComponentType):void
		{

		}

		/**
		 * Get component linked to Entity
		 * @param entity Instance of the entity
		 * @param componentType Type of the component
		 * @return Component instance if it was linked to Entity. In other case will return null
		 *
		 * @see org.gimmick.core.ComponentManager.addComponent() Before getting linked component you need to add component link to entity
		 */
		public function getComponent(entity:Entity, componentType:ComponentType):*
		{
			return null;
		}

		/**
		 * Gather all components of the entity to list and return it
		 * @param entity Instance of the entity
		 * @return List of all components of the entity
		 */
		public function getComponents(entity:Entity):Array
		{
			return null;
		}

		/**
		 * Remove all components linked to <code>Entity</code>
		 * @param entity Instance of the entity
		 */
		public function removeComponents(entity:Entity):void
		{

		}

		public function dispose():void
		{

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
