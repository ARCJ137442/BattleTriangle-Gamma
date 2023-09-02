package batr.game.block {

	import batr.game.block.*;

	// Abstract
	public class RotatableBlock extends BlockCommon {
		//============Static Functions============//

		//============Instance Variables============//
		protected var _rot:uint;

		//============Constructor Function============//
		public function RotatableBlock(rot:uint):void {
			this._rot = rot;
			super();
		}

		//============Destructor Function============//
		public override function deleteSelf():void {
			super.deleteSelf();
		}

		//============Instance Getter And Setter============//
		public function get rot():uint {
			return this._rot;
		}

		//============Instance Functions============//
		public override function clone():BlockCommon {
			return new RotatableBlock(this._rot);
		}
	}
}