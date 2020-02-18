package batr.menu.events 
{
	import batr.common.*;
	import batr.general.*;
	import batr.menu.main.*;
	import batr.menu.events.*;
	import batr.menu.objects.*;
	import batr.translations.*;
	
	import flash.events.Event;
	
	public class TranslationsChangeEvent extends Event
	{
		//============Static Variables============//
		public static const TYPE:String="TranslationsChangeEvent";
		
		//============Instance Variables============//
		protected var _nowTranslations:Translations;
		protected var _oldTranslations:Translations;
		
		//============Constructor Function============//
		public function TranslationsChangeEvent(nowTranslations:Translations,oldTranslations:Translations=null,bubbles:Boolean=false,cancelable:Boolean=false):void
		{
			super(TranslationsChangeEvent.TYPE,bubbles,cancelable);
			this._nowTranslations=nowTranslations;
			this._oldTranslations=oldTranslations;
		}
		
		//============Instance Getter And Setter============//
		public function get nowTranslations():Translations
		{
			return this._nowTranslations;
		}
		
		public function get oldTranslations():Translations
		{
			return this._oldTranslations;
		}
		
		//============Instance Functions============//
		public override function clone():Event
		{
			return new TranslationsChangeEvent(this._nowTranslations,this._oldTranslations,this.bubbles,this.cancelable);;
		}
		
		public override function toString():String
		{
			return formatToString("TranslationChangeEvent","type","gui","bubbles","cancelable","eventPhase");
		}
	}
}