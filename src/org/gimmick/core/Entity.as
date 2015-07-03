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
		private var _componentsManager:ComponentsManager;
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
		}

		/**
		 * @inheritDoc
		 */
		[Inline]
		public function add(component:Object):*
		{
			return null;
		}

		/**
		 * @inheritDoc
		 */
		[Inline]
		public function has(componentType:Class):Boolean
		{
			return false;
		}

		/**
		 * @inheritDoc
		 */
		[Inline]
		public function get(componentType:Class):*
		{
			return null;
		}

		/**
		 * @inheritDoc
		 */
		[Inline]
		public function remove(componentType:Class):void
		{
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
		[Inline]
		internal function set componentsManager(value:ComponentsManager):void
		{
			_componentsManager = value;
		}

		/**
		 * Index of the component in Gimmick scope
		 */
		[Inline]
		internal function get index():int
		{
			return _index;
		}
		//Implementation of public interface

		/**
		 * @inheritDoc
		 */
		[Inline]
		public function get name():String
		{
			return _name;
		}

		/**
		 * @inheritDoc
		 */
		[Inline]
		public function get id():String
		{
			return _id;
		}

		/**
		 * @inheritDoc
		 */
		public function get components():Array
		{
			return null;
		}

		/**
		 * @inheritDoc
		 */
		public function get componentsTypes():Array
		{
			return null;
		}

//} endregion GETTERS/SETTERS ==========================================================================================
	}
}
