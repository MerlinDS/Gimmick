/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2015 Andrew Salomatin (MerlinDS)
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

package org.gimmick.managers
{

	import org.gimmick.collections.EntitiesCollection;
	import org.gimmick.core.IEntitySystem;
	import org.gimmick.core.IIdleSystem;
	import org.gimmick.core.IProcessingSystem;

	/**
	 * Proxy link to the system.
	 * Providing extended access to instance of system.
	 */
	internal final class SystemProxy
	{

		/**
		 * Not extended system interface
		 */
		public var system:IIdleSystem;
		/**
		 * Flag that indicate an activity of system instance
		 */
		public var active:Boolean;
		//Extended interface of the IProcessingSystem
		public var collection:EntitiesCollection;
		public var processingSystem:IProcessingSystem;
		public var isProcessingSystem:Boolean;
		//Extended interface of the IEntitySystem
		public var isEntitySystem:Boolean;
		public var entitySystem:IEntitySystem;
//======================================================================================================================
//{region											PUBLIC METHODS
		public function SystemProxy(system:IIdleSystem)
		{
			this.system = system;
			this.initialize();
		}

		/**
		 * Prepare proxy for GC
		 */
		public function dispose():void
		{
			this.active = false;
			this.isProcessingSystem = false;
			this.isEntitySystem = false;
			//delete links
			this.system = null;
			this.collection = null;
			this.processingSystem = null;
			this.entitySystem = null;
		}
//} endregion PUBLIC METHODS ===========================================================================================
//======================================================================================================================
//{region										PRIVATE\PROTECTED METHODS
		/**
		 * Initailize proxy by it system.
		 * Provide extended access to instance of system.
		 */
		private function initialize():void
		{
			if(this.system is IEntitySystem)
			{
				this.entitySystem = this.system as IEntitySystem;
				this.isEntitySystem = true;
			}
			else if(this.system is IProcessingSystem)
			{
				this.processingSystem = this.system as IProcessingSystem;
				this.isProcessingSystem = true;
			}
		}
//} endregion PRIVATE\PROTECTED METHODS ================================================================================
//======================================================================================================================
//{region											GETTERS/SETTERS

//} endregion GETTERS/SETTERS ==========================================================================================
	}
}
