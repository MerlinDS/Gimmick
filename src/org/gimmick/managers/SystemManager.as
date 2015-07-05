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

	import org.gimmick.core.*;
	import org.gimmick.utils.getInstanceClass;

	/**
	 * Managing of all systems in Gimmick engine
	 */
	public class SystemManager extends GimmickManager
	{

		private var _systemsTypes:Dictionary;
		private var _systems:Vector.<EntitySystem>;
		private var _systemsLength:int;
//======================================================================================================================
//{region											PUBLIC METHODS
		public function SystemManager()
		{
		}

		/**
		 * @inheritDoc
		 */
		override public function initialize():void
		{
			_systems = new <EntitySystem>[];
			_systemsTypes = new Dictionary(true);
		}

		/**
		 * Add instance of the <code>EntitySystem</code> to Gimmick engine.
		 * @param system Instance of the system
		 * @return Instance of the system (for chaining)
		 */
		public function addSystem(system:EntitySystem):EntitySystem
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
		 * Remove system from Gimmick engine.
		 * @param systemType Type of the system that was added to Gimmick previously
		 * @return Instance of disposed <code>EntitySystem</code>
		 *
		 * @throws ArgumentError EntitySystem was not added to Gimmick previously
		 */
		public function removeSystem(systemType:Class):EntitySystem
		{
			var system:EntitySystem;
			//trying to find system, do not use getSystemByType cause index of system will be need
			if(_systemsTypes[systemType] != null)
			{
				var index:int = _systemsTypes[systemType];
				system = _systems[index];
			}
			if(system == null)
				throw new ArgumentError('EntitySystem was not added to Gimmick previously!');
			system.active = false;//deactivate system
			system.entities = null;//dispose system
			//remove system from list and map
			_systemsTypes[systemType] = null;
			_systems.splice(index, 1);//No needs in fast method
			_systemsLength--;
			return system;
		}

		/**
		 * Activate and add <code>EntitySystem</code> to Gimmick scope. <br />
		 * After adding <code>EntitySystem</code> to scope <code>EntitySystem.tick()</code> method will be executed
		 * for each tick (enter frame, or else loop).
		 *
		 * @param systemType Type of the <code>EntitySystem</code> that was added to Gimmick previously
		 *
		 * @throws ArgumentError EntitySystem was not added to Gimmick previously
		 *
		 * @see org.gimmick.core.EntitySystem#tick() EntitySystem.tick() loop method of the <code>EntitySystem</code>
		 * @see org.gimmick.managers.SystemManager#addSystem() Adding <code>EntitySystem</code> instance to Gimmick framework
		 * @see org.gimmick.core.Gimmick#tick() Main looping method of Gimmick framework
		 */
		public function activateSystem(systemType:Class):void
		{
			var system:EntitySystem = this.getSystemByType(systemType);
			if(system == null)
				throw new ArgumentError('EntitySystem was not added to Gimmick previously!');
			system.active = true;
		}

		/**
		 * Deactivate and remove <code>EntitySystem</code> from scope, but not from Gimmick.
		 * After removing EntitySystem from scope method <code>EntitySystem.tick()</code> will not be executed any more.
		 * <br />
		 * For totally removing <code>EntitySystem</code> from Gimmick use <code>removeSystem()</code> method instead.
		 *
		 * @param systemType Type of the <code>EntitySystem</code> that was added to Gimmick previously
		 *
		 * @throws ArgumentError EntitySystem was not added to Gimmick previously
		 *
		 * @see removeSystem()
		 * @see addSystem
		 * @see Gimmick.tick
		 * @see EntitySystem.tick
		 */
		public function deactivateSystem(systemType:Class):void
		{
			var system:EntitySystem = this.getSystemByType(systemType);
			if(system == null)
				throw new ArgumentError('EntitySystem was not added to Gimmick previously!');
			system.active = false;
		}

		/**
		 * Loop method
		 * @param time Time passed from previous tick
		 */
		public function tick(time:Number):void
		{
			for(var i:int = 0; i < _systemsLength; ++i)
			{
				var system:EntitySystem = _systems[i];
				if(system.active)system.tick(time);
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function dispose():void
		{
			//clean manager from systems
			while(_systems.length > 0)
			{
				var system:EntitySystem = _systems.pop();
				system.active = false;//deactivate system
				system.entities = null;//dispose system
			}
			_systemsLength = 0;
			_systemsTypes = null;
			_systems = null;
		}
//} endregion PUBLIC METHODS ===========================================================================================
//======================================================================================================================
//{region										PRIVATE\PROTECTED METHODS
		[Inline]
		private final function getSystemByType(systemType:Class):EntitySystem
		{
			var system:EntitySystem;
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
