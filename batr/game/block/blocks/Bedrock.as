package batr.game.block.blocks 
{
	import batr.general.*;
	import batr.game.block.*;
	
	import flash.display.*;
	
	public class Bedrock extends Wall
	{
		//============Static Variables============//
		public static const LINE_COLOR:uint=0x999999
		public static const FILL_COLOR:uint=0xaaaaaa
		public static const LINE_SIZE:uint=Wall.LINE_SIZE
		
		//============Constructor Function============//
		public function Bedrock(lineColor:uint=LINE_COLOR,fillColor:uint=FILL_COLOR):void
		{
			super(lineColor,fillColor);
		}
		
		//============Destructor Function============//
		
		//============Instance Getter And Setter============//
		public override function get attributes():BlockAttributes
		{
			return BlockAttributes.BEDROCK
		}
		
		public override function get type():BlockType 
		{
			return BlockType.BEDROCK
		}
		
		//============Instance Functions============//
		public override function clone():BlockCommon 
		{
			return new Bedrock(this._lineColor,this._fillColor)
		}
	}
}
