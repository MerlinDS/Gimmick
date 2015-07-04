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

	import org.gimmick.managers.FiltersManager;

	public class EntitySystem
	{

		private var _entities:FiltersManager;
//======================================================================================================================
//{region											PUBLIC METHODS
		public function EntitySystem()
		{
		}

		/**
		 * Method for system looping
		 * @param time Time from the previous tick in microseconds
		 *
		 * @see org.gimmick.core.GimmickEngine.tick() Gimmick.tick() looping method
		 */
		public function tick(time:Number):void
		{

		}
//} endregion PUBLIC METHODS ===========================================================================================
//======================================================================================================================
//{region										PRIVATE\PROTECTED METHODS

		//Initializing|Disposing
		/**
		 * This method will be executed before system initialization
		 * @see org.gimmick.core.EntitySystem.initialize() write code in initialize method
		 */
		private function preInitialize():void
		{

		}

		/**
		 * This method will be executed after system disposing
		 * @see org.gimmick.core.EntitySystem.dispose() write code in dispose method
		 */
		private function postDispose():void
		{

		}

		/**
		 * Initialize system.
		 * Method for override
		 */
		protected function initialize():void
		{
			//override this
		}

		/**
		 * Dispose system.
		 * Method for override
		 */
		protected function dispose():void
		{
			//override this
		}

		//else methods
		/**
		 * Get list of entities
		 * @param components Components types for filtering
		 * @example
		 * <listing version="3.0">
		 *     var entities:Iterator = this.getEntities(Component1, Component2, ...);
		 *     for(entities.begin(); !entities.end(); entities.next())
		 *     {
		 *     		var entity:IEntity = entities.current;
		 *     		...
		 *     }
		 * </listing>
		 */
		protected final function getEntities(...components):void
		{

		}

		/**
		 * Remove current system from Gimmick scope.
		 * @see org.gimmick.core.GimmickEngine.removeFromScope() Works same way as Gimmick.removeFromScope()
		 */
		protected final function removeMyself():void
		{

		}
//} endregion PRIVATE\PROTECTED METHODS ================================================================================
//======================================================================================================================
//{region											GETTERS/SETTERS

//} endregion GETTERS/SETTERS ==========================================================================================        
	}
}
