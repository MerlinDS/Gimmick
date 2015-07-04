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

	import org.gimmick.managers.ComponentsManager;
	import org.gimmick.managers.EntitiesManager;
	import org.gimmick.utils.getUniqueId;

	/**
	 * Internal class of entity.
	 * User can create entity only by using <code>createEntity</code> method of Gimmick
	 *
	 * @internal In fact this class is only a proxy for access to entity components and parameters.
	 *
	 * @see org.gimmick.core.GimmickEngine.createEntity() Use Gimmick.createEntity() method for creating new Entity
	 * @see org.gimmick.core.GimmickEngine.disposeEntity() Use Gimmick.disposeEntity() method for disposing exist Entity
	 *
	 * @example
	 * <listing version="3.0">
	 *     var entity:IEntity = Gimmick.createEntity('Entity name');
	 *     entity.add(new SomeComponent());//create and link component to entity
	 *     //...
	 *     if(entity.has(SomeComponent))//has method faster that get, use has method for check linkage of the component
	 *     {
	 *     		var component:SomeComponent = entity.get(SomeComponent);//Get instance of the component
	 *     		entity.remove(SomeComponent);//Component doesn't linked to entity an more.
	 *     }
	 *     //...
	 *     Gimmick.disposeEntity(entity);//remove entity from Gimmick (entity will be prepared for GC automatically)
	 * </listing>
	 */
	internal final class Entity implements IEntity
	{

		private var _name:String;
		/**
		 * Entity activity
		 */
		private var _active:Boolean;
		/**
		 * Unique ID of the component
		 */
		private var _id:String;
		/**
		 * Bitwise mask of all components that linked to entity
		 */
		private var _bits:uint;
		//links to managers
		private var _componentTypeManager:ComponentTypeManager;
		private var _componentsManager:ComponentsManager;
		private var _entitiesManager:EntitiesManager;
//======================================================================================================================
//{region											PUBLIC METHODS

		/**
		 * Constructor
		 * @param name Name of the component
		 */
		public function Entity(name:String)
		{
			_id = getUniqueId();
			if(name == null)name = "entity_" + _id;
			_name = name;
			_bits = 0x0;
		}

		/**
		 * @inheritDoc
		 */
		[Inline]
		public final function add(component:Object):*
		{
			var componentType:ComponentType = _componentTypeManager.getType(component);
			_componentsManager.addComponent(this, componentType, component);
			_entitiesManager.addToFilter(this, componentType);
			//add bit to bitwise mask if component was adding first time
			if(!(_bits & componentType.bit))_bits |= componentType.bit;
			return component;
		}

		/**
		 * @inheritDoc
		 */
		[Inline]
		public final function has(component:Class):Boolean
		{
			var componentType:ComponentType = _componentTypeManager.getType(component);
			return _bits & componentType.bit;
		}

		/**
		 * @inheritDoc
		 */
		[Inline]
		public final function get(component:Class):*
		{
			var componentType:ComponentType = _componentTypeManager.getType(component);
			//for faster works copy code from has method
			if(_bits & componentType.bit)
				return _componentsManager.getComponent(this, componentType);
			return null;
		}

		/**
		 * @inheritDoc
		 */
		[Inline]
		public final function remove(component:Class):void
		{
			var componentType:ComponentType = _componentTypeManager.getType(component);
			_componentsManager.removeComponent(this, componentType);
			_entitiesManager.removeFromFilter(this, componentType);
			//remove bit from bitwise mask
			_bits = _bits &~ componentType.bit;
		}

		/**
		 * Dispose entity.
		 * Prepare entity instance for removing from memory
		 * Only Gimmick Engine could execute this method!
		 */
		internal final function dispose():void
		{
			_bits = 0x0;
			_id = null;
			_entitiesManager = null;
			_componentsManager = null;
			_componentTypeManager = null;
		}

//} endregion PUBLIC METHODS ===========================================================================================
//======================================================================================================================
//{region										PRIVATE\PROTECTED METHODS

//} endregion PRIVATE\PROTECTED METHODS ================================================================================
//======================================================================================================================
//{region											GETTERS/SETTERS
		/**
		 * @private
		 */
		[Inline]
		internal final function set componentTypeManager(value:ComponentTypeManager):void
		{
			if(value != null)//only dispose method can set _componentTypeManager to null
				_componentTypeManager = value;
		}
		/**
		 * @private
		 */
		[Inline]
		internal final function set componentsManager(value:ComponentsManager):void
		{
			if(value != null)//only dispose method can set _componentsManager to null
				_componentsManager = value;
		}
		/**
		 * @private
		 */
		[Inline]
		internal final function set entitiesManager(value:EntitiesManager):void
		{
			if(value != null)//only dispose method can set _entitiesManager to null
			{
				_entitiesManager = value;
				_entitiesManager.addEntity(this);
			}
		}

		/**
		 * Bitwise mask of all components linked to entity
		 */
		[Inline]
		internal function get bits():uint
		{
			return _bits;
		}

//Implementation of public interface
		/**
		 * @inheritDoc
		 */
		[Inline]
		public final function get name():String
		{
			return _name;
		}

		/**
		 * @inheritDoc
		 */
		[Inline]
		public final function get id():String
		{
			return _id;
		}

		/**
		 * @inheritDoc
		 */
		[Inline]
		public final function get components():Array
		{
			if(_componentsManager != null)
				return _componentsManager.getComponents(this);
			return [];
		}

		/**
		 * @inheritDoc
		 */
		[Inline]
		public final function get active():Boolean
		{
			return _active;
		}

		/**
		 * @inheritDoc
		 */
		[Inline]
		public final function set active(value:Boolean):void
		{
			_active = value;
			_entitiesManager.changeEntityActivity(this);
		}

//} endregion GETTERS/SETTERS ==========================================================================================

	}
}
