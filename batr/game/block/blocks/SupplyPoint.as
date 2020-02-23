package batr.game.block.blocks 
{
	import batr.general.*;
	
	import batr.game.block.*;
	
	public class SupplyPoint extends BlockCommon
	{
		//============Static Variables============//
		public static const LINE_COLOR:uint=0x444444
		public static const FILL_COLOR:uint=0xdddddd
		public static const CENTER_COLOR:uint=0x00ff00
		public static const BASE_ALPHA:Number=0.5
		public static const GRID_SIZE:uint=GlobalGameVariables.DEFAULT_SIZE
		
		public static const LINE_SIZE:Number=GRID_SIZE/32
		
		//============Instance Variables============//
		
		//============Constructor Function============//
		public function SupplyPoint():void
		{
			super();
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
			return BlockAttributes.SUPPLY_POINT
		}
		
		public override function get type():BlockType
		{
			return BlockType.SUPPLY_POINT
		}
		
		//============Instance Functions============//
		public override function clone():BlockCommon
		{
			return new SupplyPoint();
		}
		
		protected override function drawMain():void
		{
			//Base
			this.graphics.beginFill(LINE_COLOR,BASE_ALPHA);
			this.graphics.drawRect(0,0,GRID_SIZE,GRID_SIZE);
			this.graphics.drawRect(LINE_SIZE,LINE_SIZE,GRID_SIZE-LINE_SIZE*2,GRID_SIZE-LINE_SIZE*2);
			this.graphics.endFill();
			this.graphics.beginFill(FILL_COLOR,BASE_ALPHA);
			this.graphics.drawRect(LINE_SIZE,LINE_SIZE,GRID_SIZE-LINE_SIZE*2,GRID_SIZE-LINE_SIZE*2);
			this.graphics.endFill();
			//Center
			//V
			this.graphics.beginFill(CENTER_COLOR);
			this.graphics.drawRect(GRID_SIZE/8,GRID_SIZE*3/8,GRID_SIZE*0.75,GRID_SIZE*0.25);
			this.graphics.endFill();
			//H
			this.graphics.beginFill(CENTER_COLOR);
			this.graphics.drawRect(GRID_SIZE*3/8,GRID_SIZE/8,GRID_SIZE*0.25,GRID_SIZE*0.75);
			this.graphics.endFill();
		}
	}
}