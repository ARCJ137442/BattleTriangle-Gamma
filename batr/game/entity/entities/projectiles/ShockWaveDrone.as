package batr.game.entity.entities.projectiles {

	import batr.general.*;
	import batr.common.*;

	import batr.game.block.*;
	import batr.game.entity.*;
	import batr.game.entity.entities.players.*;
	import batr.game.model.*;
	import batr.game.main.*;

	import flash.display.*;
	import flash.geom.*;

	public class ShockWaveDrone extends ProjectileCommon {
		//============Static Variables============//
		public static const LINE_SIZE:Number = GlobalGameVariables.DEFAULT_SIZE / 80;
		public static const BLOCK_RADIUS:Number = GlobalGameVariables.DEFAULT_SIZE / 2;

		public static const MOVING_INTERVAL:uint = GlobalGameVariables.FIXED_TPS * 0.0625;

		//============Instance Variables============//
		public var lastBlockType:BlockType = BlockType.NULL;
		public var nowBlockType:BlockType = BlockType.NULL;

		protected var _weapon:WeaponType;
		protected var _weaponChargePercent:Number;

		protected var _weaponRot:uint;
		protected var _moveDuration:uint = 0;

		//============Constructor Function============//
		public function ShockWaveDrone(host:Game, x:Number, y:Number, owner:Player, weapon:WeaponType, weaponRot:uint, weaponChargePercent:Number):void {
			super(host, x, y, owner);
			this._currentWeapon = WeaponType.SHOCKWAVE_ALPHA;
			this._weapon = weapon;
			this._weaponChargePercent = weaponChargePercent;
			this._weaponRot = weaponRot;
			this.drawShape();
		}

		//============Destructor Function============//
		public override function deleteSelf():void {
			this.graphics.clear();
			this._weapon = null;
			super.deleteSelf();
		}

		//============Instance Getter And Setter============//
		public override function get type():EntityType {
			return EntityType.SHOCKWAVE_LASER_DRONE;
		}

		//============Instance Functions============//

		//====Tick Function====//
		public override function onProjectileTick():void {
			if (this._host == null)
				return;
			// Ticking
			if (this._moveDuration > 0)
				this._moveDuration--;
			else {
				this._moveDuration = ShockWaveDrone.MOVING_INTERVAL;
				// Moving
				this.moveForwardInt(1);
				var ex:Number = this.entityX;
				var ey:Number = this.entityY;
				if (_host.isOutOfMap(ex, ey) || !this._host.testCanPass(ex, ey, false, true, false)) {
					// Gone
					this._host.entitySystem.removeProjectile(this);
				}
				// Use Weapon
				else
					this.host.playerUseWeaponAt(this.owner, this._weapon,
							ex + GlobalRot.towardIntX(this._weaponRot, GlobalGameVariables.PROJECTILES_SPAWN_DISTANCE),
							ey + GlobalRot.towardIntY(this._weaponRot, GlobalGameVariables.PROJECTILES_SPAWN_DISTANCE),
							this._weaponRot, this._weaponChargePercent, GlobalGameVariables.PROJECTILES_SPAWN_DISTANCE);
			}
		}

		//====Graphics Functions====//
		public override function drawShape():void {
			this.graphics.beginFill(this.ownerColor, 0.5);
			this.graphics.drawRect(-BLOCK_RADIUS, -BLOCK_RADIUS, BLOCK_RADIUS * 2, BLOCK_RADIUS * 2);
			this.graphics.drawRect(-BLOCK_RADIUS / 2, -BLOCK_RADIUS / 2, BLOCK_RADIUS, BLOCK_RADIUS);
			this.graphics.endFill();
		}
	}
}
