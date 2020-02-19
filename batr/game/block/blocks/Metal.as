package batr.game.block.blocks 
{
	import batr.general.*;
	
	import batr.game.block.*;
	
	import flash.display.*;
	
	public class Metal extends BlockCommon
	{
		//============Static Variables============//
		protected static const LINE_SIZE:uint=GlobalGameVariables.DEFAULT_SIZE/20
		
		//============Instance Variables============//
		protected var _lineColor:uint,_fillColor:uint
		
		//============Constructor Function============//
		public function Metal(lineColor:uint=0x444444,fillColor:uint=0xdddddd):void
		{
			super();
			this._lineColor=lineColor,this._fillColor=fillColor;
			this.drawMain();
		}
		
		//============Destructor Function============//
		public override function deleteSelf():void
		{
			this._lineColor=this._fillColor=0;
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
		
		public function get lineColor():uint
		{
			return this._lineColor;
		}
		
		public function get fillColor():uint
		{
			return this._fillColor;
		}
		
		public function set lineColor(color:uint):void
		{
			if(this._lineColor!=color)
			{
				this._lineColor=color;
				reDraw();
			}
		}
		
		public function set fillColor(color:uint):void
		{
			if(this._fillColor!=color)
			{
				this._fillColor=color;
				reDraw();
			}
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