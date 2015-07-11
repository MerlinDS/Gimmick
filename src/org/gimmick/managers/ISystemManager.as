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

	import org.gimmick.core.IBaseSystem;
	import org.gimmick.core.IEntitySystem;

	/**
	 * Intarface of systems managments
	 */
	public interface ISystemManager extends IGimmickManager
	{
//======================================================================================================================
//{region											PUBLIC METHODS
		/**
		 * Add instance of the system to Gimmick engine.
		 * @param system Instance of the system, must implement <code>IEntitySystem</code> interface.
		 * @param priority System priority
		 * @return Instance of the system
		 *
		 * @example Adding system with code chaining:
		 * <listing version="3.0">
		 * var someSystem:SomeSystem = Gimmick.addSystem( new SomeSystem() );
		 * ...
		 * </listing>
		 *
		 * @see org.gimmick.core.IEntitySystem Implenet IEntitySystem to create concreet class of system
		 * @see org.gimmick.core.IProcessingSystem Implenet IProcessingSystem to create concreet class of processing system
		 */
		function addSystem(system:IBaseSystem, priority:int = 1):IBaseSystem;
		/**
		 * Remove system from Gimmick engine.
		 * @param systemType Type of the system that was added to Gimmick previously
		 * @return Instance of removed system
		 *
		 * @throws ArgumentError System was not added to Gimmick previously
		 *
		 * @example Removing system:
		 * <listing version="3.0">
		 * Gimmick.addSystem( new SomeSystem() );
		 * ...
		 * var someSystem:SomeSystem = Gimmick.removeSystem( SomeSystem );
		 * </listing>
		 */
		function removeSystem(systemType:Class):IBaseSystem;
		/**
		 * Activate and add system to Gimmick scope. <br />
		 * After adding system to scope <code>IEntitySystem.tick()</code> or
		 * <code>IProcessingSystem#process()</code> method will be executed
		 * for each tick (enter frame, or else loop).
		 *
		 * @param systemType Type of the system that was added to Gimmick previously
		 *
		 * @throws ArgumentError System was not added to Gimmick previously
		 *
		 * @see org.gimmick.core.IEntitySystem#tick() IEntitySystem.tick() loop method of the system
		 * @see org.gimmick.core.IProcessingSystem#process() IProcessingSystem#process() loop method of the system
		 * @see org.gimmick.core.GimmickEngine#addSystem() Adding system instance to Gimmick engine
		 * @see org.gimmick.core.Gimmick#tick() Main looping method of Gimmick framework
		 */
		function activateSystem(systemType:Class):void;
		/**
		 * Deactivate and remove system from scope, but not from Gimmick.
		 * After removing system from scope method <code>IEntitySystem.tick()</code>
		 * or <code>IProcessingSystem#process()</code> will not be executed any more.
		 * <br />
		 * For totally removing system from Gimmick use <code>removeSystem()</code> method instead.
		 *
		 * @param systemType Type of the system that was added to Gimmick previously
		 *
		 * @throws ArgumentError System was not added to Gimmick previously
		 *
		 * @see org.gimmick.core.IEntitySystem#tick() IEntitySystem.tick() loop method of the system
		 * @see org.gimmick.core.IProcessingSystem#process() IProcessingSystem#process() loop method of the system
		 * @see org.gimmick.core.GimmickEngine#removeSystem() Removing system instance from Gimmick engine
		 * @see org.gimmick.core.GimmickEngine#addSystem() Adding system instance to Gimmick engine
		 * @see org.gimmick.core.Gimmick#tick() Main looping method of Gimmick framework
		 */
		function deactivateSystem(systemType:Class):void;

		/**
		 * Loop method
		 * @param time Time passed from previous tick
		 */
		function tick(time:Number):void;
//} endregion PUBLIC METHODS ===========================================================================================
//======================================================================================================================
//{region										PRIVATE\PROTECTED METHODS

//} endregion PRIVATE\PROTECTED METHODS ================================================================================
//======================================================================================================================
//{region											GETTERS/SETTERS

//} endregion GETTERS/SETTERS ==========================================================================================
	}
}
