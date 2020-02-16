package batr.menu.main
{
	import batr.common.*;
	import batr.general.*;
	
	import batr.game.block.*;
	import batr.game.map.*;
	import batr.game.main.*;
	import batr.game.model.*;
	
	import batr.menu.events.*;
	import batr.menu.objects.*;
	import batr.menu.objects.selecter.*;
	
	import batr.main.*;
	import batr.fonts.*;
	import batr.translations.*
	
	import flash.text.*;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.utils.Timer;
	
	public class Menu extends Sprite
	{
		//============Static Variables============//
		protected static const _TITLE_HIDE_Y:int=-Title.HEIGHT-GlobalGameVariables.DEFAULT_SIZE*1;
		protected static const _TITLE_SHOW_Y:int=PosTransform.localPosToRealPos(2);
		protected static const _TITLE_ANIMATION_TIME:uint=GlobalGameVariables.TPS/2;
		
		/**
		 * Menu Text Format
		 */
		public static const TEXT_FORMAT:TextFormat=new TextFormat(
			new MainFont().fontName,
			GlobalGameVariables.DEFAULT_SIZE*5/8,
			0x000000,
			true,
			null,
			null,
			null,
			null,
			TextFormatAlign.CENTER)
			
		public static const VERSION_TEXT_FORMAT:TextFormat=new TextFormat(
			new MainFont().fontName,
			GlobalGameVariables.DEFAULT_SIZE*5/8,
			0x6666ff,
			true,
			null,
			null,
			null,
			null,
			TextFormatAlign.LEFT);
		
		public static const RESULT_TITLE_FORMET:TextFormat=new TextFormat(
			new MainFont().fontName,
			GlobalGameVariables.DEFAULT_SIZE,
			0x444444,
			true,
			false,
			false,
			null,
			null,
			TextFormatAlign.CENTER);
		
		//============Instance Variables============//
		protected var _isActive:Boolean
		
		protected var _subject:BatrSubject;
		protected var _backGround:BackGround=new BackGround(GlobalGameVariables.DISPLAY_GRIDS,
															GlobalGameVariables.DISPLAY_GRIDS,
															true,true,false);
		
		protected var _titleTimer:Timer=new Timer(1000/GlobalGameVariables.TPS,_TITLE_ANIMATION_TIME);
		protected var _isShowingMenu:Boolean=false;
		
		protected var _languageSelecter:BatrSelecter;
		
		//Sheets
		//List
		protected var _sheetMain:BatrMenuSheet;
		protected var _sheetSelect:BatrMenuSheet;
		protected var _sheetAdvancedCustom:BatrMenuSheet;
		protected var _sheetGameResult:BatrMenuSheet;
		
		//Functional
		protected var _sheets:Vector.<BatrMenuSheet>;
		protected var _nowSheet:BatrMenuSheet;
		protected var _lastSheet:BatrMenuSheet;
		
		protected var _selecterListCustom:BatrSelecterList;
		protected var _selecterListAdvanced_L:BatrSelecterList;
		protected var _selecterListAdvanced_R:BatrSelecterList;
		
		protected var _gameResultText:BatrTextField;
		protected var _storedGameResult:String;
		/**
		 * A intager combine with limitted indexes.
		 */
		protected var _sheetHistory:uint;
		/* 
		 * s=<1,0,1,1,1,0,1,1,1,1,1,0,1,1,0,0,1>:[l=17,m=2],
		 * Complexed To Sum(pow(m,n)*s[n],n,0,l-1)=96217
		 */
		
		//GUI
		protected var _title:Title=new Title();
		
		//============Constructor Function============//
		public function Menu(subject:BatrSubject):void
		{
			super();
			this._subject=subject;
			this.initDisplay();
			this.addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
			this._subject.addEventListener(TranslationsChangeEvent.TYPE,onTranslationChange);
		}
		
		//============Instance Getter And Setter============//
		public function get isActive():Boolean
		{
			return this._isActive;
		}
		
		public function set isActive(value:Boolean):void
		{
			if(value==this._isActive) return;
			this._isActive=value;
		}
		
		public function get backGround():BackGround
		{
			return this._backGround;
		}
		
		public function get subject():BatrSubject
		{
			return this._subject;
		}
		
		public function get game():Game
		{
			return this._subject.gameObj;
		}
		
		public function get gameRule():GameRule
		{
			return this.subject.gameRule;
		}
		
		public function get translations():Translations
		{
			return this._subject.translations;
		}
		
		public function get nowSheet():BatrMenuSheet
		{
			return this._nowSheet;
		}
		
		public function set nowSheet(value:BatrMenuSheet):void
		{
			this.setNowSheet(value,true);
		}
		
		public function get lastSheet():BatrMenuSheet
		{
			return this._lastSheet;
		}
		
		public function get numSheet():int
		{
			return this._sheets.length;
		}
		
		/**
		 * Returns a uint.
		 * @return	A unsigned intager
		 */
		public function get historyLength():uint
		{
			//Get 12314 -> 5,1101201 ->7, ...
			return this._sheetHistory<2?this._sheetHistory:Math.ceil(Math.log(this._sheetHistory)/Math.log(this.numSheet+1));
		}
		
		/**
		 * Returns a uint>0
		 * @return	0:null,>0:sheet.indexOf(...)+1/sheet#0,sheet#1,sheet#2,...
		 */
		public function get lastSheetHistory():uint
		{
			return Math.floor(this._sheetHistory/Math.pow(this.numSheet+1,this.historyLength-1));
		}
		
		public function set storedGameResult(value:String):void
		{
			this._storedGameResult=value;
		}
		
		//============Instance Functions============//
		//========Advanced Functions========//
		/**
		 * Add a sheet index to the sheet history.
		 * @param	history	An unsigned integer that specified the index of the sheet character to be 
		 *   used to add to history. If history=0, the sheet 
		 *   history will be add nothing.
		 */
		protected function addSheetHistory(history:uint):void
		{
			//Add to the Head of UnsignedIntager
			//history>0,r=this.numSheet+1
			//trace("Before:",history,this.historyLength,this._sheetHistory,this.lastSheetHistory);
			this._sheetHistory+=Math.pow(this.numSheet+1,this.historyLength)*history;
			//trace("After:",history,this.historyLength,this._sheetHistory,this.lastSheetHistory);
		}
		
		protected function popSheetHistory():uint
		{
			//Remove from the Head of UnsignedIntager
			//trace("Before:",this.historyLength,this._sheetHistory,this.lastSheetHistory);
			var lSH:uint=this.lastSheetHistory;
			this._sheetHistory-=this.lastSheetHistory*Math.pow(this.numSheet+1,this.historyLength-1);
			//trace("After:",this.historyLength,this._sheetHistory,this.lastSheetHistory);
			return lSH;
		}
		
		//========Event Functions========//
		public function onStageResize(E:Event):void
		{
			
		}
		
		protected function onAddedToStage(E:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
			playTitleAnimation();
			addChilds();
		}
		
		public function updateMapSize():void
		{
			if(this._backGround==null) return;
			this._backGround.x=this.x;
			this._backGround.y=this.y;
			this._backGround.scaleX=this.scaleX;
			this._backGround.scaleY=this.scaleY;
		}
		
		protected function playTitleAnimation():void
		{
			_title.x=PosTransform.localPosToRealPos(2);
			_title.y=_TITLE_HIDE_Y;
			this.animaShowMenu();
			this.addEventListener(MenuEvent.TITLE_SHOWEN,constructMainManu);
		}
		
		protected function addChilds():void
		{
			this.addChild(this._backGround);
			this.addChild(this._title);
		}
		
		public function setNowSheet(value:BatrMenuSheet,addHistory:Boolean=true):void
		{
			//Change
			if(this._nowSheet!=null) this.removeChild(this._nowSheet);
			this._lastSheet=this._nowSheet;
			this._nowSheet=value;
			//Set
			if(addHistory) this.addSheetHistory(this._sheets.indexOf(this._lastSheet)+1);
			if(this._nowSheet!=null) this.addChild(this._nowSheet);
			this._title.visible=this._nowSheet.keepTitle;
		}
		
		//========Menu Build Methods========//
		//Button Build
		protected function quickButtonBuild(tKey:String,clickListenerFunction:Function,blockWidth:Number=6,blockHeight:Number=1):BatrButton
		{
			var button:BatrButton=new BatrButton(GlobalGameVariables.DEFAULT_SIZE*blockWidth,
												 GlobalGameVariables.DEFAULT_SIZE*blockHeight,
												 this.translations,tKey);
			this._subject.addEventListener(TranslationsChangeEvent.TYPE,button.onTranslationsChange);
			if(clickListenerFunction!=null) button.addEventListener(BatrGUIEvent.CLICK,clickListenerFunction);
			return button;
		}
		
		//TextField Build
		protected function quickTextFieldBuild(text:String,tKey:String,blockX:Number=0,blockY:Number=0):BatrTextField
		{
			var textField:BatrTextField=new BatrTextField(text,this.translations,tKey);
			textField.x=GlobalGameVariables.DEFAULT_SIZE*blockX;
			textField.y=GlobalGameVariables.DEFAULT_SIZE*blockY;
			textField.initFormetAsMenu();
			this._subject.addEventListener(TranslationsChangeEvent.TYPE,textField.onTranslationChange);
			return textField;
		}
		
		//Selecter Build
		protected function quickSelecterBuild(context:BatrSelecterContext,
											 minTextBlockWidth:Number=1,selecterClickFunction:Function=null):BatrSelecter
		{
			var selecter:BatrSelecter=new BatrSelecter(context,PosTransform.localPosToRealPos(minTextBlockWidth));
			this._subject.addEventListener(TranslationsChangeEvent.TYPE,selecter.onTranslationChange);
			if(selecterClickFunction!=null) selecter.addEventListener(BatrGUIEvent.CLICK,selecterClickFunction);
			return selecter;
		}
		
		//TranslationalText Build
		protected function quickTranslationalTextBuild(key:String,forcedText:String=null):TranslationalText
		{
			return new TranslationalText(this.translations,key,forcedText);
		}
		
		//Menu Main
		protected function initDisplay():void
		{
			
		}
		
		protected function constructMainManu(event:MenuEvent):void
		{
			this.removeEventListener(MenuEvent.TITLE_SHOWEN,constructMainManu)
			//Call Subject
			this.subject.onTitleComplete();
			//Build Sheets
			this.buildSheets();
			for each(var sheet:BatrMenuSheet in this._sheets) sheet.addChildPerDirectElements();
			this.nowSheet=this._sheetMain;
			//Add VresionText
			var versionText=new TextField();
			versionText.text=GlobalGameInformations.GAME_FULL_VERSION;
			versionText.setTextFormat(Menu.VERSION_TEXT_FORMAT);
			versionText.width=versionText.textWidth+10;
			versionText.height=versionText.textHeight+5;
			versionText.x=PosTransform.localPosToRealPos(1);
			versionText.y=PosTransform.localPosToRealPos(23)-versionText.textHeight;
			this.addChild(versionText)
			versionText.selectable=false;
			//Add Language Selecter
			this._languageSelecter=new BatrSelecter(BatrSelecterContext.createLanguageContext(Translations.getIDFromTranslation(this.translations)));
			this._languageSelecter.x=PosTransform.localPosToRealPos(21);
			this._languageSelecter.y=PosTransform.localPosToRealPos(22.5);
			this._languageSelecter.addEventListener(BatrGUIEvent.CLICK,this.onLanguageChange)
			this.addChild(this._languageSelecter);
		}
		
		protected function buildSheets():void
		{
			//Set Variables
			var pcS,acS,imS,pcS_2,acS_2,imS_2:BatrSelecter;
			var customLeftSelecterX:uint=10;
			//===Build Sheets===//
			this._sheets=new <BatrMenuSheet>[
				//Main
				this._sheetMain=this.buildSheet(true).appendDirectElements(
					(new BatrButtonList().appendDirectElements(
						this.quickButtonBuild(TranslationKey.CONTINUE,this.onContinueButtonClick),
						this.quickButtonBuild(TranslationKey.QUICK_GAME,this.onQuickGameButtonClick),
						this.quickButtonBuild(TranslationKey.SELECT_GAME,this.onSelectGameButtonClick),
						this.quickButtonBuild(TranslationKey.CUSTOM_MODE,this.onCustomModeButtonClick)
					) as BatrButtonList).setPos(
						GlobalGameVariables.DEFAULT_SIZE*9,
						GlobalGameVariables.DEFAULT_SIZE*9
					)
				) as BatrMenuSheet,
				//Select
				this._sheetSelect=this.buildSheet(true).appendDirectElements(
					(new BatrButtonList().appendDirectElements(
						this.quickButtonBuild(TranslationKey.START,this.onSelectStartButtonClick),
						this.quickButtonBuild(TranslationKey.ADVANCED,this.onSelectAdvancedButtonClick),
						this.quickButtonBuild(TranslationKey.SAVES,null),
						this.quickButtonBuild(TranslationKey.BACK,this.onBackButtonClick)
					) as BatrButtonList).setPos(
						GlobalGameVariables.DEFAULT_SIZE*9,
						GlobalGameVariables.DEFAULT_SIZE*9
					),
					this._selecterListCustom=new BatrSelecterList(PosTransform.localPosToRealPos(5.5)).setBlockPos(
						16,9
					).appendSelecterAndText(
						this._subject,
						pcS=this.quickSelecterBuild(
							BatrSelecterContext.createUnsignedIntagerContext(this.gameRule.playerCount)
						).setName(TranslationKey.PLAYER_COUNT),
						TranslationKey.PLAYER_COUNT,
						false
					).appendSelecterAndText(
						this._subject,
						acS=this.quickSelecterBuild(
							BatrSelecterContext.createUnsignedIntagerContext(this.gameRule.AICount)
						).setName(TranslationKey.AI_PLAYER_COUNT),
						TranslationKey.AI_PLAYER_COUNT,
						true
					).appendSelecterAndText(
						this._subject,
						imS=this.quickSelecterBuild(new BatrSelecterContext().initAsEnum(
								new <TranslationalText>[
									this.quickTranslationalTextBuild(TranslationKey.MAP_RANDOM)
								],0,0
							).initAsInt(
								Game.VALID_MAP_COUNT,0,this.gameRule.initialMapID+1
							).autoInitLoopSelect(),1/*,this.onMapPreviewSwitch*/
						).setName(TranslationKey.INITIAL_MAP),
						TranslationKey.INITIAL_MAP,
						true
					)
				) as BatrMenuSheet,
				//Advanced Custom
				this._sheetAdvancedCustom=this.buildSheet(true).appendDirectElements(
					(new BatrButtonList().appendDirectElements(
						this.quickButtonBuild(TranslationKey.START,this.onSelectStartButtonClick),
						this.quickButtonBuild(TranslationKey.BACK,this.onBackButtonClick)
					) as BatrButtonList).setPos(
						GlobalGameVariables.DEFAULT_SIZE*9,
						GlobalGameVariables.DEFAULT_SIZE*19
					),
					//Left
					this._selecterListAdvanced_L=new BatrSelecterList(PosTransform.localPosToRealPos(8)).setBlockPos(
						2,9
					).appendSelecterAndText(//Old
						this._subject,
						pcS_2=this.quickSelecterBuild(null),
						TranslationKey.PLAYER_COUNT,
						false
					).appendSelecterAndText(
						this._subject,
						acS_2=this.quickSelecterBuild(null),
						TranslationKey.AI_PLAYER_COUNT,
						false
					).appendSelecterAndText(
						this._subject,
						imS_2=this.quickSelecterBuild(null,1),
						TranslationKey.INITIAL_MAP,
						false
					).quickAppendSelecter(//New
						this,
						BatrSelecterContext.createPositiveIntagerContext(this.gameRule.defaultHealth),
						TranslationKey.DEFAULT_HEALTH,
						true
					).quickAppendSelecter(
						this,
						BatrSelecterContext.createPositiveIntagerContext(this.gameRule.defaultMaxHealth),
						TranslationKey.DEFAULT_MAX_HEALTH,
						false,
						this.onMaxHealthSelecterClick
					).quickAppendSelecter(
						this,
						BatrSelecterContext.createUnsignedIntagerAndOneSpecialContext(
							this.getLifesFromRule(false),
							this.quickTranslationalTextBuild(TranslationKey.INFINITY)
						),
						TranslationKey.REMAIN_LIFES_PLAYER,
						false
					).quickAppendSelecter(
						this,
						BatrSelecterContext.createUnsignedIntagerAndOneSpecialContext(
							this.getLifesFromRule(true),
							this.quickTranslationalTextBuild(TranslationKey.INFINITY)
						),
						TranslationKey.REMAIN_LIFES_AI,
						false
					).quickAppendSelecter(
						this,
						BatrSelecterContext.createPositiveIntagerContext(int(this.gameRule.defaultRespawnTime/GlobalGameVariables.TPS)),
						TranslationKey.RESPAWN_TIME,
						false
					),
					//Right
					this._selecterListAdvanced_R=new BatrSelecterList(PosTransform.localPosToRealPos(9)).setBlockPos(
						12,9
					).quickAppendSelecter(
						this,
						new BatrSelecterContext().initAsEnum(
							(new <TranslationalText>[
								this.quickTranslationalTextBuild(TranslationKey.COMPLETELY_RANDOM),
								this.quickTranslationalTextBuild(TranslationKey.UNIFORM_RANDOM)
							]).concat(TranslationalText.getTextsByAllAvaliableWeapons(this.translations,false)),
							0,2
						).initAsInt(
							this.gameRule.enableWeaponCount-1,-2,this.gameRule.defaultWeaponID
						).autoInitLoopSelect(),
						TranslationKey.DEFAULT_WEAPON,
						false
					).quickAppendSelecter(
						this,
						BatrSelecterContext.createYorNContext(this.gameRule.weaponsNoCD?1:0,this.translations),
						TranslationKey.WEAPONS_NO_CD,
						false
					).quickAppendSelecter(
						this,
						BatrSelecterContext.createPositiveIntagerAndOneSpecialContext(
							this.gameRule.mapTransformTime,
							this.quickTranslationalTextBuild(TranslationKey.NEVER)
						),
						TranslationKey.MAP_TRANSFORM_TIME,
						true
					).quickAppendSelecter(
						this,
						BatrSelecterContext.createUnsignedIntagerContext(this.gameRule.bonusBoxMaxCount),
						TranslationKey.MAX_BONUS_COUNT,
						true
					).quickAppendSelecter(
						this,
						BatrSelecterContext.createYorNContext(this.gameRule.bonusBoxSpawnAfterPlayerDeath?1:0,this.translations),
						TranslationKey.BONUS_SPAWN_AFTER_DEATH,
						false
					).quickAppendSelecter(
						this,
						BatrSelecterContext.createUnsignedIntagerAndOneSpecialContext(
							this.gameRule.playerAsphyxiaDamage,
							this.quickTranslationalTextBuild(TranslationKey.CERTAINLY_DEAD)
						),
						TranslationKey.ASPHYXIA_DAMAGE,
						true
					)
				) as BatrMenuSheet,
				//Unfinished
				this._sheetGameResult=this.buildSheet(false).appendDirectElements(
					this._gameResultText=quickTextFieldBuild("",TranslationKey.GAME_RESULT,2,2).setBlockSize(20,2).setFormet(RESULT_TITLE_FORMET,true),
					this.quickButtonBuild(TranslationKey.BACK,this.onBackButtonClick).setBlockPos(9,21)
				) as BatrMenuSheet
			];
			//Set Variable 2
			BatrSelecter.setRelativeLink(pcS,pcS_2);
			BatrSelecter.setRelativeLink(acS,acS_2);
			BatrSelecter.setRelativeLink(imS,imS_2);
		}
		
		protected function getLifesFromRule(isAI:Boolean):int
		{
			return transformLifesFromRule(isAI?this.gameRule.remainLifesAI:this.gameRule.remainLifesPlayer);
		}
		
		protected function transformLifesFromRule(value:Number):int
		{
			return (value==Infinity?-1:int(value));
		}
		
		protected function getLifesToRule(value:int):Number
		{
			return value<0?Infinity:Number(value);
		}
		
		//Sheet
		public function buildSheet(keepTitle:Boolean=true):BatrMenuSheet
		{
			var sheet:BatrMenuSheet=new BatrMenuSheet(keepTitle);
			sheet.x=sheet.y=0;
			return sheet;
		}
		
		public function trunSheet():void
		{
			this.nowSheet=this._sheets[(this._sheets.indexOf(this._nowSheet)+1)%this.numSheet];
		}
		
		//Title
		public function animaShowMenu():void
		{
			this._isShowingMenu=true;
			startTitleTimer();
		}
		
		public function animaHideMenu():void
		{
			this._isShowingMenu=false;
			startTitleTimer();
		}
		
		protected function startTitleTimer():void
		{
			this._titleTimer.reset();
			this._titleTimer.addEventListener(TimerEvent.TIMER,onTitleTimerTick);
			this._titleTimer.addEventListener(TimerEvent.TIMER_COMPLETE,onTitleTimerComplete);
			this._titleTimer.start();
		}
		
		protected function onTitleTimerTick(event:TimerEvent):void
		{
			var percent:Number=this._titleTimer.currentCount/this._titleTimer.repeatCount;
			var forcePercent:Number=this._isShowingMenu?(1-percent):percent;
			this._title.y=(forcePercent*_TITLE_HIDE_Y+(1-forcePercent)*_TITLE_SHOW_Y);
		}
		
		protected function onTitleTimerComplete(event:TimerEvent):void
		{
			this._titleTimer.stop();
			this._titleTimer.removeEventListener(TimerEvent.TIMER,onTitleTimerTick);
			this._titleTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,onTitleTimerComplete);
			this.dispatchEvent(new MenuEvent(MenuEvent.TITLE_SHOWEN));
		}
		
		protected function onTranslationChange(E:TranslationsChangeEvent):void
		{
			
		}
		
		//GameRule Generation
		protected function getRuleFromMenu():GameRule
		{
			var rule:GameRule=this._subject.gameRule;
			try
			{
				//====Select====//
				//PlayerCount
				var playerCountSelecter:BatrSelecter=this._selecterListCustom.getSelecterByName(TranslationKey.PLAYER_COUNT);
				rule.playerCount=playerCountSelecter==null?4:playerCountSelecter.currentValue;
				//AIPlayerCount
				var AIPlayerCountSelecter:BatrSelecter=this._selecterListCustom.getSelecterByName(TranslationKey.AI_PLAYER_COUNT);
				rule.AICount=AIPlayerCountSelecter==null?6:AIPlayerCountSelecter.currentValue;
				//InitialMap(Map)
				var initialMapSelecter:BatrSelecter=this._selecterListCustom.getSelecterByName(TranslationKey.INITIAL_MAP);
				rule.initialMapID=initialMapSelecter==null?-1:initialMapSelecter.currentValue-1;
				//========Advanced========//
				//====Left====//
				//DefaultHealth
				var defaultHealthSelecter:BatrSelecter=this._selecterListAdvanced_L.getSelecterByName(TranslationKey.DEFAULT_HEALTH);
				rule.defaultHealth=defaultHealthSelecter==null?100:defaultHealthSelecter.currentValue;
				//DefaultMaxHealth
				var defaultMaxHealthSelecter:BatrSelecter=this._selecterListAdvanced_L.getSelecterByName(TranslationKey.DEFAULT_MAX_HEALTH);
				rule.defaultMaxHealth=defaultMaxHealthSelecter==null?100:defaultMaxHealthSelecter.currentValue;
				//DefaultLifesPlayer
				var defaultLifesSelecterP:BatrSelecter=this._selecterListAdvanced_L.getSelecterByName(TranslationKey.REMAIN_LIFES_PLAYER);
				rule.remainLifesPlayer=this.getLifesToRule(defaultLifesSelecterP==null?-1:defaultLifesSelecterP.currentValue);
				//DefaultLifesAI
				var defaultLifesSelecterA:BatrSelecter=this._selecterListAdvanced_L.getSelecterByName(TranslationKey.REMAIN_LIFES_AI);
				rule.remainLifesAI=this.getLifesToRule(defaultLifesSelecterA==null?-1:defaultLifesSelecterA.currentValue);
				//DefaultRespawnTime
				var defaultRespawnTimeSelecter:BatrSelecter=this._selecterListAdvanced_L.getSelecterByName(TranslationKey.RESPAWN_TIME);
				rule.defaultRespawnTime=defaultRespawnTimeSelecter.currentValue*GlobalGameVariables.TPS;
				//====Right====//
				//DefaultWeapon
				var defaultWeaponSelecter:BatrSelecter=this._selecterListAdvanced_R.getSelecterByName(TranslationKey.DEFAULT_WEAPON);
				rule.defaultWeaponID=defaultWeaponSelecter==null?-2:defaultWeaponSelecter.currentValue;
				//WeaponsNoCD
				var weaponsNoCDSelecter:BatrSelecter=this._selecterListAdvanced_R.getSelecterByName(TranslationKey.WEAPONS_NO_CD);
				rule.weaponsNoCD=weaponsNoCDSelecter.currentValue>0;
				//MapTransformTime
				var mapTransformTimeSelecter:BatrSelecter=this._selecterListAdvanced_R.getSelecterByName(TranslationKey.MAP_TRANSFORM_TIME);
				rule.mapTransformTime=mapTransformTimeSelecter.currentValue;
				//BonusBoxMaxCount
				var bonusBoxMaxCountSelecter:BatrSelecter=this._selecterListAdvanced_R.getSelecterByName(TranslationKey.MAX_BONUS_COUNT);
				rule.bonusBoxMaxCount=bonusBoxMaxCountSelecter.currentValue;
				//BonusBoxSpawnAfterDeath
				var bonusBoxSpawnAfterDeathSelecter:BatrSelecter=this._selecterListAdvanced_R.getSelecterByName(TranslationKey.BONUS_SPAWN_AFTER_DEATH);
				rule.bonusBoxSpawnAfterPlayerDeath=bonusBoxSpawnAfterDeathSelecter.currentValue>0;
				//AsphyxiaDamage
				var asphyxiaDamageSelecter:BatrSelecter=this._selecterListAdvanced_R.getSelecterByName(TranslationKey.ASPHYXIA_DAMAGE);
				rule.playerAsphyxiaDamage=asphyxiaDamageSelecter.currentValue;
			}
			catch(err:Error)
			{
				trace("Load GameRule Error:"+err.message);
			}
			return rule;
		}
		
		//Game Button
		protected function onContinueButtonClick(event:BatrGUIEvent):void
		{
			if(this.game.isLoaded) this._subject.trunToGame();
		}
		
		protected function onQuickGameButtonClick(event:BatrGUIEvent):void
		{
			this._subject.resetRule();
			this.game.forceStartGame(this.gameRule);
			this._subject.trunToGame();
		}
		
		protected function onSelectGameButtonClick(event:BatrGUIEvent):void
		{
			this.nowSheet=this._sheetSelect;
		}
		
		protected function onCustomModeButtonClick(event:BatrGUIEvent):void
		{
			
		}
		
		protected function onBackButtonClick(event:BatrGUIEvent):void
		{
			if(this._sheetHistory<1) return;
			this.setNowSheet(this._sheets[this.lastSheetHistory-1],false);
			this.popSheetHistory();
		}
		
		protected function onMapPreviewSwitch(event:BatrGUIEvent):void
		{
			var selecter:BatrSelecter=event.gui as BatrSelecter;
			if(selecter==null) return;
			var nowMapIndex:int=selecter.currentValue;
			//trace("Now Map ID: "+nowMapIndex);
		}
		
		protected function onSelectStartButtonClick(event:BatrGUIEvent):void
		{
			this.game.forceStartGame(this.getRuleFromMenu(),false);
			this._subject.trunToGame();
		}
		
		protected function onSelectAdvancedButtonClick(event:BatrGUIEvent):void
		{
			this.nowSheet=this._sheetAdvancedCustom;
		}
		
		protected function onMaxHealthSelecterClick(event:BatrGUIEvent):void
		{
			var healthSelecter:BatrSelecter=this._selecterListAdvanced_L.getSelecterByName(TranslationKey.DEFAULT_HEALTH) as BatrSelecter;
			var maxHealthSelecter:BatrSelecter=this._selecterListAdvanced_L.getSelecterByName(TranslationKey.DEFAULT_MAX_HEALTH) as BatrSelecter;
			if(healthSelecter==null&&maxHealthSelecter!=null) return;
			if(healthSelecter.currentValue>maxHealthSelecter.currentValue)
			{
				healthSelecter.context.intMax=maxHealthSelecter.currentValue;
				healthSelecter.updateTextByContext();
			}
		}
		
		protected function onLanguageChange(event:BatrGUIEvent):void
		{
			this.subject.trunTranslationsTo(Translations.getTranslationFromID(this._languageSelecter.currentValue));
		}
	}
}