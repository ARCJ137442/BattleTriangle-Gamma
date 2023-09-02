package batr.game.effect.effects 
{
	import batr.common.*;
	import batr.general.*;
	
	import batr.game.entity.entities.players.*;
	import batr.game.effect.*;
	import batr.game.main.*;
	
	public class EffectPlayerHurt extends EffectPlayerDeathLight
	{
		//============Static Variables============//
		public static const FILL_COLOR:Number=0xff0000
		public static const LIFE:uint=GlobalGameVariables.FIXED_TPS*0.25
		
		//============Static Functions============//
		public static function fromPlayer(host:Game,player:Player,reverse:Boolean=false):EffectPlayerHurt
		{
			return new EffectPlayerHurt(host,player.entityX,player.entityY,player.rot,FILL_COLOR,player is AIPlayer?(player as AIPlayer).AILabel:null,reverse)
		}
		
		//============Instance Variables============//
		
		//============Constructor Function============//
		public function EffectPlayerHurt(host:Game,x:Number,y:Number,rot:uint=0,color:uint=EffectPlayerHurt.FILL_COLOR,AILabel:String=null,reverse:Boolean=false,life:uint=EffectPlayerHurt.LIFE):void
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
			return EffectType.PLAYER_HURT;
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
			graphics.beginFill(this._color);
			graphics.moveTo(-realRadiusX,-realRadiusY);
			graphics.lineTo(realRadiusX,0);
			graphics.lineTo(-realRadiusX,realRadiusY);
			graphics.lineTo(-realRadiusX,-realRadiusY);
			if(this._AILabel!=null) AIPlayer.drawAIDecoration(graphics,this._AILabel);
			graphics.endFill();
		}
	}
}