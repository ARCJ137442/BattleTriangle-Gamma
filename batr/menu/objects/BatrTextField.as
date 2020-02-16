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
		//============Static Variables============//
		
		//============Instance Variables============//
		protected var _translations:Translations;
		protected var _translationKey:String;
		protected var _lockSize:Boolean=false;
		
		//============Constructor Function============//
		public function BatrTextField(text:String,translations:Translations,translationKey:String=null):void
		{
			super();
			this._translations=translations==null?Translations.getTranslationByLanguage():translations;
			this.textInTranslation=translationKey;
			this.defaultTextFormat=Menu.TEXT_FORMAT;
			this.setTextFormat(Menu.TEXT_FORMAT);
		}
		
		//============Destructor Function============//
		public function deleteSelf():void
		{
			
		}
		
		//============Instance Getter And Setter============//
		public function get translations():Translations
		{
			return this._translations;
		}
		
		public function get translationKey():String
		{
			return this._translationKey;
		}
		
		public function get textInTranslation():String
		{
			return this._translations.getTranslation(this._translationKey);
		}
		
		public function set textInTranslation(value:String):void
		{
			this._translationKey=value;
			this.updateByTranslation();
		}
		
		public function get lockSize():Boolean
		{
			return this._lockSize;
		}
		
		public function set lockSize(value:Boolean):void
		{
			this._lockSize=value;
		}
		
		//============Instance Functions============//
		public function trunTranslationsTo(translations:Translations):void
		{
			this._translations=translations;
			this.updateByTranslation();
		}
		
		public function updateByTranslation():void
		{
			if(this._translations!=null) this.text=this._translations.getTranslation(this._translationKey);
			this.fitByText();
		}
		
		public function setText(value:String,autoFit:Boolean=true):void
		{
			this.text=value;
			if(autoFit) this.fitByText();
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
		
		public function initFormetAsMenu(autoFit:Boolean=true):BatrTextField
		{
			this.selectable=false;
			if(autoFit) this.fitByText();
			return this;
		}
		
		public function fitByText():void
		{
			if(this.lockSize) return;
			this.width=this.textWidth+GlobalGameVariables.DEFAULT_SIZE/10;
			this.height=this.textHeight+GlobalGameVariables.DEFAULT_SIZE/20;
		}
		
		public function setFormet(formet:TextFormat,lock:Boolean=false):BatrTextField
		{
			this.defaultTextFormat=formet;
			this.setTextFormat(formet);
			this.lockSize=lock;
			return this;
		}
		
		//============Deal With Event============//
		public function onTranslationChange(E:TranslationsChangeEvent):void
		{
			this.trunTranslationsTo(E.nowTranslations);
		}
	}
}