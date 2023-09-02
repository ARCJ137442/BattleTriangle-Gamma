package batr.game.effect.effects {

	import batr.common.*;
	import batr.general.*;

	import batr.game.entity.entities.players.*;
	import batr.game.effect.*;
	import batr.game.main.*;

	public class EffectPlayerDeathLight extends EffectCommon {
		//============Static Variables============//
		public static const SIZE:Number = GlobalGameVariables.DEFAULT_SIZE;
		public static const LINE_SIZE:Number = GlobalGameVariables.DEFAULT_SIZE / 16;
		public static const MAX_LIFE:uint = GlobalGameVariables.TPS / 2;
		public static const MAX_SCALE:Number = 2;
		public static const MIN_SCALE:Number = 1;

		//============Static Functions============//
		public static function fromPlayer(host:Game, x:Number, y:Number, player:Player, reverse:Boolean = false):EffectPlayerDeathLight {
			return new EffectPlayerDeathLight(host, x, y, player.rot, player.fillColor, player is AIPlayer ? (player as AIPlayer).AILabel : null, reverse);
		}

		//============Instance Variables============//
		protected var _color:uint = 0x000000;
		protected var _AILabel:String;
		public var reverse:Boolean = false;

		//============Constructor Function============//
		public function EffectPlayerDeathLight(host:Game, x:Number, y:Number, rot:uint = 0, color:uint = 0xffffff, AILabel:String = null, reverse:Boolean = false, life:uint = EffectPlayerDeathLight.MAX_LIFE):void {
			super(host, x, y, life);
			this._color = color;
			this.rot = rot;
			this.reverse = reverse;
			this._AILabel = AILabel;
			this.drawShape();
		}

		//============Destructor Function============//
		public override function deleteSelf():void {
			super.deleteSelf();
		}

		//============Instance Getter And Setter============//
		public override function get type():EffectType {
			return EffectType.PLAYER_DEATH_LIGHT;

		}

		public function get color():uint {
			return this._color;
		}

		public function set color(value:uint):void {
			this._color = value;
			this.drawShape();

		}

		//============Instance Functions============//
		public override function onEffectTick():void {
			this.alpha = this.reverse ? (1 - life / LIFE) : (life / LIFE);
			this.scaleX = this.scaleY = MIN_SCALE + (MAX_SCALE - MIN_SCALE) * (1 - this.alpha);
			dealLife();

		}

		public override function drawShape():void {
			var realRadiusX:Number = SIZE / 2;
			var realRadiusY:Number = SIZE / 2;
			graphics.clear();
			graphics.lineStyle(LINE_SIZE, this._color);
			graphics.moveTo(-realRadiusX, -realRadiusY);
			graphics.lineTo(realRadiusX, 0);
			graphics.lineTo(-realRadiusX, realRadiusY);
			graphics.lineTo(-realRadiusX, -realRadiusY);
			if (this._AILabel != null)
				AIPlayer.drawAIDecoration(graphics, this._AILabel);
			graphics.endFill();
		}
	}
}