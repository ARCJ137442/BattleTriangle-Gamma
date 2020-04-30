package batr.menu.objects.selecter 
{
	import batr.common.*;
	import batr.general.*;
	
	import batr.game.block.*;
	import batr.game.map.*;
	import batr.game.main.*;
	import batr.game.model.*;
	
	import batr.menu.main.*;
	import batr.menu.events.*;
	import batr.menu.objects.*;
	
	import batr.main.*;
	import batr.fonts.*;
	import batr.translations.*
	
	import flash.text.*;
	import flash.display.*;
	import flash.events.MouseEvent;
	
	public class BatrSelecter extends BatrMenuGUI implements IBatrMenuElement
	{
		//============Static Variables============//
		protected static const ARROW_OFFSET:Number=GlobalGameVariables.DEFAULT_SIZE/10
		
		//============Static Functions============//
		/**
		 * set a relative link between these selecter.
		 * @param	selecter1	the first selecter carries context.
		 * @param	selecter2	the second selecter that will lost its context.
		 */
		public static function setRelativeLink(selecter1:BatrSelecter,selecter2:BatrSelecter):void
		{
			selecter1.setLinkTarget(selecter2,false);
			selecter2.setLinkTarget(selecter1,false);
		}
		
		//============Instance Variables============//
		protected var _leftArrow:BatrSelecterArrow;
		protected var _rightArrow:BatrSelecterArrow;
		protected var _textField:BatrTextField;
		protected var _minTextWidth:Number;
		
		protected var _context:BatrSelecterContext;
		
		/**
		 * A reference to other selecter,and constantly copy context from its link target
		 * When its value update,the target's value also update
		 */
		protected var _linkTarget:BatrSelecter=null;
		
		//============Constructor Function============//
		public function BatrSelecter(context:BatrSelecterContext,
									minTextWidth:Number=2*GlobalGameVariables.DEFAULT_SIZE):void
		{
			super();
			this._context=context;
			this._minTextWidth=minTextWidth;
			//Left
			this._leftArrow=new BatrSelecterArrow();
			this._leftArrow.scaleX=-1;
			//Right
			this._rightArrow=new BatrSelecterArrow();
			//Text
			this._textField=BatrTextField.fromKey(null,null);
			//AddEventListener
			this._leftArrow.clickFunction=this.onClickLeft;
			this._rightArrow.clickFunction=this.onClickRight;
			//Init
			this.initDisplay();
		}
		
		//============Destructor Function============//
		public override function deleteSelf():void
		{
			this._leftArrow.deleteSelf();
			this._rightArrow.deleteSelf();
			this._textField.deleteSelf();
			this._context.deleteSelf();
			super.deleteSelf();
		}
		
		//============Instance Getter And Setter============//
		public function get context():BatrSelecterContext
		{
			return this._context;
		}
		
		//Int:value,Enum:index
		public function get currentValue():int
		{
			return this._context.currentValue;
		}
		
		public function get linkTarget():BatrSelecter
		{
			return this._linkTarget;
		}
		
		public function set linkTarget(value:BatrSelecter):void
		{
			//if(isValidTarget(value))
			{
				this._linkTarget=value;
				this.copyContextTo(this._linkTarget);
			}
		}
		
		//============Instance Functions============//
		public function setPos(x:Number, y:Number):BatrSelecter
		{
			super.protected::sP(x,y);
			return this;
		}
		
		public function setBlockPos(x:Number, y:Number):BatrSelecter
		{
			super.protected::sBP(x,y);
			return this;
		}
		
		protected function isValidTarget(other:BatrSelecter):Boolean
		{
			while(other!=null)
			{
				if(other.linkTarget==this) return false;
				other=other.linkTarget;
			}
			return true;
		}
		
		protected function setLinkTarget(other:BatrSelecter,callee:Boolean=true):BatrSelecter
		{
			this._linkTarget=other;
			this.copyContextTo(this._linkTarget,callee);
			return this;
		}
		
		/**
		 * Let the other selecter copy context from this
		 * @param	num	the other selecter
		 * @param	callee	the boolean determines to callee
		 */
		protected function copyContextTo(other:BatrSelecter,callee:Boolean=true):void
		{
			if(other==null) return;
			if(this._context!=null) other.setContext(this._context);
			if(!callee) return;
			while(other!=null&&other._linkTarget!=null)
			{
				if(other._linkTarget==this) break;
				other._linkTarget._context=other._context;
				other._linkTarget.updateTextByContext();
				other._linkTarget.copyContextTo(other,false);
				other=other._linkTarget;
			}
		}
		
		protected function initDisplay():void
		{
			this.updateTextByContext();
			this._textField.initFormetAsMenu();
			//Add Childs
			this.addChild(this._leftArrow);
			this.addChild(this._rightArrow);
			this.addChild(this._textField);
		}
		
		protected function updateText():void
		{
			this._textField.setTextFormat(Menu.TEXT_FORMAT);
			this._textField.width=this._textField.textWidth+GlobalGameVariables.DEFAULT_SIZE/10;
			this._textField.height=this._textField.textHeight+GlobalGameVariables.DEFAULT_SIZE/20;
			this._textField.x=-this._textField.width/2;
			this._textField.y=-this._textField.height/2;
			this._leftArrow.x=-Math.max(this._textField.textWidth+this._leftArrow.displayWidth,this._minTextWidth)/2-ARROW_OFFSET;
			this._rightArrow.x=Math.max(this._textField.textWidth+this._rightArrow.displayWidth,this._minTextWidth)/2+ARROW_OFFSET;
			this._leftArrow.y=this._rightArrow.y=0;
		}
		
		public function updateTextByContext():BatrSelecter
		{
			if(this._context==null) return this;
			this._textField.setText(this._context.currentText);
			this.updateText();
			return this;
		}
		
		protected override function drawShape():void
		{
			
		}
		
		public function setLinkTo(target:BatrSelecter):BatrSelecter
		{
			this.linkTarget=target;
			return this;
		}
		
		public function setContext(context:BatrSelecterContext):void
		{
			this._context=context;
			this.updateTextByContext();
		}
		
		//Event
		protected function onClickLeft(E:MouseEvent):void
		{
			this.trunSelectLeft();
		}
		
		protected function onClickRight(E:MouseEvent):void
		{
			this.trunSelectRight();
		}
		
		public function onTranslationChange(E:TranslationsChangeEvent):void
		{
			/* trace(this.name,this._textField.text,this._context);
			 * The Player Selecter in Game Result Menu dosn't has context when INITIAL LOAD! */
			if(this._context==null) return;
			this._context.alignTranslationsFrom(E.nowTranslations);
			this.updateTextByContext();
		}
		
		//Select
		public function trunSelectTo(index:int):BatrSelecter
		{
			this._context.currentValue=index;
			return this;
		}
		
		public function trunSelectLeft():void
		{
			//Check
			if(this._context==null) return;
			//Select
			this._context.currentValue--;
			//Update
			this.updateTextByContext();
			this.copyContextTo(this._linkTarget);
			//Event
			this.dispatchEvent(new BatrGUIEvent(BatrGUIEvent.CLICK_LEFT,this));
		}
		
		public function trunSelectRight():void
		{
			//Check
			if(this._context==null) return;
			//Select
			this._context.currentValue++;
			//Update
			this.updateTextByContext();
			this.copyContextTo(this._linkTarget);
			//Event
			this.dispatchEvent(new BatrGUIEvent(BatrGUIEvent.CLICK_RIGHT,this));
		}
	}
}