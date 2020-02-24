package batr.game.block.blocks 
{
	import batr.general.*;
	
	import batr.game.block.*;
	
	import flash.display.*;
	
	public class Metal extends Wall
	{
		//============Static Variables============//
		protected static const LINE_SIZE:uint=GlobalGameVariables.DEFAULT_SIZE/20
		
		//============Instance Variables============//
		
		//============Constructor Function============//
		public function Metal(lineColor:uint=0x444444,fillColor:uint=0xdddddd):void
		{
			super(lineColor,fillColor);
			this.drawMain();
		}
		
		//============Destructor Function============//
		public override function deleteSelf():void
		{
			super.deleteSelf();
		}
		
		//============Instance Getter And Setter============//
		public override function get attributes():BlockAttributes
		{
			return BlockAttributes.METAL;
		}
		
		public override function get type():BlockType 
		{
			return BlockType.METAL;
		}
		
		//============Instance Functions============//
		public override function clone():BlockCommon 
		{
			return new Metal(this._lineColor,this._fillColor);
		}
		
		protected override function drawMain():void 
		{
			//Line
			this.graphics.beginFill(this._lineColor);
			this.graphics.drawRect(0,0,GlobalGameVariables.DEFAULT_SIZE,GlobalGameVariables.DEFAULT_SIZE);
			this.graphics.endFill();
			//Fill
			this.graphics.beginFill(this._fillColor);
			this.graphics.drawRect(Metal.LINE_SIZE,Metal.LINE_SIZE,GlobalGameVariables.DEFAULT_SIZE-Metal.LINE_SIZE*2,GlobalGameVariables.DEFAULT_SIZE-Metal.LINE_SIZE*2);
			this.graphics.endFill();
			//Block
			this.graphics.beginFill(this._lineColor);
			this.graphics.drawRect(GlobalGameVariables.DEFAULT_SIZE/4,GlobalGameVariables.DEFAULT_SIZE/4,GlobalGameVariables.DEFAULT_SIZE/2,GlobalGameVariables.DEFAULT_SIZE/2);
			this.graphics.endFill();
		}
	}
}