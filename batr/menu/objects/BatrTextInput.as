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
	
	public class BatrTextInput extends TextField implements IBatrMenuElement
	{
		//============Static Constructor============//
		
		//============Static Variables============//
		
		//============Instance Variables============//
		
		//============Constructor============//
		public function BatrTextInput(initialText:String="",autoSize:String=TextFieldAutoSize.LEFT):void
		{
			super();
			//text
			this.selectable=true;
			this.text=initialText;
			this.type=TextFieldType.INPUT;
			this.border=true;
			// this.multiline=true;
			this.mouseWheelEnabled = true; // avaliable when limited height
			// this.wordWrap = true; //auto newline

			//form
			this.defaultTextFormat=Menu.INPUT_FORMAT;
			this.setTextFormat(Menu.INPUT_FORMAT);
			this.autoSize=autoSize;
		}
		
		//============Destructor Function============//
		public function deleteSelf():void
		{
			
		}
		
		//============Instance Getter And Setter============//
		
		//============Instance Functions============//
		
		public function setText(value:String):void
		{
			this.text=value;
		}
		
		public function setPos(x:Number,y:Number):BatrTextInput
		{
			this.x=x;
			this.y=y;
			return this;
		}
		
		public function setBlockPos(x:Number,y:Number):BatrTextInput
		{
			this.x=PosTransform.localPosToRealPos(x);
			this.y=PosTransform.localPosToRealPos(y);
			return this;
		}
		
		public function setSize(w:Number,h:Number):BatrTextInput
		{
			this.width=w;
			this.height=h;
			return this;
		}
		
		public function setBlockSize(w:Number,h:Number):BatrTextInput
		{
			this.width=PosTransform.localPosToRealPos(w);
			this.height=PosTransform.localPosToRealPos(h);
			return this;
		}
		
		public function setFormet(formet:TextFormat,lock:Boolean=false):BatrTextInput
		{
			this.defaultTextFormat=formet;
			this.setTextFormat(formet);
			return this;
		}
	}
}