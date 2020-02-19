package batr.game.block.blocks 
{
	import batr.general.*;
	
	import batr.game.block.*;
	
	import flash.display.*;
	
	public class Wall extends BlockCommon
	{
		//============Static Variables============//
		protected static const LINE_SIZE:uint=GlobalGameVariables.DEFAULT_SIZE/50
		
		//============Instance Variables============//
		protected var _lineColor:uint,_fillColor:uint
		
		//============Constructor Function============//
		public function Wall(lineColor:uint=0xaaaaaa,fillColor:uint=0xbbbbbb):void
		{
			super();
			this._lineColor=lineColor,this._fillColor=fillColor
			drawMain()
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
			return BlockAttributes.WALL;
		}
		
		public override function get type():BlockType 
		{
			return BlockType.WALL;
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
			return new Wall(this._lineColor,this._fillColor);
		}
		
		protected override function drawMain():void 
		{
			//Line
			this.graphics.beginFill(this._lineColor);
			this.graphics.drawRect(0,0,GlobalGameVariables.DEFAULT_SIZE,GlobalGameVariables.DEFAULT_SIZE);
			this.graphics.endFill();
			//Fill
			this.graphics.beginFill(this._fillColor);
			this.graphics.drawRect(Wall.LINE_SIZE,Wall.LINE_SIZE,GlobalGameVariables.DEFAULT_SIZE-Wall.LINE_SIZE*2,GlobalGameVariables.DEFAULT_SIZE-Wall.LINE_SIZE*2);
			this.graphics.endFill();
		}
	}
}