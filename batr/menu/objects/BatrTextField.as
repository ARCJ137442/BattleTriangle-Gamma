package batr.menu.objects
{
	import batr.common.*;
	import batr.general.*;
	
	import batr.menu.main.*;
	import batr.menu.events.*;
	import batr.menu.objects.*;
	import batr.menu.objects.selecter.*;
	
	import batr.main.*;
	import batr.fonts.*;
	import batr.translations.*
	
	import flash.text.*;
	
	public class BatrTextField extends TextField implements IBatrMenuElement
	{
		//============Static Constructor============//
		public static function fromKey(translations:Translations,translationKey:String=null,autoSize:String=TextFieldAutoSize.LEFT):BatrTextField
		{
			return new BatrTextField(new TranslationalText(
				translations==null?Translations.getTranslationByLanguage():translations,
				translationKey
			),autoSize);
		}
		
		//============Static Variables============//
		
		//============Instance Variables============//
		protected var _translationalText:TranslationalText
		
		//============Constructor============//
		public function BatrTextField(translationalText:TranslationalText,autoSize:String=TextFieldAutoSize.LEFT):void
		{
			super();
			//text
			this._translationalText=translationalText;
			this.updateByTranslation();
			//form
			this.defaultTextFormat=Menu.TEXT_FORMAT;
			this.setTextFormat(Menu.TEXT_FORMAT);
			this.autoSize=autoSize;
		}
		
		//============Destructor Function============//
		public function deleteSelf():void
		{
			this._translationalText=null;
		}
		
		//============Instance Getter And Setter============//
		public function get translationalText():TranslationalText
		{
			return this._translationalText;
		}
		
		public function set translationalText(value:TranslationalText):void
		{
			this._translationalText=value;
			this.updateByTranslation();
		}
		
		public function get translations():Translations
		{
			return this._translationalText.translations;
		}
		
		public function get translationKey():String
		{
			return this._translationalText.key;
		}
		
		public function get textInTranslation():String
		{
			return this._translationalText.currentText;
		}
		
		//============Instance Functions============//
		public function turnTranslationsTo(translations:Translations):void
		{
			this._translationalText.translations=translations;
			this.updateByTranslation();
		}
		
		public function updateByTranslation():void
		{
			this.text=this.textInTranslation;
		}
		
		public function setText(value:String):void
		{
			this.text=value;
		}
		
		public function setPos(x:Number,y:Number):BatrTextField
		{
			this.x=x;
			this.y=y;
			return this;
		}
		
		public function setBlockPos(x:Number,y:Number):BatrTextField
		{
			this.x=PosTransform.localPosToRealPos(x);
			this.y=PosTransform.localPosToRealPos(y);
			return this;
		}
		
		public function setSize(w:Number,h:Number):BatrTextField
		{
			this.width=w;
			this.height=h;
			return this;
		}
		
		public function setBlockSize(w:Number,h:Number):BatrTextField
		{
			this.width=PosTransform.localPosToRealPos(w);
			this.height=PosTransform.localPosToRealPos(h);
			return this;
		}
		
		public function initFormetAsMenu():BatrTextField
		{
			this.selectable=false;
			return this;
		}
		
		public function setFormet(formet:TextFormat,lock:Boolean=false):BatrTextField
		{
			this.defaultTextFormat=formet;
			this.setTextFormat(formet);
			return this;
		}
		
		//============Deal With Event============//
		public function onTranslationChange(E:TranslationsChangeEvent):void
		{
			this.turnTranslationsTo(E.nowTranslations);
		}
	}
}