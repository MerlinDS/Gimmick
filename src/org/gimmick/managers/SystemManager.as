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

	import org.gimmick.collections.EntitiesCollection;
	import org.gimmick.core.IIdleSystem;
	import org.gimmick.utils.getInstanceClass;

	/**
	 * Managing of all systems and groups of activity in Gimmick engine.
	 *
	 */
	internal class SystemManager implements ISystemManager
	{

		/**
		 * All nodes, passive and active
		 */
		private var _systemsTypes:Dictionary;
		/**
		 * Map of activity groups. Contains subtrees of systems.
		 */
		private var _groups:Dictionary;
		private var _activeGroupId:String;
		private var _activateNextGroup:Boolean;
		private var _nextGroup:String;
		//current subtree
		/**
		 * Head of linked list
		 */
		private var _head:SystemNode;
//======================================================================================================================
//{region											PUBLIC METHODS
		public function SystemManager()
		{
		}

		/**
		 * @inheritDoc
		 */
		public function initialize(allocationSize:int = 1):void
		{
			_groups = new Dictionary(true);
			_systemsTypes = new Dictionary(true);
		}

		/**
		 * @inheritDoc
		 */
		public function addSystem(system:IIdleSystem, priority:int = 1, groups:Array = null):IIdleSystem
		{
			var systemType:Class = getInstanceClass(system);
			var proxy:SystemProxy = _systemsTypes[systemType];
			if(proxy != null)//Do not use hasOwnProperty, cause this method is very slow
				this.removeSystem(systemType);
			//Create new proxy fo system
			proxy = new SystemProxy(system);
			if(proxy.isProcessingSystem)
			{
				proxy.collection = proxy.processingSystem .targetEntities as EntitiesCollection;
				if(proxy.collection == null)
					throw new ArgumentError('TargetCollection for processing was not added to system!');
			}
			//add system to groups if it was linked
			while(groups != null && groups.length)
			{
				//no meter in what order system will be added to gropus
				var groupId:String = groups.pop();
				//create group if it does not exist
				if(_groups[groupId] == null)
					this.createGroup(groupId);
				this.addToGroup(groupId, proxy, priority);
				//update head in need
				if(groupId == _activeGroupId)
					_head = _groups[groupId].prev;
			}

			//system was added normally
			_systemsTypes[systemType] = proxy;
			proxy.system.initialize();
			trace("[Gimmick] System ", systemType, " was added");
			return proxy.system;
		}

		/**
		 * @inheritDoc
		 */
		public function removeSystem(systemType:Class):IIdleSystem
		{
			var proxy:SystemProxy = _systemsTypes[systemType];
			if(proxy == null)
				throw new ArgumentError("[Gimmick] system " + systemType + ' was not added to Gimmick previously!');
			this.removeFromGroups(proxy);
			_systemsTypes[systemType] = null;
			if(proxy.isProcessingSystem)
				proxy.collection.dispose();
			var system:IIdleSystem = proxy.system;
			if(proxy.active)
				proxy.system.deactivate();
			proxy.system.dispose();
			proxy.dispose();
			trace("[Gimmick] System ", systemType, " was removed");
			return system;
		}

		/**
		 * @inheritDoc
		 */
		public function activateSystem(systemType:Class, priotiry:int = 1):void
		{
			var proxy:SystemProxy = _systemsTypes[systemType];
			if(proxy == null)
				throw new ArgumentError("[Gimmick] system" + systemType + 'was not added to Gimmick previously!');
			if(!proxy.active)
			{
				this.addToGroup(_activeGroupId, proxy, priotiry);
				_head = _groups[_activeGroupId].prev;
				trace("[Gimmick] system", systemType, "was activate as a part of", _activeGroupId);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function deactivateSystem(systemType:Class):void
		{
			var proxy:SystemProxy = _systemsTypes[systemType];
			if(proxy == null)
				throw new ArgumentError('System was not added to Gimmick previously!');
			if(proxy.active)
			{
				this.removeFromGroup(_activeGroupId, proxy);
				trace("[Gimmick] system", systemType, "was deactivate and remove from", _activeGroupId);
				proxy.active = false;
				proxy.system.deactivate();
			}
		}

		/**
		 * @inheritDoc
		 */
		public function activateGroup(groupId:String):void
		{
			if(_activeGroupId == groupId)
			{
				trace("[Gimmick] Group already active!");
				return;
			}
			var root:SystemNode = _groups[groupId];
			if(root == null)
				throw new ArgumentError('Group was not created previously!');

			_nextGroup = groupId;
			_activateNextGroup = true;
			trace("[Gimmick] group",_nextGroup,"will be activated on next frame");
		}

		/**
		 * @inheritDoc
		 */
		public function tick(time:Number):void
		{
			if(_activateNextGroup)this.activateNextGroup();
			for (var cursor:SystemNode = _head; cursor != null; cursor = cursor.next)
			{
				//activate systems
				if(!cursor.value.active)
				{
					cursor.value.system.activate();
					cursor.value.active = true;
					trace("[Gimmick] system", cursor.value.system, "was activate");
				}
				//update all except idle systems
				if(cursor.value.isProcessingSystem)
				{
					if(!cursor.value.collection.empty)
						cursor.value.collection.forEach(cursor.value.processingSystem.process);
				}
				else if( cursor.value.isEntitySystem)
					cursor.value.entitySystem.tick(time);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function dispose():void
		{
			for each(var group:SystemNode in _groups)
			{
				_head = group.next;
				for (var cursor:SystemNode = _head; cursor != null; cursor = cursor.next)
					cursor.dispose();
			}

			_activeGroupId = null;
			_systemsTypes = null;
			_groups = null;
			_head = null;
		}
//} endregion PUBLIC METHODS ===========================================================================================
//======================================================================================================================
//{region										PRIVATE\PROTECTED METHODS
		//Working with activity groups
		/**
		 * Create activity group, linked list of systems (also can be considered as subtree)
		 * @param groupId Unique id for new group,
		 */
		private function createGroup(groupId:String):void
		{
			if(_groups[groupId] == null)
			{
				trace("[Gimmick] Activity group", groupId, "was created");
				/*
				 * Structure of subtree:
				 * prev - contains link to head of the subtree
				 * next - contains link to tail of the subtree
				 */
				var root:SystemNode = new SystemNode(null);
				_groups[groupId] = root;
			}
			//nothing to do in other cases
		}

		private function activateNextGroup():void
		{
			var root:SystemNode = _groups[_nextGroup];
			if(_head != null)
			{
				//deactivate previous group
				for (var cursor:SystemNode = _head; cursor != null; cursor = cursor.next)
				{
					cursor.value.active = false;
					trace("[Gimmick] system", cursor.value.system, "was deactivate and remove from", _activeGroupId);
					cursor.value.system.deactivate();
				}
			}
			//change subtree
			_head = root.prev;
			_activeGroupId = _nextGroup;
			_activateNextGroup = false;
			trace("[Gimmick] Group", _activeGroupId ,"active");
		}

		/**
		 * Add System proxy to group with priority.
		 * If system proxy was already added to group,
		 * only priority of this proxy will be updated.
		 *
		 * @param groupId Unique id of existing group
		 * @param proxy Sytem proxy
		 * @param priority priority of current proxy in linked list of the group
		 */
		private function addToGroup(groupId:String, proxy:SystemProxy, priority:int = 1):void
		{
			var root:SystemNode = _groups[groupId];
			if(root == null)
				throw new ArgumentError("Activity group was not created!");

			var node:SystemNode = new SystemNode(proxy, priority);
			if(root.prev == null)//head of subtree equals null
			{
				root.prev = node;//head
				root.next = node;//tail
			}
			else
			{
				var target:SystemNode;
				target = root.next;//set tail as target
				//get node place by priority
				while(target != null && target.priority > node.priority)
					target = target.prev;
				//add to linked list
				if(target != null)
				{
					node.next = target.next;
					node.prev = target;
					target.next = node;
					if(node.next != null)
						node.next.prev = node;
					if(target == root.next)//set node as tail
						root.next = node;
				}
				else
				{
					/*
					 * If target is null, then current node
					 * becomes a head of linked list
					 */
					node.next = root.prev;
					root.prev.prev = node;
					root.prev = node;
				}
			}
		}

		/**
		 * Remove system from all groups
		 * @param proxy System proxy for removing
		 */
		private function removeFromGroups(proxy:SystemProxy):void
		{
			for(var groupId:String in _groups)
				this.removeFromGroup(groupId, proxy);
		}

		[Inline]
		private final function removeFromGroup(groupId:String, proxy:SystemProxy):void
		{
			var node:SystemNode;
			var next:SystemNode;
			var prev:SystemNode;
			var root:SystemNode = _groups[groupId];
			//find node in linked list
			node = root.prev;
			while(node != null && node.value != proxy)
				node = node.next;
			if(node != null)
			{
				//delete node from linked list
				next = node.next;
				prev = node.prev;
				if(prev != null)prev.next = next;
				if(next != null)next.prev = prev;
				if(root.next == node)root.next = prev;
				if(root.prev == node)root.prev = next;
				if(_head == node)_head = root.prev;//update current head
			}
		}
//} endregion PRIVATE\PROTECTED METHODS ================================================================================
//======================================================================================================================
//{region											GETTERS/SETTERS

		public function get activeGroupId():String
		{
			return _activeGroupId;
		}

//} endregion GETTERS/SETTERS ==========================================================================================
	}
}