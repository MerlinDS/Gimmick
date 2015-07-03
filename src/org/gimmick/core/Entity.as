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
	 * Internal class of entity.
	 * User can create entity only by using createEntity method of GimmickEngine
	 *
	 * @see org.gimmick.core.GimmickEngine.createEntity() Use Gimmick.createEntity() method for creating new Entity
	 * @see org.gimmick.core.GimmickEngine.disposeEntity() Use Gimmick.disposeEntity() method for disposing exist Entity
	 */
	internal final class Entity implements IEntity
	{

		private var _index:int;
		private var _name:String;
		/**
		 * Unique ID of the component
		 */
		private var _id:String;
		/**
		 * Bitwise mask of all components that linked to entity
		 */
		private var _bits:uint;
		private var _componentsManager:ComponentsManager;
		private var _filtersManager:FiltersManager;
//======================================================================================================================
//{region											PUBLIC METHODS

		/**
		 * Constructor
		 * @param name Name of the component
		 * @param index Index of the component in Gimmick scope
		 *
		 */
		public function Entity(name:String, index:int)
		{
			_name = name;
			_index = index;
			_bits = 0;
		}

		/**
		 * @inheritDoc
		 */
		[Inline]
		public final function add(component:Object):*
		{
			_componentsManager.addComponent(this, component);
			_filtersManager.addToFilter(this, component);
			return component;
		}

		/**
		 * @inheritDoc
		 */
		[Inline]
		public final function has(componentType:Class):Boolean
		{
			return false;
		}

		/**
		 * @inheritDoc
		 */
		[Inline]
		public final function get(componentType:Class):*
		{
			return _componentsManager.getComponent(this, componentType);
		}

		/**
		 * @inheritDoc
		 */
		[Inline]
		public final function remove(componentType:Class):void
		{
			_componentsManager.removeComponent(this, componentType);
			_filtersManager.removeFromFilter(this, componentType);
		}

		/**
		 * Dispose entity.
		 * Prepare entity instance for removing from memory
		 */
		internal final function dispose():void
		{
			_bits = 0x0;
			_index = -1;
			_id = null;
			_componentsManager = null;
			_filtersManager = null;
		}
//} endregion PUBLIC METHODS ===========================================================================================
//======================================================================================================================
//{region										PRIVATE\PROTECTED METHODS

//} endregion PRIVATE\PROTECTED METHODS ================================================================================
//======================================================================================================================
//{region											GETTERS/SETTERS
		/**
		 * Entity needs link to componentsManager for working with components
		 * @param value Link to ComponentsManager instance
		 */
		internal function set componentsManager(value:ComponentsManager):void
		{
			_componentsManager = value;
		}

		internal function set filtersManager(value:FiltersManager):void
		{
			_filtersManager = value;
		}

		/**
		 * Index of the component in Gimmick scope
		 */
		[Inline]
		internal final function get index():int
		{
			return _index;
		}
		//Implementation of public interface

		/**
		 * @inheritDoc
		 */
		[Inline]
		public final function get name():String
		{
			return _name;
		}

		/**
		 * @inheritDoc
		 */
		[Inline]
		public final function get id():String
		{
			return _id;
		}

		/**
		 * @inheritDoc
		 */
		[Inline]
		public final function get components():Array
		{
			return _componentsManager.getComponents(this);
		}

//} endregion GETTERS/SETTERS ==========================================================================================
	}
}
