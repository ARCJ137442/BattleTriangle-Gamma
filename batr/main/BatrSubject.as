package batr.main 
{
	import batr.common.*;
	import batr.general.*;
	
	import batr.game.main.*;
	import batr.menu.events.*;
	import batr.menu.main.*;
	import batr.translations.*;
	
	import flash.display.*;
	import flash.events.*;
	
	public class BatrSubject extends Sprite
	{
		//============Instance Variables============//
		protected var _game:Game
		protected var _menu:Menu
		
		protected var _gameRule:GameRule
		protected var _translations:Translations
		
		//============Constructor Function============//
		public function BatrSubject():void
		{
			//Init Variables
			this._translations=Translations.getTranslationByLanguage();
			this._gameRule=new GameRule();
			this._game=new batr.game.main.Game(this,false);
			this._menu=new batr.menu.main.Menu(this);
			//Add Event Listener
			this.addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
		}
		
		//============Instance Getter And Setter============//
		public function get gameRule():GameRule
		{
			return this._gameRule;
		}
		
		public function get gameObj():Game
		{
			return this._game;
		}
		
		public function get menuObj():Menu
		{
			return this._menu;
		}
		
		public function get gameVisible():Boolean
		{
			return this._game.visible;
		}
		
		public function set gameVisible(value:Boolean):void
		{
			this._game.visible=value;
		}
		
		public function get menuVisible():Boolean
		{
			return this._menu.visible;
		}
		
		public function set menuVisible(value:Boolean):void
		{
			this._menu.visible=value;
		}
		
		public function get translations():Translations
		{
			return this._translations;
		}
		
		//============Instance Functions============//
		protected function onStageResize(E:Event=null):void
		{
			//Information
			var originalStageWidth:Number=GlobalGameVariables.DISPLAY_SIZE
			var originalStageHeight:Number=originalStageWidth//Square
			var nowStageWidth:Number=this.stage.stageWidth
			var nowStageHeight:Number=this.stage.stageHeight
			var mapGridWidth:uint=this._game.isLoaded?this._game.mapWidth:GlobalGameVariables.DISPLAY_GRIDS
			var mapGridHeight:uint=this._game.isLoaded?this._game.mapHeight:GlobalGameVariables.DISPLAY_GRIDS
			var mapDisplayWidth:Number=GlobalGameVariables.DEFAULT_SCALE*mapGridWidth*GlobalGameVariables.DEFAULT_SIZE
			var mapDisplayHeight:Number=GlobalGameVariables.DEFAULT_SCALE*mapGridHeight*GlobalGameVariables.DEFAULT_SIZE
			//var distanceBetweenBorderX:Number=0(nowStageWidth-originalStageWidth)/2
			//var distanceBetweenBorderY:Number=0(nowStageHeight-originalStageHeight)/2
			//Operation
			var isMapDisplayWidthMax:Boolean=mapDisplayWidth>=mapDisplayHeight
			var isStageWidthMax:Boolean=nowStageWidth>=nowStageHeight
			var mapDisplaySizeMax:Number=isMapDisplayWidthMax?mapDisplayWidth:mapDisplayHeight
			var mapDisplaySizeMin:Number=isMapDisplayWidthMax?mapDisplayHeight:mapDisplayWidth
			var stageSizeMax:Number=isStageWidthMax?nowStageWidth:nowStageHeight
			var stageSizeMin:Number=isStageWidthMax?nowStageHeight:nowStageWidth
			//Output
			var displayScale:Number=stageSizeMin/mapDisplaySizeMin
			var shouldX:Number=/*-distanceBetweenBorderX+*/(isStageWidthMax?(nowStageWidth-mapDisplayWidth*displayScale)/2:0)
			var shouldY:Number=/*-distanceBetweenBorderY+*/(isStageWidthMax?0:(nowStageHeight-mapDisplayHeight*displayScale)/2)
			var shouldScale:Number=displayScale*GlobalGameVariables.DEFAULT_SCALE
			//Deal
			this.x=shouldX
			this.y=shouldY
			this.scaleX=this.scaleY=shouldScale
			//Patch
			_menu.onStageResize(E)
			_game.onStageResize(E)
		}
		
		protected function onAddedToStage(E:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,onAddedToStage)
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN,onSubjectKeyDown)
			this.addChilds();
			this.resize();
			//backGround
			this._menu.backGround.visible=false;
			//Menu game preview
			this.initGamePreview();
		}
		
		public function onTitleComplete():void
		{
			//Menu game preview
			this.startGamePreview();
		}
		
		protected function initGamePreview():void
		{
			this._game.load(GameRule.MENU_BACKGROUND);
			this._game.visibleHUD=false;
			this.gameVisible=true;
			this._game.mapVisible=!(this._game.entityAndEffectVisible=false);
		}
		
		protected function startGamePreview():void
		{
			this._game.isActive=true;
			this._game.entityAndEffectVisible=true;
		}
		
		protected function onSubjectKeyDown(E:KeyboardEvent):void
		{
			var code:uint=E.keyCode;
			var ctrl:Boolean=E.ctrlKey;
			var alt:Boolean=E.altKey;
			var shift:Boolean=E.shiftKey;
			// P:Pause
			if(code==KeyCode.P&&!this.menuVisible)
			{
				this.toggleGamePause();
			}
		}
		
		protected function onTranslationsChange(E:TranslationsChangeEvent):void
		{
			var nowT:Translations=E.nowTranslations;
			var oldT:Translations=E.oldTranslations;
		}
		
		//====Methods====//
		protected function addChilds():void
		{
			this.addChild(this._game);
			this.addChild(this._menu);
		}
		
		public function resize():void 
		{
			this.scaleX=this.scaleY=GlobalGameVariables.DEFAULT_SCALE
		}
		
		public function set emableAutoResize(value:Boolean):void
		{
			if(value)
			{
				this.stage.scaleMode=StageScaleMode.NO_SCALE
				this.stage.align=StageAlign.TOP_LEFT
				this.stage.addEventListener(Event.RESIZE,onStageResize)
			}
			else
			{
				this.stage.scaleMode=StageScaleMode.SHOW_ALL
				this.stage.align=StageAlign.TOP
				this.stage.removeEventListener(Event.RESIZE,onStageResize)
			}
		}
		
		public function gotoGame():void
		{
			//Load Game if Game won't loaded
			if(!this.gameObj.isLoaded) this.startGame();
			this.gameVisible=true;
			this._game.visibleHUD=true;
			this.menuVisible=false;
			this._game.updateMapSize();
		}
		
		public function gotoMenu():void
		{
			//this.gameVisible=false
			this.menuVisible=true;
			this._menu.updateMapSize();
		}
		
		public function trunToGame():void
		{
			gotoGame();
			continueGame();
		}
		
		public function trunToMenu():void
		{
			gotoMenu();
			pauseGame();
		}
		
		public function startGame():void
		{
			this._game.forceStartGame(this._gameRule);
		}
		
		public function pauseGame():void
		{
			this._game.isActive=false;
		}
		
		public function continueGame():void
		{
			this._game.isActive=true;
		}
		
		public function toggleGamePause():void
		{
			this._game.isActive=!this._game.isActive;
		}
		
		public function trunTranslationsTo(translations:Translations):void
		{
			var oldTranslations:Translations=this._translations;
			this._translations=translations;
			this.dispatchEvent(new TranslationsChangeEvent(this._translations,oldTranslations));
		}
		
		public function trunTranslations():void
		{
			this.trunTranslationsTo(Translations.translationsList[(Translations.translationsList.indexOf(this._translations)+1)%Translations.numTranslations]);
		}
		
		public function resetRule():void
		{
			this._gameRule=new GameRule();
		}
	}
}