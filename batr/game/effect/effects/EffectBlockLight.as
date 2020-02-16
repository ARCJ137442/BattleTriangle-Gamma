package batr.game.effect.effects 
{
	import batr.common.*;
	import batr.general.*;
	
	import batr.game.block.*;
	import batr.game.effect.*;
	import batr.game.main.*;
	
	public class EffectBlockLight extends EffectCommon 
	{
		//============Static Variables============//
		public static const SIZE:Number=GlobalGameVariables.DEFAULT_SIZE
		public static const LINE_SIZE:Number=GlobalGameVariables.DEFAULT_SIZE/25
		public static const MAX_LIFE:uint=GlobalGameVariables.TPS/2
		public static const MAX_SCALE:Number=2
		public static const MIN_SCALE:Number=1
		
		//============Static Functions============//
		public static function fromBlock(host:Game,x:Number,y:Number,block:BlockCommon,reverse:Boolean=false):EffectBlockLight
		{
			return new EffectBlockLight(host,x,y,block.pixelColor,block.pixelAlpha,reverse)
		}
		
		//============Instance Variables============//
		protected var _color:uint=0x000000;
		/**
		 * The uint percent.
		 */
		protected var _alpha:uint;
		public var reverse:Boolean=false;
		
		//============Constructor Function============//
		public function EffectBlockLight(host:Game,x:Number,y:Number,color:uint=0xffffff,alpha:uint=uint.MAX_VALUE,reverse:Boolean=false,life:uint=EffectBlockLight.MAX_LIFE):void
		{
			super(host,x,y,life);
			this._color=color;
			this._alpha=alpha;
			this.reverse=reverse;
			this.drawShape();
		}
		
		//============Destructor Function============//
		public override function deleteSelf():void
		{
			super.deleteSelf();
		}
		
		//============Instance Getter And Setter============//
		public override function get type():EffectType
		{
			return EffectType.PLAYER_DEATH_LIGHT
		}
		
		public function get color():uint 
		{
			return this._color;
		}
		
		public function set color(value:uint):void 
		{
			this._color=value;
			drawShape()
		}
		
		//============Instance Functions============//
		public override function onEffectTick():void
		{
			this.alpha=(this.reverse?(1-life/LIFE):(life/LIFE));
			this.scaleX=this.scaleY=MIN_SCALE+(MAX_SCALE-MIN_SCALE)*(1-this.alpha);
			dealLife();
		}
		
		public override function drawShape():void
		{
			var realRadiusX:Number=SIZE/2;
			var realRadiusY:Number=SIZE/2;
			graphics.clear();
			graphics.beginFill(this._color,UsefulTools.uintToPercent(this._alpha));
			graphics.drawRect(-realRadiusX,-realRadiusY,SIZE,SIZE);
			graphics.drawRect(LINE_SIZE-realRadiusX,LINE_SIZE-realRadiusY,SIZE-LINE_SIZE*2,SIZE-LINE_SIZE*2);
			graphics.endFill();
		}
	}
}
