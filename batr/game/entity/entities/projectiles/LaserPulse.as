package batr.game.entity.entities.projectiles 
{
	import batr.general.*;
	
	import batr.game.entity.entities.players.*;
	import batr.game.model.*;
	import batr.game.main.*;
	
	public class LaserPulse extends LaserBasic 
	{
		//============Static Variables============//
		public static const LIFE:Number=GlobalGameVariables.TPS/8
		public static const SIZE:Number=GlobalGameVariables.DEFAULT_SIZE/4
		public static const ALPHA:Number=1/0.75
		
		//============Instance Variables============//
		public var isPull:Boolean=false
		
		//============Constructor Function============//
		public function LaserPulse(host:Game,x:Number,y:Number,owner:Player,length:uint=LENGTH,chargePercent:Number=1):void
		{
			super(host,x,y,owner,length,chargePercent);
			this._currentWeapon=WeaponType.PULSE_LASER;
			this._life=LaserPulse.LIFE;
			this.damage=this._currentWeapon.defaultDamage;
			this.dealCharge(chargePercent);
		}
		
		//============Instance Functions============//
		public override function onLaserTick():void
		{
			if(!this.isDamaged) this._host.laserHurtPlayers(this);
			if(this.isPull)
			{
				this.scaleY=1+this._life/LaserPulse.LIFE;
				this.alpha=(2-this.scaleY)*ALPHA;
			}
			else
			{
				this.scaleY=2-(this._life/LaserPulse.LIFE);
				this.alpha=(2-this.scaleY)*ALPHA;
			}
		}
		
		protected override function dealCharge(percent:Number):void
		{
			if(percent!=1) this.isPull=true;
		}
		
		public override function drawShape():void
		{
			this.graphics.clear();
			for(var i:uint=0;i<2;i++)//0,1
			{
				this.drawOwnerLine(-SIZE/Math.pow(2,i+1),
									SIZE/Math.pow(2,i+1),
									i*0.1+0.2);
			}
		}
	}
}