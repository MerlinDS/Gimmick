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
	 * This class contains public interface of Gimmick framework.
	 */
	internal class GimmickEngine
	{
		//managers
		private var _systemsManager:SystemManager;
		private var _filtersManager:FilterManager;
		private var _entitiesManager:EntitiesManager;
		private var _componentsManager:ComponentsManager;
//======================================================================================================================
//{region											PUBLIC METHODS
		public function GimmickEngine()
		{
			this.initialize();
		}
		//delegates from entitiesManager
		/**
		 * Create new entity and add it to main loop
		 * @param name Name of the new Entity. Can be generated automatically
		 * @return Instance of new Entity. New entity will be empty (without components).
		 * To add a component to Entity use Entity.add() method.
		 *
		 * @see org.gimmick.core.IEntity Entity public interface
		 * @example
		 * <listing version="3.0">
		 * var entity:IEntity = Gimmick.createEntity("entityName");
		 * entity.add(new Component());
		 * </listing>
		 */
		public function createEntity(name:String = null):IEntity
		{
			var entity:Entity = _entitiesManager.createEntity(name);
			entity.componentsManager = _componentsManager;
			//TODO add entity to filters
			return entity;
		}

		/**
		 * Dispose existing entity. Remove entity from scope and free memory from it data.
		 * @param entity Instance of existing Entity.
		 *
		 * @throws ArgumentError If entity was not in scope or was disposed previously
		 */
		public function disposeEntity(entity:IEntity):void
		{

		}
		//delegates from systemsManager
		/**
		 * @copy org.gimmick.core.SystemManager#addSystem()
		 */
		public function addSystem(system:EntitySystem):EntitySystem
		{
			_systemsManager.addSystem(system);
			return system;
		}

		/**
		 * @copy org.gimmick.core.SystemManager#removeSystem()
		 */
		public function removeSystem(systemType:Class):void
		{
			_systemsManager.removeSystem(systemType);
		}
		/**
		 * @copy org.gimmick.core.SystemManager#addToScope()
		 */
		public function addToScope(systemType:Class):void
		{
			_systemsManager.addToScope(systemType)
		}

		/**
		 * @copy org.gimmick.core.SystemManager#removeFromScope()
		 */
		public function removeFromScope(system:Class):void
		{
			_systemsManager.removeFromScope(system);
		}

		//updates
		/**
		 * Loop method of framework.
		 * @example
		 * <listing version="3.0">
		 *     this.stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		 *
		 *     enterFrameHandler(event:Event):void
		 *     {
		 *     		Gimmick.tick();
		 *     }
		 * </listing>
		 */
		public function tick():void
		{

		}
//} endregion PUBLIC METHODS ===========================================================================================
//======================================================================================================================
//{region										PRIVATE\PROTECTED METHODS
		/**
		 * Initialize GimmickEngine. Create all managers and startup preparations.
		 */
		private function initialize():void
		{
			_systemsManager = new SystemManager();
			_componentsManager = new ComponentsManager();
			_entitiesManager = new EntitiesManager();
			_filtersManager = new FilterManager();
		}
//} endregion PRIVATE\PROTECTED METHODS ================================================================================
//======================================================================================================================
//{region											GETTERS/SETTERS

//} endregion GETTERS/SETTERS ==========================================================================================
	}
}
