package batr.game.entity 
{
	import batr.common.*;
	import batr.general.*;
	
	import batr.game.main.*;
	
	import flash.display.Sprite;
	
	public class EntityCommon extends Sprite
	{
		//============Static Variables============//
		protected static const _ACTIVE_AT_CREATE:Boolean=true
		
		protected static var _NEXT_UUID:uint=1
		
		//============Static Functions============//
		public static function inValidUUID(entity:EntityCommon):Boolean
		{
			return entity._uuid==0;
		}
		
		//============Instance Variables============//
		protected var _uuid:uint
		protected var _host:Game
		protected var _isActive:Boolean
		
		//============Constructor Function============//
		public function EntityCommon(host:Game,
									x:Number,y:Number,
									isActive:Boolean=EntityCommon._ACTIVE_AT_CREATE):void
		{
			super();
			//Init ID
			this._uuid=_NEXT_UUID;
			_NEXT_UUID++;
			//Init Host
			this._host=host;
			//Init Positions
			this.setXY(x,y);
			//Be Active
			if(isActive) this.isActive=true;
		}
		
		//============Destructor Function============//
		public function deleteSelf():void
		{
			this.isActive=false
			this._host=null
			this._uuid=0
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
			return GlobalRot.lockToStandard(GlobalRot.fromRealRot(this.rotation));
		}
		
		public function set rot(value:Number):void
		{
			if(value==this.rot) return;
			this.rotation=GlobalRot.toRealRot(GlobalRot.lockToStandard(value));
			this.onRotationChange(this.rot);
			this.onPositionChange(this.entityX,this.entityY,this.rot);
		}
		
		public function get type():EntityType
		{
			return EntityType.ABSTRACT;
		}
		
		public function get entityX():Number
		{
			return this.getX();
		}
		
		public function get entityY():Number
		{
			return this.getY();
		}
		
		/**
		 * Return a Intager than entityX
		 */
		public function get gridX():int
		{
			return PosTransform.alignToGrid(this.getX());
		}
		
		/**
		 * Return a Intager than entityY
		 */
		public function get gridY():int
		{
			return PosTransform.alignToGrid(this.getY());
		}
		
		/**
		 * Return a Point Contains gridX,gridY
		 */
		public function get gridPoint():iPoint
		{
			return new iPoint(this.gridX,this.gridY);
		}
		
		public function get lockedEntityX():Number
		{
			return this._host.lockPosInMap(this.entityX,true);
		}
		
		public function get lockedEntityY():Number
		{
			return this._host.lockPosInMap(this.entityY,false);
		}
		
		//============Instance Functions============//
		//====Tickrun Functions====//
		public function tickFunction():void
		{
			
		}
		
		//====Position Functions====//
		public function getX():Number
		{
			return PosTransform.realPosToLocalPos(this.x);
		}
		
		public function getY():Number
		{
			return PosTransform.realPosToLocalPos(this.y);
		}
		
		public function setX(value:Number):void
		{
			if(value==this.entityX) return;
			this.x=PosTransform.localPosToRealPos(value);
			this.onLocationChange(value,this.entityY);
			this.onPositionChange(value,this.entityY,this.rot);
		}
		
		public function setY(value:Number):void
		{
			if(value==this.entityY) return;
			this.y=PosTransform.localPosToRealPos(value);
			this.onLocationChange(this.entityX,value);
			this.onPositionChange(this.entityX,value,this.rot);
		}
		
		public function addX(value:Number):void
		{
			this.setX(this.getX()+value);
		}
		
		public function addY(value:Number):void
		{
			this.setY(this.getY()+value);
		}
		
		public function setXY(x:Number,y:Number):void
		{
			setX(x);
			setY(y);
		}
		
		public function addXY(x:Number,y:Number):void
		{
			addX(x);
			addY(y);
		}
		
		public function setPositions(x:Number,y:Number,rot:uint):void
		{
			setXY(x,y);
			if(GlobalRot.isValidRot(rot)) this.rot=rot;
		}
		
		public function addPositions(x:Number,y:Number,rot:Number=NaN):void
		{
			addXY(x,y);
			if(!isNaN(rot)) this.rot+=rot;
		}
		
		public function getFrontX(distance:Number=1,rotatedAsRot:Number=5):Number
		{
			return this.getX()+GlobalRot.towardX(rotatedAsRot>4?this.rot:rotatedAsRot,distance);
		}
		
		public function getFrontY(distance:Number=1,rotatedAsRot:Number=5):Number
		{
			return this.getY()+GlobalRot.towardY(rotatedAsRot>4?this.rot:rotatedAsRot,distance);
		}
		
		public function getFrontIntX(distance:Number=1,rotatedAsRot:uint=5):Number
		{
			return this.getX()+GlobalRot.towardIntX(rotatedAsRot>4?this.rot:rotatedAsRot,distance);
		}
		
		public function getFrontIntY(distance:Number=1,rotatedAsRot:uint=5):Number
		{
			return this.getY()+GlobalRot.towardIntY(rotatedAsRot>4?this.rot:rotatedAsRot,distance);
		}
		
		public function moveForward(distance:Number=1):void
		{
			this.addXY(GlobalRot.towardX(this.rot,distance),GlobalRot.towardY(this.rot,distance));
		}
		
		public function moveIntForward(distance:Number=1):void
		{
			this.addXY(GlobalRot.towardIntX(this.rot,distance),
					   GlobalRot.towardIntY(this.rot,distance));
		}
		
		public function onPositionChange(newX:Number,newY:Number,newRot:Number):void
		{
			
		}
		
		public function onLocationChange(newX:Number,newY:Number):void
		{
			
		}
		
		public function onRotationChange(newRot:Number):void
		{
			
		}
	}
}
