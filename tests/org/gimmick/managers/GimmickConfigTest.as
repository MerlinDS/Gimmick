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
package org.gimmick.managers
{

	import flexunit.framework.Assert;

	public class GimmickConfigTest
	{


		//======================================================================================================================
//{region											PUBLIC METHODS
		public function GimmickConfigTest()
		{
		}

		[Test]
		public function testEntityManager():void
		{
			var config:GimmickConfig = new GimmickConfig();
			Assert.assertNotNull("Empty manager", config.entitiesManager);
			config = new GimmickConfig(null, null, new TestEntityManager());
			Assert.assertNotNull("External manager", config.entitiesManager);
		}

		[Test]
		public function testSystemManager():void
		{
			var config:GimmickConfig = new GimmickConfig();
			Assert.assertNotNull("Empty manager", config.systemManager);
			config = new GimmickConfig(new TestSystemManager());
			Assert.assertNotNull("External manager", config.systemManager);
		}

		[Test]
		public function testComponentsManager():void
		{
			var config:GimmickConfig = new GimmickConfig();
			Assert.assertNotNull("Empty manager", config.componentsManager);
			config = new GimmickConfig(null, new TestComponentManager());
			Assert.assertNotNull("External manager", config.componentsManager);
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

import org.gimmick.core.ComponentType;
import org.gimmick.core.EntitySystem;
import org.gimmick.core.IEntity;
import org.gimmick.managers.IComponentsManager;
import org.gimmick.managers.IEntitiesManager;
import org.gimmick.managers.ISystemManager;

class TestSystemManager implements ISystemManager
{

	public function addSystem(system:EntitySystem):EntitySystem{}
	public function removeSystem(systemType:Class):EntitySystem{}
	public function activateSystem(systemType:Class):void{}
	public function deactivateSystem(systemType:Class):void{}
	public function tick(time:Number):void{}
	public function dispose():void{}
	public function initialize():void{}
}

class TestComponentManager implements IComponentsManager
{

	public function addComponent(entity:IEntity, componentType:ComponentType, component:Object):void{}
	public function removeComponent(entity:IEntity, componentType:ComponentType):void{}
	public function getComponent(entity:IEntity, componentType:ComponentType):*{}
	public function getComponents(entity:IEntity):Array{return null;}
	public function removeComponents(entity:IEntity):void{}
	public function dispose():void{}
	public function initialize():void{}
}

class TestEntityManager implements IEntitiesManager
{
	public function addEntity(entity:IEntity):void{}
	public function removeEntity(entity:IEntity):void{}
	public function changeEntityActivity(entity:IEntity):void{}
	public function addToFilter(entity:IEntity, componentType:ComponentType):void{}
	public function removeFromFilter(entity:IEntity, componentType:ComponentType):void{}
	public function getEntities(components:Array):void{}
	public function dispose():void{}
	public function initialize():void{}
}