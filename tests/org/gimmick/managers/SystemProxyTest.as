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

	import org.flexunit.Assert;

	public class SystemProxyTest
	{

		//======================================================================================================================
//{region											PUBLIC METHODS
		public function SystemProxyTest()
		{
		}

		[Test]
		public function idleSystem():void
		{
			var system:IdleSystem = new IdleSystem();
			var proxy:SystemProxy = new SystemProxy(system);
			Assert.assertNotNull(proxy.system);
			Assert.assertFalse(proxy.isEntitySystem);
			Assert.assertFalse(proxy.isProcessingSystem);
			proxy.dispose();
			Assert.assertNull(proxy.system);
		}

		[Test]
		public function entitySystem():void
		{
			var system:IdleSystem = new EntitySystem();
			var proxy:SystemProxy = new SystemProxy(system);
			Assert.assertNotNull(proxy.system);
			Assert.assertTrue(proxy.isEntitySystem);
			Assert.assertFalse(proxy.isProcessingSystem);
			Assert.assertEquals(system, proxy.entitySystem);
			proxy.dispose();
			Assert.assertNull(proxy.system);
			Assert.assertNull(proxy.entitySystem);
		}

		[Test]
		public function processingSystem():void
		{
			var system:IdleSystem = new ProcessingSystem();
			var proxy:SystemProxy = new SystemProxy(system);
			Assert.assertNotNull(proxy.system);
			Assert.assertFalse(proxy.isEntitySystem);
			Assert.assertTrue(proxy.isProcessingSystem);
			Assert.assertEquals(system, proxy.processingSystem);
			proxy.dispose();
			Assert.assertNull(proxy.system);
			Assert.assertNull(proxy.processingSystem);
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

import org.gimmick.collections.IEntities;
import org.gimmick.core.IEntity;
import org.gimmick.core.IEntitySystem;
import org.gimmick.core.IIdleSystem;
import org.gimmick.core.IProcessingSystem;

class IdleSystem implements IIdleSystem
{

	public function initialize():void
	{
	}

	public function dispose():void
	{
	}

	public function activate():void
	{
	}

	public function deactivate():void
	{
	}
}

class EntitySystem extends IdleSystem implements IEntitySystem
{

	public function tick(time:Number):void
	{
	}
}

class ProcessingSystem extends IdleSystem implements IProcessingSystem
{

	public function process(entity:IEntity, entities:IEntities):void
	{
	}

	public function get targetEntities():IEntities
	{
		return null;
	}
}