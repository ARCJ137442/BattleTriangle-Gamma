package batr.menu.objects.selecter 
{
	import batr.translations.*;
	import batr.game.stat.PlayerStats;
	
	public class BatrSelecterContext
	{
		//============Static Variables============//
		
		//============Static Functions============//
		public static function createPositiveIntagerContext(initValue:int):BatrSelecterContext
		{
			return new BatrSelecterContext().initAsInt(int.MAX_VALUE,1,initValue).autoInitLoopSelect();
		}
		
		public static function createUnsignedIntagerContext(initValue:int):BatrSelecterContext
		{
			return new BatrSelecterContext().initAsInt(int.MAX_VALUE,0,initValue).autoInitLoopSelect();
		}
		
		public static function createPositiveIntagerAndOneSpecialContext(initValue:int,tText:TranslationalText):BatrSelecterContext
		{
			return new BatrSelecterContext().initAsEnum(
							new <TranslationalText>[
								tText
							],0,0
						).initAsInt(
							int.MAX_VALUE,0,initValue
						).autoInitLoopSelect()
		}
		
		public static function createUnsignedIntagerAndOneSpecialContext(initValue:int,tText:TranslationalText):BatrSelecterContext
		{
			return new BatrSelecterContext().initAsEnum(
							new <TranslationalText>[
								tText
							],0,1
						).initAsInt(
							int.MAX_VALUE,-1,initValue
						).autoInitLoopSelect()
		}
		
		public static function createYorNContext(initValue:int,translations:Translations):BatrSelecterContext
		{
			return new BatrSelecterContext().initAsEnum(new <TranslationalText>[BatrSelecterContext.quickTranslationalTextBuild(TranslationKey.BOOLEAN_NO,translations),BatrSelecterContext.quickTranslationalTextBuild(TranslationKey.BOOLEAN_YES,translations)],0,0).initAsInt(1,0,initValue).autoInitLoopSelect();
		}
		
		public static function createBooleanContext(initValue:int,translations:Translations):BatrSelecterContext
		{
			return new BatrSelecterContext().initAsEnum(new <TranslationalText>[BatrSelecterContext.quickTranslationalTextBuild(TranslationKey.FALSE,translations),BatrSelecterContext.quickTranslationalTextBuild(TranslationKey.TRUE,translations)],0,0).initAsInt(1,0,initValue).autoInitLoopSelect();
		}
		
		public static function createLanguageContext(initValue:int):BatrSelecterContext
		{
			return new BatrSelecterContext().initAsEnum(
				TranslationalText.getTextsByLanguages(),0,0
			).initAsInt(
				Translations.numTranslations-1,0,initValue
			).autoInitLoopSelect();
		}
		
		public static function createPlayerNamesContext(playerStats:Vector.<PlayerStats>):BatrSelecterContext
		{
			var names:Vector.<TranslationalText>=ForcedTranslationalText.getTextsByPlayerNames(playerStats);
			return new BatrSelecterContext().initAsEnum(
				names,0,0
			).initAsInt(
				names.length-1,0,0
			).autoInitLoopSelect();
		}
		
		protected static function quickTranslationalTextBuild(key:String,translations:Translations):TranslationalText
		{
			return new TranslationalText(translations,key);
		}
		
		//============Instance Variables============//
		//====Total====//
		/**The _value is the "_intValue"&"_enumIndex"
		 * The enumText is force the intText
		 */
		protected var _value:int=0;
		protected var _enableLoopLeft:Boolean=false;
		protected var _enableLoopRight:Boolean=false;
		
		//====Int====//
		protected var _intMax:int=int.MAX_VALUE;
		protected var _intMin:int=int.MIN_VALUE;
		
		//====Enum====//
		protected var _enumTexts:Vector.<TranslationalText>;
		protected var _enumIndexOffect:int=0;//Let The Enum affects the negative value
		
		//============Constructor Function============//
		public function BatrSelecterContext():void
		{
			this._enumTexts=new Vector.<TranslationalText>();
		}
		
		public function copyFrom(other:BatrSelecterContext):void
		{
			//Total
			this._value=other._value;
			this._enableLoopLeft=other._enableLoopLeft;
			this._enableLoopRight=other._enableLoopRight;
			//Int
			this._intMax=other._intMax;
			this._intMin=other._intMin;
			//Enum
			this._enumTexts=other._enumTexts;
			this._enumIndexOffect=other._enumIndexOffect;
		}
		
		public function clone():BatrSelecterContext
		{
			var copy:BatrSelecterContext=new BatrSelecterContext();
			copy.copyFrom(this);
			return copy;
		}
		
		//============Destructor Function============//
		public function deleteSelf():void
		{
			this._enumTexts=null;
			this._value=this._intMax=this._intMin=0;
		}
		
		//============Instance Getter And Setter============//
		//====Total====//
		public function get enumIndexOffect():int
		{
			return this._enumIndexOffect;
		}
		
		public function set enumIndexOffect(value:int):void
		{
			this._enumIndexOffect=value;
		}
		
		public function get currentValue():int
		{
			return this._value;
		}
		
		public function set currentValue(value:int):void
		{
			if(this._value>int.MIN_VALUE&&this._value<int.MAX_VALUE)
			{
				if(value>this._intMax) value=this._enableLoopRight?this._intMin:this._intMax;
				else if(value<this._intMin) value=this._enableLoopLeft?this._intMax:this._intMin;
			}
			this._value=value;
		}
		
		public function get currentText():String
		{
			var t=this.enumText;
			return (t==null)?String(this.currentValue):t;
		}
		
		public function get enableLoopSelectLeft():Boolean
		{
			return this._enableLoopLeft;
		}
		
		public function set enableLoopSelectLeft(value:Boolean):void
		{
			this._enableLoopLeft=value;
		}
		
		public function get enableLoopSelectRight():Boolean
		{
			return this._enableLoopRight;
		}
		
		public function set enableLoopSelectRight(value:Boolean):void
		{
			this._enableLoopRight=value;
		}
		
		public function get enableLoopSelect():Boolean
		{
			return this._enableLoopLeft||this._enableLoopRight;
		}
		
		public function set enableLoopSelect(value:Boolean):void
		{
			this._enableLoopLeft=this._enableLoopRight=value;
		}
		
		//====Int====//
		public function get intMax():int
		{
			return this._intMax;
		}
		
		public function get intMin():int
		{
			return this._intMin;
		}
		
		public function set intMax(value:int):void
		{
			if(this._intMax>value)
			{
				this._intMax=value;
				this.updateValue();
				return;
			}
			this._intMax=value;
		}
		
		public function set intMin(value:int):void
		{
			if(this._intMin<value)
			{
				this._intMin=value;
				this.updateValue();
				return;
			}
			this._intMin=value;
		}
		
		//====Enum====//
		public function get enumIndex():int
		{
			return this._value+this._enumIndexOffect;
		}
		
		public function get enumText():String
		{
			return this.getEnumTextAt(this.enumIndex);
		}
		
		public function get enumTexts():Vector.<TranslationalText>
		{
			return this._enumTexts;
		}
		
		public function set enumTexts(value:Vector.<TranslationalText>):void
		{
			this._enumTexts=value;
		}
		
		public function get hasEnum():Boolean
		{
			return this.hasEnumTextAt(this.enumIndex);
		}
		
		//============Instance Functions============//
		//====Total====//
		//Limit between "min<value<max"
		public function updateValue():BatrSelecterContext
		{
			this._value=Math.min(Math.max(this._value,this._intMin),this._intMax);
			return this;
		}
		
		public function initLoopSelect(left:Boolean,right:Boolean):BatrSelecterContext
		{
			this._enableLoopLeft=left;
			this._enableLoopRight=right;
			return this;
		}
		
		public function autoInitLoopSelect():BatrSelecterContext
		{
			this._enableLoopLeft=this._intMax<int.MAX_VALUE;
			this._enableLoopRight=this._intMin>int.MIN_VALUE;
			return this;
		}
		
		//====Int====//
		public function initAsInt(max:int,min:int,value:int=0):BatrSelecterContext
		{
			this._intMax=max;
			this._intMin=min;
			this._value=value;
			return this;
		}
		
		//====Enum====//
		public function initAsEnum(texts:Vector.<TranslationalText>,index:int=0,offset:int=0):BatrSelecterContext
		{
			this._enumTexts=texts;
			this._value=index;
			this._enumIndexOffect=offset;
			return this;
		}
		
		public function hasEnumTextAt(index:int):Boolean
		{
			return !(this._enumTexts==null||
					 index<0||index>=this._enumTexts.length||
					 this._enumTexts[index]==null);
		}
		
		public function getEnumTextAt(index:int):String
		{
			if(!this.hasEnumTextAt(index)) return null;
			return this._enumTexts[index].currentText;
		}
		
		public function alignTranslationsFrom(translations:Translations):BatrSelecterContext
		{
			if(this._enumTexts!=null)
			{
				for each(var tText:TranslationalText in this._enumTexts)
				{
					tText.translations=translations;
				}
			}
			return this;
		}
		
		//====Debug====//
		public function toString():String
		{
			return "BatrSelecterContext["+this._value+"]{"+this._intMin+"~"+this._intMax+","+this._enumTexts+"/"+this._enumIndexOffect+"}"
		}
	}
}