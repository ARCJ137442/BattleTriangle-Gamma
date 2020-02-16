package batr.translations 
{
	import flash.system.Capabilities;
	
	public class Translations
	{
		//============Static Variables============//
		//Translations
		protected static var EN_US:Translations
		protected static var ZH_CN:Translations
		protected static var _translationsList:Vector.<Translations>;
		
		//Class Init
		protected static var isInited:Boolean=false
		
		//============Static Getter And Setter============//
		public static function get translationsList():Vector.<Translations>
		{
			return Translations._translationsList;
		}
		
		public static function get numTranslations():int
		{
			return Translations._translationsList.length;
		}
		
		//============Static Functions============//
		public static function getTranslationByLanguage():Translations
		{
			if(!isInited) cInit()
			switch(Capabilities.language)
			{
				case "en":
					return EN_US
				case "zh-CN":
					return ZH_CN
				default:
					return null
			}
		}
		
		//"index:text,index2:text2,index3:text3..."
		public static function fromString(str:String):Translations
		{
			return Translations.fromStringArr(str.split(","))
		}
		
		//["index:text","index2:text2","index3:text3"...]
		public static function fromStringArr(str:Array):Translations
		{
			if(!isInited) cInit()
			var returnT:Translations=new Translations()
			if(str.length<1||str==null) return returnT
			var str1:Array,k:String,v:String
			for each(var value in str)
			{
				str1=String(value).split(":")
				k=str1[0]
				v=str1[1]
				returnT.setTranslation(k,v)
			}
			return returnT
		}
		
		public static function getTranslation(translation:Translations,key:String):String
		{
			return translation==null?null:translation.getTranslation(key);
		}
		
		//"index:text","index2:text2","index3:text3","..."
		public static function fromStringArr2(...str):Translations
		{
			return Translations.fromStringArr(str)
		}
		
		public static function getIDFromTranslation(translations:Translations):int
		{
			return Translations._translationsList.indexOf(translations);
		}
		
		public static function getTranslationFromID(index:int):Translations
		{
			return Translations._translationsList[index];
		}
		
		//====Init Translations====//
		protected static function cInit():Boolean 
		{
			isInited=true;
			EN_US=DefaultNativeTranslations.EN_US;
			ZH_CN=DefaultNativeTranslations.ZH_CN;
			//trace(ZH_CN.translationKeys.toString()+"\n"+ZH_CN.translationValues.toString())
			_translationsList=new <Translations>[Translations.EN_US,Translations.ZH_CN];
			return true;
		}
		
		//============Instance Variables============//
		protected var _dictionary:Object=new Object()
		protected var _enabledToWrite:Boolean=true
		protected var _getFunction:Function
		protected var _setFunction:Function
		
		//============Constructor Function============//
		//"index","text","index2","text2","index3","text3","..."
		public function Translations(...translations):void
		{
			if(!isInited) cInit();
			this._getFunction=this.defaultGet;
			this._setFunction=this.defaultSet;
			for(var i:uint=0;i+1<translations.length;i+=2)
			{
				this.setTranslation(translations[i],translations[i+1]);
			}
		}
		
		//============Instance Getter And Setter============//
		public function get enableToWrite():Boolean
		{
			return this._enabledToWrite
		}
		
		public function get translationKeys():Vector.<String>
		{
			var rV:Vector.<String>=new Vector.<String>()
			for(var index in this._dictionary)
			{
				rV.push(String(index))
			}
			return rV
		}
		
		public function get translationValues():Vector.<String>
		{
			var rV:Vector.<String>=new Vector.<String>()
			for each(var value in this._dictionary)
			{
				rV.push(String(value))
			}
			return rV
		}
		
		//============Instance Functions============//
		public function getTranslation(key:String):String
		{
			return this._getFunction(key);
		}
		
		public function setTranslation(key:String,value:String):void
		{
			this._setFunction(key,value);
		}
		
		protected function defaultGet(key:String):String
		{
			var value:String=String(this._dictionary[key]);
			if(value=="undefined"||value=="null"||value=="") return DefaultNativeTranslations.getDefaultTranslation(key);
			return value;
		}
		
		protected function defaultSet(key:String,value:String):void
		{
			if(this._enabledToWrite) this._dictionary[key]=value;
		}
		
		public function lock():void
		{
			this._enabledToWrite=false;
		}
		
		public function clear():void
		{
			if(this._enabledToWrite) this._dictionary=new Object();
		}
		
		public function toString():String
		{
			var rS:String=""
			for(var index in this._dictionary)
			{
				rS+=String(index)+":"+String(this._dictionary[index])+";";
			}
			return rS
		}
	}
}
