package batr.game.block.blocks {

	import batr.general.*;

	import batr.game.block.*;
	import batr.game.block.blocks.*;

	import flash.display.*;

	public class Water extends ColoredBlock {
		//============Static Variables============//
		protected static const ALPHA:Number = 0.4;

		//============Instance Variables============//

		//============Constructor Function============//
		public function Water(color:uint = 0x2222FF):void {
			super(color);
		}

		//============Destructor Function============//
		public override function deleteSelf():void {
			super.deleteSelf();
		}

		//============Instance Getter And Setter============//
		public override function get attributes():BlockAttributes {
			return BlockAttributes.WATER;
		}

		public override function get type():BlockType {
			return BlockType.WATER;
		}

		public override function get pixelAlpha():uint {
			return Water.ALPHA;
		}

		//============Instance Functions============//
		public override function clone():BlockCommon {
			return new Water(this._fillColor);
		}

		protected override function drawMain():void {
			this.graphics.beginFill(this._fillColor, Water.ALPHA);
			this.graphics.drawRect(0, 0, GlobalGameVariables.DEFAULT_SIZE, GlobalGameVariables.DEFAULT_SIZE);
			this.graphics.endFill();
		}
	}
}