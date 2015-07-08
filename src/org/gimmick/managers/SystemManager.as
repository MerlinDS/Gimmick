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

	import flash.utils.Dictionary;

	import org.gimmick.core.IEntitySystem;
	import org.gimmick.utils.getInstanceClass;

	/**
	 * Managing of all systems in Gimmick engine
	 */
	internal class SystemManager implements ISystemManager
	{

		//TODO Data consistency #10
		private var _activeSystems:Vector.<IEntitySystem>;
		private var _passiveSystems:Vector.<IEntitySystem>;
		private var _systemsTypes:Dictionary;

		private var _systems:Vector.<IEntitySystem>;
		private var _systemsLength:int;
//======================================================================================================================
//{region											PUBLIC METHODS
		public function SystemManager()
		{
		}

		/**
		 * @inheritDoc
		 */
		public function initialize():void
		{
			_systems = new <IEntitySystem>[];
			_systemsTypes = new Dictionary(true);
		}

		/**
		 * @inheritDoc
		 */
		public function addSystem(system:IEntitySystem):IEntitySystem
		{
			var type:Class = getInstanceClass(system);
			//remove old system from manager
			if(_systemsTypes[type] != null)//Do not use hasOwnProperty, cause this method is very slow
				this.removeSystem(type);
			//save new systemType to map
			_systemsTypes[type] = _systemsLength;
			_systems[_systemsLength] = system;
			_systemsLength++;
			return system;
		}

		/**
		 * @inheritDoc
		 */
		public function removeSystem(systemType:Class):IEntitySystem
		{
			var system:IEntitySystem;
			//trying to find system, do not use getSystemByType cause index of system will be need
			if(_systemsTypes[systemType] != null)
			{
				var index:int = _systemsTypes[systemType];
				system = _systems[index];
			}
			if(system == null)
				throw new ArgumentError('IEntitySystem was not added to Gimmick previously!');
			//remove system from list and map
			_systemsTypes[systemType] = null;
			_systems.splice(index, 1);//No needs in fast method
			_systemsLength--;
			return system;
		}

		/**
		 * @inheritDoc
		 */
		public function activateSystem(systemType:Class):void
		{
			var system:IEntitySystem = this.getSystemByType(systemType);
			if(system == null)
				throw new ArgumentError('IEntitySystem was not added to Gimmick previously!');
		}

		/**
		 * @inheritDoc
		 */
		public function deactivateSystem(systemType:Class):void
		{
			var system:IEntitySystem = this.getSystemByType(systemType);
			if(system == null)
				throw new ArgumentError('IEntitySystem was not added to Gimmick previously!');
		}

		/**
		 * @inheritDoc
		 */
		public function tick(time:Number):void
		{
			for(var i:int = 0; i < _systemsLength; ++i)
			{
				//update only active systems
				_activeSystems[i].tick(time);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function dispose():void
		{
			//clean manager from systems
			_systemsLength = 0;
			_systemsTypes = null;
			_systems = null;
		}
//} endregion PUBLIC METHODS ===========================================================================================
//======================================================================================================================
//{region										PRIVATE\PROTECTED METHODS
		[Inline]
		private final function getSystemByType(systemType:Class):IEntitySystem
		{
			var system:IEntitySystem;
			if(_systemsTypes[systemType] != null)
			{
				var index:int = _systemsTypes[systemType];
				system = _systems[index];
			}
			return system;
		}
//} endregion PRIVATE\PROTECTED METHODS ================================================================================
//======================================================================================================================
//{region											GETTERS/SETTERS

//} endregion GETTERS/SETTERS ==========================================================================================
	}
}
