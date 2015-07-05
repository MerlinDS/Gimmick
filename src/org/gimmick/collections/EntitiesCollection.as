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

	import org.gimmick.core.IEntity;

	public class EntitiesCollection implements IEntitiesCollection
	{

		private var _cursor:int;
		private var _entities:Vector.<IEntity>;
		//======================================================================================================================
//{region											PUBLIC METHODS
		public function EntitiesCollection(entities:Vector.<IEntity>)
		{
			_entities = entities;
		}

		public function begin():void
		{
		}

		public function end():Boolean
		{
			return false;
		}

		public function next():void
		{
		}

		public function getCollection(...types):IEntitiesCollection
		{
			return null;
		}

		public function dispose():void
		{
		}
//} endregion PUBLIC METHODS ===========================================================================================
//======================================================================================================================
//{region										PRIVATE\PROTECTED METHODS

//} endregion PRIVATE\PROTECTED METHODS ================================================================================
//======================================================================================================================
//{region											GETTERS/SETTERS

		public function get collectionTypes():Array
		{
			return null;
		}

		public function get current():IEntity
		{
			return null;
		}
//} endregion GETTERS/SETTERS ==========================================================================================
	}
}
