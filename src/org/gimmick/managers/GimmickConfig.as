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
	 * Constance managers classes and collections
	 */
	public class GimmickConfig
	{

		private var _systemManager:ISystemManager;
		private var _componentsManager:IComponentsManager;
		private var _entitiesManager:IEntitiesManager;
		private var _componentTypeManager:ComponentTypeManager;
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

//} endregion GETTERS/SETTERS ==========================================================================================
	}
}
