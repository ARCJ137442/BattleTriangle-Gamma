package batr.game.block.blocks 
{
	import batr.general.*;
	import batr.game.block.*;
	
	import flash.display.*;
	
	public class Bedrock extends Wall
	{
		//============Static Variables============//
		protected static const LINE_SIZE:uint=GlobalGameVariables.DEFAULT_SIZE/50
		
		//============Constructor Function============//
		public function Bedrock(lineColor:uint=0x888888,fillColor:uint=0xaaaaaa):void
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
