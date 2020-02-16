package batr.game.block.blocks 
{
	import batr.game.block.*;
	import batr.game.block.blocks.*;
	import batr.general.*;
	
	import flash.display.*;
	
	public class XTrap extends BlockCommon
	{
		//============Static Variables============//
		protected static const LINE_SIZE:uint=GlobalGameVariables.DEFAULT_SIZE/20
		protected static const ALPHA:Number=0.8
		protected static const COLOR_NULL:uint=0
		protected static const COLOR_HURT:uint=0xffff00
		protected static const COLOR_KILL:uint=0xff0000
		
		//============Constructor Functions============//
		private static function getColorByType(type:BlockType):uint
		{
			switch(type)
			{
				case BlockType.X_TRAP_HURT: return XTrap.COLOR_HURT;
				case BlockType.X_TRAP_KILL: return XTrap.COLOR_KILL;
				default: return XTrap.COLOR_NULL;
			}
		}
		
		//============Instance Variables============//
		private var _type:BlockType
		
		//============Constructor Function============//
		public function XTrap(type:BlockType):void
		{
			super();
			this._type=type;
			this.drawMain();
		}
		
		//============Destructor Function============//
		
		//============Instance Getter And Setter============//
		public override function get attributes():BlockAttributes
		{
			return this._type.currentAttributes;
		}
		
		public override function get type():BlockType 
		{
			return this._type;
		}
		
		//============Instance Functions============//
		public override function clone():BlockCommon 
		{
			return new XTrap(this._type);
		}
		
		protected override function drawMain():void
		{
			//Line
			this.graphics.lineStyle(LINE_SIZE,XTrap.getColorByType(this._type),ALPHA)
			this.graphics.moveTo(LINE_SIZE/2,LINE_SIZE/2)
			this.graphics.lineTo(GlobalGameVariables.DEFAULT_SIZE-LINE_SIZE/2,GlobalGameVariables.DEFAULT_SIZE-LINE_SIZE/2)
			this.graphics.moveTo(LINE_SIZE/2,GlobalGameVariables.DEFAULT_SIZE-LINE_SIZE/2)
			this.graphics.lineTo(GlobalGameVariables.DEFAULT_SIZE-LINE_SIZE/2,LINE_SIZE/2)
		}
	}
}