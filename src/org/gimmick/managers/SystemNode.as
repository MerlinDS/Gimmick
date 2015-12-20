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

	/**
	 * Node for linked lists in SystemManager.
	 * Contains SystemWraper as value
	 *
	 * @see org.gimmick.managers.SystemManager
	 * @see org.gimmick.managers.SystemProxy
	 */
	internal final  class SystemNode
	{

		/**
		 * Link to the next node in linked list
		 */
		public var next:SystemNode;
		/**
		 * Link to the presious node in linked list
		 */
		public var prev:SystemNode;
		/**
		 * Priority in linked list
		 */
		public var priority:int;
		/**
		 * SystemNodeOld that contains system instace
		 */
		public var value:SystemProxy;
		//======================================================================================================================
//{region											PUBLIC METHODS
		/**
		 * Constructor
		 * @param value SystemProxy that contains system instace
		 * @param priority priority in linked list
		 */
		public function SystemNode(value:SystemProxy, priority:int = 1)
		{
			this.value = value;
			this.priority = priority;
		}

		/**
		 * Prepare node for GC
		 */
		public function dispose():void
		{
			this.value = null;
			this.priority = 0;
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
