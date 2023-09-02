package batr.game.effect {

	import batr.common.*;

	import batr.game.effect.*;
	import batr.game.main.*;

	import flash.utils.Dictionary;

	/**
	 * Use for manage effects in game.
	 */
	public class EffectSystem {
		//============Static Variables============//

		//============Static Functions============//

		//============Instance Variables============//
		protected var _host:Game;

		// UUID

		/**
		 * The UUID Process to system.
		 * getEffectByUUID(this._headUUID) usual equals null.
		 */
		private var _headUUID:uint = 1;
		private var _uuidDic:Dictionary = new Dictionary(true);

		protected var _effects:Vector.<EffectCommon> = new Vector.<EffectCommon>;

		//============Constructor Function============//
		public function EffectSystem(host:Game):void {
			this._host = host;
		}

		//============Destructor Function============//
		public function deleteSelf():void {
			this.removeAllEffect();
			this._effects = null;

			this._host = null;

		}

		//============Instance Getters And Setters============//
		public function get host():Game {
			return this._host;
		}

		public function get effects():Vector.<EffectCommon> {
			return this._effects;
		}

		public function get effectCount():uint {
			if (this._effects == null)
				return 0;
			return this._effects.length;
		}

		//============Instance Functions============//
		public function nextUUID():uint {
			while (getEffectByUUID(++this._headUUID) == null && isValidUUID(this._headUUID)) {
				return this._headUUID;
			}
			return 0;
		}

		public function getEffectByUUID(uuid:uint):EffectCommon {
			return (this._uuidDic[uuid] as EffectCommon);
		}

		public function getUUIDByEffect(effect:EffectCommon):uint {
			return uint(this._uuidDic[effect]);
		}

		/**
		 * Use for loop to register UUID for effect.
		 * @param	uuid	needed UUID
		 * @return	if uuid!=0
		 */
		public function isValidUUID(uuid:uint):Boolean {
			return uuid > 0;
		}

		public function hasValidEffect(uuid:uint):Boolean {
			return this.isValidUUID(uuid) && this.getEffectByUUID(uuid) != null;
		}

		public function hasValidUUID(effect:EffectCommon):Boolean {
			return effect != null && this.isValidUUID(this.getUUIDByEffect(effect));
		}

		public function getAllEffect():Vector.<EffectCommon> {
			var result:Vector.<EffectCommon> = new Vector.<EffectCommon>();
			for each (var obj:Object in this._uuidDic) {
				if (obj != null && obj is EffectCommon)
					result.push(obj as EffectCommon);
			}
			return result;
		}

		public function getAllUUID():Vector.<uint> {
			var result:Vector.<uint> = new Vector.<uint>();
			for each (var obj:Object in this._uuidDic) {
				if (obj != null && obj is uint && isValidUUID(obj as uint))
					result.push(obj as uint);
			}
			return result;
		}

		public function registerEffectforUUID(effect:EffectCommon):Boolean {
			if (effect == null)
				return false;
			var uuid:uint = this.nextUUID();
			if (this.isValidUUID(uuid)) {
				this._uuidDic[effect] = uuid;
				this._uuidDic[uuid] = effect;
				return true;
			}
			return false;
		}

		public function cencellEffectforUUID(effect:EffectCommon):Boolean {
			var uuid:uint = this.getUUIDByEffect(effect);
			if (this.isValidUUID(uuid)) {
				this._uuidDic[effect] = 0;
				this._uuidDic[uuid] = null;
				return true;
			}
			return false;
		}

		public function GC():void {
			if (this._effects == null)
				return;
			// Effect
			while (this._effects.indexOf(null) >= 0) {
				this._effects.splice(this._effects.indexOf(null), 1);
			}
		}

		// Register,Cencell and Remove
		public function isRegisteredEffect(effect:EffectCommon):Boolean {
			// List
			/*return this._effects.some(
			function(e2:EffectCommon,i:uint,v:Vector.<EffectCommon>) {
				return e2==effect
			})*/
			// UUIDMap
			return this.hasValidUUID(effect);

		}

		public function registerEffect(effect:EffectCommon):Boolean {
			if (effect == null || isRegisteredEffect(effect))
				return false;
			// List
			this._effects.push(effect);

			// UUIDMap
			if (!this.hasValidUUID(effect))
				this.registerEffectforUUID(effect);
			return true;

		}

		public function cencellEffect(effect:EffectCommon):Boolean {
			if (effect == null || !isRegisteredEffect(effect))
				return false;
			// List
			this._effects.splice(this._effects.indexOf(effect), 1);
			// UUIDMap
			if (this.hasValidUUID(effect))
				this.cencellEffectforUUID(effect);
			return true;

		}

		public function addEffect(effect:EffectCommon):void {
			this.registerEffect(effect);

			this._host.addEffectChild(effect);

		}

		public function removeEffect(effect:EffectCommon):void {
			if (effect == null)
				return;

			effect.deleteSelf();

			cencellEffect(effect);

			UsefulTools.removeChildIfContains(this._host.effectContainerBottom, effect);

			UsefulTools.removeChildIfContains(this._host.effectContainerTop, effect);

		}

		public function removeAllEffect():void {
			while (this._effects.length > 0) {
				this.removeEffect(this._effects[0]);

			}
		}
	}
}