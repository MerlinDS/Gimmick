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
		 * Map of activity gropus. Contains subtrees of systems.
		 */
		private var _groups:Dictionary;
		private var _activeGroupId:String;
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
		public function addSystem(system:IIdleSystem, priority:int = 1, ...groups):IIdleSystem
		{
			var newSystem:Boolean;
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
			while(groups.length)
			{
				//no meter in what order system will be added to gropus
				var groupId:String = groups.pop();
				//create group if it does not exist
				if(_groups[groupId] == null)
					this.createGroup(groupId);
				this.addToGroup(groupId, proxy, priority);
			}

			//system was added normaly
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
				throw new ArgumentError('IEntitySystem was not added to Gimmick previously!');
			this.removeFromGroups(proxy);
			_systemsTypes[systemType] = null;
			if(proxy.isProcessingSystem)
				proxy.collection.dispose();
			var system:IIdleSystem = proxy.system;
			proxy.system.dispose();
			proxy.dispose();
			trace("[Gimmick] System ", systemType, " was removed");
			return system;
		}

		/**
		 * @inheritDoc
		 */
		public function activateSystem(systemType:Class):void
		{
			var node:SystemProxy = _systemsTypes[systemType];
			if(node == null)
				throw new ArgumentError('IEntitySystem was not added to Gimmick previously!');
		}

		/**
		 * @inheritDoc
		 */
		public function deactivateSystem(systemType:Class):void
		{
			var node:SystemProxy = _systemsTypes[systemType];
			if(node == null)
				throw new ArgumentError('System was not added to Gimmick previously!');
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
			if(_head != null)
			{
				//deactivate previous group
				for (var cursor:SystemNode = _head; cursor != null; cursor = cursor.next)
				{
					cursor.value.system.deactivate();
					cursor.value.active = false;
				}
			}
			//change subtree
			_head = root.prev;
			_activeGroupId = groupId;
			trace("[Gimmick] Group", _activeGroupId ,"activeted!");
		}

		/**
		 * @inheritDoc
		 */
		public function tick(time:Number):void
		{
			for (var cursor:SystemNode = _head; cursor != null; cursor = cursor.next)
			{
				//activate systems
				if(!cursor.value.active)
				{
					cursor.value.system.activate();
					cursor.value.active = true;
				}
				//update all except idle systems
				if(cursor.value.isProcessingSystem)
					cursor.value.collection.forEach(cursor.value.processingSystem.process);
				else if( cursor.value.isEntitySystem)
					cursor.value.entitySystem.tick(time);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function dispose():void
		{
			/*var cursor:SystemNodeOld;
			for (var type:Class in _systemsTypes)
			{
				cursor = _systemsTypes[type];
				if(cursor != null)//system can be already removed manually
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
			_head = null;*/
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
		 * @param proxy Sytem proxy for removing
		 */
		private function removeFromGroups(proxy:SystemProxy):void
		{
			var node:SystemNode;
			var next:SystemNode;
			var prev:SystemNode;
			for each(var root:SystemNode in _groups)
			{
				//find node in linked list
				node = root;
				while(node != null && node.value.system != proxy)
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
				}

			}
		}

//} endregion PRIVATE\PROTECTED METHODS ================================================================================
//======================================================================================================================
//{region											GETTERS/SETTERS

//} endregion GETTERS/SETTERS ==========================================================================================
	}
}