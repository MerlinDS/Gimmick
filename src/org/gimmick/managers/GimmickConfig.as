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
	//TODO Gimmick initialization #7
	/**
	 * Configuration for Gimmick engine.
	 * Constance managers classes and collections
	 */
	public class GimmickConfig
	{

		private var _systemManager:ISystemManager;
		private var _componentsManager:IComponentsManager;
		private var _entitiesManager:IEntitiesManager;
		private var _componentTypeManager:ComponentTypeManager;

		private var _maxEntities:int;
		private var _maxComponents:int;
//======================================================================================================================
//{region											PUBLIC METHODS
		/**
		 * Constructor of config
		 * @param systemManager Instance of external SystemManager
		 * @param componentsManager Instance of external ComponentsManager
		 * @param entityManager Instance of external EntityManager
		 */
		public function GimmickConfig(systemManager:ISystemManager = null,
									  componentsManager:IComponentsManager = null,
									  entityManager:IEntitiesManager = null)
		{
			_systemManager = systemManager == null ? new SystemManager() : systemManager;
			_componentsManager = componentsManager == null ? new ComponentsManager() : componentsManager;
			_entitiesManager = entityManager == null ? new EntitiesManager() : entityManager;
			_componentTypeManager = new ComponentTypeManager();
			//
			_maxEntities = 100;
			_maxComponents = 100;
		}

//} endregion PUBLIC METHODS ===========================================================================================
//======================================================================================================================
//{region										PRIVATE\PROTECTED METHODS

//} endregion PRIVATE\PROTECTED METHODS ================================================================================
//======================================================================================================================
//{region											GETTERS/SETTERS

		[Inline]
		public final function get systemManager():ISystemManager
		{
			return _systemManager;
		}

		[Inline]
		public final function get componentsManager():IComponentsManager
		{
			return _componentsManager;
		}

		[Inline]
		public final function get entitiesManager():IEntitiesManager
		{
			return _entitiesManager;
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
		 * @deafult 100
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
		 * @deafult 100
		 * @see org.gimmick.collections.ComponentsCollection ComponentsCollection
		 */
		[Inline]
		public final function set maxComponents(value:int):void
		{
			_maxComponents = value;
		}

//} endregion GETTERS/SETTERS ==========================================================================================
	}
}
