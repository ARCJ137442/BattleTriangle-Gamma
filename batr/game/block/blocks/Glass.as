package batr.game.block.blocks 
{
	import batr.general.*;
	
	import batr.game.block.*;
	import batr.game.block.blocks.*;
	
	import flash.display.*;
	
	public class Glass extends ColoredBlock
	{
		//============Static Variables============//
		protected static const LINE_SIZE:uint=GlobalGameVariables.DEFAULT_SIZE/16
		protected static const ALPHA_FRAME:Number=0.6
		protected static const ALPHA_FILL:Number=0.2
		
		//============Instance Variables============//
		
		//============Constructor Function============//
		public function Glass(color:uint=0xddffff):void
		{
			super(color);
		}
		
		//============Destructor Function============//
		
		//============Instance Getter And Setter============//
		public override function get attributes():BlockAttributes
		{
			return BlockAttributes.GLASS
		}
		
		public override function get type():BlockType 
		{
			return BlockType.GLASS
		}
		
		//============Instance Functions============//
		public override function clone():BlockCommon 
		{
			return new Glass(this._color)
		}
		
		protected override function drawMain():void
		{
			//Line
			this.graphics.beginFill(this._color,Glass.ALPHA_FRAME)
			this.graphics.drawRect(0,0,GlobalGameVariables.DEFAULT_SIZE,GlobalGameVariables.DEFAULT_SIZE)
			this.graphics.drawRect(Glass.LINE_SIZE,Glass.LINE_SIZE,GlobalGameVariables.DEFAULT_SIZE-Glass.LINE_SIZE*2,GlobalGameVariables.DEFAULT_SIZE-Glass.LINE_SIZE*2)
			this.graphics.endFill()
			//Fill
			this.graphics.beginFill(this._color,Glass.ALPHA_FILL)
			this.graphics.drawRect(Glass.LINE_SIZE,Glass.LINE_SIZE,GlobalGameVariables.DEFAULT_SIZE-Glass.LINE_SIZE*2,GlobalGameVariables.DEFAULT_SIZE-Glass.LINE_SIZE*2)
			this.graphics.endFill()
		}
	}
}