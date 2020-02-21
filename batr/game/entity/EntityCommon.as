package batr.game.entity 
{
	import batr.common.*;
	import batr.general.*;
	
	import batr.game.main.*;
	
	import flash.display.Sprite;
	
	public class EntityCommon extends Sprite
	{
		//============Static Variables============//
		
		//============Static Functions============//
		
		//============Instance Variables============//
		protected var _host:Game
		protected var _isActive:Boolean
		
		//============Constructor Function============//
		public function EntityCommon(host:Game,
									x:Number,y:Number,
									initActive:Boolean=true):void
		{
			super();
			//Init Host
			this._host=host;
			//Init Positions
			this.setXY(x,y);
			//Be Active
			if(initActive) this.isActive=true;
		}
		
		//============Destructor Function============//
		public function deleteSelf():void
		{
			this.isActive=false;
			this._host=null;
		}
		
		//============Instance Getters And Setters============//
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
			if(value!=this.rot) this.rotation=GlobalRot.toRealRot(GlobalRot.lockToStandard(value));
			this.onRotationUpdate(this.rot);
			this.onPositionUpdate(this.entityX,this.entityY,this.rot);
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
		
		public function get lockedGridX():Number
		{
			return this._host.lockPosInMap(this.gridX,true);
		}
		
		public function get lockedGridY():Number
		{
			return this._host.lockPosInMap(this.gridY,false);
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
		
		public function setX(value:Number,update:Boolean=true):void
		{
			//if(value==this.getX()) return;
			this.x=PosTransform.localPosToRealPos(value);
			if(!update) return;
			this.onLocationUpdate(value,this.entityY);
			this.onPositionUpdate(value,this.entityY,this.rot);
		}
		
		public function setY(value:Number,update:Boolean=true):void
		{
			//if(value==this.getY()) return;
			this.y=PosTransform.localPosToRealPos(value);
			if(!update) return;
			this.onLocationUpdate(this.entityX,value);
			this.onPositionUpdate(this.entityX,value,this.rot);
		}
		
		public function addX(value:Number):void
		{
			this.setX(this.getX()+value);
		}
		
		public function addY(value:Number):void
		{
			this.setY(this.getY()+value);
		}
		
		public function setXY(x:Number,y:Number,update:Boolean=true):void
		{
			this.setX(x,false);
			this.setY(y,false);
			if(!update) return;
			this.onLocationUpdate(x,y);
			this.onPositionUpdate(x,y,this.rot);
		}
		
		public function addXY(x:Number,y:Number,update:Boolean=true):void
		{
			this.setXY(this.getX()+x,this.getY()+y,update);
		}
		
		public function setPositions(x:Number,y:Number,rot:Number):void
		{
			this.setXY(x,y,false);
			if(GlobalRot.isValidRot(rot)) this.rot=rot;
			this.onLocationUpdate(x,y);
			this.onPositionUpdate(x,y,rot);
		}
		
		public function addPositions(x:Number,y:Number,rot:Number=NaN):void
		{
			this.addXY(x,y,false);
			if(!isNaN(rot)) this.rot=GlobalRot.rotate(this.rot,rot);
			this.onLocationUpdate(x,y);
			this.onPositionUpdate(x,y,rot);
		}
		
		public function getFrontX(distance:Number=1):Number
		{
			return this.getX()+GlobalRot.towardX(this.rot);
		}
		
		public function getFrontY(distance:Number=1):Number
		{
			return this.getY()+GlobalRot.towardY(this.rot);
		}
		
		public function getFrontAsRotX(asRot:Number,distance:Number=1):Number
		{
			return this.getX()+GlobalRot.towardX(asRot,distance);
		}
		
		public function getFrontAsRotY(asRot:Number,distance:Number=1):Number
		{
			return this.getY()+GlobalRot.towardY(asRot,distance);
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
		
		public function onPositionUpdate(newX:Number,newY:Number,newRot:Number):void
		{
			
		}
		
		public function onLocationUpdate(newX:Number,newY:Number):void
		{
			
		}
		
		public function onRotationUpdate(newRot:Number):void
		{
			
		}
	}
}
