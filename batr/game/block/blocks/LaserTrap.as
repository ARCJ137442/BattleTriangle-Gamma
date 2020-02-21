package batr.game.block.blocks 
{
	import batr.general.*;
	
	import batr.game.block.*;
	
	//ShootLaser in 4 side.
	public class LaserTrap extends BlockCommon
	{
		//============Static Variables============//
		public static const LINE_COLOR:uint=0x444444
		public static const FILL_COLOR:uint=0xdddddd
		
		public static const LINE_SIZE:Number=GlobalGameVariables.DEFAULT_SIZE/32
		
		//============Instance Variables============//
		
		//============Constructor Function============//
		public function LaserTrap():void
		{
			super();
			drawMain()
		}
		
		//============Destructor Function============//
		public override function deleteSelf():void
		{
			super.deleteSelf();
		}
		
		//============Instance Getter And Setter============//
		public override function get attributes():BlockAttributes
		{
			return BlockAttributes.LASER_TRAP;
		}
		
		public override function get type():BlockType
		{
			return BlockType.LASER_TRAP;
		}
		
		//============Instance Functions============//
		public override function clone():BlockCommon
		{
			return new LaserTrap();
		}
		
		protected override function drawMain():void
		{
			//Line
			this.graphics.beginFill(LINE_COLOR);
			this.graphics.drawRect(0,0,GlobalGameVariables.DEFAULT_SIZE,GlobalGameVariables.DEFAULT_SIZE);
			this.graphics.drawRect(LINE_SIZE,LINE_SIZE,GlobalGameVariables.DEFAULT_SIZE-LINE_SIZE*2,GlobalGameVariables.DEFAULT_SIZE-LINE_SIZE*2);
			this.graphics.endFill();
			//Fill
			this.graphics.beginFill(FILL_COLOR);
			this.graphics.drawRect(LINE_SIZE,LINE_SIZE,GlobalGameVariables.DEFAULT_SIZE-LINE_SIZE*2,GlobalGameVariables.DEFAULT_SIZE-LINE_SIZE*2);
			this.graphics.endFill();
			//Rhombus
			this.graphics.lineStyle(LINE_SIZE,LINE_COLOR);
			this.drawRhombus(
				GlobalGameVariables.DEFAULT_SIZE/2,
				GlobalGameVariables.DEFAULT_SIZE/2,
				GlobalGameVariables.DEFAULT_SIZE/3
			);
			this.drawRhombus(
				GlobalGameVariables.DEFAULT_SIZE/2,
				GlobalGameVariables.DEFAULT_SIZE/2,
				GlobalGameVariables.DEFAULT_SIZE/4
			);
			this.drawRhombus(
				GlobalGameVariables.DEFAULT_SIZE/2,
				GlobalGameVariables.DEFAULT_SIZE/2,
				GlobalGameVariables.DEFAULT_SIZE/5
			);
			this.drawRhombus(
				GlobalGameVariables.DEFAULT_SIZE/2,
				GlobalGameVariables.DEFAULT_SIZE/2,
				GlobalGameVariables.DEFAULT_SIZE/6
			);
			this.graphics.beginFill(LINE_COLOR);
			this.graphics.drawCircle(
				GlobalGameVariables.DEFAULT_SIZE/2,
				GlobalGameVariables.DEFAULT_SIZE/2,
				GlobalGameVariables.DEFAULT_SIZE/10
			);
			this.graphics.endFill();
		}
		
		private function drawRhombus(cX:Number,cY:int,radius:Number):void
		{
			this.graphics.moveTo(cX-radius,cY);
			this.graphics.lineTo(cX,cY+radius);
			this.graphics.lineTo(cX+radius,cY);
			this.graphics.lineTo(cX,cY-radius);
			this.graphics.lineTo(cX-radius,cY);
		}
	}
}