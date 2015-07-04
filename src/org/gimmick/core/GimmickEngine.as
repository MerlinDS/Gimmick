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

	import flash.utils.getTimer;

	import org.gimmick.managers.ComponentsManager;
	import org.gimmick.managers.EntitiesManager;
	import org.gimmick.managers.SystemManager;

	/**
	 * This class contains public interface of Gimmick framework.
	 */
	internal class GimmickEngine
	{
		//managers
		private var _systemsManager:SystemManager;
		private var _entitiesManager:EntitiesManager;
		private var _componentsManager:ComponentsManager;
		private var _componentTypeManagers:ComponentTypeManager;
		//
		private var _lastTimestamp:Number;
		private var _onPause:Boolean;
//======================================================================================================================
//{region											PUBLIC METHODS
		public function GimmickEngine()
		{
			this.initialize();
		}

		/**
		 * Set Gimmick to pause.
		 * Entity systems will not updated (EntitySystem.tick() will not be executed event EntitySystems are in scope)
		 */
		public function pause():void
		{
			if(!_onPause)
				_onPause = true;
		}

		/**
		 * Resume Gimmick
		 * @param cleanTimer Clean internal Gimmick timestamp from previous tick time
		 */
		public function resume(cleanTimer:Boolean = false):void
		{
			if(_onPause)
			{
				if(cleanTimer)
					_lastTimestamp = getTimer();
				_onPause = false;
			}
		}

		/**
		 * Free memory from Gimmick framework
		 */
		public function dispose():void
		{
			_systemsManager.dispose();
			_entitiesManager.dispose();
			_componentsManager.dispose();
			_componentTypeManagers.dispose();

			_systemsManager = null;
			_entitiesManager = null;
			_componentsManager = null;
			_componentTypeManagers = null;
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
			var entity:Entity = new Entity(name);
			entity.componentTypeManager = _componentTypeManagers;
			entity.componentsManager = _componentsManager;
			entity.entitiesManager = _entitiesManager;
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
			_componentsManager.removeComponents(entity as Entity);
			_entitiesManager.removeEntity(entity as Entity);
		}
		//delegates from systemsManager
		/**
		 * @copy org.gimmick.managers.SystemManager#addSystem()
		 */
		public function addSystem(system:EntitySystem):EntitySystem
		{
			return _systemsManager.addSystem(system);
		}

		/**
		 * @copy org.gimmick.managers.SystemManager#removeSystem()
		 */
		public function removeSystem(systemType:Class):void
		{
			_systemsManager.removeSystem(systemType);
		}
		/**
		 * @copy org.gimmick.managers.SystemManager#addToScope()
		 */
		public function addToScope(systemType:Class):void
		{
			_systemsManager.addToScope(systemType)
		}

		/**
		 * @copy org.gimmick.managers.SystemManager#removeFromScope()
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
			if(_onPause)
			{
				//do not update systems if Gimmick on pause
				return;
			}
			var now:Number = getTimer();
			var passedTime:Number = now - _lastTimestamp;
			_lastTimestamp = now;
			//update systems
			_systemsManager.tick(passedTime);
		}
//} endregion PUBLIC METHODS ===========================================================================================
//======================================================================================================================
//{region										PRIVATE\PROTECTED METHODS
		/**
		 * Initialize GimmickEngine. Create all managers and startup preparations.
		 */
		private function initialize():void
		{
			//initialize managers
			_componentTypeManagers = new ComponentTypeManager();
			//TODO need initialization with external managers
			_systemsManager = new SystemManager();
			_entitiesManager = new EntitiesManager();
			_componentsManager = new ComponentsManager();
			_entitiesManager.initialize();
			_systemsManager.initialize();
			_componentsManager.initialize();
			//
			_lastTimestamp = 0;
			this.resume(true);
		}
//} endregion PRIVATE\PROTECTED METHODS ================================================================================
//======================================================================================================================
//{region											GETTERS/SETTERS

//} endregion GETTERS/SETTERS ==========================================================================================
	}
}
