package batr.game.entity.entities.projectiles 
{
	import batr.general.*;
	
	import batr.game.entity.entities.players.*;
	import batr.game.model.*;
	import batr.game.main.*;
	
	public class LaserTeleport extends LaserBasic 
	{
		//============Static Variables============//
		public static const LIFE:Number=GlobalGameVariables.TPS/4
		public static const SIZE:Number=GlobalGameVariables.DEFAULT_SIZE/4
		
		//============Constructor Function============//
		public function LaserTeleport(host:Game,x:Number,y:Number,owner:Player,length:uint=LENGTH):void
		{
			super(host,x,y,owner,length);
			this._currentWeapon=WeaponType.TELEPORT_LASER
			this.damage=this._currentWeapon.defaultDamage
		}
		
		//============Instance Functions============//
		public override function onLaserTick():void
		{
			this.alpha=_life%4<2?0.75:1
			if(_life<1/4*LIFE)
			{
				this.scaleY=(1/4*LIFE-_life)/(1/4*LIFE)
			}
			else if(this._life%4==0)
			{
				this._host.laserHurtPlayers(this)
			}
		}
		
		public override function drawShape():void
		{
			graphics.clear()
			//Middle
			drawOwnerLine(-SIZE/2,SIZE/2,0.25)
			//Side
			drawOwnerLine(-SIZE/2,-SIZE/4,0.6)
			drawOwnerLine(SIZE/4,SIZE/2,0.6)
		}
	}
}