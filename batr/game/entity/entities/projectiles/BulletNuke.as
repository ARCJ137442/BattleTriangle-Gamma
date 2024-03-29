package batr.game.entity.entities.projectiles {

	import batr.general.*;

	import batr.game.entity.*;
	import batr.game.entity.entities.players.*;
	import batr.game.entity.entities.projectiles.*;
	import batr.game.model.*;
	import batr.game.main.*;

	import flash.display.*;
	import flash.geom.*;

	public class BulletNuke extends BulletBasic {
		//============Static Variables============//
		public static const SIZE:Number = PosTransform.localPosToRealPos(1 / 2);
		public static const DEFAULT_SPEED:Number = 12 / GlobalGameVariables.FIXED_TPS;
		public static const DEFAULT_EXPLODE_COLOR:uint = 0xffcc00;
		public static const DEFAULT_EXPLODE_RADIUS:Number = 6.4;

		//============Constructor Function============//
		public function BulletNuke(host:Game, x:Number, y:Number, owner:Player, chargePercent:Number):void {
			var scalePercent:Number = (0.25 + chargePercent * 0.75);
			super(host, x, y, owner, DEFAULT_SPEED * (2 - scalePercent), DEFAULT_EXPLODE_RADIUS * (2 * scalePercent));
			this._currentWeapon = WeaponType.NUKE;
			this.damage = this._currentWeapon.defaultDamage * scalePercent;
			this.drawShape();
		}

		//============Destructor Function============//
		public override function deleteSelf():void {
			this.graphics.clear();
			super.deleteSelf();
		}

		//============Instance Getter And Setter============//
		public override function get type():EntityType {
			return EntityType.BULLET_NUKE;
		}

		//============Instance Functions============//
		protected override function explode():void {
			this._host.weaponCreateExplode(this.entityX, this.entityY, this.finalExplodeRadius, this.damage, this, DEFAULT_EXPLODE_COLOR, 0.5);
			this._host.entitySystem.removeProjectile(this);
		}

		//====Graphics Functions====//
		public override function drawShape():void {
			super.drawShape();
			this.drawNukeSign();
			this.scaleX = this.scaleY = BulletNuke.SIZE / BulletBasic.SIZE;
		}

		protected function drawNukeSign():void {
			graphics.beginFill(this.ownerLineColor);
			graphics.drawCircle(0, 0, BulletBasic.SIZE * 0.125);
			graphics.endFill();
		}
	}
}