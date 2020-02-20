package batr.game.entity.entities.projectiles 
{
	import batr.common.*;
	import batr.general.*;
	
	import batr.game.block.*;
	import batr.game.entity.entities.players.*;
	import batr.game.entity.entities.projectiles.*;
	import batr.game.entity.*;
	import batr.game.model.*;
	import batr.game.main.*;
	
	import flash.display.*;
	import flash.geom.*;
	
	public class ThrowedBlock extends ProjectileCommon
	{
		//============Static Variables============//
		public static const MAX_SPEED:Number=15/GlobalGameVariables.TPS*2
		public static const MIN_SPEED:Number=1/3*MAX_SPEED
		
		//============Instance Variables============//
		public var xSpeed:Number
		public var ySpeed:Number
		protected var _carriedBlock:BlockCommon
		
		//============Constructor Function============//
		public function ThrowedBlock(host:Game,x:Number,y:Number,
									 owner:Player,block:BlockCommon,
									 rot:uint,chargePercent:Number=1):void
		{
			super(host,x,y,owner);
			this._carriedBlock=block
			this._currentWeapon=WeaponType.BLOCK_THROWER
			this.xSpeed=GlobalRot.towardIntX(rot)*(MIN_SPEED+(MAX_SPEED-MIN_SPEED)*chargePercent)
			this.ySpeed=GlobalRot.towardIntY(rot)*(MIN_SPEED+(MAX_SPEED-MIN_SPEED)*chargePercent)
			this.damage=exMath.getDistance2(GlobalRot.towardIntX(rot,chargePercent),GlobalRot.towardIntY(rot,chargePercent))*this._currentWeapon.defaultDamage
			drawShape();
		}
		
		//============Destructor Function============//
		public override function deleteSelf():void
		{
			UsefulTools.removeChildIfContains(this,this._carriedBlock)
			this._carriedBlock=null
			super.deleteSelf();
		}
		
		//============Instance Getter And Setter============//
		public override function get type():EntityType
		{
			return EntityType.THROWED_BLOCK;
		}
		
		public function get carriedBlock():BlockCommon
		{
			return this._carriedBlock;
		}
		
		//============Instance Functions============//
		//====Tick Function====//
		public override function onProjectileTick():void
		{
			if(!_host.isOutOfMap(
					this._host.lockPosInMap(this.entityX+this.xSpeed,true),
					this._host.lockPosInMap(this.entityY+this.ySpeed,false)
				)&&
				this._host.testCanPass(
					this._host.lockPosInMap(this.entityX+this.xSpeed,true),
					this._host.lockPosInMap(this.entityY+this.ySpeed,false),
					false,true,false,false
				)&&
			   !this._host.isHitAnyPlayer(this.gridX,this.gridY))
			{
				this.addXY(this.xSpeed,this.ySpeed)
			}
			else
			{
				if(Game.debugMode) trace("Block Hit:",this.getX(),this.getY())
				this.onBlockHit()
			}
		}
		
		protected function onBlockHit():void
		{
			var lx:int=this.lockedGridX,ly:int=this.lockedGridY;
			this._host.setBlock(lx,ly,this._carriedBlock);
			this._host.throwedBlockHurtPlayer(this);
			//Effect
			this.host.addBlockLightEffect2(
				PosTransform.alignToEntity(lx),
				PosTransform.alignToEntity(ly),
				this.carriedBlock,false
			);
			//Remove
			this._host.entitySystem.removeProjectile(this);
		}
		
		//====Graphics Functions====//
		public override function drawShape():void
		{
			if(this._carriedBlock!=null)
			{
				this._carriedBlock.x=-this._carriedBlock.width/2
				this._carriedBlock.y=-this._carriedBlock.height/2
				this.addChild(this._carriedBlock)
			}
			
		}
	}
}