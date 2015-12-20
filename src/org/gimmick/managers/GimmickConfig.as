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
	/**
	 * Configuration for Gimmick engine.
	 * Will be used only for Gimmick initialization.
	 * After gimmick initialization will be disposed.
	 * Constance managers classes and collections
	 */
	public class GimmickConfig
	{

		//managers
		private var _systemManager:ISystemManager;
		private var _componentsManager:IComponentsManager;
		private var _entitiesManager:IEntitiesManager;
		private var _componentTypeManager:ComponentTypeManager;
		//allocations
		private var _maxEntities:int;
		private var _maxComponents:int;
		//other configurations
		private var _optimalFPS:int;
		private var _initCallback:Function;
//======================================================================================================================
//{region											PUBLIC METHODS
		/**
		 * Constructor of config
		 * @param optimalFPS - Optimal application fps. Used to calculate tick to free memory from disposed entities.
		 * @param initCallback - Callback that will be executed after initialization
		 */
		public function GimmickConfig(optimalFPS:int = 60, initCallback:Function = null)
		{
			_componentTypeManager = new ComponentTypeManager();
			_optimalFPS = optimalFPS;
			_initCallback = initCallback;
			//
			_maxEntities = 100;
			_maxComponents = 100;
		}

		/**
		 * Prepare config object for GC. Reset links and data.
		 * Will be executed automatically, by Gimmick, after initialization.
		 */
		public function dispose():void
		{
			_optimalFPS = 0;
			_initCallback = null;
			_maxEntities = 0;
			_maxComponents = 0;
			_componentsManager = null;
			_componentTypeManager = null;
			_entitiesManager = null;
			_systemManager = null;
		}

//} endregion PUBLIC METHODS ===========================================================================================
//======================================================================================================================
//{region										PRIVATE\PROTECTED METHODS

//} endregion PRIVATE\PROTECTED METHODS ================================================================================
//======================================================================================================================
//{region											GETTERS/SETTERS

		[Inline]
		public final function set systemManager(value:ISystemManager):void
		{
			_systemManager = value;
		}

		[Inline]
		public final function set componentsManager(value:IComponentsManager):void
		{
			_componentsManager = value;
		}

		[Inline]
		public final function set entitiesManager(value:IEntitiesManager):void
		{
			_entitiesManager = value;
		}

		[Inline]
		public final function get systemManager():ISystemManager
		{
			return _systemManager || new SystemManager();
		}

		[Inline]
		public final function get componentsManager():IComponentsManager
		{
			return _componentsManager || new ComponentsManager();
		}

		[Inline]
		public final function get entitiesManager():IEntitiesManager
		{
			return _entitiesManager || new EntitiesManager();
		}

		[Inline]
		public final function get componentTypeManager():ComponentTypeManager
		{
			return _componentTypeManager;
		}
		//allocations configuration
		/**
		 * @private
		 */
		[Inline]
		public final function get maxEntities():int
		{
			return _maxEntities;
		}

		/**
		 * Presumably maximum count of entities in application.
		 * Used to allocate memory for entities collection.
		 * This is not flag of a limitation!
		 * In case when count of entities will be bigger than allocated size,
		 * collection will allocate additional memory for new entities.
		 *
		 * @default 100
		 * @see org.gimmick.collections.EntitiesCollection EntitiesCollection
		 */
		[Inline]
		public final function set maxEntities(value:int):void
		{
			_maxEntities = value;
		}

		/**
		 * @private
		 */
		[Inline]
		public final function get maxComponents():int
		{
			return _maxComponents;
		}
		/**
		 * Presumably maximum count of components (one type of components!) in application.
		 * Used to allocate memory for components collection.
		 * This is not flag of a limitation!
		 * In case when count of components will be bigger than allocated size,
		 * collection will allocate additional memory for new entities.
		 *
		 * @default 100
		 * @see org.gimmick.collections.ComponentsCollection ComponentsCollection
		 */
		[Inline]
		public final function set maxComponents(value:int):void
		{
			_maxComponents = value;
		}

		[Inline]
		public final function get optimalFPS():int
		{
			return _optimalFPS;
		}

		[Inline]
		public final function get initCallback():Function
		{
			return _initCallback;
		}

//} endregion GETTERS/SETTERS ==========================================================================================
	}
}
