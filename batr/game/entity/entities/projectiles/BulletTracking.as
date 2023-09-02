package batr.game.entity.entities.projectiles {

	import batr.general.*;

	import batr.game.entity.*;
	import batr.game.entity.entities.players.*;
	import batr.game.entity.entities.projectiles.*;
	import batr.game.model.*;
	import batr.game.main.*;

	import flash.display.*;
	import flash.geom.*;

	public class BulletTracking extends BulletBasic {
		//============Static Variables============//
		public static const SIZE:Number = PosTransform.localPosToRealPos(3 / 8);
		public static const DEFAULT_SPEED:Number = 12 / GlobalGameVariables.FIXED_TPS;
		public static const DEFAULT_EXPLODE_COLOR:uint = 0xffff00;
		public static const DEFAULT_EXPLODE_RADIUS:Number = 1.25;

		//============Instance Variables============//
		protected var _target:Player = null;
		protected var _trackingFunction:Function = getTargetRot; // not the criterion
		protected var _scalePercent:Number = 1;
		protected var _cachedTargets:Vector.<Player> = new Vector.<Player>();

		//============Constructor Function============//
		public function BulletTracking(host:Game, x:Number, y:Number, owner:Player, chargePercent:Number):void {
			this._scalePercent = (1 + chargePercent * 0.5);
			if (chargePercent >= 1)
				this._trackingFunction = this.getTargetRotWidely;
			super(host, x, y, owner, DEFAULT_SPEED, DEFAULT_EXPLODE_RADIUS);
			this._currentWeapon = WeaponType.TRACKING_BULLET;
			this.cacheTargets();
			this.drawShape();
		}

		//============Instance Getter And Setter============//
		public override function get type():EntityType {
			return EntityType.BULLET_TRACKING;
		}

		//============Instance Functions============//

		/**
		 * Cached some static properties, during the short lifespan of the bullet
		 */
		protected function cacheTargets():void {
			for each (var player:Player in _host.entitySystem.players) {
				if (player != null && // not null
						(this._owner == null || this._owner.canUseWeaponHurtPlayer(player, this._currentWeapon)) // should can use it to hurt
					)
					this._cachedTargets.push(player);
			}
		}

		public override function onBulletTick():void {
			var tempRot:int;
			if (this._target == null) {
				var player:Player;
				for (var i:int = this._cachedTargets.length - 1; i >= 0; i--) {
					player = this._cachedTargets[i];
					// check valid
					if (this.checkTargetInvalid(player)) {
						this._cachedTargets.splice(i, 1);
						continue;
					};
					// tracking
					if ((tempRot = this.getTargetRot(player)) >= 0) {
						this._target = player;
						this.rot = tempRot;
						this.speed = DEFAULT_SPEED * this._scalePercent;
						break;
					}
				}
			}
			// if lost target
			else if (this.checkTargetInvalid(this._target) || (tempRot = this._trackingFunction(this._target)) < 0) {
				this._target = null;
			}
			else {
				// tracking
				this.rot = tempRot;
			}
		}

		protected function checkTargetInvalid(player:Player):Boolean {
			return (
					player == null || // not null
					player.isRespawning || // not respawning
					(this._owner != null && !this._owner.canUseWeaponHurtPlayer(player, this._currentWeapon)) // should can use it to hurt
				);

		}

		protected function getTargetRot(player:Player):int {
			if (this.gridX == player.gridX) {
				return this.gridY > player.gridY ? GlobalRot.UP : GlobalRot.DOWN; // from left top
			}
			else if (this.gridY == player.gridY) {
				return this.gridX > player.gridX ? GlobalRot.LEFT : GlobalRot.RIGHT;
			}
			return -1;
		}

		protected function getTargetRotWidely(player:Player):int {
			var xDistance:int = this.gridX - player.gridX;
			var yDistance:int = this.gridY - player.gridY;
			if (Math.abs(xDistance) > Math.abs(yDistance)) {
				return this.gridX > player.gridX ? GlobalRot.LEFT : GlobalRot.RIGHT;
			}
			else {
				return this.gridY > player.gridY ? GlobalRot.UP : GlobalRot.DOWN; // from left top
			}
		}

		//====Graphics Functions====//
		public override function drawShape():void {
			super.drawShape();
			this.drawTrackingSign();
			this.scaleX = this.scaleY = BulletTracking.SIZE / BulletBasic.SIZE;
		}

		protected function drawTrackingSign():void {
			graphics.beginFill(this.ownerLineColor);
			var radius:Number = BulletTracking.SIZE * 0.125;
			graphics.moveTo(-radius, -radius);
			graphics.lineTo(radius, 0);
			graphics.lineTo(-radius, radius);
			graphics.lineTo(-radius, -radius);
			graphics.endFill();
		}
	}
}