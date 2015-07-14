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

	import flash.utils.Dictionary;

	import org.gimmick.core.Component;

	/**
	 * Collection that contains components of entities.
	 * Id of the component is linked id to the entity that contains this component.
	 */
	public class ComponentsCollection
	{
		private var _allocationSize:int;
		private var _content:Vector.<Component>;
		private var _hashMap:Dictionary = new Dictionary(true);
		private var _length:int;
		//======================================================================================================================
//{region											PUBLIC METHODS
		/**
		 * Constructor
		 * @param allocationSize Size of initial allocations
		 */
		public function ComponentsCollection(allocationSize:int = 100)
		{
			_allocationSize = allocationSize;
			_content = new <Component>[];
			_hashMap = new Dictionary(true);
			this.increaseSize();
		}

		/**
		 * Push component to collection
		 * @param id Id of the component
		 * @param component Instance of the component
		 */
		[Inline]
		public final function push(id:String, component:Component):void
		{
			if(_hashMap[id] != null)this.remove(id);
			if(_length == _content.length)
				this.increaseSize();
			_hashMap[id] = _length;//set index of entity in content list
			_content[_length++] = component;//add to content list
		}

		/**
		 * Remove component for collection
		 * @param id Id of the component
		 */
		public final function remove(id:String):void
		{
			//Remove entity only in case if it was added previously
			if(_hashMap[id] != null)
			{
				var index:int = _hashMap[id];
				_content[index] = null;//delete instance of content
				//get content from end of list and push it to empty place
				var lastIndex:int = --_length;
				_content[index] = _content[lastIndex];
				_content[lastIndex] = null;
				//remove from has map
				_hashMap[id] = null;
			}
		}

		/**
		 * Get component from collection by id
		 * @param id Component id in collection
		 * @return Instance of the component if it was added to collection. Null in other case.
		 */
		[Inline]
		public final function get(id:String):Component
		{
			var component:Component;
			if(_hashMap[id] != null)
				component = _content[ _hashMap[id] ];
			return component;
		}

		/**
		 * Check if collection contains component with id
		 * @param id Id of component in collection
		 * @return True if collection contains such component. False in other case
		 */
		[Inline]
		public final function has(id:String):Boolean
		{
			return _hashMap[id] != null;
		}

		/**
		 * Clear collection from content.
		 */
		public function clear():void
		{
			_hashMap = new Dictionary(true);
			this.increaseSize(true);
			_length = 0;
		}

		/**
		 * Dispose collection. Prepare it for GC.
		 */
		public function dispose():void
		{
			this.clear();
			_hashMap = null;
			_content = null;
		}

//} endregion PUBLIC METHODS ===========================================================================================
//======================================================================================================================
//{region										PRIVATE\PROTECTED METHODS
		/**
		 * Increase size of collection
		 * @param fromClean If this flag equals true, clear content and increase collection as new.
		 */
		private function increaseSize(fromClean:Boolean = false):void
		{
			_content.fixed = false;
			if(fromClean)
				_content.length = 0;
			_content.length = _content.length + _allocationSize;
			_content.fixed = true;
		}
//} endregion PRIVATE\PROTECTED METHODS ================================================================================
//======================================================================================================================
//{region											GETTERS/SETTERS

//} endregion GETTERS/SETTERS ==========================================================================================
	}
}
