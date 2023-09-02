package batr.game.block.blocks {

	import batr.general.*;

	import batr.game.block.*;

	public class ColorSpawner extends BlockCommon {
		//============Static Variables============//
		public static const LINE_COLOR:uint = Bedrock.LINE_COLOR;
		public static const FILL_COLOR:uint = Bedrock.FILL_COLOR;
		public static const CENTER_COLOR:uint = 0x444444;

		public static const LINE_SIZE:Number = GlobalGameVariables.DEFAULT_SIZE / 32;

		//============Instance Variables============//

		//============Constructor Function============//
		public function ColorSpawner():void {
			super();
			this.drawMain();
		}

		//============Destructor Function============//
		public override function deleteSelf():void {
			super.deleteSelf();
		}

		//============Instance Getter And Setter============//
		public override function get attributes():BlockAttributes {
			return BlockAttributes.COLOR_SPAWNER;

		}

		public override function get type():BlockType {
			return BlockType.COLOR_SPAWNER;

		}

		//============Instance Functions============//
		public override function clone():BlockCommon {
			return new ColorSpawner();
		}

		protected override function drawMain():void {
			// Line
			this.graphics.beginFill(LINE_COLOR);
			this.graphics.drawRect(0, 0, GlobalGameVariables.DEFAULT_SIZE, GlobalGameVariables.DEFAULT_SIZE);
			this.graphics.endFill();
			// Fill
			this.graphics.beginFill(FILL_COLOR);
			this.graphics.drawRect(LINE_SIZE, LINE_SIZE, GlobalGameVariables.DEFAULT_SIZE - LINE_SIZE * 2, GlobalGameVariables.DEFAULT_SIZE - LINE_SIZE * 2);
			this.graphics.endFill();
			// Circle
			this.graphics.lineStyle(GlobalGameVariables.DEFAULT_SIZE / 32, CENTER_COLOR);
			// 1
			this.graphics.drawCircle(GlobalGameVariables.DEFAULT_SIZE / 2,
					GlobalGameVariables.DEFAULT_SIZE / 2,
					GlobalGameVariables.DEFAULT_SIZE * 0.4);
			// 2
			this.graphics.drawCircle(GlobalGameVariables.DEFAULT_SIZE / 2,
					GlobalGameVariables.DEFAULT_SIZE / 2,
					GlobalGameVariables.DEFAULT_SIZE * 0.25);
			// 3
			this.graphics.drawCircle(GlobalGameVariables.DEFAULT_SIZE / 2,
					GlobalGameVariables.DEFAULT_SIZE / 2,
					GlobalGameVariables.DEFAULT_SIZE * 0.325);
		}
	}
}