package batr.game.entity.entities.projectiles {

	import batr.common.*;
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
	public class ShockWaveBase extends ProjectileCommon {
		//============Static Variables============//
		public static const BLOCK_RADIUS:Number = GlobalGameVariables.DEFAULT_SIZE * 1.2;

		/**
		 * Life For Charge
		 */
		public static const LIFE:uint = GlobalGameVariables.FIXED_TPS;

		//============Static Functions============//

		//============Instance Variables============//
		protected var _leftBlock:Sprite;
		protected var _rightBlock:Sprite;

		protected var _life:uint = 0;

		protected var _weapon:WeaponType;
		protected var _weaponChargePercent:Number;

		/**
		 * Default is 0,Vortex is 1
		 */
		public var mode:uint = 0;

		//============Constructor Function============//
		public function ShockWaveBase(host:Game, x:Number, y:Number, owner:Player, weapon:WeaponType, weaponCharge:Number, mode:uint = 0):void {
			super(host, x, y, owner);
			this._currentWeapon = WeaponType.SHOCKWAVE_ALPHA;
			this._weapon = weapon;
			this.mode = mode;
			this._weaponChargePercent = weaponCharge;
			this.drawShape();
		}

		//============Instance Getter And Setter============//
		public override function get type():EntityType {
			return EntityType.SHOCKWAVE_LASER_BASE;
		}

		//============Instance Functions============//
		public override function onProjectileTick():void {
			// Charging
			if (this._life >= LIFE) {
				this.summonDrones();
				// Remove
				this._host.entitySystem.removeProjectile(this);
			}
			else {
				this._life++;
				this.scaleX = this.scaleY = 1 - this._life / LIFE;
				this.alpha = 0.5 + (this._life / LIFE) / 2;
			}
		}

		public override function drawShape():void {
			this.graphics.beginFill(this.ownerColor);
			this.graphics.drawRect(-BLOCK_RADIUS, -BLOCK_RADIUS, BLOCK_RADIUS * 2, BLOCK_RADIUS * 2);
			this.graphics.drawRect(-BLOCK_RADIUS / 2, -BLOCK_RADIUS / 2, BLOCK_RADIUS, BLOCK_RADIUS);
			this.graphics.endFill();
		}

		public function summonDrones():void {
			// Summon Drone
			switch (this.mode) {
				case 1:
					var i:int = exMath.random1();
					for (var u:int = 0; u < 4; u++)
						this.summonDrone(u, u + i);
					break;
				default:
					this.summonDrone(GlobalRot.rotateInt(this.rot, 1));
					this.summonDrone(GlobalRot.rotateInt(this.rot, -1));
			}
		}

		public function summonDrone(rot:int, weaponRot:int = int.MIN_VALUE):void {
			var drone:ShockWaveDrone = new ShockWaveDrone(this.host, this.entityX, this.entityY, this.owner, this._weapon, weaponRot == int.MIN_VALUE ? this.rot : GlobalRot.lockIntToStandard(weaponRot), this._weaponChargePercent);
			drone.rot = GlobalRot.lockIntToStandard(rot);
			this.host.entitySystem.registerProjectile(drone);
			this.host.projectileContainer.addChild(drone);
		}
	}
}