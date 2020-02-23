package batr.game.block.blocks 
{
	import batr.game.block.*;
	import batr.game.block.blocks.*;
	import batr.general.*;
	
	import flash.display.*;
	
	public class Gate extends BlockCommon
	{
		//============Static Variables============//
		protected static const BLOCK_SIZE:uint=GlobalGameVariables.DEFAULT_SIZE
		protected static const LINE_SIZE:uint=BLOCK_SIZE/20
		
		public static const LINE_COLOR:uint=0xaaaaaa
		public static const FILL_COLOR:uint=0xbbbbbb
		public static const CENTER_COLOR:uint=0x666666
		
		//============Constructor Functions============//
		
		//============Instance Variables============//
		private var _open:Boolean
		
		//============Constructor Function============//
		public function Gate(open:Boolean):void
		{
			super();
			this._open=open;
			this.drawMain();
		}
		
		//============Destructor Function============//
		
		//============Instance Getter And Setter============//
		public override function get attributes():BlockAttributes
		{
			return this._open?BlockAttributes.GATE_OPEN:BlockAttributes.GATE_CLOSE;
		}
		
		public override function get type():BlockType 
		{
			return this._open?BlockType.GATE_OPEN:BlockType.GATE_CLOSE;
		}
		
		//============Instance Functions============//
		public override function clone():BlockCommon 
		{
			return new Gate(this._open);
		}
		
		protected override function drawMain():void
		{
			if(this._open)
			{
				//Line
				this.graphics.beginFill(LINE_COLOR);
				this.graphics.drawRect(0,0,BLOCK_SIZE,BLOCK_SIZE);
				this.graphics.drawRect(LINE_SIZE,LINE_SIZE,BLOCK_SIZE-LINE_SIZE*2,BLOCK_SIZE-LINE_SIZE*2);
				this.graphics.endFill();
			}
			else
			{
				this.graphics.beginFill(LINE_COLOR);
				this.graphics.drawRect(0,0,BLOCK_SIZE,BLOCK_SIZE);
				this.graphics.endFill();
				//Fill
				this.graphics.beginFill(FILL_COLOR);
				this.graphics.drawRect(LINE_SIZE,LINE_SIZE,BLOCK_SIZE-LINE_SIZE*2,BLOCK_SIZE-LINE_SIZE*2);
				this.graphics.endFill();
				//Center
				this.graphics.beginFill(CENTER_COLOR);
				this.graphics.drawCircle(BLOCK_SIZE/2,BLOCK_SIZE/2,BLOCK_SIZE/3);
				this.graphics.drawCircle(BLOCK_SIZE/2,BLOCK_SIZE/2,BLOCK_SIZE/4);
				this.graphics.endFill();
			}
		}
	}
}