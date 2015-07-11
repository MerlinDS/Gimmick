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

	import org.gimmick.core.IEntitySystem;
	import org.gimmick.utils.getInstanceClass;

	/**
	 * Managing of all systems in Gimmick engine
	 */
	internal class SystemManager implements ISystemManager
	{

		/**
		 * Head of linked list
		 */
		private var _head:Node;
		/**
		 * Tail of linked list
		 */
		private var _tail:Node;
		/**
		 * All nodes, passive and active
		 */
		private var _systemsTypes:Dictionary;
//======================================================================================================================
//{region											PUBLIC METHODS
		public function SystemManager()
		{
		}

		/**
		 * @inheritDoc
		 */
		public function initialize():void
		{
			//TODO Data consistency #10
			_systemsTypes = new Dictionary(true);
		}

		/**
		 * @inheritDoc
		 */
		public function addSystem(system:IEntitySystem, priority:int = 1):IEntitySystem
		{
			var type:Class = getInstanceClass(system);
			//remove old system from manager
			if(_systemsTypes[type] != null)//Do not use hasOwnProperty, cause this method is very slow
				this.removeSystem(type);
			//save new systemType to map and to linked list
			_systemsTypes[type] = new Node(system, priority);
			//all was done nornaly, lets initialize system
			system.initialize();
			return system;
		}

		/**
		 * @inheritDoc
		 */
		public function removeSystem(systemType:Class):IEntitySystem
		{
			var node:Node = _systemsTypes[systemType];
			if(node == null)
				throw new ArgumentError('IEntitySystem was not added to Gimmick previously!');
			if(node.active)
				this.deactivateSystem(systemType);
			_systemsTypes[systemType] = null;
			node.system.dispose();
			node.dispose();
			return node.system;
		}

		/**
		 * @inheritDoc
		 */
		public function activateSystem(systemType:Class):void
		{
			var node:Node = _systemsTypes[systemType];
			if(node == null)
				throw new ArgumentError('IEntitySystem was not added to Gimmick previously!');
			if(!node.active)
			{
				if(_head == null)
				{
					_head = node;
					_tail = node;
				}
				else
				{
					var target:Node;
					//check node priority
					if(_tail.priority > node.priority)
					{
						//find place for node by it's priority
						target = _tail;
						do target = target.prev;
						while(target != null && target.priority > node.priority);
					}
					else
						target = _tail;
					//add node to linked list
					if(target != null)
					{
						node.next = target.next;
						node.prev = target;
						target.next = node;
					}else
					{
						/*
						 * If target is null, then current node
						 * becomes a head of linked list
						 */
						node.next = _head;
						if(_head)_head.prev = node;
						_head = node;
					}
				}
				node.system.activate();
				node.active = true;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function deactivateSystem(systemType:Class):void
		{
			var node:Node = _systemsTypes[systemType];
			if(node == null)
				throw new ArgumentError('IEntitySystem was not added to Gimmick previously!');
			if(node.active)
			{
				//delete node from linked list
				var next:Node = node.next;
				var prev:Node = node.prev;
				if(prev != null)prev.next = next;
				if(next != null)next.prev = prev;
				//deactivate system and node
				node.system.deactivate();
				node.active = false;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function tick(time:Number):void
		{
			for (var cursor:Node = _head; cursor != null; cursor = cursor.next)
			{
				//update only active systems
				cursor.system.tick(time);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function dispose():void
		{
			var cursor:Node;
			for (var type:Class in _systemsTypes)
			{
				cursor = _systemsTypes[type];
				if(cursor != null)//system can be already removed manualy
				{
					if (cursor.active)cursor.system.deactivate();
					cursor.system.dispose();
					cursor.dispose();
				}
				delete _systemsTypes[type];
			}
			_systemsTypes = null;
			cursor = null;
			_tail = null;
			_head = null;
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

import org.gimmick.core.IEntitySystem;

/**
 * Linked list node - helper
 */
class Node{
	public var prev:Node;
	public var next:Node;
	public var priority:int;
	public var active:Boolean;
	public var system:IEntitySystem;

	public function Node(system:IEntitySystem, priority:int)
	{
		this.priority = priority;
		this.system = system;
	}

	public function dispose():void
	{
		prev = null;
		next = null;
		system = null;
		priority = 0;
		active = false;
	}
}