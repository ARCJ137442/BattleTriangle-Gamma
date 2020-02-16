package batr.menu.objects
{
	import batr.common.*;
	import batr.general.*;
	import batr.menu.main.*;
	import batr.menu.events.*;
	import batr.menu.objects.*;
	import batr.menu.events.*;
	
	import flash.display.*;
	import flash.events.*;
	
	public class BatrMenuGUI extends Sprite implements IBatrMenuElement
	{
		//============Static Variables============//
		
		//============Instance Variables============//
		
		//============Constructor Function============//
		public function BatrMenuGUI(listener:Boolean=true):void
		{
			super();
			if(listener) this.addEventListeners();
		}
		
		//============Destructor Function============//
		public function deleteSelf():void
		{
			//RemoveEventListener
			this.removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
			this.removeEventListener(MouseEvent.ROLL_OVER,this.onMouseRollOver);
			this.removeEventListener(MouseEvent.ROLL_OUT,this.onMouseRollOut);
			this.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseHold);
			this.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseRelease);
			this.removeEventListener(MouseEvent.CLICK,this.onClick);
		}
		
		//============Instance Getter And Setter============//
		
		//============Instance Functions============//
		protected function addEventListeners():void
		{
			//AddEventListener
			this.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
			this.addEventListener(MouseEvent.ROLL_OVER,this.onMouseRollOver);
			this.addEventListener(MouseEvent.ROLL_OUT,this.onMouseRollOut);
			this.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseHold);
			this.addEventListener(MouseEvent.MOUSE_UP,this.onMouseRelease);
			this.addEventListener(MouseEvent.CLICK,this.onClick);
		}
		
		public function setName(value:String):BatrMenuGUI
		{
			this.name=value;
			return this;
		}
		
		protected function sP(x:Number,y:Number):void
		{
			this.x=x;
			this.y=y;
		}
		
		protected function sBP(x:Number,y:Number):void
		{
			this.x=PosTransform.localPosToRealPos(x);
			this.y=PosTransform.localPosToRealPos(y);
		}
		
		protected function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
		}
		
		protected function drawShape():void
		{
			
		}
		
		protected function onClick(event:MouseEvent):void
		{
			dispatchEvent(new BatrGUIEvent(BatrGUIEvent.CLICK,this));
		}
		
		protected function onMouseRollOver(event:MouseEvent):void
		{
			
		}
		
		protected function onMouseRollOut(event:MouseEvent):void
		{
			
		}
		
		protected function onMouseHold(event:MouseEvent):void
		{
			
		}
		
		protected function onMouseRelease(event:MouseEvent):void
		{
			
		}
	}
}