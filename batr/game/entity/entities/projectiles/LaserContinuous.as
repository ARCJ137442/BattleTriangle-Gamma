package batr.game.entity.entities.projectiles 
{
	import batr.general.*;
	
	import batr.game.entity.entities.players.*;
	import batr.game.model.*;
	import batr.game.main.*;
	
	public class LaserContinuous extends LaserBasic 
	{
		//============Static Variables============//
		public static const LIFE:Number=GlobalGameVariables.TPS/8
		public static const SIZE:Number=GlobalGameVariables.DEFAULT_SIZE/4
		public static const ALPHA:Number=1/12.5
		
		//============Constructor Function============//
		public function LaserContinuous(host:Game,x:Number,y:Number,owner:Player,length:uint=LENGTH):void
		{
			super(host,x,y,owner,length);
			this._currentWeapon=WeaponType.CONTINUOUS_LASER;
			this.damage=this._currentWeapon.defaultDamage;
		}
		
		//============Instance Functions============//
		public override function onLaserTick():void
		{
			if(!this.isDamaged) this._host.laserHurtPlayers(this);
			this.alpha=(_life/LaserContinuous.LIFE)*ALPHA;
		}
		
		public override function drawShape():void
		{
			graphics.clear();
			for(var i:uint=0;i<2;i++)//0,1
			{
				drawOwnerLine(-SIZE/Math.pow(2,i+1),SIZE/Math.pow(2,i+1),
							  i*0.1+0.2);
			}
		}
	}
}