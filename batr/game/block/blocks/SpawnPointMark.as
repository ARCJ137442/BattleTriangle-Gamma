package batr.game.block.blocks 
{
	import batr.general.*;
	
	import batr.game.block.*;
	
	//A Mark to SpawnPoint
	public class SpawnPointMark extends BlockCommon
	{
		//============Static Variables============//
		public static const LINE_COLOR:uint=0x808080
		public static const FILL_COLOR:uint=0xcccccc
		public static const CENTER_COLOR:uint=0x8000ff
		public static const BASE_ALPHA:Number=0.5
		
		public static const LINE_SIZE:Number=GlobalGameVariables.DEFAULT_SIZE/32
		
		//============Instance Variables============//
		
		//============Constructor Function============//
		public function SpawnPointMark():void
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
			return BlockAttributes.SPAWN_POINT_MARK;
		}
		
		public override function get type():BlockType
		{
			return BlockType.SPAWN_POINT_MARK;
		}
		
		//============Instance Functions============//
		public override function clone():BlockCommon
		{
			return new SpawnPointMark();
		}
		
		protected override function drawMain():void
		{
			//Line
			this.graphics.beginFill(LINE_COLOR,BASE_ALPHA);
			this.graphics.drawRect(0,0,GlobalGameVariables.DEFAULT_SIZE,GlobalGameVariables.DEFAULT_SIZE);
			this.graphics.drawRect(LINE_SIZE,LINE_SIZE,GlobalGameVariables.DEFAULT_SIZE-LINE_SIZE*2,GlobalGameVariables.DEFAULT_SIZE-LINE_SIZE*2);
			this.graphics.endFill();
			//Fill
			this.graphics.beginFill(FILL_COLOR,BASE_ALPHA);
			this.graphics.drawRect(LINE_SIZE,LINE_SIZE,GlobalGameVariables.DEFAULT_SIZE-LINE_SIZE*2,GlobalGameVariables.DEFAULT_SIZE-LINE_SIZE*2);
			this.graphics.endFill();
			//Center
			this.graphics.lineStyle(LINE_SIZE,CENTER_COLOR);
			this.drawSpawnMark(
				GlobalGameVariables.DEFAULT_SIZE/2,
				GlobalGameVariables.DEFAULT_SIZE/2,
				GlobalGameVariables.DEFAULT_SIZE/3
			);
			this.drawSpawnMark(
				GlobalGameVariables.DEFAULT_SIZE/2,
				GlobalGameVariables.DEFAULT_SIZE/2,
				GlobalGameVariables.DEFAULT_SIZE/4
			);
			this.drawSpawnMark(
				GlobalGameVariables.DEFAULT_SIZE/2,
				GlobalGameVariables.DEFAULT_SIZE/2,
				GlobalGameVariables.DEFAULT_SIZE/5
			);
			this.drawSpawnMark(
				GlobalGameVariables.DEFAULT_SIZE/2,
				GlobalGameVariables.DEFAULT_SIZE/2,
				GlobalGameVariables.DEFAULT_SIZE/6
			);
			/*this.graphics.beginFill(LINE_COLOR);
			this.graphics.drawCircle(
				GlobalGameVariables.DEFAULT_SIZE/2,
				GlobalGameVariables.DEFAULT_SIZE/2,
				GlobalGameVariables.DEFAULT_SIZE/10
			);
			this.graphics.endFill();*/
		}
		
		private function drawSpawnMark(cX:Number,cY:int,radius:Number):void
		{
			this.graphics.drawRect(cX-radius,cY-radius,radius*2,radius*2);
			this.graphics.moveTo(cX-radius,cY);
			this.graphics.lineTo(cX,cY+radius);
			this.graphics.lineTo(cX+radius,cY);
			this.graphics.lineTo(cX,cY-radius);
			this.graphics.lineTo(cX-radius,cY);
		}
	}
}