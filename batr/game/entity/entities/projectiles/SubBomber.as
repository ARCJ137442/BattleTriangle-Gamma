package batr.game.entity.entities.projectiles 
{
	import batr.general.*;
	
	import batr.game.entity.*;
	import batr.game.entity.entities.players.*;
	import batr.game.entity.entities.projectiles.*;
	import batr.game.model.*;
	import batr.game.main.*;
	
	import flash.display.*;
	import flash.geom.*;
	
	public class SubBomber extends BulletBasic
	{
		//============Static Variables============//
		public static const SIZE:Number=PosTransform.localPosToRealPos(1/2)
		public static const DEFAULT_SPEED:Number=12/GlobalGameVariables.TPS*2
		public static const DEFAULT_EXPLODE_COLOR:uint=0xffcc00
		public static const FORCE_EXPLODE_COLOR:uint=0xff0000
		public static const DEFAULT_EXPLODE_RADIUS:Number=2
		public static const MAX_BOMB_TICK:uint=GlobalGameVariables.TPS*0.0625
		
		//============Static Variables============//
		protected var fuel:int
		protected var _bombTick:uint
		protected var _maxBombTick:uint
		protected var _bombUsesFuel:uint=10
		
		//============Constructor Function============//
		public function SubBomber(host:Game,x:Number,y:Number,owner:Player,chargePercent:Number,fuel:int=100):void
		{
			var scalePercent:Number=(0.25+chargePercent*0.75);
			super(host,x,y,owner,DEFAULT_SPEED,DEFAULT_EXPLODE_RADIUS*scalePercent);
			this._currentWeapon=WeaponType.SUB_BOMBER;
			this.damage=this._currentWeapon.defaultDamage;
			this.fuel=fuel*scalePercent*this.finalExplodeRadius/DEFAULT_EXPLODE_RADIUS;
			this._maxBombTick=MAX_BOMB_TICK*(0.75+scalePercent);
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
			return EntityType.SUB_BOMBER;
		}
		
		//============Instance Functions============//
		protected override function explode():void
		{
			if(this.fuel>0)
			{
				var percent:Number=this.fuel/this._bombUsesFuel;
				this._host.weaponCreateExplode(
					this.entityX,this.entityY,
					this.finalExplodeRadius*(percent>1?(2-1/percent):percent),
					2*this.damage*percent,
					this,
					percent<1?DEFAULT_EXPLODE_COLOR:DEFAULT_EXPLODE_COLOR*(1/percent)+FORCE_EXPLODE_COLOR*(1-1/percent)
				);
			}
			this._host.entitySystem.removeProjectile(this);
		}
		
		public override function onBulletTick():void
		{
			if((this._bombTick--)==0)
			{
				this.bomb();
				this._bombTick=this._maxBombTick;
			}
		}
		
		protected function bomb():void
		{
			if(this.fuel>this._bombUsesFuel)
			{
				this._host.weaponCreateExplode(this.entityX,this.entityY,this.finalExplodeRadius,this.damage,this,DEFAULT_EXPLODE_COLOR);
				this.fuel-=this._bombUsesFuel;
			}
			else this.explode();
		}
		
		//====Graphics Functions====//
		public override function drawShape():void
		{
			super.drawShape();
			this.drawBomberSign();
			this.scaleX=this.scaleY=SubBomber.SIZE/BulletBasic.SIZE;
		}
		
		protected function drawBomberSign():void
		{
			var realRadius:Number=BulletBasic.SIZE*0.25;
			graphics.beginFill(this.ownerLineColor);
			graphics.moveTo(-realRadius,-realRadius);
			graphics.lineTo(realRadius,0);
			graphics.lineTo(-realRadius,realRadius);
			graphics.lineTo(-realRadius,-realRadius);
			graphics.endFill();
		}
	}
}