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

	import flash.utils.Dictionary;

	import org.gimmick.utils.getInstanceClass;

	/**
	 * Manager for components types.
	 */
	internal final class ComponentTypeManager extends GimmickManager
	{

		private var _nextBit:uint;
		private var _nextIndex:int;
		private var _componentTypes:Dictionary;
//======================================================================================================================
//{region											PUBLIC METHODS
		public function ComponentTypeManager()
		{
			_nextBit = 0x1;
			_componentTypes = new Dictionary(true);
		}

		/**
		 * Get component Type by it's instance or class
		 * @param component Instance of the components or it's class
		 * @return Component type of the component
		 */
		[Inline]
		public final function getType(component:Object):ComponentType
		{
			//get component class if it does not provided
			if(!(component is Class))component = getInstanceClass(component);
			var componentType:ComponentType = _componentTypes[component];
			if(componentType == null)//Create component type in it does not exist
			{
				componentType = new ComponentType(_nextBit, _nextIndex);
				_componentTypes[component] = componentType;
				_nextBit = _nextBit << 1;
				_nextIndex++;
			}
			return componentType;
		}

		/**
		 * Get component type by it bitwise mask
		 * @param bit Bitwise mask
		 * @return Component type if it exist or null in other case
		 */
		public final function getTypeByBit(bit:uint):ComponentType
		{
			for each(var componentType:ComponentType in _componentTypes)
				if(componentType.bit == bit)return componentType;
			return null;
		}

		override public final function dispose():void
		{

		}
//} endregion PUBLIC METHODS ===========================================================================================
//======================================================================================================================
//{region										PRIVATE\PROTECTED METHODS

//} endregion PRIVATE\PROTECTED METHODS ================================================================================
//======================================================================================================================
//{region											GETTERS/SETTERS
		/**
		 * Last used bitwise mask
		 */
		[Inline]
		public final function get lastBit():uint
		{
			return _nextBit >> 1;
		}
//} endregion GETTERS/SETTERS ==========================================================================================        

	}
}
