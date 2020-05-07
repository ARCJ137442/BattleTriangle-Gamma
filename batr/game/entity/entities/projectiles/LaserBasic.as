package batr.game.entity.entities.projectiles 
{
	import batr.general.*;
	
	import batr.game.entity.*;
	import batr.game.entity.entities.players.*;
	import batr.game.model.*;
	import batr.game.main.*;
	
	public class LaserBasic extends ProjectileCommon 
	{
		//============Static Variables============//
		public static const LIFE:Number=GlobalGameVariables.TPS/2
		public static const SIZE:Number=GlobalGameVariables.DEFAULT_SIZE/2
		public static const LENGTH:uint=32//EntityPos
		
		//============Instance Variables============//
		protected var _life:uint=LIFE
		public var isDamaged:Boolean=false
		
		//============Constructor Function============//
		public function LaserBasic(host:Game,x:Number,y:Number,owner:Player,length:Number=LENGTH,chargePercent:Number=1):void
		{
			super(host,x,y,owner);
			this._currentWeapon=WeaponType.LASER;
			this.damage=this._currentWeapon.defaultDamage;
			this.scaleX=length;
			this.dealCharge(chargePercent);
			this.drawShape();
		}
		
		//============Destructor Function============//
		public override function deleteSelf():void
		{
			this.graphics.clear();
			super.deleteSelf();
		}
		
		//============Instance Getter And Setter============//
		public override function get type():EntityType
		{
			return EntityType.LASER_BASIC;
		}
		
		public function get length():Number
		{
			return this.scaleX;
		}
		
		public function get life():uint
		{
			return this._life;
		}
		
		//============Instance Functions============//
		public override function drawShape():void
		{
			this.graphics.clear();
			for(var i:uint=0;i<3;i++)//0,1,2
			{
				this.drawOwnerLine(-SIZE/Math.pow(2,i+1),
									SIZE/Math.pow(2,i+1),
									i*0.1+0.5);
			}
		}
		
		protected function dealCharge(percent:Number):void
		{
			if(percent==1) return;
			this.damage*=percent;
			this._life=LIFE*percent;
		}
		
		public function dealLife():void
		{
			if(this._life>0) this._life--;
			else this._host.entitySystem.removeProjectile(this);
		}
		
		public function onLaserCommonTick():void
		{
			dealLife();
		}
		
		public function onLaserTick():void
		{
			if(!this.isDamaged) this._host.laserHurtPlayers(this);
			this.scaleY=_life/LIFE;
		}
		
		public override function onProjectileTick():void
		{
			onLaserTick();//Untrunable
			onLaserCommonTick();//Untrunable
		}
		
		protected function drawLine(y1:Number,y2:Number,
									color:uint=0xffffff,
									alpha:Number=1):void
		{
			var yStart:Number=Math.min(y1,y2);
			this.graphics.beginFill(color,alpha);
			this.graphics.drawRect(0,yStart,
								   GlobalGameVariables.DEFAULT_SIZE,
								   Math.max(y1,y2)-yStart);
			this.graphics.endFill();
		}
		
		protected function drawOwnerLine(y1:Number,y2:Number,
										alpha:Number=1):void
		{
			var yStart:Number=Math.min(y1,y2);
			this.graphics.beginFill(this.ownerColor,alpha);
			this.graphics.drawRect(0,yStart,
								   GlobalGameVariables.DEFAULT_SIZE,
								   Math.max(y1,y2)-yStart);
			this.graphics.endFill();
		}
	}
}