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

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Point;

	import flexunit.framework.Assert;

	import org.gimmick.collections.IEntities;

	import org.gimmick.managers.GimmickConfig;

	public class GimmickEngineTest
	{

		private var _entities:Array;
		private var _displaySystems:DisplaySystem;
		//======================================================================================================================
//{region											PUBLIC METHODS
		public function GimmickEngineTest()
		{
		}

		[Before]
		public function setUp():void
		{
			_entities = [
				{position:new Point(100, 100), velocity:new Velocity(1, -1), display:new Display(new Sprite())},
				{position:new Point(100, 100), display:new Display(new Sprite())}
			];
		}

		[After]
		public function tearDown():void
		{
			Gimmick.dispose();
		}

		[Test]
		public function creationTest():void
		{
			var i:int;
			Gimmick.initialize(new GimmickConfig(60, this.initCallback));
			//timer
			Gimmick.tick();
			//
			var allEntities:IEntities = Gimmick.getEntities();
			for(i = 0; i < _entities.length; i++)
			{
				var data:Object = _entities[i];
				var p:Point = data.position;
				var entity:IEntity = allEntities.getById(data.entityId);
				var display:Display = entity.get(Display);
				Assert.assertEquals(data.display, display);
				var position:Position = entity.get(Position);
				if(data.velocity != null)
				{
					var velocity:Velocity = entity.get(Velocity);
					Assert.assertEquals(p.x + velocity.x, position.x);
					Assert.assertEquals(p.y + velocity.y, position.y);
				}
				Assert.assertEquals(position.x, display.view.x);
				Assert.assertEquals(position.y, display.view.y);
			}
			allEntities.dispose();
			Assert.assertTrue(allEntities.isDisposed);
			Assert.assertEquals(1, _displaySystems.ticksCount);
		}

		private function initCallback():void
		{
			/*
			  Create application with starting system
			 */
			var starter:StartingSystem = Gimmick.addSystem(new StartingSystem(_entities));
			//get date for tests
			_displaySystems = starter.displaySystem;
			var scene:DisplayObjectContainer = starter.scene;
			//crete application
			Gimmick.activateSystem(StartingSystem);
			Assert.assertTrue(starter.disposed);
		}

		[Test]
		public function pauseResumeTest():void
		{
			this.creationTest();
			Gimmick.pause();
			Gimmick.tick();
			Assert.assertEquals(1, _displaySystems.ticksCount);
			Gimmick.resume();
			Gimmick.tick();
			Assert.assertEquals(2, _displaySystems.ticksCount);
		}

		[Test]
		public function systemActivateDeactivate():void
		{
			this.creationTest();
			Gimmick.deactivateSystem(DisplaySystem);
			Gimmick.tick();
			Assert.assertEquals(1, _displaySystems.ticksCount);
			Gimmick.activateSystem(DisplaySystem);
			Gimmick.tick();
			Assert.assertEquals(2, _displaySystems.ticksCount);
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

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.geom.Point;

import org.gimmick.collections.IEntities;
import org.gimmick.core.Component;
import org.gimmick.core.Gimmick;
import org.gimmick.core.IEntity;
import org.gimmick.core.IEntitySystem;
import org.gimmick.core.IIdleSystem;
import org.gimmick.core.IProcessingSystem;

class StartingSystem implements IIdleSystem
{

	public var disposed:Boolean;

	private var _scene:DisplayObjectContainer;
	private var _entitiesData:Array;
	private var _displaySystem:DisplaySystem;

	public function StartingSystem(entitiesData:Array)
	{
		_entitiesData = entitiesData;
	}

	public function initialize():void
	{
		_scene = new Sprite();
		Gimmick.addSystem(new MovementSystem());
		_displaySystem = Gimmick.addSystem(new DisplaySystem(_scene), 2);
	}

	public function dispose():void
	{
		this.disposed = true;
		_entitiesData = null;
		_scene = null;
		_displaySystem = null;
	}

	public function activate():void
	{
		Gimmick.activateSystem(MovementSystem);
		Gimmick.activateSystem(DisplaySystem);
		this.createEntities();
		/*
		 This system create application and remove itself from engine
		 */
		Gimmick.removeSystem(StartingSystem);
	}

	public function deactivate():void
	{
	}

	private function createEntities():void
	{
		for(var i:int = 0; i < _entitiesData.length; i++)
		{
			var entity:IEntity = Gimmick.createEntity('testEntity' + i);
			var data:Object = _entitiesData[i];
			var p:Point = data.position;
			if(data.velocity != null)
				entity.add(data.velocity);
			entity.add(data.display);
			entity.add(new Position(p.x, p.y));
			data.entityId = entity.id;
		}
	}

	public function get displaySystem():DisplaySystem {return _displaySystem;}

	public function get scene():DisplayObjectContainer
	{
		return _scene;
	}
}

class DisplaySystem implements IEntitySystem
{

	private var _entities:IEntities;
	private var _scene:DisplayObjectContainer;
	public var ticksCount:int;

	public function DisplaySystem(scene:DisplayObjectContainer)
	{
		_scene = scene;
	}

	public function tick(time:Number):void
	{
		this.ticksCount++;
		for(_entities.begin(); !_entities.end(); _entities.next())
		{
			var entity:IEntity = _entities.current;
			var display:Display = entity.get(Display);
			//add entity view to scene
			if(display.view.parent != _scene)
				_scene.addChild(display.view);
			//change position on view
			var position:Position = entity.get(Position);
			display.view.x = position.x;
			display.view.y = position.y;
		}
	}

	public function initialize():void
	{
		_entities = Gimmick.getEntities(Display, Position);
	}

	public function dispose():void
	{
		_entities.dispose();
	}

	public function activate():void
	{
	}

	public function deactivate():void
	{
	}
}

class MovementSystem implements IProcessingSystem
{

	public function process(entity:IEntity, entities:IEntities):void
	{
		var position:Position = entity.get(Position);
		var velocity:Velocity = entity.get(Velocity);
		position.x += velocity.x;
		position.y += velocity.y;
	}

	public function get targetEntities():IEntities
	{
		return Gimmick.getEntities(Position, Velocity);
	}

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



class Position extends Component
{
	public var x:Number;
	public var y:Number;

	public function Position(x:Number, y:Number)
	{
		this.x = x;
		this.y = y;
	}
}

class Velocity extends Component
{

	public var x:Number;
	public var y:Number;

	public function Velocity(x:Number, y:Number)
	{
		this.x = x;
		this.y = y;
	}
}

class Display extends Component
{
	public var view:DisplayObject;

	public function Display(view:DisplayObject)
	{
		this.view = view;
	}
}