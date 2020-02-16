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
	import batr.translations.*;
	
	import flash.text.*;
	import flash.display.*;
	import flash.events.MouseEvent;
	
	public class BatrButton extends BatrMenuGUI implements IBatrMenuElement
	{
		//============Static Variables============//
		public static const LINE_COLOR:uint=0x888888
		public static const FILL_COLOR:uint=0xcccccc
		public static const FILL_ALPHA:Number=0.5
		public static const LINE_SIZE:Number=GlobalGameVariables.DEFAULT_SIZE/16
		public static const HOLD_ALPHA:Number=1
		public static const OVER_ALPHA:Number=0.75
		public static const RELEASE_ALPHA:Number=0.5
		
		//============Instance Variables============//
		protected var _displayWidth:Number
		protected var _displayHeight:Number
		protected var _lineColor:uint
		protected var _fillColor:uint
		protected var _lineSize:Number
		protected var _smoothLine:Boolean
		
		protected var _translations:Translations
		protected var _text:BatrTextField
		
		//============Constructor Function============//
		public function BatrButton(width:Number,height:Number,
								   translations:Translations,
								   translationKey:String="",
								   smoothLine:Boolean=true,
								   lineColor:uint=LINE_COLOR,
								   fillColor:uint=FILL_COLOR,
								   lineSize:Number=LINE_SIZE):void
		{
			super();
			this._displayWidth=width;
			this._displayHeight=height;
			this._lineColor=lineColor;
			this._fillColor=fillColor;
			this._lineSize=lineSize;
			this._smoothLine=smoothLine;
			this._translations=translations;
			this._text=new BatrTextField("",this._translations,translationKey);
			this.initDisplay();
			this.drawShape();
			this.buttonMode=true;
			this.tabEnabled=true;
			this.onMouseRollOut(null);
		}
		
		//============Destructor Function============//
		public override function deleteSelf():void
		{
			this.graphics.clear();
			this._text.deleteSelf();
			this._text=null;
			super.deleteSelf();
		}
		
		//============Instance Getter And Setter============//
		public function get displayWidth():Number
		{
			return this._displayWidth;
		}
		
		public function set displayWidth(value:Number):void
		{
			if(this._displayWidth==value) return;
			this._displayWidth=value;
			drawShape();
		}
		
		public function get displayHeight():Number
		{
			return this._displayHeight;
		}
		
		public function set displayHeight(value:Number):void
		{
			if(this._displayHeight==value) return;
			this._displayHeight=value;
			drawShape();
		}
		
		public function get lineColor():uint 
		{
			return this._lineColor;
		}
		
		public function set lineColor(value:uint):void 
		{
			if(this._lineColor==value) return;
			this._lineColor=value;
			drawShape();
		}
		
		public function get fillColor():uint 
		{
			return this._fillColor;
		}
		
		public function set fillColor(value:uint):void 
		{
			if(this._fillColor==value) return;
			this._fillColor=value;
			drawShape();
		}
		
		public function get lineSize():Number 
		{
			return this._fillColor;
		}
		
		public function set lineSize(value:Number):void 
		{
			if(this.lineSize==value) return;
			this._lineSize=value;
			drawShape();
		}
		
		public function get smoothLine():Boolean
		{
			return this._smoothLine;
		}
		
		public function set smoothLine(value:Boolean):void
		{
			if(this._smoothLine==value) return;
			this._smoothLine=value;
			drawShape();
		}
		
		//============Instance Functions============//
		public function setPos(x:Number, y:Number):BatrButton 
		{
			super.protected::sP(x,y);
			return this;
		}
		
		public function setBlockPos(x:Number, y:Number):BatrButton 
		{
			super.protected::sBP(x,y);
			return this;
		}
		
		protected function initDisplay():void
		{
			this._text.x=this._text.y=0;
			this._text.width=this._displayWidth;
			this._text.height=this._displayHeight;
			this._text.selectable=false;
			this._text.setTextFormat(Menu.TEXT_FORMAT);
			this.addChild(this._text);
		}
		
		protected override function drawShape():void
		{
			super.drawShape();
			//Draw
			if(this._smoothLine)
			{
				this.graphics.lineStyle(this._lineSize,this._lineColor);
				this.graphics.beginFill(this._fillColor,FILL_ALPHA);
				this.graphics.drawRect(0,0,this._displayWidth,this._displayHeight);
			}
			else
			{
				this.graphics.beginFill(this._lineColor);
				this.graphics.drawRect(0,0,this._displayWidth,this._displayHeight);
				this.graphics.endFill();
				this.graphics.beginFill(this._fillColor,FILL_ALPHA);
				this.graphics.drawRect(this._lineSize,this._lineSize,this._displayWidth-this._lineSize*2,this._displayHeight-this._lineSize*2);
			}
			this.graphics.endFill();
		}
		
		protected override function onMouseRollOver(event:MouseEvent):void
		{
			super.onMouseRollOver(event);
			this.alpha=OVER_ALPHA;
		}
		
		protected override function onMouseRollOut(event:MouseEvent):void
		{
			super.onMouseRollOut(event);
			this.alpha=RELEASE_ALPHA;
		}
		
		protected override function onMouseHold(event:MouseEvent):void
		{
			super.onMouseHold(event);
			this.alpha=HOLD_ALPHA;
		}
		
		protected override function onMouseRelease(event:MouseEvent):void
		{
			super.onMouseRelease(event);
			this.alpha=RELEASE_ALPHA;
		}
		
		public function onTranslationsChange(E:TranslationsChangeEvent):void
		{
			this.trunTranslationsTo(E.nowTranslations);
		}
		
		protected function trunTranslationsTo(translations:Translations):void
		{
			this._translations=translations;
			this._text.trunTranslationsTo(translations);
			this._text.width=this._displayWidth;
			this._text.height=this._displayHeight;
		}
	}
}