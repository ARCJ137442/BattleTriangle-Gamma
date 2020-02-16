package batr.menu.objects.selecter 
{
	import batr.common.*;
	import batr.general.*;
	import batr.main.*;
	import batr.fonts.*;
	import batr.menu.events.*;
	import batr.menu.main.*;
	import batr.menu.objects.*;
	import batr.menu.objects.selecter.*;
	import batr.translations.*;
	
	import flash.text.*;
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	
	public class BatrSelecterList extends BatrMenuGUI implements IBatrMenuElementContainer
	{
		//============Static Variables============//
		public static const DEFAULT_DISTANCE_H:Number=GlobalGameVariables.DEFAULT_SIZE*8;
		public static const DEFAULT_DISTANCE_V:Number=GlobalGameVariables.DEFAULT_SIZE;
		
		//============Instance Variables============//
		protected var _selecters:Vector.<BatrSelecter>=new Vector.<BatrSelecter>();
		protected var _selectTextFields:Vector.<BatrTextField>=new Vector.<BatrTextField>();
		
		/**
		 * Distance Between Selecter And Selecter.
		 */
		protected var _verticalDistance=DEFAULT_DISTANCE_V;
		
		/**
		 * Distance Between Text And Selecter.
		 */
		protected var _horizontalDistance=DEFAULT_DISTANCE_H;
		
		//============Constructor Function============//
		public function BatrSelecterList(horizontalDistance:Number=BatrSelecterList.DEFAULT_DISTANCE_H,verticalDistance:Number=BatrSelecterList.DEFAULT_DISTANCE_V):void
		{
			super(false);
			this.setDistance(horizontalDistance,verticalDistance);
		}
		
		//============Destructor Function============//
		public override function deleteSelf():void
		{
			for each(var selecter:BatrSelecter in this._selecters)
			{
				selecter.deleteSelf();
			}
			this._selecters=null;
			for each(var textField:BatrTextField in this._selectTextFields)
			{
				textField.deleteSelf();
			}
			this._selectTextFields=null;
		}
		
		//============Instance Getter And Setter============//
		//Selecter
		public function get selecters():Vector.<BatrSelecter>
		{
			return this._selecters;
		}
		
		public function get selecterCount():int
		{
			return this._selecters.length;
		}
		
		//Text
		public function get selectTextFields():Vector.<BatrTextField>
		{
			return this._selectTextFields;
		}
		
		public function get selectTextFieldCount():int
		{
			return this._selectTextFields.length;
		}
		
		//verticalDistance
		public function get horizontalDistance():Number
		{
			return this._horizontalDistance;
		}
		
		public function set horizontalDistance(value:Number):void
		{
			this._horizontalDistance=value;
			this.refreshDisplay();
		}
		
		//verticalDistance
		public function get verticalDistance():Number
		{
			return this._verticalDistance;
		}
		
		public function set verticalDistance(value:Number):void
		{
			this._verticalDistance=value;
			this.refreshDisplay();
		}
		
		//============Instance Functions============//
		public function setPos(x:Number, y:Number):BatrSelecterList 
		{
			super.protected::sP(x,y);
			return this;
		}
		
		public function setBlockPos(x:Number, y:Number):BatrSelecterList 
		{
			super.protected::sBP(x,y);
			return this;
		}
		
		protected function initDisplay():void
		{
			var dy:Number,i:int;
			if(this.selectTextFieldCount>0)
			{
				var textField:BatrTextField;
				for(dy=i=0;i<this.selectTextFieldCount;i++)
				{
					textField=this._selectTextFields[i];
					if(textField==null)
					{
						dy+=this.verticalDistance;
						continue;
					}
					textField.x=0;
					textField.y=dy;
					dy+=this.verticalDistance;
					this.addChild(textField);
				}
			}
			if(this.selecterCount>0)
			{
				var selecter:BatrSelecter;
				for(dy=i=0;i<this.selecterCount;i++)
				{
					selecter=this._selecters[i];
					if(selecter==null)
					{
						dy+=this.verticalDistance;
						continue;
					}
					selecter.x=this.horizontalDistance;
					selecter.y=dy+GlobalGameVariables.DEFAULT_SIZE/2;
					dy+=this.verticalDistance;
					this.addChild(selecter);
				}
			}
		}
		
		public function refreshDisplay():BatrSelecterList
		{
			this.initDisplay();
			return this;
		}
		
		public function setPosAndRefresh(x:Number,y:Number):BatrSelecterList
		{
			this.x=x;
			this.y=y;
			this.refreshDisplay();
			return this;
		}
		
		public function setDistance(H:Number,V:Number):BatrSelecterList
		{
			this._horizontalDistance=H;
			this._verticalDistance=V;
			this.initDisplay();
			return this;
		}
		
		//========By IBatrMenuElementContainer========//
		/**
		 * Unfinished.
		 */
		public function appendDirectElement(element:IBatrMenuElement):IBatrMenuElement
		{
			functionNotFound();
			return null;
		}
		
		/**
		 * Unfinished.
		 */
		public function appendDirectElements(...elements):IBatrMenuElement
		{
			functionNotFound();
			return null;
		}
		
		/**
		 * Unfinished.
		 */
		public function addChildPerDirectElements():void
		{
			this.initDisplay();
		}
		
		/**
		 * Unfinished.
		 */
		public function getElementAt(index:int):IBatrMenuElement
		{
			functionNotFound();
			return null;
		}
		
		/**
		 * Unfinished.
		 */
		public function getElementByName(name:String):BatrMenuGUI
		{
			functionNotFound();
			return null;
		}
		
		private function functionNotFound():void
		{
			throw new Error("Function Not Found!")
		}
		
		//========True Functions About Selecters========//
		public function appendSelecterAndText(host:BatrSubject,selecter:BatrSelecter,tKey:String,shiftEmptyLine:Boolean=false):BatrSelecterList
		{
			//Empty Line
			if(shiftEmptyLine) this.AddNewEmptyLine();
			//Selecter
			this._selecters.push(selecter);
			//Text
			var textField:BatrTextField=new BatrTextField("",host.translations,tKey);
			textField.initFormetAsMenu();
			this._selectTextFields.push(textField);
			host.addEventListener(TranslationsChangeEvent.TYPE,textField.onTranslationChange);
			//Return
			return this;
		}
		
		protected function AddNewEmptyLine():void
		{
			this._selecters.push(null);
			this._selectTextFields.push(null);
		}
		
		public function getSelecterByName(name:String):BatrSelecter
		{
			for each(var selecter:BatrSelecter in this._selecters)
			{
				if(selecter!=null&&selecter.name==name) return selecter;
			}
			return null;
		}
		
		public function quickAppendSelecter(menu:Menu,context:BatrSelecterContext,keyName:String,shiftEmptyLine:Boolean=false,clickListener:Function=null,minTextBlockWidth:Number=0.5):BatrSelecterList
		{
			var selecter:BatrSelecter=new BatrSelecter(context,PosTransform.localPosToRealPos(minTextBlockWidth));
			selecter.setName(keyName);
			menu.subject.addEventListener(TranslationsChangeEvent.TYPE,selecter.onTranslationChange);
			if(clickListener!=null) selecter.addEventListener(BatrGUIEvent.CLICK,clickListener);
			this.appendSelecterAndText(menu.subject,selecter,keyName,shiftEmptyLine);
			return this;
		}
	}
}