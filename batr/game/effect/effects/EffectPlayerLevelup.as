package batr.game.effect.effects {

	import batr.common.*;
	import batr.general.*;

	import batr.game.effect.*;
	import batr.game.main.*;

	public class EffectPlayerLevelup extends EffectCommon {
		//============Static Variables============//
		public static const DEFAULT_COLOR:uint = 0x000000;
		public static const LINE_ALPHA:Number = 0.8;
		public static const FILL_ALPHA:Number = 0.75;
		public static const LINE_SIZE:Number = GlobalGameVariables.DEFAULT_SIZE / 25;
		public static const GRID_SIZE:Number = GlobalGameVariables.DEFAULT_SIZE / 5;

		//============Instance Variables============//

		//============Constructor Function============//
		public function EffectPlayerLevelup(host:Game, x:Number, y:Number,
				color:uint = DEFAULT_COLOR,
				scale:Number = 1):void {
			super(host, x, y, GlobalGameVariables.TPS / 2);
			this.scaleX = this.scaleY = scale;
			this.drawArrow(color);
		}

		//============Destructor Function============//
		public override function deleteSelf():void {
			super.deleteSelf();
		}

		//============Instance Getter And Setter============//
		public override function get type():EffectType {
			return EffectType.PLAYER_LEVELUP;
		}

		//============Instance Functions============//
		public override function onEffectTick():void {
			this.alpha = this.life / LIFE;
			dealLife();
			this.y -= GRID_SIZE / 4 * (1 - this.life / LIFE);
		}

		public override function drawShape():void {
			this.graphics.clear();
			this.drawArrow(DEFAULT_COLOR);
		}

		protected function drawArrow(color:uint):void {
			// Colored Arrow
			this.graphics.lineStyle(LINE_SIZE, color, LINE_ALPHA);
			this.graphics.beginFill(color, FILL_ALPHA);
			this.graphics.moveTo(0, -GRID_SIZE * 1.5); // T1
			this.graphics.lineTo(GRID_SIZE * 1.5, 0); // T2
			this.graphics.lineTo(GRID_SIZE / 2, 0); // B1
			this.graphics.lineTo(GRID_SIZE / 2, GRID_SIZE * 1.5); // B2
			this.graphics.lineTo(-GRID_SIZE / 2, GRID_SIZE * 1.5); // B3
			this.graphics.lineTo(-GRID_SIZE / 2, 0); // B4
			this.graphics.lineTo(-GRID_SIZE * 1.5, 0); // T3
			this.graphics.lineTo(0, -GRID_SIZE * 1.5); // T1
			this.graphics.endFill();
		}
	}
}