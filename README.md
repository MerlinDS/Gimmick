# Gimmick - Component/Entity System framework for ActionScript

Gimmick is the fast and simple CES framework for ActionScript3 (and js in future)

Main goals of "Gimmick" development:
* Fast and ease CES framework
* Smart and rapid filtration of entities by their components `getEntities(ComponentType1, ..., ComponentTypeN)`
* Homogeneity of components in memory
* Operations with parallel systems( [ActionScript Workers support](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/system/Worker.html) )

##Links
* [Gimmick-Examples](https://github.com/MerlinDS/Gimmick-Examples)
* For more documentation see *[Wiki](https://github.com/MerlinDS/Gimmick/wiki)*
* To see all [tasks, create bug or leave proposal, please visit:
[https://github.com/MerlinDS/Gimmick/issues](https://github.com/MerlinDS/Gimmick/issues)

If you are interested feel free to ask questions:
* [Twitter - MerlinDS](https://twitter.com/MerlinDs)
* Email - merlinkolv@gmail.com
* [Blog](http://merlinds.com)

##Simple Example
VelocityComponent and PositionComponent.

    public class VelocityComponent extends Component
    {
        public var x:Number;
        public var y:Number;
        
        public function VelocityComponent(x:Number, y:Number)
        {
            this.x = x;
            this.y = y;
        }
    }
    
    public class PositionComponent extends Component
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

    public class MovementSystem extends IEntitySystem 
    {
    
        private var _entities:IEntities;
        
        public function initialize():void
        {
            //For quick iterations through entities use pre initialized of entities collection
            _entities = Gimmick.getEntities(VelocityComponent, PositionComponent);
        }
        
        public function dispose():void
        {
            _entities.dispose();
            _entities = null;
        }
        
        public function tick(time:Number):void
        {
            /*
            * Collection can be created in body of tick method, 
            * but in this case iteration through entities will be slower.
            * var entities:IEntities = Gimmick.getEntities(VelocityComponent, PositionComponent);
            */
            for(_entities.begin(); !_entities.end(); _entities.next())
            {
                var entity:IEntity = entities.current;
                entity.get(PositionComponent).x += entity.get(VelocityComponent).x * time;
                entity.get(PositionComponent).y += entity.get(VelocityComponent).y * time;
            }
        }
        //... implementation of other methods from  IEntitySystem interface
    }

Or with EntityProcessingSystem

    public class MovementSystem extends IEntityProcessingSystem 
    {
           
        public function process(entity:IEntity, entities:IEntities):void
        {
            entity.get(PositionComponent).x += entity.get(VelocityComponent).x * this.time;
            entity.get(PositionComponent).y += entity.get(VelocityComponent).y * this.time;
        }
        
        public function get targetEntities():IEntities
        {
            //initialize entities collection for future iterations in process method
            return Gimmick.getEntities(VelocityComponent, PositionComponent);
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
            Gimmick.initialize();//Can be initialized with external managers
            Gimmick.addSystem(new MovementSystem());
            Gimmick.activateSystem(MovementSystem);
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

More Examples you can found in [Gimmick-Examples](https://github.com/MerlinDS/Gimmick-Examples)

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