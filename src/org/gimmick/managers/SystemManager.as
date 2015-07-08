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

		private var _systemsTypes:Dictionary;
		private var _passiveSystems:Vector.<IEntitySystem>;
		private var _activeSystems:Vector.<IEntitySystem>;
		private var _activeLength:int;
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
			//TODO Data consistency #10
			_activeSystems = new <IEntitySystem>[];
			_passiveSystems = new <IEntitySystem>[];
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
			_passiveSystems[_passiveSystems.length] = system;
			_systemsTypes[type] = system;
			//all was done nornaly, lets initialize system
			system.initialize();
			return system;
		}

		/**
		 * @inheritDoc
		 */
		public function removeSystem(systemType:Class):IEntitySystem
		{
			var index:int;
			var system:IEntitySystem;
			var list:Vector.<IEntitySystem>;
			system = _systemsTypes[systemType];
			if(system == null)
				throw new ArgumentError('IEntitySystem was not added to Gimmick previously!');
			//trying to find system, do not use getSystemByType cause index and list of system will be need
			if(_systemsTypes[systemType] != null)
			{
				//in normal behavior system will be olready deactivated
				list = _passiveSystems;
				index = list.indexOf(system);
				if(index < 0)//system is not deactivated yet :(
				{
					list = _activeSystems;
					index = list.indexOf(system);
					//if system was not found in both list, something goes wrong!
					if(index < 0)
						throw new Error('System was not found nor in active systems neither in passive!');
					system.deactivate();
					_activeLength--;
				}
			}
			//remove system from list and map
			_systemsTypes[systemType] = null;
			list.splice(index, 1);//No needs in fast method
			//all was done nornaly, lets dispose system
			system.dispose();
			return system;
		}

		/**
		 * @inheritDoc
		 */
		public function activateSystem(systemType:Class):void
		{
			var system:IEntitySystem = _systemsTypes[systemType];
			if(system == null)
				throw new ArgumentError('IEntitySystem was not added to Gimmick previously!');
			var indes:int = _passiveSystems.indexOf(system);
			if(indes >= 0)//in other case system was already activated
			{
				_passiveSystems.splice(indes, 1);//!!! slow, with redundant allocations
				_activeSystems[_activeLength++] = system;
				system.activate();
			}
		}

		/**
		 * @inheritDoc
		 */
		public function deactivateSystem(systemType:Class):void
		{
			var system:IEntitySystem = _systemsTypes[systemType];
			if(system == null)
				throw new ArgumentError('IEntitySystem was not added to Gimmick previously!');
			var indes:int = _activeSystems.indexOf(system);
			if(indes >= 0)//in other case was olready deactivated
			{
				_activeSystems.splice(indes, 1);//!!! slow, with redundant allocations
				_passiveSystems[_passiveSystems.length] = system;
				_activeLength--;
				system.deactivate();
			}
		}

		/**
		 * @inheritDoc
		 */
		public function tick(time:Number):void
		{
			for(var i:int = 0; i < _activeLength; ++i)
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
			//deactivate and dispose active systems
			while(_activeSystems.length > 0)
			{
				_activeSystems[_activeSystems.length - 1].deactivate();
				_activeSystems.pop().dispose();
			}
			//dispose passive systems
			while(_passiveSystems.length > 0)
				_passiveSystems.pop().dispose();
			//clean manager from systems
			_systemsTypes = null;
			_passiveSystems = null;
			_activeSystems = null;
			_activeLength = 0;
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
