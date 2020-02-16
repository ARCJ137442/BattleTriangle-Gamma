package batr.game.effect 
{
	import batr.general.*;
	
	import batr.game.main.*;
	
	import flash.display.*;
	
	public class EffectCommon extends MovieClip
	{
		//============Static Variables============//
		protected static const DEFAULE_MAX_LIFE:uint=GlobalGameVariables.TPS
		protected static var _NEXT_UUID:uint=0
		
		//============Static Functions============//
		public static function inValidUUID(effect:EffectCommon):Boolean
		{
			return effect._uuid==0;
		}
		
		//============Instance Variables============//
		protected var _uuid:uint;
		protected var _host:Game
		protected var _isActive:Boolean
		protected var life:uint
		protected var LIFE:uint
		
		//============Constructor Function============//
		public function EffectCommon(host:Game,x:Number,y:Number,maxLife:uint=DEFAULE_MAX_LIFE,active:Boolean=true):void
		{
			super();
			//Init ID
			this._uuid=_NEXT_UUID;
			_NEXT_UUID++;
			//Init Host
			this._host=host;
			//Set Life
			this.LIFE=maxLife;
			this.life=LIFE;
			//Init Positions
			this.setPositions(x,y);
			//Active
			this.isActive=active;
		}
		
		//============Destructor Function============//
		public function deleteSelf():void
		{
			this.graphics.clear();
			this._uuid=0;
			this.isActive=false;
			this.life=this.LIFE=0;
			this._host=null;
		}
		
		//============Instance Getters And Setters============//
		public function get uuid():uint
		{
			return this._uuid;
		}
		
		public function get host():Game
		{
			return this._host;
		}
		
		public function get isActive():Boolean
		{
			return this._isActive;
		}
		
		public function set isActive(value:Boolean):void
		{
			if(value==this._isActive) return;
			this._isActive=value;
		}
		
		public function get rot():Number
		{
			return GlobalRot.fromRealRot(this.rotation);
		}
		
		public function set rot(value:Number):void
		{
			if(value==this.rot) return;
			this.rotation=GlobalRot.toRealRot(value);
		}
		
		public function get type():EffectType
		{
			return EffectType.ABSTRACT;
		}
		
		public function get layer():int
		{
			return this.type.effectLayer
		}
		
		//============Instance Functions============//
		public function onEffectTick():void
		{
			
		}
		
		protected function dealLife():void
		{
			if(this.life>0) this.life--;
			else _host.effectSystem.removeEffect(this);
		}
		
		public function drawShape():void
		{
			
		}
		
		//====Position Functions====//
		public function getX():Number
		{
			return PosTransform.realPosToLocalPos(this.x)
		}
		
		public function getY():Number
		{
			return PosTransform.realPosToLocalPos(this.y)
		}
		
		public function setX(value:Number):void
		{
			this.x=PosTransform.localPosToRealPos(value);
		}
		
		public function setY(value:Number):void
		{
			this.y=PosTransform.localPosToRealPos(value);
		}
		
		public function addX(value:Number):void
		{
			this.setX(this.getX()+value)
		}
		
		public function addY(value:Number):void
		{
			this.setY(this.getY()+value)
		}
		
		public function setXY(x:Number,y:Number):void
		{
			this.setX(x)
			this.setY(y)
		}
		
		public function addXY(x:Number,y:Number):void
		{
			this.addX(x)
			this.addY(y)
		}
		
		public function setPositions(x:Number,y:Number,rot:Number=NaN):void
		{
			this.setXY(x,y)
			if(!isNaN(rot)) this.rot=rot
		}
		
		public function addPositions(x:Number,y:Number,rot:Number=NaN):void
		{
			this.addXY(x,y)
			if(!isNaN(rot)) this.rot+=rot
		}
	}
}
