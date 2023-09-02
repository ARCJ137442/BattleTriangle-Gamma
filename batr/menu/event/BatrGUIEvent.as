package batr.menu.event {

	import batr.menu.objects.*;

	import flash.events.Event;

	public class BatrGUIEvent extends Event {
		//============Static Variables============//
		public static const CLICK:String = "BatrButtonEvent:click";
		public static const CLICK_LEFT:String = "BatrButtonEvent:left_click";
		public static const CLICK_RIGHT:String = "BatrButtonEvent:right_click";

		//============Instance Variables============//
		protected var _gui:BatrMenuGUI;

		//============Constructor Function============//
		public function BatrGUIEvent(type:String, gui:BatrMenuGUI, bubbles:Boolean = false, cancelable:Boolean = false):void {
			super(type, bubbles, cancelable);
			this._gui = gui;
		}

		//============Instance Getter And Setter============//
		public function get gui():BatrMenuGUI {
			return this._gui;
		}

		//============Instance Functions============//
		public override function clone():Event {
			return new BatrGUIEvent(this.type, this._gui, this.bubbles, this.cancelable);
			;
		}

		public override function toString():String {
			return formatToString("BatrButtonEvent", "type", "gui", "bubbles", "cancelable", "eventPhase");
		}
	}
}
