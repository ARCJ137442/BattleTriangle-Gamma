package batr.game.entity.entities.projectiles {

	import batr.general.*;

	import batr.game.entity.entities.players.*;
	import batr.game.entity.entities.projectiles.*;
	import batr.game.entity.*;
	import batr.game.model.*;
	import batr.game.main.*;

	import flash.display.*;
	import flash.geom.*;

	public class Wave extends ProjectileCommon {
		//============Static Variables============//
		public static const SIZE:Number = GlobalGameVariables.DEFAULT_SIZE;
		public static const ALPHA:Number = 0.64;
		public static const DEFAULT_SPEED:Number = 24 / GlobalGameVariables.FIXED_TPS;
		public static const MAX_SCALE:Number = 4;
		public static const MIN_SCALE:Number = 1 / 4;
		public static const LIFE:uint = GlobalGameVariables.FIXED_TPS * 4;
		public static const DAMAGE_DELAY:uint = GlobalGameVariables.FIXED_TPS / 12;

		//============Instance Variables============//
		public var speed:Number = DEFAULT_SPEED;

		public var tempScale:Number;

		protected var life:uint = LIFE;

		protected var _finalScale:Number;

		//============Constructor Function============//
		public function Wave(host:Game, x:Number, y:Number, owner:Player, chargePercent:Number):void {
			super(host, x, y, owner);
			this._currentWeapon = WeaponType.WAVE;
			dealCharge(chargePercent);
			this.drawShape();
		}

		//============Instance Getter And Setter============//
		public override function get type():EntityType {
			return EntityType.WAVE;
		}

		public override function deleteSelf():void {
			this.graphics.clear();
		}

		public function get finalScale():Number {
			return this._finalScale;
		}

		public function set finalScale(value:Number):void {
			this._finalScale = this.scaleX = this.scaleY = value;
		}

		//============Instance Functions============//
		public function dealCharge(percent:Number):void {
			this.tempScale = Wave.MIN_SCALE + (Wave.MAX_SCALE - Wave.MIN_SCALE) * percent;
			this.finalScale = this._owner == null ? tempScale : (1 + this._owner.operateFinalRadius(this.tempScale) / 2);
			this.damage = this._currentWeapon.defaultDamage * tempScale / Wave.MAX_SCALE;
		}

		//====Graphics Functions====//
		public override function drawShape():void {
			var realRadius:Number = SIZE / 2;

			graphics.clear();
			graphics.beginFill(this.ownerColor, ALPHA);
			// That's right but that create a double wave
			/*graphics.drawEllipse(-3*realRadius,-realRadius,realRadius*4,realRadius*2)
			graphics.drawCircle(-realRadius,0,realRadius)*/
			// That use two half-circle
			/*graphics.drawRect(-realRadius,-realRadius,realRadius,2*realRadius)
			graphics.drawRoundRectComplex(-realRadius*2,-realRadius,realRadius*2,realRadius*2,
										  0,realRadius,0,realRadius)
			graphics.drawRoundRectComplex(-realRadius,-realRadius,realRadius*2,realRadius*2,
										  0,realRadius,0,realRadius)
			graphics.drawRect(-realRadius*2,-realRadius,2*realRadius,2*realRadius)*/
			// That use four bezier curve
			/*graphics.moveTo(-realRadius,realRadius)
			graphics.curveTo(realRadius,realRadius,realRadius,0)
			graphics.moveTo(-realRadius,-realRadius)
			graphics.curveTo(realRadius,-realRadius,realRadius,0)
			graphics.moveTo(-realRadius,realRadius)
			graphics.curveTo(0,realRadius,0,0)
			graphics.moveTo(-realRadius,-realRadius)
			graphics.curveTo(0,-realRadius,0,0)*/
			// Final:At last use three bezier curve
			graphics.moveTo(-realRadius, realRadius);

			graphics.curveTo(realRadius, realRadius, realRadius, 0);

			graphics.curveTo(realRadius, -realRadius, -realRadius, -realRadius);
			graphics.cubicCurveTo(realRadius / 2, -realRadius, realRadius / 2, realRadius, -realRadius, realRadius);
			graphics.endFill();
		}

		//====Tick Function====//
		public override function onProjectileTick():void {
			this.moveForward(this.speed);

			if (this.life % DAMAGE_DELAY == 0) {
				this._host.waveHurtPlayers(this);
			}
			dealLife();

		}

		protected function dealLife():void {
			if (this.life > 0)
				this.life--;

			else {
				this._host.entitySystem.removeProjectile(this);

			}
		}
	}
}