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
	
	public class BulletBasic extends ProjectileCommon
	{
		//============Static Variables============//
		public static const LINE_SIZE:Number=GlobalGameVariables.DEFAULT_SIZE/80
		public static const SIZE:Number=PosTransform.localPosToRealPos(3/8)
		public static const DEFAULT_SPEED:Number=16/GlobalGameVariables.TPS*2//'*2': In order to synchronize the in-game CD with the real CD<Will be removed in 0.2.1>
		public static const DEFAULT_EXPLODE_RADIUS:Number=1
		
		//============Instance Variables============//
		public var speed:Number
		public var finalExplodeRadius:Number//Entity Pos
		
		public var lastBlockType:BlockType=BlockType.NULL;
		public var nowBlockType:BlockType=BlockType.NULL;
		
		//============Constructor Function============//
		public function BulletBasic(host:Game,x:Number,y:Number,
									owner:Player,
									speed:Number=DEFAULT_SPEED,
									defaultExplodeRadius:Number=DEFAULT_EXPLODE_RADIUS):void
		{
			super(host,x,y,owner);
			this.speed=speed
			this.finalExplodeRadius=owner==null?defaultExplodeRadius:owner.operateFinalRadius(defaultExplodeRadius);
			this._currentWeapon=WeaponType.BULLET
			this.damage=this._currentWeapon.defaultDamage
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
			return EntityType.BULLET_BASIC;
		}
		
		//============Instance Functions============//
		
		//====Tick Function====//
		public override function onProjectileTick():void
		{
			this.onBulletTick()
			this.onBulletCommonTick()
		}
		
		public function onBulletCommonTick():void
		{
			//Move
			//Detect
			if(this._host==null) return;
			this.nowBlockType=this._host.getBlockType(this.gridX,this.gridY);
			if(this.lastBlockType!=this.nowBlockType)
			{
				//Random rotate
				if(this.nowBlockType!=null&&
					this.nowBlockType.currentAttributes.rotateWhenMoveIn)
				{
					this.rot+=exMath.random1();
				}
			}
			this.moveForward(this.speed)
			if(!_host.isOutOfMap(this.entityX,this.entityY)&&
			   this._host.testCanPass(this.entityX,this.entityY,false,true,false))
			{
				this.lastBlockType=this.nowBlockType;
			}
			else
			{
				if(Game.debugMode) trace("Bullet explode:",this.getX(),this.getY())
				this.explode()
			}
		}
		
		public function onBulletTick():void
		{
			
		}
		
		protected function explode():void
		{
			this._host.weaponCreateExplode(this.entityX,this.entityY,this.finalExplodeRadius,this.damage,this,0xffff00,1)
			this._host.entitySystem.removeProjectile(this)
		}
		
		//====Graphics Functions====//
		public override function drawShape():void
		{
			var realRadiusX:Number=SIZE/2
			var realRadiusY:Number=SIZE/2
			with(this.graphics)
			{
				clear();
				lineStyle(LINE_SIZE,this.ownerLineColor);
				beginFill(this.ownerColor);
				/* GRADIENT-FILL REMOVED
				var m:Matrix=new Matrix()
				m.createGradientBox(SIZE,
									SIZE,0,-realRadiusX,-realRadiusX)
				beginGradientFill(GradientType.LINEAR,
				[this.ownerColor,ownerLineColor],
				[1,1],
				[63,255],
				m,
				SpreadMethod.PAD,
				InterpolationMethod.RGB,
				1)
				*/
				moveTo(-realRadiusX,-realRadiusY);
				lineTo(realRadiusX,0);
				lineTo(-realRadiusX,realRadiusY);
				lineTo(-realRadiusX,-realRadiusY);
				endFill();
			}
		}
	}
}
