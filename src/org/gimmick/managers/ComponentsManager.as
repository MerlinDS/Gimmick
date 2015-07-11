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

	import flash.utils.Dictionary;

	import org.gimmick.collections.ComponentsCollection;
	import org.gimmick.core.Component;
	import org.gimmick.core.ComponentType;
	import org.gimmick.core.IEntity;

	internal class ComponentsManager implements IComponentsManager
	{

		private var _allocationSize:int;
		private var _components:Vector.<ComponentsCollection>;
//======================================================================================================================
//{region											PUBLIC METHODS
		public function ComponentsManager()
		{
		}

		/**
		 * @inheritDoc
		 */
		public function initialize(allocationSize:int = 1):void
		{
			_allocationSize = allocationSize;
			_components = new <ComponentsCollection>[];
		}

		/**
		 * @inheritDoc
		 */
		public function addComponent(entity:IEntity, componentType:ComponentType, component:Component):void
		{
			if(_components.length <= componentType.index)
			{
				//increase components list size
				_components.length = componentType.index + 1;
			}
			//get component list
			var collection:ComponentsCollection = _components[componentType.index];
			if(collection == null)
			{
				collection = new ComponentsCollection(_allocationSize);
				_components[componentType.index] = collection;
			}
			//add component to collection
			collection.push(entity.id, component);
		}

		/**
		 * @inheritDoc
		 */
		public function removeComponent(entity:IEntity, componentType:ComponentType):void
		{
			if(_components.length > componentType.index)
				_components[componentType.index].remove(entity.id);
		}

		/**
		 * @inheritDoc
		 */
		public function getComponent(entity:IEntity, componentType:ComponentType):*
		{
			if(_components.length <= componentType.index)return null;
			return _components[componentType.index].get(entity.id);
		}

		/**
		 * @inheritDoc
		 */
		public function getComponents(entity:IEntity):Array
		{
			var array:Array = [];
			var n:int = _components.length;
			for(var i:int = 0; i < n; i++)
			{
				var collection:ComponentsCollection = _components[i];
				if(collection.has(entity.id))
					array.push(collection.get(entity.id));
			}
			return array;
		}

		/**
		 * @inheritDoc
		 */
		public function removeComponents(entity:IEntity):void
		{
			var n:int = _components.length;
			for(var i:int = 0; i < n; i++)
			{
				var collection:ComponentsCollection = _components[i];
				if(collection.has(entity.id))
					collection.remove(entity.id);
			}
		}
		/**
		 * @inheritDoc
		 */
		public function dispose():void
		{
			while(_components.length > 0)
			{
				var collection:ComponentsCollection = _components[_components.length - 1];
				collection.dispose();
				_components.length--;
			}
			_components = null;
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
