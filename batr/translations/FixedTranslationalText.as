package batr.translations {

	/**
	 * ...
	 * @author ARCJ137442
	 */
	public class FixedTranslationalText extends TranslationalText {
		//============Instance Variables============//
		protected var _prefix:String;
		protected var _suffix:String;

		//============Constructor Function============//
		public function FixedTranslationalText(translations:Translations, key:String = null, prefix:String = "", suffix:String = "") {
			super(translations, key);
			this._prefix = prefix;
			this._suffix = suffix;
		}

		override public function clone():TranslationalText {
			return new FixedTranslationalText(this._translations, this._key, this._prefix, this._suffix);
		}

		//============Destructor Function============//
		override public function deleteSelf():void {
			this._prefix = this._suffix = null;
			super.deleteSelf();
		}

		//============Instance Getter And Setter============//
		public function get prefix():String {
			return this._prefix;
		}

		public function set prefix(value:String):void {
			this._prefix = value;
		}

		public function get suffix():String {
			return this._suffix;
		}

		public function set suffix(value:String):void {
			this._suffix = value;
		}

		public override function get currentText():String {
			return this._prefix + super.currentText + this._suffix;
		}
	}
}