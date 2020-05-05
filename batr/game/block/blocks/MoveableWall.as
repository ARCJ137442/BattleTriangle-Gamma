package batr.game.block.blocks 
{
	import batr.general.*;
	
	import batr.game.block.*;
	
	//Move as throwed block.
	public class MoveableWall extends Wall
	{
		//============Static Variables============//
		public static const LINE_COLOR:uint=0x889988;
		public static const FILL_COLOR:uint=0xbbccbb;
		
		public static const LINE_SIZE:uint=Wall.LINE_SIZE
		
		//============Instance Variables============//
		protected var _virus:Boolean;
		
		//============Constructor Function============//
		public function MoveableWall(virus:Boolean=false):void
		{
			super(LINE_COLOR,FILL_COLOR);
			this._virus=virus;
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
			return BlockAttributes.MOVEABLE_WALL;
		}
		
		public override function get type():BlockType
		{
			return BlockType.MOVEABLE_WALL;
		}
		
		public function get virus():Boolean
		{
			return this._virus;
		}
		
		//============Instance Functions============//
		public override function clone():BlockCommon
		{
			return new MoveableWall(this._virus);
		}
		
		protected override function drawMain():void
		{
			//Line
			this.graphics.beginFill(this._lineColor);
			this.graphics.drawRect(0,0,GlobalGameVariables.DEFAULT_SIZE,GlobalGameVariables.DEFAULT_SIZE);
			this.graphics.endFill();
			//Fill
			this.graphics.beginFill(this._fillColor);
			this.graphics.drawRect(MoveableWall.LINE_SIZE,MoveableWall.LINE_SIZE,GlobalGameVariables.DEFAULT_SIZE-Wall.LINE_SIZE*2,GlobalGameVariables.DEFAULT_SIZE-MoveableWall.LINE_SIZE*2);
			//Circle
			this.graphics.drawCircle(GlobalGameVariables.DEFAULT_SIZE/2,GlobalGameVariables.DEFAULT_SIZE/2,GlobalGameVariables.DEFAULT_SIZE/8);
			this.graphics.endFill();
		}
	}
}