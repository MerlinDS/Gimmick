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

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import flexunit.framework.Assert;

	import org.flexunit.async.Async;
	import org.gimmick.managers.GimmickConfig;

	public class DisposingEntitiesTest extends EventDispatcher
	{
		private var _timer:Timer;
		private var _componentManager:TestComponentManager;
		private var _entitiesManager:TestEntitiesManager;
		private var _entity:IEntity;
		//======================================================================================================================
//{region											PUBLIC METHODS
		public function DisposingEntitiesTest()
		{
			super ();
		}

		[Before]
		public function setUp():void
		{
			_timer = new Timer(30);
			_timer.addEventListener(TimerEvent.TIMER, this.timerHandler);
			_componentManager = new TestComponentManager();
			_entitiesManager = new TestEntitiesManager();
			var gimmickConfig:GimmickConfig = new GimmickConfig(20);
			gimmickConfig.componentsManager = _componentManager;
			gimmickConfig.entitiesManager = _entitiesManager;
			Gimmick.initialize(gimmickConfig);
			_entity = Gimmick.createEntity();
		}

		[After]
		public function tearDown():void
		{
			Gimmick.dispose();
			_timer.removeEventListener(TimerEvent.TIMER, testDisposeEntity);
		}

		[Test(async, description="fast disposing")]
		public function testDisposeEntity():void
		{
			Gimmick.disposeEntity(_entity);
			Assert.assertTrue(_entitiesManager.disposed);
			var callback:Function = function(event:Event, data:*):void
			{
				Assert.assertTrue("Disposing fail", _componentManager.disposed);
			};
			Async.handleEvent(this, this, Event.COMPLETE, callback, 1000);
			_timer.start();

		}
//} endregion PUBLIC METHODS ===========================================================================================
//======================================================================================================================
//{region										PRIVATE\PROTECTED METHODS
		private function timerHandler(event:TimerEvent):void
		{
			if(_componentManager.disposed)
			{
				_timer.stop();
				this.dispatchEvent( new Event(Event.COMPLETE));
			}
			else
				Gimmick.tick();

		}
//} endregion PRIVATE\PROTECTED METHODS ================================================================================
//======================================================================================================================
//{region											GETTERS/SETTERS

//} endregion GETTERS/SETTERS ==========================================================================================

	}
}

import org.gimmick.collections.IEntities;
import org.gimmick.core.Component;
import org.gimmick.core.ComponentType;
import org.gimmick.core.IEntity;
import org.gimmick.managers.IComponentsManager;
import org.gimmick.managers.IEntitiesManager;

class TestComponentManager implements IComponentsManager
{

	public var disposed:Boolean;

	public function addComponent(entity:IEntity, componentType:ComponentType, component:Component):void
	{
	}

	public function removeComponent(entity:IEntity, componentType:ComponentType):void
	{
	}

	public function getComponent(entity:IEntity, componentType:ComponentType):*
	{
		return null;
	}

	public function getComponents(entity:IEntity):Array
	{
		return null;
	}

	public function removeComponents(entity:IEntity):void
	{
		this.disposed = true;
	}

	public function initialize(allocationSize:int = 1):void
	{
	}

	public function dispose():void
	{
	}
}

class TestEntitiesManager implements IEntitiesManager
{
	public var disposed:Boolean;

	public function addEntity(entity:IEntity, componentType:ComponentType = null):void
	{
	}

	public function removeEntity(entity:IEntity, componentType:ComponentType = null):void
	{
		 this.disposed = componentType == null;
	}

	public function getEntities(types:Array):IEntities
	{
		return null;
	}

	public function tick(time:Number):void
	{
	}

	public function initialize(allocationSize:int = 1):void
	{
	}

	public function dispose():void
	{
	}
}