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

	/**
	 * This class contains public interface of Gimmick framework.
	 */
	internal class GimmickEngine
	{

		private var _manualTick:Boolean;
//======================================================================================================================
//{region											PUBLIC METHODS
		public function GimmickEngine()
		{
		}
		//entities
		/**
		 * Create new entity and add it to main loop
		 * @param name Name of the new Entity. Can be generated automatically
		 * @return Instance of new Entity. New entity will be empty (without components).
		 * To add a component to Entity use Entity.add() method.
		 *
		 * @see Entity
		 */
		public function createEntity(name:String = null):Object
		{

		}

		/**
		 * Dispose existing entity. Remove entity from scope and free memory from it data.
		 * @param entity Instance of existing Entity.
		 *
		 * @throw ArgumentError If entity was not in scope or was disposed previously
		 */
		public function disposeEntity(entity:Object):void
		{

		}
		//systems
		/**
		 * Add System Type to framework
		 * @param system System type
		 */
		public function addSystem(system:Class):void
		{

		}

		/**
		 * Remove System Type from framework
		 * @param system System type
		 */
		public function removeSystem(system:Class):void
		{

		}
		//scope
		/**
		 * Add system to scope
		 * @param system System type
		 */
		public function addToScope(system:Class):void
		{

		}

		/**
		 * Remove system from scope. But not from framework
		 * @param system System type
		 */
		public function removeFromScope(system:Class):void
		{

		}

		//updates
		/**
		 * Loop method of framework.
		 * Executed each frame aromatically. Or can be executed manually if manualTick flag was set to true.
		 *
		 *	@see Gimmick.manualTick
		 */
		public function tick():void
		{

		}
//} endregion PUBLIC METHODS ===========================================================================================
//======================================================================================================================
//{region										PRIVATE\PROTECTED METHODS

//} endregion PRIVATE\PROTECTED METHODS ================================================================================
//======================================================================================================================
//{region											GETTERS/SETTERS

		/**
		 * Flag for manual looping.
		 * If this flag set to false Gimmick will be looped automatically.
		 *
		 * @see Gimmick.tick
		 */
		public function get manualTick():Boolean
		{
			return _manualTick;
		}

		/**
		 * Flag for manual looping.
		 * If this flag set to false Gimmick will be looped automatically.
		 *
		 * @see Gimmick.tick
		 */
		public function set manualTick(value:Boolean):void
		{
			_manualTick = value;
		}

//} endregion GETTERS/SETTERS ==========================================================================================
	}
}
