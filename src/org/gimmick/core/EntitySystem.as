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

	import org.gimmick.managers.IEntitiesManager;

	//TODO Create interface for Gimmick systems #5
	[Deprecated]
	public class EntitySystem
	{

		private var _active:Boolean;
		private var _entities:IEntitiesManager;
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
		//Activate|Deactivate
		/**
		 * This method executed after system activated.
		 * Active systems fall into main loop
		 */
		protected function activate():void
		{

		}

		/**
		 * This method executed after system deactivated
		 * Deactivated systems does not fall into main loop. But not disposed.
		 */
		protected function deactivate():void
		{

		}

//} endregion PRIVATE\PROTECTED METHODS ================================================================================
//======================================================================================================================
//{region											GETTERS/SETTERS
		public function set entities(value:IEntitiesManager):void
		{
			if(value != null)this.initialize();
			else
			{
				this.active = false;
				this.dispose();
			}
			_entities = value;
		}

		public function get entities():IEntitiesManager
		{
			return _entities;
		}
		/**
		 * Activate or deactivate system.
		 * Active systems fall in main loop and take part in Gimmick tick processing
		 */
		public final function set active(value:Boolean):void
		{
			if(value == _active)return;
			//only in state of system will be changed
			if(value)this.activate();
			else this.deactivate();
			_active = value;
		}
		/**
		 * @private
		 */
		public final function get active():Boolean
		{
			return _active;
		}


//} endregion GETTERS/SETTERS ==========================================================================================
	}
}
