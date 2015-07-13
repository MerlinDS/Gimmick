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
	import flash.display.Sprite;
	import flash.geom.Point;

	import flexunit.framework.Assert;

	import org.gimmick.collections.IEntities;

	import org.gimmick.managers.GimmickConfig;

	public class GimmickEngineTest
	{

		private var _scene:Sprite;
		private var _entities:Array;
		//======================================================================================================================
//{region											PUBLIC METHODS
		public function GimmickEngineTest()
		{
		}

		[Before]
		public function setUp():void
		{
			_scene = new Sprite();
			_entities = [
				{position:new Point(100, 100), velocity:new Velocity(1, -1), display:new Display(new Sprite())}
			];
		}

		[After]
		public function tearDown():void
		{
			_scene.removeChildren();
			Gimmick.dispose();
			_scene = null;
		}

		[Test]
		public function createEngine():void
		{
			var i:int;
			Gimmick.initialize();
			//systems
			Gimmick.addSystem(new MovementSystem());
			Gimmick.addSystem(new DisplaySystem(_scene), 2);
			Gimmick.activateSystem(MovementSystem);
			Gimmick.activateSystem(DisplaySystem);
			//add entities
			for(i = 0; i < _entities.length; i++)
			{
				var entity:IEntity = Gimmick.createEntity('testEntity' + i);
				var data:Object = _entities[i];
				var p:Point = data.position;
				entity.add(data.velocity);
				entity.add(data.display);
				entity.add(new Position(p.x, p.y));
				data.entityId = entity.id;
			}
			//timer
			Gimmick.tick();
			var allEntities:IEntities = Gimmick.getEntities();
			for(i = 0; i < _entities.length; i++)
			{
				data = _entities[i];
				p = data.position;
				entity = allEntities.getById(data.entityId);
				var display:Display = entity.get(Display);
				Assert.assertEquals(data.display, display);
				Assert.assertEquals(_scene, display.view.parent);
				var position:Position = entity.get(Position);
				var velocity:Velocity = entity.get(Velocity);
				Assert.assertEquals(p.x + velocity.x, position.x);
				Assert.assertEquals(p.y + velocity.y, position.y);
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

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;

import org.gimmick.collections.IEntities;
import org.gimmick.core.Component;
import org.gimmick.core.Gimmick;
import org.gimmick.core.IEntity;
import org.gimmick.core.IEntitySystem;
import org.gimmick.core.IProcessingSystem;

class DisplaySystem implements IEntitySystem
{

	private var _entities:IEntities;
	private var _scene:DisplayObjectContainer;

	public function DisplaySystem(scene:DisplayObjectContainer)
	{
		_scene = scene;
	}

	public function tick(time:Number):void
	{
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