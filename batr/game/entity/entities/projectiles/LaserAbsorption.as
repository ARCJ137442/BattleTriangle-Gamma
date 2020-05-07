package batr.game.entity.entities.projectiles 
{
	import batr.general.*;
	import batr.game.model.*;
	import batr.game.main.*;
	
	import batr.game.entity.entities.players.*;
	import batr.game.entity.*;
	
	public class LaserAbsorption extends LaserBasic 
	{
		//============Static Variables============//
		public static const LIFE:Number=GlobalGameVariables.TPS
		public static const SIZE:Number=GlobalGameVariables.DEFAULT_SIZE/4
		public static const SCALE_V:Number=1/4
		
		//============Instance Variables============//
		protected var scaleReverse:Boolean=true
		
		//============Constructor Function============//
		public function LaserAbsorption(host:Game,x:Number,y:Number,owner:Player,length:uint=LENGTH):void
		{
			super(host,x,y,owner,length);
			this._currentWeapon=WeaponType.ABSORPTION_LASER
			this.damage=this._currentWeapon.defaultDamage
		}
		
		//============Instance Getter And Setter============//
		public override function get type():EntityType
		{
			return EntityType.LASER_ABSORPTION;
		}
		
		//============Instance Functions============//
		public override function onLaserTick():void
		{
			this.scaleY+=SCALE_V*(scaleReverse?-1:1)
			if(this.scaleY>=1)
			{
				scaleReverse=true
				this._host.laserHurtPlayers(this)
			}
			else if(this.scaleY<=-1) scaleReverse=false
		}
		
		public override function drawShape():void
		{
			graphics.clear()
			//Left
			drawOwnerLine(-SIZE/2,-SIZE/4,0.6)
			drawOwnerLine(-SIZE/2,-SIZE/8,0.5)
			//Right
			drawOwnerLine(SIZE/4,SIZE/2,0.6)
			drawOwnerLine(SIZE/8,SIZE/2,0.5)
		}
	}
}