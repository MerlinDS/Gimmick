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

package org.gimmick.collections
{

	import org.gimmick.core.IEntity;

	/**
	 * Node for linked list that contains entities
	 */
	internal class EntityNode
	{

		private static var _free:Vector.<EntityNode>;
		/**
		 * Link to next node
		 */
		public var next:EntityNode;
		/**
		 * Link to prevoius node
		 */
		public var prev:EntityNode;
		/**
		 * Value of current node
		 */
		public var entity:IEntity;

		private var _allocated:Boolean;
//======================================================================================================================
//{region											PUBLIC METHODS
		//initialize free nodes list
		{
			_free = new <EntityNode>[];
		}

		/** Constructor **/
		public function EntityNode()
		{
		}

		/**
		 * Allocate new node
		 * @param entity Value for new node
		 * @return Instance of new node
		 */
		public static function allocateNode(entity:IEntity):EntityNode
		{
			var node:EntityNode;
			if(_free.length == 0)
			{
				node = new EntityNode();
				_free[_free.length] = node;
			}
			else
			{
				node = _free[_free.length - 1];
				_free.length--;
			}

			node._allocated = true;
			node.entity = entity;
			return node;
		}

		/**
		 * Free memory form allocated node. Release node
		 * @param node Instance of node to release
		 */
		public static function freeNode(node:EntityNode):void
		{
			if(node._allocated == true)
			{
				node.next = null;
				node.prev = null;
				node.entity = null;
				_free[_free.length] = node;
			}
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
