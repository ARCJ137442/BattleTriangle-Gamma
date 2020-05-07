package batr.game.entity.entities.projectiles 
{
	import batr.general.*;
	import batr.common.*;
	
	import batr.game.block.*;
	import batr.game.entity.*;
	import batr.game.entity.entities.players.*;
	import batr.game.model.*;
	import batr.game.main.*;
	
	import flash.display.*;
	import flash.geom.*;
	
	public class ShockWaveLaserDrone extends ProjectileCommon
	{
		//============Static Variables============//
		public static const LINE_SIZE:Number=GlobalGameVariables.DEFAULT_SIZE/80
		public static const BLOCK_RADIUS:Number=GlobalGameVariables.DEFAULT_SIZE/4;
		
		public static const MOVING_INTERVAL:uint=GlobalGameVariables.TPS/32;
		
		//============Instance Variables============//
		public var lastBlockType:BlockType=BlockType.NULL;
		public var nowBlockType:BlockType=BlockType.NULL;
		
		public var usingWeapon:WeaponType;
		
		protected var _weaponRot:uint;
		protected var _moveTick:uint=0;
		
		//============Constructor Function============//
		public function ShockWaveLaserDrone(host:Game,x:Number,y:Number,owner:Player,weapon:WeaponType,weaponRot:uint):void
		{
			super(host,x,y,owner);
			this._currentWeapon=WeaponType.SHOCKWAVE_LASER;
			this.usingWeapon=weapon;
			this._weaponRot=weaponRot;
			this.drawShape();
		}
		
		//============Destructor Function============//
		public override function deleteSelf():void
		{
			this.graphics.clear();
			this.usingWeapon=null;
			super.deleteSelf();
		}
		
		//============Instance Getter And Setter============//
		public override function get type():EntityType
		{
			return EntityType.SHOCKWAVE_LASER_DRONE;
		}
		
		//============Instance Functions============//
		
		//====Tick Function====//
		public override function onProjectileTick():void
		{
			if(this._host==null) return;
			//Ticking
			if(this._moveTick<ShockWaveLaserDrone.MOVING_INTERVAL) this._moveTick++;
			else
			{
				this._moveTick=0;
				var ex:Number=this.entityX;
				var ey:Number=this.entityY;
				if(!_host.isOutOfMap(ex,ey)&&
				   this._host.testCanPass(ex,ey,false,true,false))
				{
					//Moving
					this.moveForwardInt(1);
					//Use Weapon
					this.host.playerUseWeaponAt(this.owner,this.usingWeapon,ex,ey,this._weaponRot,1);
				}
				//Gone
				else this._host.entitySystem.removeProjectile(this);
			}
		}
		
		//====Graphics Functions====//
		public override function drawShape():void
		{
			this.graphics.beginFill(this.ownerColor,0.5);
			this.graphics.drawRect(-BLOCK_RADIUS,-BLOCK_RADIUS,BLOCK_RADIUS*2,BLOCK_RADIUS*2);
			this.graphics.drawRect(-BLOCK_RADIUS/2,-BLOCK_RADIUS/2,BLOCK_RADIUS,BLOCK_RADIUS);
			this.graphics.endFill();
		}
	}
}
