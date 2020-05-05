package batr.game.block.blocks
{
	import batr.general.*;
	
	import batr.game.block.*;
	
	public class ColoredBlock extends BlockCommon
	{
		//============Static Variables============//
		
		//============Instance Variables============//
		protected var _fillColor:uint;
		
		//============Constructor Function============//
		public function ColoredBlock(color:uint=0x000000):void
		{
			super();
			this._fillColor=color;
			this.drawMain();
		}
		
		//============Destructor Function============//
		public override function deleteSelf():void
		{
			this._fillColor=0;
			super.deleteSelf();
		}
		
		//============Instance Getter And Setter============//
		public override function get attributes():BlockAttributes
		{
			return BlockAttributes.COLORED_BLOCK;
		}
		
		public override function get type():BlockType 
		{
			return BlockType.COLORED_BLOCK;
		}
		
		public function get fillColor():uint
		{
			return this._fillColor;
		}
		
		public function set fillColor(value:uint):void
		{
			if(this._fillColor!=value)
			{
				this._fillColor=value;
				this.reDraw();
			}
		}
		
		public override function get pixelColor():uint
		{
			return this._fillColor;
		}
		
		//============Instance Functions============//
		public override function clone():BlockCommon 
		{
			return new ColoredBlock(this._fillColor);
		}
		
		protected override function drawMain():void
		{
			this.graphics.beginFill(this._fillColor);
			this.graphics.drawRect(0,0,GlobalGameVariables.DEFAULT_SIZE,GlobalGameVariables.DEFAULT_SIZE);
			this.graphics.endFill();
		}
	}
}