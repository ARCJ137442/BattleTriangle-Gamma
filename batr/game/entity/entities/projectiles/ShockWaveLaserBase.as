package batr.game.entity.entities.projectiles 
{
	import batr.general.*;
	
	import batr.game.entity.*;
	import batr.game.entity.entities.players.*;
	import batr.game.entity.entities.projectiles.*;
	import batr.game.model.*;
	import batr.game.main.*;
	
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author ARCJ137442
	 */
	public class ShockWaveLaserBase extends ProjectileCommon 
	{
		//============Static Variables============//
		public static const BLOCK_RADIUS:Number=GlobalGameVariables.DEFAULT_SIZE*1.2;
		
		public static const LIFE:uint=GlobalGameVariables.TPS;//Life For Charge
		
		//============Static Functions============//
		
		//============Instance Variables============//
		protected var _leftBlock:Sprite;
		protected var _rightBlock:Sprite;
		
		protected var _life:uint=0;
		
		protected var _weapon:WeaponType;
		
		//============Constructor Function============//
		public function ShockWaveLaserBase(host:Game,x:Number,y:Number,owner:Player,weapon:WeaponType):void
		{
			super(host,x,y,owner);
			this._currentWeapon=WeaponType.SHOCKWAVE_LASER;
			this._weapon=weapon!=this._currentWeapon?weapon:WeaponType.LASER;
		}
		
		//============Instance Getter And Setter============//
		public override function get type():EntityType
		{
			return EntityType.SHOCKWAVE_LASER_BASE;
		}
		
		//============Instance Functions============//
		public override function onProjectileTick():void
		{
			//Charging
			if(this._life>=LIFE)
			{
				//Summon Drone
				this.summonDrone(GlobalRot.rotateInt(this.rot,1));
				this.summonDrone(GlobalRot.rotateInt(this.rot,-1));
				//Remove
				this._host.entitySystem.removeProjectile(this);
			}
			else
			{
				this._life++;
				this.scaleX=this.scaleY=1-this._life/LIFE;
				this.alpha=0.5+(this._life/LIFE)/2;
			}
		}
		
		public override function drawShape():void
		{
			this.graphics.beginFill(this.ownerColor);
			this.graphics.drawRect(-BLOCK_RADIUS,-BLOCK_RADIUS,BLOCK_RADIUS*2,BLOCK_RADIUS*2);
			this.graphics.endFill();
		}
		
		public function summonDrone(rot:uint):void
		{
			var drone:ShockWaveLaserDrone=new ShockWaveLaserDrone(this.host,this.entityX,this.entityY,this.owner,this._weapon,this.rot);
			drone.rot=GlobalRot.lockIntToStandard(rot);
			this.host.entitySystem.registerProjectile(drone);
			this.host.projectileContainer.addChild(drone);
		}
	}
}