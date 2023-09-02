package batr.menu.objects {

	import batr.common.*;
	import batr.game.main.*;
	import batr.general.*;
	import batr.menu.events.*;
	import batr.menu.objects.*;
	import batr.main.*;
	import batr.translations.*;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.utils.Timer;

	public class BatrMenuSheet extends BatrMenuGUI implements IBatrMenuElementContainer {
		//============Static Variables============//

		//============Instance Variables============//
		protected var _directElements:Vector.<IBatrMenuElement>;
		protected var _keepTitle:Boolean;

		//============Constructor Function============//
		public function BatrMenuSheet(keepTitle:Boolean = true):void {
			super(false);
			this._keepTitle = keepTitle;
			this._directElements = new Vector.<IBatrMenuElement>();
		}

		//============Destructor Function============//
		public override function deleteSelf():void {
			for each (var element:IBatrMenuElement in this._directElements) {
				element.deleteSelf();
			}
		}

		//============Instance Getter And Setter============//
		public function get keepTitle():Boolean {
			return this._keepTitle;
		}

		public function get directElements():Vector.<IBatrMenuElement> {
			return this._directElements;
		}

		public function get directElementCount():int {
			return this._directElements.length;
		}

		//============Instance Functions============//
		public function setPos(x:Number, y:Number):BatrMenuSheet {
			super.protected::sP(x, y);
			return this;
		}

		public function setBlockPos(x:Number, y:Number):BatrMenuSheet {
			super.protected::sBP(x, y);
			return this;
		}

		/**
		 * Clear the graphics and draw the background of the specified color.
		 * @param	color	The color.
		 * @param	alpha	The alpha.
		 * @return	this
		 */
		public function setMaskColor(color:uint, alpha:Number = 1):BatrMenuSheet {
			with (this.graphics) {
				clear();
				beginFill(color, alpha);
				drawRect(0, 0, GlobalGameVariables.DEFAULT_SIZE * GlobalGameVariables.DISPLAY_GRIDS, GlobalGameVariables.DEFAULT_SIZE * GlobalGameVariables.DISPLAY_GRIDS);
				endFill();
			}
			return this;
		}

		//========By IBatrMenuElementContainer========//
		public function appendDirectElement(element:IBatrMenuElement):IBatrMenuElement {
			if (element == null)
				return this;
			this._directElements.push(element);
			return this;
		}

		public function appendDirectElements(...elements):IBatrMenuElement {
			var element:IBatrMenuElement;
			for (var i:int = 0; i < elements.length; i++) {
				element = elements[i] as IBatrMenuElement;
				if (element != null)
					this._directElements.push(element);
			}
			return this;
		}

		public function addChildPerDirectElements():void {
			for each (var element:IBatrMenuElement in this._directElements) {
				if (element == null)
					continue;
				if (element is IBatrMenuElementContainer)
					(element as IBatrMenuElementContainer).addChildPerDirectElements();
				if (element is DisplayObject)
					this.addChild(element as DisplayObject);
			}
		}

		public function getElementAt(index:int):IBatrMenuElement {
			return (index < 1 || index >= this.directElementCount) ? null : this._directElements[index];
		}

		public function getElementByName(name:String):BatrMenuGUI {
			for each (var element:IBatrMenuElement in this._directElements) {
				if (element != null &&
						element is BatrMenuGUI &&
						(element as DisplayObject).name == name)
					return (element as BatrMenuGUI);
			}
			return null;
		}
	}
}