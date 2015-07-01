# Gimmick - Entity Component System framework for ActionScript


##Example
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
        private var _entities:IEntityIterator;
        
        override protected function initialize():void
        {
            _entities = this.getEntities(VelocityComponent, PositionComponent);
        }
        
        override public function tick(time:Number):void
        {
            for(_entities.begin(); !_entities.end(); _entities.next())
            {
                _entities.current.get(PositionComponent).x += _entities.current.get(VelocityComponent).x * time;
                _entities.current.get(PositionComponent).y += _entities.current.get(VelocityComponent).y * time;
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
            Gimmick.initialize(this.stage, null, this.tick);
            Gimmick.addSystem(MovementSystem);
            //Add new entity
            _entity = Gimmick.createEntity("Some entity");
            _entity.add(new VelocityComponent(2, 4));
            _entity.add(new PositionComponent(0, 0));
            //Start Gimmick
            Gimmick.setSystemToScope(MovementSystem);
            Gimmick.start();
        }
        
        /**
        * Will be executed every frame
        */
        private function tick(time:Number):void
        {
            trace(_entity.get(PositionComponent).x, _entity.get(PositionComponent).y);
        }
        
    }

##License


