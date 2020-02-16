package batr.menu.objects 
{
	import batr.general.*;
	
	import flash.text.*;
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	
	public class BatrButtonList extends BatrMenuGUI implements IBatrMenuElementContainer
	{
		//============Static Variables============//
		public static const DEFAULT_DISTANCE:Number=GlobalGameVariables.DEFAULT_SIZE;
		
		//============Instance Variables============//
		protected var _buttons:Vector.<BatrButton>=new Vector.<BatrButton>();
		protected var _verticalDistance=DEFAULT_DISTANCE;
		
		//============Constructor Function============//
		public function BatrButtonList(verticalDistance:Number=BatrButtonList.DEFAULT_DISTANCE):void
		{
			super(false);
			this.verticalDistance=verticalDistance;
			this.initDisplay();
		}
		
		//============Destructor Function============//
		public override function deleteSelf():void
		{
			for each(var button:BatrButton in this._buttons)
			{
				button.deleteSelf();
			}
			this._buttons=null;
		}
		
		//============Instance Getter And Setter============//
		//Button
		public function get buttons():Vector.<BatrButton>
		{
			return this._buttons;
		}
		
		public function get buttonCount():int
		{
			return this._buttons.length;
		}
		
		//verticalDistance
		public function get verticalDistance():Number
		{
			return this._verticalDistance;
		}
		
		public function set verticalDistance(value:Number):void
		{
			this._verticalDistance=value;
		}
		
		//============Instance Functions============//
		public function setPos(x:Number, y:Number):BatrButtonList 
		{
			super.protected::sP(x,y);
			return this;
		}
		
		public function setBlockPos(x:Number, y:Number):BatrButtonList 
		{
			super.protected::sBP(x,y);
			return this;
		}
		
		protected function initDisplay():void
		{
			if(this.buttonCount<1) return;
			var dy:Number=0;
			for(var i:int=0;i<this._buttons.length;i++)
			{
				var button:BatrButton=this._buttons[i];
				button.x=0;
				button.y=dy;
				dy+=this.verticalDistance+button.displayHeight;
				this.addChild(button);
			}
		}
		
		public function refreshDisplay():void
		{
			this.initDisplay();
		}
		
		//========By IBatrMenuElementContainer========//
		public function appendDirectElement(element:IBatrMenuElement):IBatrMenuElement
		{
			if(element is BatrButton) this._buttons.push(element as BatrButton);
			return this;
		}
		
		public function appendDirectElements(...elements):IBatrMenuElement
		{
			var button:BatrButton;
			for(var i:int=0;i<elements.length;i++)
			{
				button=elements[i] as BatrButton;
				if(button!=null) this._buttons.push(button);
			}
			return this;
		}
		
		public function addChildPerDirectElements():void
		{
			this.initDisplay();
		}
		
		public function getElementAt(index:int):IBatrMenuElement
		{
			return (index<1||index>=this.buttonCount)?null:(this._buttons[index] as IBatrMenuElement);
		}
		
		public function getElementByName(name:String):BatrMenuGUI
		{
			for each(var button:BatrButton in this._buttons)
			{
				if(button!=null&&button.name==name) return (button as BatrMenuGUI);
			}
			return null;
		}
	}
}