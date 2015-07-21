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

/**
 * Internal class for systems linked list in SystemManager
 * @see org.gimmick.managers.SystemManager
 */
package org.gimmick.managers
{

	import org.gimmick.collections.EntitiesCollection;
	import org.gimmick.core.IEntitySystem;
	import org.gimmick.core.IIdleSystem;
	import org.gimmick.core.IProcessingSystem;

	internal final class SystemNodeOld
	{
		public var prev:SystemNodeOld;
		public var next:SystemNodeOld;
		public var system:IIdleSystem;
		public var priority:int;
		public var active:Boolean;

		//for IProcessingSystem
		public var collection:EntitiesCollection;
		public var processingSystem:IProcessingSystem;
		public var isProcessingSystem:Boolean;
		//for IEntitySystem
		public var isEntitySystem:Boolean;
		public var entitySystem:IEntitySystem;
//======================================================================================================================
//{region											PUBLIC METHODS
		public function SystemNodeOld(system:IIdleSystem, priority:int)
		{
			this.system = system;
			this.priority = priority;
			if(system is IEntitySystem)
			{
				this.entitySystem = system as IEntitySystem;
				this.isEntitySystem = true;
			}
			else if(system is IProcessingSystem)
			{
				this.processingSystem = system as IProcessingSystem;
				this.isProcessingSystem = true;
			}
		}

		/**
		 * Prepare node for GC.
		 */
		public function dispose():void
		{
			this.active = false;
			this.priority = 0;
			this.isProcessingSystem = false;
			this.isEntitySystem = false;
			//reset links
			this.prev = null;
			this.next = null;
			this.system = null;
			this.collection = null;
			this.processingSystem = null;
			this.entitySystem = null;
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
