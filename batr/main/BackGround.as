package batr.main {

	import batr.general.*;
	import batr.game.block.*;
	import batr.game.block.blocks.*;

	import flash.display.*;

	public class BackGround extends Sprite {
		//============Static Variables============//
		public static const BACKGROUND_COLOR:uint = 0xdddddd;
		public static const GRID_COLOR:uint = 0xd6d6d6;
		public static const GRID_SIZE:Number = GlobalGameVariables.DEFAULT_SIZE / 32;
		public static const DEFAULT_DISPLAY_GRIDS:uint = GlobalGameVariables.DISPLAY_GRIDS;
		public static const GRID_SPREAD:uint = 0;
		public static const FRAME_LINE_COLOR:uint = 0x88ffff;
		public static const FRAME_LINE_SIZE:Number = GlobalGameVariables.DEFAULT_SIZE / 8;

		//============Instance Variables============//
		protected var _frame:Sprite;

		protected var _enableGrid:Boolean;

		protected var _enableFrame:Boolean;

		protected var _enableBorderLine:Boolean;

		//============Constructor Function============//
		public function BackGround(width:uint, height:uint,
				enableGrid:Boolean = true,
				enableFrame:Boolean = true,
				enableBorderLine:Boolean = true) {
			super();
			this._enableGrid = enableGrid;

			this._enableFrame = enableFrame;

			this._enableBorderLine = enableBorderLine;

			if (enableGrid)
				updateGrid(width, height);

			this._frame = new Sprite();

			drawFrame(width, height);

			addChilds();

		}

		//============Destructor Function============//
		public function deleteSelf():void {
			this.graphics.clear();

			this._enableFrame = false;

			this._enableGrid = false;

			this._enableBorderLine = false;

			this.deleteFrame();

			this._frame = null;

		}

		//============Instance Getter And Setter============//
		public function get frameVisible():Boolean {
			if (this._frame == null)
				return false;

			return _frame.visible;

		}

		public function set frameVisible(value:Boolean):void {
			if (this._frame == null)
				return;

			_frame.visible = value;

		}

		//============Instance Functions============//
		public function addChilds():void {
			this.addChild(this._frame);
			this._frame.visible = this._enableFrame;
		}

		protected function drawGround(width:uint, height:uint):void {
			this.graphics.beginFill(BACKGROUND_COLOR, 1);
			this.graphics.drawRect(0, 0, PosTransform.localPosToRealPos(width), PosTransform.localPosToRealPos(height));
		}

		protected function drawGrid(x:int, y:int, width:uint, height:uint):void {
			var dx:int = x, dy:int = y, mx:int = x + width, my:int = y + height;
			this.graphics.lineStyle(GRID_SIZE, GRID_COLOR);
			// V
			while (dx <= mx) {
				drawLineInGrid(dx, y, dx, my);
				dx++;
			}
			// H
			while (dy <= my) {
				drawLineInGrid(x, dy, mx, dy);
				dy++;
			}
		}

		protected function drawBorderLine(width:uint, height:uint):void {
			this.graphics.lineStyle(FRAME_LINE_SIZE, FRAME_LINE_COLOR);
			// V
			drawLineInGrid(0, 0, 0, height);
			drawLineInGrid(width, height, 0, height);
			// H
			drawLineInGrid(0, 0, width, 0);
			drawLineInGrid(width, height, width, 0);
		}

		public function updateGrid(width:uint, height:uint):void {
			this.graphics.clear();
			this.drawGround(width, height);
			if (this._enableGrid)
				this.drawGrid(-GRID_SPREAD, -GRID_SPREAD, width + GRID_SPREAD * 2, height + GRID_SPREAD * 2);
			if (this._enableBorderLine)
				this.drawBorderLine(width, height);
		}

		public function resetGrid():void {
			this.updateGrid(DEFAULT_DISPLAY_GRIDS, DEFAULT_DISPLAY_GRIDS);
		}

		protected function drawLineInGrid(x1:int, y1:int, x2:int, y2:int):void {
			this.graphics.moveTo(PosTransform.localPosToRealPos(x1), PosTransform.localPosToRealPos(y1));
			this.graphics.lineTo(PosTransform.localPosToRealPos(x2), PosTransform.localPosToRealPos(y2));
		}

		public function toggleFrameVisible():void {
			if (this._frame == null)
				return;
			_frame.visible = _frame.visible ? false : true;
		}

		protected function drawFrame(width:uint, height:uint):void {
			if (this._frame == null)
				return;
			for (var xi:uint = 0; xi < width; xi++) {
				for (var yi:uint = 0; yi < height; yi++) {
					if ((xi == 0 || xi == width - 1) || (yi == 0 || yi == height - 1)) {
						var block:BlockCommon = new Bedrock();
						block.x = GlobalGameVariables.DEFAULT_SIZE * xi;
						block.y = GlobalGameVariables.DEFAULT_SIZE * yi;
						_frame.addChild(block);
					}
				}
			}
		}

		protected function deleteFrame():void {
			if (this._frame == null)
				return;

			var child:DisplayObject;

			while (this._frame.numChildren > 0) {
				child = this._frame.getChildAt(0);

				if (child is BlockCommon) {
					(child as BlockCommon).deleteSelf();

				}
				this._frame.removeChild(child);

			}
		}
	}
}
