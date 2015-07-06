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

	import flash.errors.IllegalOperationError;
	import flash.utils.getTimer;

	import org.gimmick.collections.IEntities;

	import org.gimmick.managers.GimmickConfig;
	import org.gimmick.managers.IComponentTypeManager;
	import org.gimmick.managers.IComponentsManager;
	import org.gimmick.managers.IEntitiesManager;
	import org.gimmick.managers.ISystemManager;

	/**
	 * This class contains public interface of Gimmick framework.
	 */
	internal class GimmickEngine
	{
		//managers
		private var _systemsManager:ISystemManager;
		private var _entitiesManager:IEntitiesManager;
		private var _componentsManager:IComponentsManager;
		private var _componentTypeManagers:IComponentTypeManager;
		//
		private var _lastTimestamp:Number;
		private var _initialized:Boolean;
		private var _onPause:Boolean;
//======================================================================================================================
//{region											PUBLIC METHODS
		public function GimmickEngine()
		{

		}
		/**
		 *
		 * @param config Configuration of Gimmick. Only for advanced usage
		 * @param autoStart Start Gimmick automatically
		 *
		 * @throws flash.errors.IllegalOperationError Dispose Gimmick engine before new initialization
		 *
		 * @see org.gimmick.managers.GimmickConfig Gimmick configuration
		 */
		public function initialize(config:GimmickConfig = null, autoStart:Boolean = true):void
		{
			if(_initialized)
				throw new IllegalOperationError("Gimmick already initialized!");
			if(config == null)
				config = new GimmickConfig();//create default configuration object
			//set managers to engine
			_systemsManager = config.systemManager;
			_entitiesManager = config.entitiesManager;
			_componentsManager = config.componentsManager;
			_componentTypeManagers = config.componentTypeManager;
			//initializeManagers managers
			_entitiesManager.initialize();
			_systemsManager.initialize();
			_componentsManager.initialize();
			_componentTypeManagers.initialize();
			_lastTimestamp = 0;
			_initialized = true;
			if(autoStart)
				this.resume(true);
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
			_initialized = false;
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

		public function getEntities(...types):IEntities
		{
			//get types bits
			var firstBit:uint = 0x0, bits:uint = 0x0;
			if(types != null)
			{
				var n:int = types.length;
				for(var i:int = 0; i < n; i++)
				{
					bits |= _componentTypeManagers.getType(types[i]).bit;
					if(i == 0)firstBit = bits;
				}
			}
			return _entitiesManager.getEntities(firstBit, bits);
		}
		//delegates from systemsManager
		/**
		 * @copy org.gimmick.managers.SystemManager#addSystem()
		 */
		public function addSystem(system:EntitySystem):EntitySystem
		{
			system.entities = _entitiesManager;
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
		 * @copy org.gimmick.managers.SystemManager#activateSystem()
		 */
		public function activateSystem(systemType:Class):void
		{
			_systemsManager.activateSystem(systemType)
		}

		/**
		 * @copy org.gimmick.managers.SystemManager#deactivateSystem()
		 */
		public function deactivateSystem(system:Class):void
		{
			_systemsManager.deactivateSystem(system);
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
//} endregion PRIVATE\PROTECTED METHODS ================================================================================
//======================================================================================================================
//{region											GETTERS/SETTERS

//} endregion GETTERS/SETTERS ==========================================================================================
	}
}
