package batr.menu.events {

	import batr.common.*;
	import batr.general.*;
	import batr.menu.main.*;
	import batr.menu.events.*;
	import batr.menu.objects.*;

	import flash.events.Event;

	public class MenuEvent extends Event {
		//============Static Variables============//
		public static const TITLE_SHOWEN:String = "MenuEvent:titleShowen";

		//============Instance Variables============//

		//============Constructor Function============//
		public function MenuEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false):void {
			super(type, bubbles, cancelable);
		}

		//============Instance Getter And Setter============//

		//============Instance Functions============//
		public override function clone():Event {
			return new MenuEvent(type, bubbles, cancelable);
		}

		public override function toString():String {
			return formatToString("MenuEvent", "type", "bubbles", "cancelable", "eventPhase");
		}
	}
}