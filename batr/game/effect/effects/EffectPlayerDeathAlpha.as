package batr.game.effect.effects 
{
	import batr.common.*;
	import batr.general.*;
	
	import batr.game.entity.entities.players.*;
	import batr.game.effect.*;
	import batr.game.main.*;
	
	public class EffectPlayerDeathAlpha extends EffectPlayerDeathLight
	{
		//============Static Variables============//
		public static const ALPHA:Number=0.8
		public static const MAX_LIFE:uint=GlobalGameVariables.TPS
		
		//============Static Functions============//
		public static function fromPlayer(host:Game,x:Number,y:Number,player:Player,reverse:Boolean=false):EffectPlayerDeathAlpha
		{
			return new EffectPlayerDeathAlpha(host,x,y,player.rot,player.fillColor,player is AIPlayer?(player as AIPlayer).AILabel:null,reverse)
		}
		
		//============Instance Variables============//
		
		//============Constructor Function============//
		public function EffectPlayerDeathAlpha(host:Game,x:Number,y:Number,rot:uint=0,color:uint=0xffffff,AILabel:String=null,reverse:Boolean=false,life:uint=EffectPlayerDeathAlpha.MAX_LIFE):void
		{
			super(host,x,y,rot,color,AILabel,reverse,life);
		}
		
		//============Destructor Function============//
		public override function deleteSelf():void
		{
			super.deleteSelf();
		}
		
		//============Instance Getter And Setter============//
		public override function get type():EffectType
		{
			return EffectType.PLAYER_DEATH_ALPHA;
		}
		
		//============Instance Functions============//
		public override function onEffectTick():void
		{
			this.alpha=this.reverse?1-life/LIFE:life/LIFE;
			this.dealLife();
		}
		
		public override function drawShape():void
		{
			var realRadiusX:Number=SIZE/2;
			var realRadiusY:Number=SIZE/2;
			graphics.clear();
			graphics.beginFill(this._color,ALPHA);
			graphics.moveTo(-realRadiusX,-realRadiusY);
			graphics.lineTo(realRadiusX,0);
			graphics.lineTo(-realRadiusX,realRadiusY);
			graphics.lineTo(-realRadiusX,-realRadiusY);
			if(this._AILabel!=null) AIPlayer.drawAIDecoration(graphics,this._AILabel);
			graphics.endFill();
		}
	}
}