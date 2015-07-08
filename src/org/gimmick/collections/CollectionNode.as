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

package org.gimmick.collections
{

	import org.gimmick.core.IEntity;

	/**
	 * Internal class.
	 * Node for entities collection.
	 * Contains allocation methods.
	 */
	internal class CollectionNode
	{
		/**
		 * Pool for free nodes
		 */
		//TODO Data consistency #10
		private static const _free:Vector.<CollectionNode> = new <CollectionNode>[];
		/**
		 * Link to next node in collection
		 */
		public var next:CollectionNode;
		/**
		 * Link to previous node in collection
		 */
		public var prev:CollectionNode;

		/**
		 * Value of the node. Link to instance of entity collection.
		 */
		public var entity:IEntity;

		private var _allocated:Boolean;
		//======================================================================================================================
//{region											PUBLIC METHODS

		/**
		 * Constructor. Don't use it. Use allocateNode() method instead!
		 *
		 * @see org.gimmick.collections.CollectionNode#allocateNode() Use allocateNode() method for node creating
		 * @see org.gimmick.collections.CollectionNode#freeNode() Use freeNode() for node disposing
		 */
		public function CollectionNode()
		{
		}

		/**
		 * Allocate node for collection. If node does not exist create new one
		 * @return CollectionNode
		 */
		[Inline]
		public static function allocateNode():CollectionNode
		{
			var node:CollectionNode = _free.length == 0 ? new CollectionNode() : _free.pop();
			node._allocated = true;
			return node;
		}

		/**
		 * Free node and add it to pool for using it next time
		 * @param node CollectionNode that need to be free
		 */
		[Inline]
		public static function freeNode(node:CollectionNode):void
		{
			//if node allocated
			if(node._allocated)
			{
				//delete data from node
				node.entity = null;
				node.next = null;
				node.prev = null;
				node._allocated = false;
				//set node to pool
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