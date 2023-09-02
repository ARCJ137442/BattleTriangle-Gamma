package batr.game.entity.ai {

	import batr.common.*;
	import batr.general.*;

	public final class AIPlayerAction {
		//============Static Variables============//
		public static const NULL:AIPlayerAction = null;

		public static const MOVE_UP:AIPlayerAction = new AIPlayerAction("moveUp");
		public static const MOVE_DOWN:AIPlayerAction = new AIPlayerAction("moveDown");
		public static const MOVE_LEFT_ABS:AIPlayerAction = new AIPlayerAction("moveLeftAbs");
		public static const MOVE_RIGHT_ABS:AIPlayerAction = new AIPlayerAction("moveRightAbs");
		public static const MOVE_FORWARD:AIPlayerAction = new AIPlayerAction("moveForward");
		public static const MOVE_BACK:AIPlayerAction = new AIPlayerAction("moveBack");
		public static const MOVE_LEFT_REL:AIPlayerAction = new AIPlayerAction("moveLeftRel");
		public static const MOVE_RIGHT_REL:AIPlayerAction = new AIPlayerAction("moveRightRel");
		public static const TRUN_UP:AIPlayerAction = new AIPlayerAction("turnUp");
		public static const TRUN_DOWN:AIPlayerAction = new AIPlayerAction("turnDown");
		public static const TRUN_LEFT_ABS:AIPlayerAction = new AIPlayerAction("turnLeftAbs");
		public static const TRUN_RIGHT_ABS:AIPlayerAction = new AIPlayerAction("turnRightAbs");
		public static const TRUN_BACK:AIPlayerAction = new AIPlayerAction("turnBack");
		public static const TRUN_LEFT_REL:AIPlayerAction = new AIPlayerAction("turnLeftRel");
		public static const TRUN_RIGHT_REL:AIPlayerAction = new AIPlayerAction("turnRightRel");
		public static const USE_WEAPON:AIPlayerAction = new AIPlayerAction("useWeapon");
		public static const PRESS_KEY_UP:AIPlayerAction = new AIPlayerAction("pressKeyUp");
		public static const PRESS_KEY_DOWN:AIPlayerAction = new AIPlayerAction("pressKeyDown");
		public static const PRESS_KEY_LEFT:AIPlayerAction = new AIPlayerAction("pressKeyLeft");
		public static const PRESS_KEY_RIGHT:AIPlayerAction = new AIPlayerAction("pressKeyRight");
		public static const PRESS_KEY_USE:AIPlayerAction = new AIPlayerAction("pressKeyUse");
		public static const RELEASE_KEY_UP:AIPlayerAction = new AIPlayerAction("releaseKeyUp");
		public static const RELEASE_KEY_DOWN:AIPlayerAction = new AIPlayerAction("releaseKeyDown");
		public static const RELEASE_KEY_LEFT:AIPlayerAction = new AIPlayerAction("releaseKeyLeft");
		public static const RELEASE_KEY_RIGHT:AIPlayerAction = new AIPlayerAction("releaseKeyRight");
		public static const RELEASE_KEY_USE:AIPlayerAction = new AIPlayerAction("releaseKeyUse");
		public static const DISABLE_CHARGE:AIPlayerAction = new AIPlayerAction("disableCharge");

		public static const _ALL_ACTIONS:Vector.<AIPlayerAction> = new <AIPlayerAction>[
				AIPlayerAction.MOVE_UP,
				AIPlayerAction.MOVE_DOWN,
				AIPlayerAction.MOVE_LEFT_ABS,
				AIPlayerAction.MOVE_RIGHT_ABS,
				AIPlayerAction.MOVE_FORWARD,
				AIPlayerAction.MOVE_BACK,
				AIPlayerAction.MOVE_LEFT_REL,
				AIPlayerAction.MOVE_RIGHT_REL,
				AIPlayerAction.TRUN_UP,
				AIPlayerAction.TRUN_DOWN,
				AIPlayerAction.TRUN_LEFT_ABS,
				AIPlayerAction.TRUN_RIGHT_ABS,
				AIPlayerAction.TRUN_BACK,
				AIPlayerAction.TRUN_LEFT_REL,
				AIPlayerAction.TRUN_RIGHT_REL,
				AIPlayerAction.USE_WEAPON,
				AIPlayerAction.PRESS_KEY_UP,
				AIPlayerAction.PRESS_KEY_DOWN,
				AIPlayerAction.PRESS_KEY_LEFT,
				AIPlayerAction.PRESS_KEY_RIGHT,
				AIPlayerAction.PRESS_KEY_USE,
				AIPlayerAction.RELEASE_KEY_UP,
				AIPlayerAction.RELEASE_KEY_DOWN,
				AIPlayerAction.RELEASE_KEY_LEFT,
				AIPlayerAction.RELEASE_KEY_RIGHT,
				AIPlayerAction.RELEASE_KEY_USE,
				AIPlayerAction.DISABLE_CHARGE
			];
		//============Static Functions============//
		public static function fromString(str:String):AIPlayerAction {
			for each (var action:AIPlayerAction in AIPlayerAction._ALL_ACTIONS) {
				if (action.name == str)
					return action;
			}
			return AIPlayerAction.NULL;
		}

		public static function getMoveActionFromEntityRot(rot:uint):AIPlayerAction {
			switch (rot) {
				case GlobalRot.UP:
					return AIPlayerAction.MOVE_UP;
				case GlobalRot.DOWN:
					return AIPlayerAction.MOVE_DOWN;
				case GlobalRot.LEFT:
					return AIPlayerAction.MOVE_LEFT_ABS;
				case GlobalRot.RIGHT:
					return AIPlayerAction.MOVE_RIGHT_ABS;
				default:
					return AIPlayerAction.NULL;
			}
		}

		public static function getTrunActionFromEntityRot(rot:uint):AIPlayerAction {
			switch (rot) {
				case GlobalRot.UP:
					return AIPlayerAction.TRUN_UP;
				case GlobalRot.DOWN:
					return AIPlayerAction.TRUN_DOWN;
				case GlobalRot.LEFT:
					return AIPlayerAction.TRUN_LEFT_ABS;
				case GlobalRot.RIGHT:
					return AIPlayerAction.TRUN_RIGHT_ABS;
				default:
					return AIPlayerAction.NULL;
			}
		}

		public static function get RANDOM():AIPlayerAction {
			return _ALL_ACTIONS[exMath.random(_ALL_ACTIONS.length)];
		}

		//============Instance Variables============//
		protected var _name:String;

		//============Constructor Function============//
		public function AIPlayerAction(name:String):void {
			this._name = name;
		}

		//============Instance Getter And Setter============//
		public function get name():String {
			return this._name;
		}

		//============Instance Functions============//
		public function toString():String {
			return "AIPlayerAction/" + this.name;
		}
	}
}