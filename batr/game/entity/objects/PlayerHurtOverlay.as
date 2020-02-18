package batr.game.entity.objects 
{
	import batr.general.*;
	
	import batr.game.entity.entities.players.*;
	
	import flash.display.Shape;
	
	public class PlayerHurtOverlay extends Shape
	{
		//============Static Variables============//
		public static const FILL_COLOR:uint=0xff0000
		public static const LIFE:uint=GlobalGameVariables.TPS/8
		
		//============Instance Variables============//
		protected var _life:int=-1
		protected var _lifeMax:uint=0
		
		//============Constructor Function============//
		public function PlayerHurtOverlay(owner:Player):void
		{
			super();
			drawShape(owner is AIPlayer?(owner as AIPlayer).AILabel:null)
			dealLife()
		}
		
		//============Instance Getter And Setter============//
		public function get life():uint
		{
			return this._life
		}
		
		//============Instance Functions============//
		protected function drawShape(AILabel:String=null):void
		{
			var realRadiusX:Number=Player.SIZE/2//-LINE_SIZE
			var realRadiusY:Number=Player.SIZE/2
			graphics.clear();
			//graphics.lineStyle(LINE_SIZE,this._lineColor);
			graphics.beginFill(FILL_COLOR);
			graphics.moveTo(-realRadiusX,-realRadiusY);
			graphics.lineTo(realRadiusX,0);
			graphics.lineTo(-realRadiusX,realRadiusY);
			graphics.lineTo(-realRadiusX,-realRadiusY);
			if(AILabel!=null) AIPlayer.drawAIDecoration(graphics,AILabel);
			graphics.endFill();
		}
		
		public function playAnimation(life:uint=LIFE):void
		{
			if(life>_lifeMax)
			{
				this._lifeMax=life
			}
			this._life=life
		}
		
		public function dealLife():void
		{
			if(_life>0) _life--
			else
			{
				_life=-1
				_lifeMax=0
				this.alpha=0
				return
			}
			this.alpha=_life/_lifeMax
		}
		
		public function deleteSelf():void
		{
			this.graphics.clear()
			this._life=-1
			this._lifeMax=0
		}
	}
}