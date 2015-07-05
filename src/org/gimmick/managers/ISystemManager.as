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

	import org.gimmick.core.EntitySystem;

	public interface ISystemManager extends IGimmickManager
	{
		//======================================================================================================================
//{region											PUBLIC METHODS
		/**
		 * Add instance of the <code>EntitySystem</code> to Gimmick engine.
		 * @param system Instance of the system
		 * @return Instance of the system (for chaining)
		 */
		function addSystem(system:EntitySystem):EntitySystem;

		/**
		 * Remove system from Gimmick engine.
		 * @param systemType Type of the system that was added to Gimmick previously
		 * @return Instance of disposed <code>EntitySystem</code>
		 *
		 * @throws ArgumentError EntitySystem was not added to Gimmick previously
		 */
		function removeSystem(systemType:Class):EntitySystem;

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
		function activateSystem(systemType:Class):void;

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
