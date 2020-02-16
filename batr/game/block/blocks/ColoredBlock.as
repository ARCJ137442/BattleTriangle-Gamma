package batr.game.block.blocks
{
	import batr.general.*;
	
	import batr.game.block.*;
	
	public class ColoredBlock extends BlockCommon
	{
		//============Static Variables============//
		
		//============Instance Variables============//
		protected var _color:uint
		
		//============Constructor Function============//
		public function ColoredBlock(color:uint=0x000000):void
		{
			super();
			this._color=color
			drawMain()
		}
		
		//============Destructor Function============//
		public override function deleteSelf():void
		{
			this._color=0;
			super.deleteSelf();
		}
		
		//============Instance Getter And Setter============//
		public override function get attributes():BlockAttributes
		{
			return BlockAttributes.COLORED_BLOCK
		}
		
		public override function get type():BlockType 
		{
			return BlockType.COLORED_BLOCK
		}
		
		public function get color():uint
		{
			return this._color
		}
		
		public function set color(value:uint):void
		{
			if(this._color!=value)
			{
				this._color=value
				this.reDraw()
			}
		}
		
		public override function get pixelColor():uint
		{
			return this._color;
		}
		
		//============Instance Functions============//
		public override function clone():BlockCommon 
		{
			return new ColoredBlock(this._color);
		}
		
		protected override function drawMain():void 
		{
			this.graphics.beginFill(this._color);
			this.graphics.drawRect(0,0,GlobalGameVariables.DEFAULT_SIZE,GlobalGameVariables.DEFAULT_SIZE);
			this.graphics.endFill();
		}
	}
}