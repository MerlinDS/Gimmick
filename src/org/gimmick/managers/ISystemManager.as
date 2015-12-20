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

	import org.gimmick.core.IIdleSystem;

	/**
	 * Interface of systems managements
	 */
	public interface ISystemManager extends IGimmickManager
	{
//======================================================================================================================
//{region											PUBLIC METHODS
		/**
		 * Add instance of the system to Gimmick engine.
		 * System can belong to different groups of activity.
		 * System's method <code>initialize()</code> will be executed automatically, after adding system to engine.
		 *
		 * @param system Instance of the system, must implement one of special interfaces:
		 * <code>IIdleSystem</code>, <code>IEntitySystem</code> or <code>IProcessingSystem</code>
		 * @param priority System priority in all groups.
		 * @param groups <code>String</code> List of ids of groups.
		 * System can belong to different groups of activity.
		 *
		 * @return Instance of the system. For code chaining.
		 *
		 * @example Adding system with code chaining:
		 * <listing version="3.0">
		 * const SOME_GROUP:String = "some_group";//group indicator
		 * var someSystem:SomeSystem = Gimmick.addSystem( new SomeSystem() );
		 * var otherSystem:OtherSystem = Gimmick.addSystem( new OtherSystem(), 1, SOME_GROUP );
		 * //...
		 * </listing>
		 *
		 * @see org.gimmick.core.IIdleSystem#initialize() System's method initialize()
		 * @see org.gimmick.core.IIdleSystem Implement IIdleSystem to create concrete class of idle system
		 * @see org.gimmick.core.IEntitySystem Implement IEntitySystem to create concrete class of system
		 * @see org.gimmick.core.IProcessingSystem Implement IProcessingSystem to create concrete class of processing system
		 */
		function addSystem(system:IIdleSystem, priority:int = 1, groups:Array = null):IIdleSystem;
		/**
		 * Remove system from Gimmick engine.
		 * Also remove from all groups of activity.
		 * Use this method just in case when you need dispose system from application.
		 * In other cases use <code>deactivateSystem()</code> method.
		 *
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
		function removeSystem(systemType:Class):IIdleSystem;

		/**
		 * Activate and add system to active group. <br />
		 * After adding system to active group <code>IEntitySystem.tick()</code> or
		 * <code>IProcessingSystem#process()</code> method will be executed
		 * for each tick (enter frame, or else loop).
		 *
		 * @param systemType Type of the system that was added to Gimmick previously
		 * @param priotiry Priority in active group
		 *
		 * @throws ArgumentError System was not added to Gimmick previously
		 *
		 * @see org.gimmick.core.IEntitySystem#tick() IEntitySystem.tick() loop method of the system
		 * @see org.gimmick.core.IProcessingSystem#process() IProcessingSystem#process() loop method of the system
		 * @see org.gimmick.core.GimmickEngine#addSystem() Adding system instance to Gimmick engine
		 * @see org.gimmick.core.Gimmick#tick() Main looping method of Gimmick framework
		 */
		function activateSystem(systemType:Class, priotiry:int = 1):void;
		/**
		 * Deactivate and remove system from active group, but not from Gimmick.
		 * After removing system from active group, method <code>IEntitySystem.tick()</code>
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

		/**
		 * Activate group of systems.
		 * Previous active group will be automatically deactivated
		 * @param groupId Unique group id
		 */
		function activateGroup(groupId:String):void;
//} endregion PUBLIC METHODS ===========================================================================================
//======================================================================================================================
//{region										PRIVATE\PROTECTED METHODS

//} endregion PRIVATE\PROTECTED METHODS ================================================================================
//======================================================================================================================
//{region											GETTERS/SETTERS
		/**
		 * Id of activated group
		 */
		function get activeGroupId():String;

//} endregion GETTERS/SETTERS ==========================================================================================
	}
}
