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

	import flexunit.framework.Assert;

	import org.gimmick.utils.TestEntity;

	public class CollectionNodeTest
	{

		private var _node:CollectionNode;
		//======================================================================================================================
//{region											PUBLIC METHODS
		public function CollectionNodeTest()
		{
		}

		[Test(order=1)]
		public function testAllocateNode():void
		{
			_node = CollectionNode.allocateNode();
			Assert.assertNotNull(_node);
			_node.entity = new TestEntity();

		}

		[Test(order=2)]
		public function testFreeNode():void
		{
			this.testAllocateNode();
			CollectionNode.freeNode(_node);
			Assert.assertNull(_node.entity);
		}

		[Test(order=3)]
		public function testAllocateFromPoolNode():void
		{
			this.testFreeNode();
			var pooledNode:CollectionNode = CollectionNode.allocateNode();
			Assert.assertNotNull(pooledNode);
			Assert.assertEquals(_node, pooledNode);
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
