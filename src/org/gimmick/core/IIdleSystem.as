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
	 * Base interfaces for all systems in Gimmick.
	 * Implement this interface only when you need idle system, System that not react on tick, but can be active.
	 * In other cases implement IEntitySystem and IProcessingSystem instead
	 *
	 * @see org.gimmick.core.IEntitySystem IEntitySystem
	 * @see org.gimmick.core.IProcessingSystem IProcessingSystem
	 */
	public interface IIdleSystem
	{
		//======================================================================================================================
//{region											PUBLIC METHODS
		/**
		 * System initialization. Will be executed automatically
		 * after adding system by addSystem() method.
		 * @see org.gimmick.core.GimmickEngine#addSystem() For adding concrete system to Gimmick use addSystem()
		 */
		function initialize():void;

		/**
		 * System disposing. Will be executed automatically
		 * after removing system by removeSystem() method.
		 * @see org.gimmick.core.GimmickEngine#removeSystem() For removing concrete system from Gimmick use removeSystem()
		 */
		function dispose():void;

		/**
		 * System activation. Will be executed automatically
		 * each time after system added to Gimmick loop.
		 * After system's activation, tick() method of system will be executed each tick of Gimmick
		 * <br />
		 * Do not use this method manually!
		 * Use <code>Gimmick.activateSystem()</code> method instead!
		 *
		 * @see org.gimmick.core.GimmickEngine#activateSystem() For concrete system activation used activateSystem
		 * @see org.gimmick.core.GimmickEngine#deactivateSystem() For concrete system deactivation used deactivateSystem()
		 */
		function activate():void;

		/**
		 * System deactivation. Will be executed automatically
		 * each time after system removing from Gimmick loop.
		 * After system deactivation, tick() method of system will not be executed anymore.
		 * Till system will not be activated again.
		 * <br />
		 * Do not use this method manually!
		 * Use <code>Gimmick.deactivateSystem()</code> method instead!
		 *
		 * @see org.gimmick.core.GimmickEngine#deactivateSystem() For concrete system deactivation used deactivateSystem()
		 * @see org.gimmick.core.GimmickEngine#activateSystem() For concrete system activation used activateSystem()
		 */
		function deactivate():void;
//} endregion PUBLIC METHODS ===========================================================================================
//======================================================================================================================
//{region										PRIVATE\PROTECTED METHODS

//} endregion PRIVATE\PROTECTED METHODS ================================================================================
//======================================================================================================================
//{region											GETTERS/SETTERS

//} endregion GETTERS/SETTERS ==========================================================================================
	}
}
