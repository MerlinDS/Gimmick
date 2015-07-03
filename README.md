# Gimmick - Entity Component System framework for ActionScript

Main goals of "Gimmick" development:
* Fast and ease ECS framework
* Smart and rapid filtration of entities by their components `getEntities(ComponentType1, ..., ComponentTypeN)`
* Consistency and homogeneity of components in memory
* Operations with parallel systems( [ActionScript Workers support](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/system/Worker.html) )

More documentation (API, best practices, etc) will be available after ending of development of first library prototype.

If you are interested feel free to ask questions:
* [Twitter - MerlinDS](https://twitter.com/MerlinDs)
* Email - merlinkolv@gmail.com
* [Blog](http://merlinds.com)

##Simple Example
VelocityComponent and PositionComponent.

    public class VelocityComponent
    {
        public var x:Number;
        public var y:Number;
        
        public function VelocityComponent(x:Number, y:Number)
        {
            this.x = x;
            this.y = y;
        }
    }
    
    public class PositionComponent
    {
        public var x:Number;
        public var y:Number;
        
        public function PositionComponent(x:Number, y:Number)
        {
            this.x = x;
            this.y = y;
        }
    }

Update entity position by velocity with MovementSystem

    public class MovementSystem extends EntitySystem 
    {
    
        override public function tick(time:Number):void
        {
            var entities:IEntities = this.getEntities(VelocityComponent, PositionComponent);
            for(entities.begin(); !entities.end(); entities.next())
            {
                var entity:IEntity = entities.current;
                entity.get(PositionComponent).x += entity.get(VelocityComponent).x * time;
                entity.get(PositionComponent).y += entity.get(VelocityComponent).y * time;
            }
        }
    }

Or with EntityProcessingSystem

    public class MovementSystem extends EntityProcessingSystem 
    {
        
        override protected function initialize():void
        {
            this.setProcessingEntities(VelocityComponent, PositionComponent);
        }
        
        override public function processEntity(entity:IEntity):void
        {
            entity.get(PositionComponent).x += entity.get(VelocityComponent).x * this.time;
            entity.get(PositionComponent).y += entity.get(VelocityComponent).y * this.time;
        }
    }

Usage (Main class of the application):

    public  class Application extends Sprite
    {    
    
        private var _entity:IEntity;
        
        public function Application()
        {
            this.addEventListener(Event.ADD_TO_STAGE, this.addToStageHandler);
            super();
        }
        
        private function addToStageHandler(event:Event):void
        {
            this.removeEventListener(Event.ADD_TO_STAGE, this.addToStageHandler);
            //Initialize Gimmick
            Gimmick.addSystem(MovementSystem);
            Gimmick.addToScope(MovementSystem);
            //Create new entity
            _entity = Gimmick.createEntity("Some entity");
            _entity.add(new VelocityComponent(2, 4));
            _entity.add(new PositionComponent(0, 0));
            //start game loop
            this.stage.addEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
        }
        
        private function enterFrameHandler(event:Event):void
        { 
            //Update Gimmick, update all in scope systems
            Gimmick.tick();
            //Will trace new position of entity 
            trace(_entity.get(PositionComponent).x, _entity.get(PositionComponent).y);
        }
        
    }

##License


The MIT License (MIT)

Copyright (c) 2015 Andrew Salomatin (MerlinDS)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.