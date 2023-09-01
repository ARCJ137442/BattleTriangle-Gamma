package batr.game.main 
{
	import batr.common.*;
	import batr.general.*;
	import batr.game.stat.*;
	
	import batr.game.block.*;
	import batr.game.block.blocks.*;
	
	import batr.game.effect.*;
	import batr.game.effect.effects.*;
	
	import batr.game.entity.*;
	import batr.game.entity.objects.*;
	import batr.game.entity.entities.*;
	import batr.game.entity.entities.players.*;
	import batr.game.entity.entities.projectiles.*;
	
	import batr.game.main.*;
	import batr.game.map.*;
	import batr.game.map.main.*;
	import batr.game.model.*;
	import batr.game.events.*;
	
	import batr.menu.events.*;
	import batr.menu.main.*;
	import batr.menu.objects.*;
	
	import batr.main.*;
	import batr.fonts.*;
	import batr.translations.*;
	
	import flash.display.*;
	import flash.text.*;
	import flash.utils.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.system.fscommand;
	
	public class Game extends Sprite
	{
		//============Static Variables============//
		public static const ALL_MAPS:Vector.<IMap>=new <IMap>[
			Map_V1.EMPTY,
			Map_V1.FRAME,
			Map_V1.MAP_1,
			Map_V1.MAP_2,
			Map_V1.MAP_3,
			Map_V1.MAP_4,
			Map_V1.MAP_5,
			Map_V1.MAP_6,
			Map_V1.MAP_7,
			Map_V1.MAP_8,
			Map_V1.MAP_9,
			Map_V1.MAP_A,
			Map_V1.MAP_B,
			Map_V1.MAP_C,
			Map_V1.MAP_D,
			Map_V1.MAP_E,
			Map_V1.MAP_F,
			Map_V1.MAP_G
		]
		
		public static const MAP_TRANSFORM_TEXT_FORMAT:TextFormat=new TextFormat(
			new MainFont().fontName,
			GlobalGameVariables.DEFAULT_SIZE*5/8,
			0x3333ff,
			true,
			null,
			null,
			null,
			null,
			TextFormatAlign.LEFT)
		
		public static const GAME_PLAYING_TIME_TEXT_FORMET:TextFormat=new TextFormat(
			new MainFont().fontName,
			GlobalGameVariables.DEFAULT_SIZE*5/8,
			0x66ff66,
			true,
			null,
			null,
			null,
			null,
			TextFormatAlign.LEFT)
		
		public static var debugMode:Boolean=false
		
		//============Static Getter And Setter============//
		public static function get VALID_MAP_COUNT():int
		{
			return Game.ALL_MAPS.length;
		}
		
		//============Static Functions============//
		public static function getMapFromID(id:int):IMap
		{
			if(id>=0&&id<Game.VALID_MAP_COUNT) return Game.ALL_MAPS[id];
			return null;
		}
		
		public static function getIDFromMap(map:IMap):int
		{
			return Game.ALL_MAPS.indexOf(map);
		}
		
		//Tools
		public static function joinNamesFromPlayers(players:Vector.<Player>):String
		{
			var result:String="";
			for(var i:uint=0;i<players.length;i++)
			{
				if(players[i]==null) result+="NULL";
				else result+=players[i].customName;
				if(i<players.length-1) result+=",";
			}
			return result;
		}
		
		//============Instance Variables============//
		//General
		/**
		 * The reference of Subject
		 */
		protected var _subject:BatrSubject
		protected var _map:IMap
		
		/**
		 * Internal GameRule copy from Subject
		 */
		protected var _rule:GameRule
		
		protected var _stat:GameStats
		
		//BackGround
		protected var _backGround:BackGround=new BackGround(0,0,true,false,true)
		
		//System
		protected var _entitySystem:EntitySystem
		protected var _effectSystem:EffectSystem
		
		//Map
		protected var _mapDisplayerBottom:IMapDisplayer=new MapDisplayer()
		protected var _mapDisplayerMiddle:IMapDisplayer=new MapDisplayer()
		protected var _mapDisplayerTop:IMapDisplayer=new MapDisplayer()
		
		//Players
		protected var _playerGUIContainer:Sprite=new Sprite()
		protected var _playerContainer:Sprite=new Sprite()
		protected var _projectileContainer:Sprite=new Sprite()
		protected var _bonusBoxContainer:Sprite=new Sprite()
		
		//Effects
		protected var _effectContainerBottom:Sprite=new Sprite()
		protected var _effectContainerMiddle:Sprite=new Sprite()
		protected var _effectContainerTop:Sprite=new Sprite()
		
		//Global
		protected var _isActive:Boolean;
		protected var _isLoaded:Boolean;
		protected var _tickTimer:Timer=new Timer(GlobalGameVariables.TICK_TIME_MS);
		//protected var _secondTimer:Timer=new Timer(1000);//When a timer stop and start the timer will lost its phase.
		protected var _speed:Number;
		
		//Frame Complement
		protected var _lastTime:int;
		protected var _timeDistance:uint;
		protected var _expectedFrames:uint;
		protected var _enableFrameComplement:Boolean;
		
		//Temp
		protected var _tempUniformWeapon:WeaponType
		protected var _tempMapTransformSecond:uint
		//protected var _tempTimer:int=getTimer();
		protected var _tempSecordPhase:uint=0;
		protected var _second:uint;
		protected var _temp_game_rate:Number=0.0;
		
		//HUD
		protected var _globalHUDContainer:Sprite=new Sprite()
		
		protected var _mapTransformTimeText:BatrTextField=BatrTextField.fromKey(null,null)
		protected var _gamePlayingTimeText:BatrTextField=BatrTextField.fromKey(null,null)
		
		//============Constructor Function============//
		public function Game(subject:BatrSubject,active:Boolean=false):void
		{
			super();
			this._subject=subject;
			this._entitySystem=new EntitySystem(this);
			this._effectSystem=new EffectSystem(this);
			this.initDisplay();
			this.isActive=active;
			this.addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
		}
		
		//============Instance Getter And Setter============//
		//======Main Getters======//
		public function get subject():BatrSubject
		{
			return this._subject;
		}
		
		public function get menu():Menu
		{
			return this._subject.menuObj;
		}
		
		public function get rule():GameRule
		{
			return this._rule;
		}
		
		public function get translations():Translations
		{
			return this._subject.translations;
		}
		
		public function get isActive():Boolean
		{
			return this._isActive;
		}
		
		public function set isActive(value:Boolean):void
		{
			if(value==this._isActive) return;
			this._isActive=value;
			if(value)
			{
				//Key
				this.stage.addEventListener(KeyboardEvent.KEY_DOWN,onGameKeyDown);
				this.stage.addEventListener(KeyboardEvent.KEY_UP,onGameKeyUp);
				//Timer
				this._tickTimer.addEventListener(TimerEvent.TIMER,this.onGameTick);
				this._tickTimer.start();
				//this._secondTimer.addEventListener(TimerEvent.TIMER,this.dealSecond);
				//this._secondTimer.start();
				//lastTime
				this._lastTime=getTimer();
			}
			else
			{
				//Key
				this.stage.removeEventListener(KeyboardEvent.KEY_DOWN,onGameKeyDown);
				this.stage.removeEventListener(KeyboardEvent.KEY_UP,onGameKeyUp);
				//Timer
				this._tickTimer.removeEventListener(TimerEvent.TIMER,this.onGameTick);
				this._tickTimer.stop();
				//this._secondTimer.removeEventListener(TimerEvent.TIMER,this.dealSecond);
				//this._secondTimer.stop();
			}
		}
		
		public function get visibleHUD():Boolean
		{
			return this._globalHUDContainer.visible;
		}
		
		public function set visibleHUD(value:Boolean):void
		{
			this._globalHUDContainer.visible=value;
		}
		
		public function get isLoaded():Boolean
		{
			return this._isLoaded;
		}
		
		public function get speed():Number
		{
			return this._speed;
		}
		
		public function set speed(value:Number):void
		{
			this._speed=value;
		}
		
		public function get enableFrameComplement():Boolean
		{
			return this._enableFrameComplement;
		}
		
		public function set enableFrameComplement(value:Boolean):void
		{
			this._enableFrameComplement=value;
		}
		
		//======Entity Getters======//
		public function get playerContainer():Sprite
		{
			return this._playerContainer;
		}
		
		public function get projectileContainer():Sprite
		{
			return this._projectileContainer;
		}
		
		public function get bonusBoxContainer():Sprite
		{
			return this._bonusBoxContainer;
		}
		
		public function get playerGUIContainer():Sprite
		{
			return this._playerGUIContainer;
		}
		
		public function get effectContainerBottom():Sprite
		{
			return this._effectContainerBottom;
		}
		
		public function get effectContainerTop():Sprite
		{
			return this._effectContainerTop;
		}
		
		public function get entitySystem():EntitySystem
		{
			return this._entitySystem;
		}
		
		public function get effectSystem():EffectSystem
		{
			return this._effectSystem;
		}
		
		//======Map Getters======//
		public function get map():IMap
		{
			return this._map;
		}
		
		public function get mapWidth():uint
		{
			return this._map.mapWidth;
		}
		
		public function get mapHeight():uint
		{
			return this._map.mapHeight;
		}
		
		public function get mapTransformPeriod():uint
		{
			return this._rule.mapTransformTime;
		}
		
		public function set mapVisible(value:Boolean):void
		{
			if(this._mapDisplayerBottom as DisplayObject!=null) (this._mapDisplayerBottom as DisplayObject).visible=value;
			if(this._mapDisplayerMiddle as DisplayObject!=null) (this._mapDisplayerMiddle as DisplayObject).visible=value;
			if(this._mapDisplayerTop as DisplayObject!=null) (this._mapDisplayerTop as DisplayObject).visible=value;
		}
		
		public function set entityAndEffectVisible(value:Boolean):void
		{
			this._effectContainerTop.visible=this._effectContainerMiddle.visible=this._effectContainerBottom.visible=this._bonusBoxContainer.visible=this._playerGUIContainer.visible=this._playerContainer.visible=value;
		}
		
		//========Game AI Interface========//
		public function get allAvaliableBonusBox():Vector.<BonusBox>
		{
			return this.entitySystem.bonusBoxes;
		}
		
		public function getBlockPlayerDamage(x:int,y:int):int
		{
			var blockAtt:BlockAttributes=this._map.getBlockAttributes(x,y);
			if(blockAtt!=null) return blockAtt.playerDamage;
			return 0;
		}
		
		public function isKillZone(x:int,y:int):Boolean
		{
			var blockAtt:BlockAttributes=this._map.getBlockAttributes(x,y);
			if(blockAtt!=null) return blockAtt.playerDamage==int.MAX_VALUE;
			return false;
		}
		
		//============Instance Functions============//
		//========About Game End========//
		/**
		 * Condition: Only one team's player alive.
		 */
		protected function isPlayersEnd(players:Vector.<Player>):Boolean
		{
			if(this.rule.playerCount+this.rule.AICount<2) return false;
			var team:PlayerTeam=null;
			for each(var player:Player in players)
			{
				if(team==null) team=player.team;
				else if(player.team!=team) return false;
			}
			return true;
		}
		
		public function getAlivePlayers():Vector.<Player>
		{
			var result:Vector.<Player>=new Vector.<Player>();
			for each(var player:Player in this._entitySystem.players)
			{
				if(player==null) continue;
				if(!player.isCertainlyOut) result.push(player);
			}
			return result;
		}
		
		public function getInMapPlayers():Vector.<Player>
		{
			var result:Vector.<Player>=new Vector.<Player>();
			for each(var player:Player in this._entitySystem.players)
			{
				if(player==null) continue;
				if(player.health>0&&!(player.isRespawning||this.isOutOfMap(player.entityX,player.entityY))) result.push(player);
			}
			return result;
		}
		
		public function testGameEnd(force:Boolean=false):void
		{
			var alivePlayers:Vector.<Player>=this.getAlivePlayers();
			if(this.isPlayersEnd(alivePlayers)||force)
			{
				//if allowTeamVictory=false,reset team colors
				if(!force&&alivePlayers.length>1&&!this.rule.allowTeamVictory)
				{
					this.resetPlayersTeamInDifferent(alivePlayers);
				}
				//Game End with winners
				else this.onGameEnd(alivePlayers);
			}
		}
		
		protected function resetPlayersTeamInDifferent(players:Vector.<Player>):void
		{
			var tempTeamIndex:uint=exMath.random(this.rule.playerTeams.length);
			for each(var player:Player in players)
			{
				player.team=this.rule.playerTeams[tempTeamIndex];
				tempTeamIndex=(tempTeamIndex+1)%this.rule.playerTeams.length;
			}
		}
		
		protected function onGameEnd(winners:Vector.<Player>):void
		{
			this.subject.pauseGame();
			this.subject.gotoMenu();
			this.subject.menuObj.loadResult(this.getGameResult(winners));
		}
		
		protected function getGameResult(winners:Vector.<Player>):GameResult
		{
			var result:GameResult=new GameResult(this,
				this.getResultMessage(winners),
				this._stat
			);
			return result;
		}
		
		protected function getResultMessage(winners:Vector.<Player>):TranslationalText
		{
			if(winners.length<1)
			{
				return new TranslationalText(this.translations,TranslationKey.NOTHING_WIN);
			}
			else if(winners.length==this.rule.playerCount+this.rule.AICount)
			{
				return new TranslationalText(this.translations,TranslationKey.WIN_ALL_PLAYER);
			}
			else if(winners.length>3)
			{
				return new FixedTranslationalText(
					this.translations,
					TranslationKey.WIN_PER_PLAYER,
					winners.length.toString()
					);
			}
			else
			{
				return new FixedTranslationalText(
					this.translations,
					winners.length>1?TranslationKey.WIN_MULTI_PLAYER:TranslationKey.WIN_SIGNLE_PLAYER,
					joinNamesFromPlayers(winners)
					);
			}
		}
		
		//====Functions About Init====//
		protected function onAddedToStage(E:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
			//this.addEventListener(Event.ENTER_FRAME,onEnterFrame);
			this.subject.addEventListener(TranslationsChangeEvent.TYPE,this.onTranslationsChange);
			this.addChilds();
		}
		
		protected function initDisplay():void
		{
			//HUD Text
			this._mapTransformTimeText.setBlockPos(0,23);
			this._mapTransformTimeText.defaultTextFormat=MAP_TRANSFORM_TEXT_FORMAT;
			this._mapTransformTimeText.selectable=false;
			this._gamePlayingTimeText.setBlockPos(0,0);
			this._gamePlayingTimeText.defaultTextFormat=GAME_PLAYING_TIME_TEXT_FORMET;
			this._gamePlayingTimeText.selectable=false;
			//Initial HUD visible
			this.visibleHUD=false;
		}
		
		protected function addChilds():void
		{
			this.addChild(this._backGround)
			this.addChild(this._effectContainerBottom);
			this.addChild(this._mapDisplayerBottom as DisplayObject);
			this.addChild(this._bonusBoxContainer);
			this.addChild(this._effectContainerMiddle);
			this.addChild(this._playerContainer);
			this.addChild(this._mapDisplayerMiddle as DisplayObject);
			this.addChild(this._projectileContainer);
			this.addChild(this._mapDisplayerTop as DisplayObject);
			this.addChild(this._effectContainerTop);
			this.addChild(this._playerGUIContainer);
			this.addChild(this._globalHUDContainer)
			this._globalHUDContainer.addChild(this._mapTransformTimeText);
			this._globalHUDContainer.addChild(this._gamePlayingTimeText);
		}
		
		//====Functions About Game Global Running====//
		public function load(rule:GameRule,becomeActive:Boolean=false):Boolean
		{
			//Check
			if(this._isLoaded) return false;
			//Update
			this._rule=rule;
			this.loadMap(true,true,false);
			this.updateMapSize(true);
			this._isLoaded=true;
			this._tempUniformWeapon=this._rule.randomWeaponEnable;
			this._tempMapTransformSecond=this.mapTransformPeriod;
			this._speed=1;
			//Create
			this.spawnPlayersByRule();
			//Timer
			this._tickTimer.reset();
			//this._tempTimer=getTimer();
			this._tempSecordPhase=0;
			this._second=0;
			this.updateGUIText();
			//Stats
			this._stat=new GameStats(this._rule,this.entitySystem.players);
			//Listen
			this._rule.addEventListener(GameRuleEvent.TEAMS_CHANGE,this.onPlayerTeamsChange);
			//Active
			if(becomeActive) this.isActive=true;
			//Return
			return true;
		}
		
		public function clearGame():Boolean
		{
			//Check
			if(!this._isLoaded) return false;
			//Listen
			this._rule.removeEventListener(GameRuleEvent.TEAMS_CHANGE,this.onPlayerTeamsChange);
			//Global
			this.isActive=false;
			this._isLoaded=false;
			this._rule=null;
			this._stat=null;
			//Map
			this._map.deleteSelf();
			this._map=null;
			this.forceMapDisplay();
			this.updateMapSize(false);
			this.removeAllPlayer(false);
			//Entity
			this._entitySystem.removeAllEntity();//NonPlayer Entity
			//Effect
			this._effectSystem.removeAllEffect();
			//Return
			return true;
		}
		
		public function restartGame(rule:GameRule,becomeActive:Boolean=false):void
		{
			this.clearGame();
			this.load(rule,becomeActive);
		}
		
		public function forceStartGame(rule:GameRule,becomeActive:Boolean=false):Boolean
		{
			return (this._isLoaded?this.restartGame:this.load)(rule,becomeActive);
		}
		
		public function dealGameTick():void
		{
			//=====Ticking=====//
			this._tempSecordPhase+=this._tickTimer.delay;
			if(this._tempSecordPhase>=1000)
			{
				this._tempSecordPhase-=1000;
				this._second++;
				this.dealSecond();
			}
			//=====Entity TickRun=====//
			for each(var entity:EntityCommon in this._entitySystem.entities)
			{
				if(entity!=null)
				{
					if(entity.isActive)
					{
						entity.tickFunction()
					}
				}
				else
				{
					this._entitySystem.GC()
				}
			}
			//=====Player TickRun=====//
			for each(var player:Player in this._entitySystem.players)
			{
				if(player!=null)
				{
					//Respawn About
					if(player.infinityLife||player.lifes>0)
					{
						if(!player.isActive&&player.respawnTick>=0)
						{
							player.dealRespawn()
						}
					}
				}
			}
			//=====Effect TickRun=====//
			for each(var effect:EffectCommon in this._effectSystem.effects)
			{
				if(effect!=null)
				{
					if(effect.isActive)
					{
						effect.onEffectTick()
					}
				}
				else
				{
					this._effectSystem.GC()
				}
			}
			//=====Random Tick=====//
			this.onRandomTick(this._map.randomX,this._map.randomY)
		}
		
		//====Listener Functions====//
		/*protected function onEnterFrame(E:Event):void
		{
			//Reset
			this._tempTimer=getTimer();
		}*/
		
		protected function onGameTick(E:Event):void
		{
			var i:Number=this._speed
			//Frame Complement
			if(this._enableFrameComplement)
			{
				//Ranging
				this._timeDistance=getTimer()-this._lastTime;
				//Computing<Experimental>
				this._expectedFrames=this._timeDistance/GlobalGameVariables.TICK_TIME_MS;
				if(this._expectedFrames>1) trace("this._expectedFrames>1! value=",this._expectedFrames,"distance=",this._timeDistance)
				i=this._expectedFrames*this._speed;
				//Synchronize
				this._lastTime+=this._expectedFrames*GlobalGameVariables.TICK_TIME_MS;//this._timeDistance;
			}
			//i end at 0
			this._temp_game_rate+=i;
			while(this._temp_game_rate>=1){
				this._temp_game_rate--;
				this.dealGameTick();
			}
		}
		
		public function refreshLastTime():void
		{
			this._lastTime=getTimer();
			this._timeDistance=this._expectedFrames=0;
		}
		
		protected function dealSecond():void
		{
			//=====Map Transform=====//
			if(this.mapTransformPeriod>0)
			{
				this._mapTransformTimeText.visible=true;
				if((this._tempMapTransformSecond--)==0)
				{
					this._tempMapTransformSecond=this.mapTransformPeriod;
					this.transformMap();
				}
			}
			//=====Update Text=====//
			this.updateGUIText();
			//this._secondTimer.delay=1000;
		}
		
		protected function updateGUIText():void
		{
			if(this.translations==null||this.rule==null) return;
			this._mapTransformTimeText.setText(
				Translations.getTranslation(
					this.translations,
					TranslationKey.REMAIN_TRANSFORM_TIME
				)+"\u003a\u0020"+this._tempMapTransformSecond+
				"\u002f"+this.rule.mapTransformTime
			);
			this._gamePlayingTimeText.setText(
				Translations.getTranslation(
					this.translations,
					TranslationKey.GAME_DURATION
				)+"\u003a\u0020"+this._second);
			this._mapTransformTimeText.visible=this.rule.mapTransformTime>0;
		}
		
		protected function onTranslationsChange(event:Event):void
		{
			this.updateGUIText();
		}
		
		protected function onGameKeyDown(E:KeyboardEvent):void
		{
			var code:uint=E.keyCode;
			var ctrl:Boolean=E.ctrlKey;
			var alt:Boolean=E.altKey;
			var shift:Boolean=E.shiftKey;
			//End Game
			if(shift&&code==KeyCode.ESC)
			{
				fscommand("quit");
				return;
			}
			//Player Contol
			this.dealKeyDownWithPlayers(E.keyCode,true);
		}
		
		protected function onGameKeyUp(E:KeyboardEvent):void
		{
			//Player Contol
			dealKeyDownWithPlayers(E.keyCode,false);
		}
		
		protected function dealKeyDownWithPlayers(code:uint,isKeyDown:Boolean):void
		{
			if(this._entitySystem.playerCount>0)
			{
				for each(var player:Player in this._entitySystem.players)
				{
					//Detect - NOT USE:if(player.isRespawning) continue;
					//Initial Action
					if(isKeyDown&&!player.isOwnKeyDown(code))
					{
						player.runActionByKeyCode(code);
					}
					//Set Rot
					switch(code)
					{
						case player.contolKey_Up:
							player.pressUp=isKeyDown;
							break;
						case player.contolKey_Down:
							player.pressDown=isKeyDown;
							break;
						case player.contolKey_Left:
							player.pressLeft=isKeyDown;
							break;
						case player.contolKey_Right:
							player.pressRight=isKeyDown;
							break;
						case player.contolKey_Use:
							player.pressUse=isKeyDown;
							break;/*
						case player.contolKey_Select_Left:
							player.pressLeftSelect=isKeyDown;
							break;
						case player.contolKey_Select_Right:
							player.pressRightSelect=isKeyDown;
							break;*/
					}
				}
			}
		}
		
		public function onStageResize(E:Event):void
		{
			
		}
		
		//====Functions About Gameplay====//
		/**
		 * @param	x	The position x.
		 * @param	y	The position y.
		 * @param	asPlayer	Judge as player
		 * @param	asBullet	Judge as Bullet
		 * @param	asLaser	Judge as Laser
		 * @param	includePlayer	Avoidplayer(returns false)
		 * @param	avoidHurting	Avoidharmful block(returns false)
		 * @return	true if can pass.
		 */
		public function testCanPass(x:Number,y:Number,asPlayer:Boolean,asBullet:Boolean,asLaser:Boolean,includePlayer:Boolean=true,avoidHurting:Boolean=false):Boolean
		{
			return testIntCanPass(PosTransform.alignToGrid(x),PosTransform.alignToGrid(y),asPlayer,asBullet,asLaser,includePlayer,avoidHurting);
		}
		
		public function testIntCanPass(x:int,y:int,asPlayer:Boolean,asBullet:Boolean,asLaser:Boolean,includePlayer:Boolean=true,avoidHurting:Boolean=false):Boolean
		{
			//Debug: trace("testCanPass:"+arguments+";"+this.getBlockAttributes(x,y).bulletCanPass,isHitAnyPlayer(x,y))
			var mapX:int=this.lockPosInMap(x,true)
			var mapY:int=this.lockPosInMap(y,false)
			//if(isOutOfMap(gridX,gridY)) return true
			var attributes:BlockAttributes=this.getBlockAttributes(mapX,mapY)
			if(avoidHurting&&attributes.playerDamage>-1) return false
			if(asPlayer&&!attributes.playerCanPass) return false
			if(asBullet&&!attributes.bulletCanPass) return false
			if(asLaser&&!attributes.laserCanPass) return false
			if(includePlayer&&isHitAnyPlayer(mapX,mapY)) return false
			return true
		}
		
		/**
		 * return testCanPass in player's front position.
		 */
		public function testFrontCanPass(entity:EntityCommon,distance:Number,asPlayer:Boolean,asBullet:Boolean,asLaser:Boolean,includePlayer:Boolean=true,avoidTrap:Boolean=false):Boolean
		{
			//Debug: trace("testFrontCanPass:"+entity.type.name+","+entity.getFrontX(distance)+","+entity.getFrontY(distance))
			return testCanPass(entity.getFrontX(distance),
							   entity.getFrontY(distance),
							   asPlayer,asBullet,asLaser,
							   includePlayer,avoidTrap)
		}
		
		public function testBonusBoxCanPlaceAt(x:int,y:int):Boolean
		{
			return this.testIntCanPass(x,y,true,false,false,true,true);
		}
		
		/**
		 * return testCanPass as player in other position.
		 */
		public function testPlayerCanPass(player:Player,x:int,y:int,includePlayer:Boolean=true,avoidHurting:Boolean=false):Boolean
		{
			//Debug: trace("testPlayerCanPass:"+player.customName+","+x+","+y+","+includePlayer)
			//Define
			var gridX:int=this.lockIntPosInMap(x,true)
			var gridY:int=this.lockIntPosInMap(y,false)
			var attributes:BlockAttributes=this.getBlockAttributes(gridX,gridY)
			//Test
			//if(isOutOfMap(gridX,gridY)) return true
			if(avoidHurting&&attributes.playerDamage>-1) return false
			if(!attributes.playerCanPass) return false
			if(includePlayer&&isHitAnyPlayer(gridX,gridY)) return false
			return true
		}
		
		public function testFullPlayerCanPass(player:Player,x:int,y:int,oldX:int,oldY:int,includePlayer:Boolean=true,avoidHurting:Boolean=false):Boolean
		{
			//Debug: trace("testFullPlayerCanPass:"+player.customName+","+x+","+y+","+oldX+","+oldY+","+includePlayer)
			//Target can pass
			if(!testPlayerCanPass(player,x,y,includePlayer,avoidHurting)) return false;
			//Test Whether OldBlock can Support
			//if(!testPlayerCanPass(player,oldX,oldY,includePlayer,avoidHurting)) return false;//don't support
			return true
		}
		
		public function testPlayerCanPassToFront(player:Player,rotatedAsRot:uint=5,includePlayer:Boolean=true,avoidTrap:Boolean=false):Boolean
		{
			return this.testFullPlayerCanPass(player,
											  PosTransform.alignToGrid(player.getFrontIntX(player.moveDistence,rotatedAsRot)),
											  PosTransform.alignToGrid(player.getFrontIntY(player.moveDistence,rotatedAsRot)),
											  player.gridX,player.gridY,
											  includePlayer,avoidTrap)
		}
		
		public function testCarryableWithMap(blockAtt:BlockAttributes,map:IMap):Boolean
		{
			return blockAtt.isCarryable&&!(map.isArenaMap&&blockAtt.unbreakableInArenaMap);
		}
		
		public function testBreakableWithMap(blockAtt:BlockAttributes,map:IMap):Boolean
		{
			return blockAtt.isBreakable&&!(map.isArenaMap&&blockAtt.unbreakableInArenaMap);
		}
		
		public function weaponCreateExplode(x:Number,y:Number,finalRadius:Number,
											damage:uint,projectile:ProjectileCommon,
											color:uint,edgePercent:Number=1):void
		{
			//Operate
			var creater:Player=projectile.owner;
			//Effect
			this._effectSystem.addEffect(new EffectExplode(this,x,y,finalRadius,color));
			//Hurt Player
			var distanceP:Number;
			for each(var player:Player in this._entitySystem.players)
			{
				if(player==null) continue;
				distanceP=exMath.getDistanceSquare(x,y,player.entityX,player.entityY)/(finalRadius*finalRadius);
				if(distanceP<=1)
				{
					//Operate damage by percent
					if(edgePercent<1) damage*=edgePercent+(distanceP*(1-edgePercent));
					if(projectile==null||
						(creater==null||creater.canUseWeaponHurtPlayer(player,projectile.currentWeapon)))
						{
							//Hurt With FinalDamage
							player.finalRemoveHealth(creater,projectile.currentWeapon,damage);
						}
				}
			}
		}
		
		public function laserHurtPlayers(laser:LaserBasic):void
		{
			//Set Variables
			var attacker:Player=laser.owner
			var damage:uint=laser.damage
			var length:uint=laser.length
			var rot:uint=laser.rot
			var teleport:Boolean=laser is LaserTeleport
			var absorption:Boolean=laser is LaserAbsorption
			var pulse:Boolean=laser is LaserPulse
			//Pos
			var baseX:int=PosTransform.alignToGrid(laser.entityX)
			var baseY:int=PosTransform.alignToGrid(laser.entityY)
			var vx:int=GlobalRot.towardXInt(rot,1)
			var vy:int=GlobalRot.towardYInt(rot,1)
			var cx:int=baseX,cy:int=baseY,players:Vector.<Player>
			//var nextBlockAtt:BlockAttributes
			//Damage
			laser.isDamaged=true
			var finalDamage:uint;
			for(var i:uint=0;i<length;i++)
			{
				//nextBlockAtt=this.getBlockAttributes(cx+vx,cy+vy);
				players=getHitPlayers(cx,cy)
				for each(var victim:Player in players)
				{
					if(victim==null) continue
					//Operate
					finalDamage=attacker==null?damage:victim.operateFinalDamage(attacker,laser.currentWeapon,damage);
					//Effects
					if(attacker==null||attacker.canUseWeaponHurtPlayer(victim,laser.currentWeapon))
					{
						//Damage
						victim.removeHealth(finalDamage,attacker)
						//Absorption
						if(attacker!=null&&!attacker.isRespawning&&absorption)
							attacker.heal+=damage;
					}
					if(victim!=attacker&&!victim.isRespawning)
					{
						if(teleport)
						{
							spreadPlayer(victim);
						}
						if(pulse)
						{
							if((laser as LaserPulse).isPull)
							{
								if(this.testCanPass(cx-vx,cy-vy,true,false,false,true,false))
									victim.addXY(-vx,-vy);
							}
							else if(this.testCanPass(cx+vx,cy+vy,true,false,false,true,false))
								victim.addXY(vx,vy);
						}
					}
				}
				cx+=vx;cy+=vy;
			}
		}
		
		public function waveHurtPlayers(wave:Wave):void
		{
			//Set Variables
			var attacker:Player=wave.owner
			var damage:uint=wave.damage
			var scale:Number=wave.finalScale
			var rot:uint=wave.rot
			//Pos
			var baseX:Number=wave.entityX
			var baseY:Number=wave.entityY
			var radius:Number=scale
			for each(var victim:Player in this._entitySystem.players)
			{
				if(victim==null) continue;
				//FinalDamage
				if(attacker==null||attacker.canUseWeaponHurtPlayer(victim,wave.currentWeapon))
				{
					if(exMath.getDistance(baseX,baseY,victim.entityX,victim.entityY)<=radius)
					{
						victim.finalRemoveHealth(attacker,wave.currentWeapon,damage);
					}
				}
			}
		}
		
		public function throwedBlockHurtPlayer(block:ThrowedBlock):void
		{
			var attacker:Player=block.owner;
			var damage:uint=block.damage;
			for each(var victim:Player in this._entitySystem.players)
			{
				if(victim==null) continue;
				//FinalDamage
				if(attacker==null||attacker.canUseWeaponHurtPlayer(victim,block.currentWeapon))
				{
					if(victim.gridX==block.gridX&&victim.gridY==block.gridY)
					{
						victim.finalRemoveHealth(attacker,block.currentWeapon,damage);
					}
				}
			}
		}
		
		public function lightningHurtPlayers(lightning:Lightning,players:Vector.<Player>,damages:Vector.<uint>):void
		{
			var p:Player,d:uint;
			for(var i:* in players)
			{
				p=players[i];
				d=damages[i];
				if(p!=null) p.finalRemoveHealth(lightning.owner,lightning.currentWeapon,d);
			}
		}
		
		public function moveInTestWithEntity():void
		{
			//All Player
			for each(var player:Player in this._entitySystem.players)
			{
				player.dealMoveInTest(player.entityX,player.entityY,true,false)
			}
			//BonusBox Displace by Asphyxia/Trap
			for(var i:int=this._entitySystem.bonusBoxCount-1;i>=0;i--)
			{
				var box:BonusBox=this._entitySystem.bonusBoxes[i];
				if(box!=null&&!testCanPass(box.entityX,box.entityY,true,false,false,false,true))
				{
					this._entitySystem.removeBonusBox(box)
				}
			}
		}
		
		/** 
		 * Execute when Player Move in block
		 */
		public function moveInTestPlayer(player:Player,isLocationChange:Boolean=false):Boolean
		{
			if(!player.isActive) return false;
			var x:int=player.gridX;
			var y:int=player.gridY;
			var type:BlockType=this.getBlockType(player.gridX,player.gridY);
			var attributes:BlockAttributes=BlockAttributes.fromType(type);
			var returnBoo:Boolean=false;
			if(attributes!=null)
			{
				if(attributes.playerDamage==-1)
				{
					player.removeHealth(this.operateFinalPlayerHurtDamage(player,x,y,this.rule.playerAsphyxiaDamage),null);
					returnBoo=true;
				}
				else if(attributes.playerDamage>-1)
				{
					player.removeHealth(this.operateFinalPlayerHurtDamage(player,x,y,attributes.playerDamage),null);
					returnBoo=true;
				}
				else if(attributes.playerDamage==-2)
				{
					if(!isLocationChange)
					{
						if(!player.isFullHealth) player.addHealth(1);
						else player.heal++;
						returnBoo=true;
					}
				}
				if(attributes.rotateWhenMoveIn)
				{
					player.rot=GlobalRot.randomWithout(player.rot);
					returnBoo=true;
				}
			}
			return returnBoo;
		}
		
		/**
		 * Operate damage to player by blockAtt.playerDamage,
		 * int.MAX_VALUE -> uint.MAX_VALUE
		 * [...-2) -> 0
		 * -1 -> uint.MAX_VALUE
		 * [0,100] -> player.maxHealth*playerDamage/100
		 * (100...] -> playerDamage-100
		 * @return	The damage.
		 */
		public function operateFinalPlayerHurtDamage(player:Player,x:int,y:int,playerDamage:int):uint
		{
			if(playerDamage<-1) return 0;
			if(playerDamage==-1) return this.rule.playerAsphyxiaDamage;
			if(playerDamage==int.MAX_VALUE) return uint.MAX_VALUE;
			if(playerDamage<=100) return player.maxHealth*playerDamage/100;
			return playerDamage-100;
		}
		
		/** 
		 * Execute when Player Move out block
		 * @param	x	the old X
		 * @param	y	the old Y
		 */
		public function moveOutTestPlayer(player:Player,x:int,y:int,isLocationChange:Boolean=false):void
		{
			if(!player.isActive) return;
			var type:BlockType=this.getBlockType(x,y);
			if(type==BlockType.GATE_OPEN)
			{
				this.setBlock(x,y,BlockCommon.fromType(BlockType.GATE_CLOSE))
			}
		}
		
		/**
		 * Function about Player pickup BonusBox
		 */
		public function bonusBoxTest(player:Player,x:Number=NaN,y:Number=NaN):Boolean
		{
			if(!player.isActive) return false;
			x=isNaN(x)?player.gridX:x;
			y=isNaN(y)?player.gridY:y;
			for each(var bonusBox:BonusBox in this._entitySystem.bonusBoxes)
			{
				if(this.hitTestPlayer(player,bonusBox.gridX,bonusBox.gridY))
				{
					bonusBox.onPlayerPickup(player);
					player.onPickupBonusBox(bonusBox);
					this.testGameEnd();
					return true;
				}
			}
			return false;
		}
		
		//====Functions About Map====//
		public function hasBlock(x:int,y:int):Boolean
		{
			return this._map.hasBlock(x,y);
		}
		
		public function getBlock(x:int,y:int):BlockCommon
		{
			return this._map.getBlock(x,y);
		}
		
		public function getBlockAttributes(x:int,y:int):BlockAttributes
		{
			return this._map.getBlockAttributes(x,y);
		}
		
		public function getBlockType(x:int,y:int):BlockType
		{
			return this._map.getBlockType(x,y);
		}
		
		/**
		 * Set Block in map,and update Block in map displayer.
		 * @param	x	the Block position x.
		 * @param	y	the Block position y.
		 * @param	block	the current Block.
		 */
		public function setBlock(x:int,y:int,block:BlockCommon):void
		{
			this._map.setBlock(x,y,block);
			this.onBlockUpdate(x,y,block);
		}
		
		public function isVoid(x:int,y:int):Boolean
		{
			return this._map.isVoid(x,y)
		}
		
		/**
		 * Set voidin map,and clear Block in map displayer.
		 * @param	x	the voidposition x.
		 * @param	y	the voidposition y.
		 */
		public function setVoid(x:int,y:int):void
		{
			this._map.setVoid(x,y);
			this.onBlockUpdate(x,y,null);
		}
		
		public function forceMapDisplay():void
		{
			if(this._map==null)
			{
				this._mapDisplayerBottom.removeAllBlock();
				this._mapDisplayerMiddle.removeAllBlock();
				this._mapDisplayerTop.removeAllBlock();
			}
			else this._map.forceDisplayToLayers(this._mapDisplayerBottom,this._mapDisplayerMiddle,this._mapDisplayerTop);
		}
		
		public function updateMapDisplay(x:int,y:int,block:BlockCommon):void
		{
			this._map.updateDisplayToLayers(x,y,block,this._mapDisplayerBottom,this._mapDisplayerMiddle,this._mapDisplayerTop)
		}
		
		public function getDisplayerThenLayer(layer:int):IMapDisplayer
		{
			return layer>0?this._mapDisplayerTop:((layer<0)?this._mapDisplayerBottom:this._mapDisplayerMiddle);
		}
		
		public function updateMapSize(updateBackground:Boolean=true):void
		{
			//Information
			var originalStageWidth:Number=GlobalGameVariables.DISPLAY_SIZE
			var originalStageHeight:Number=originalStageWidth//Square
			var mapGridWidth:uint=this._map==null?GlobalGameVariables.DISPLAY_GRIDS:this._map.mapWidth
			var mapGridHeight:uint=this._map==null?GlobalGameVariables.DISPLAY_GRIDS:this._map.mapHeight
			var mapShouldDisplayWidth:Number=GlobalGameVariables.DEFAULT_SCALE*mapGridWidth*GlobalGameVariables.DEFAULT_SIZE
			var mapShouldDisplayHeight:Number=GlobalGameVariables.DEFAULT_SCALE*mapGridHeight*GlobalGameVariables.DEFAULT_SIZE
			//Operation
			var isMapDisplayWidthMax:Boolean=mapShouldDisplayWidth>=mapShouldDisplayHeight
			var isStageWidthMax:Boolean=originalStageWidth>=originalStageHeight
			var mapShouldDisplaySizeMax:Number=isMapDisplayWidthMax?mapShouldDisplayWidth:mapShouldDisplayHeight
			var mapShouldDisplaySizeMin:Number=isMapDisplayWidthMax?mapShouldDisplayHeight:mapShouldDisplayWidth
			var stageSizeMax:Number=isStageWidthMax?originalStageWidth:originalStageHeight
			var stageSizeMin:Number=isStageWidthMax?originalStageHeight:originalStageWidth
			//Oputput
			var displayScale:Number=stageSizeMin/mapShouldDisplaySizeMin
			var shouldX:Number=/*-distanceBetweenBorderX+*/(isStageWidthMax?(originalStageWidth-mapShouldDisplayWidth*displayScale)/2:0)
			var shouldY:Number=/*-distanceBetweenBorderY+*/(isStageWidthMax?0:(originalStageHeight-mapShouldDisplayHeight*displayScale)/2)
			var shouldScale:Number=displayScale
			//Deal
			this.x=shouldX
			this.y=shouldY
			this.scaleX=this.scaleY=shouldScale
			if(updateBackground)
			{
				this._backGround.x=shouldX
				this._backGround.y=shouldY
				this._backGround.scaleX=this._backGround.scaleY=shouldScale
				this._backGround.updateGrid(mapGridWidth,mapGridHeight)
			}
		}
		
		/* Change Map into Other
		 */
		public function loadMap(isInitial:Boolean=false,update:Boolean=true,reSperadPlayer:Boolean=false):void
		{
			if(isInitial&&this.rule.initialMap!=null)
				this.changeMap(this.rule.initialMap,update,reSperadPlayer);
			else if(this.rule.mapRandomPotentials==null,this.rule.initialMapID)
				this.changeMap(getRandomMap(),update,reSperadPlayer);
			else this.changeMap(Game.ALL_MAPS[exMath.intMod(exMath.randomByWeightV(this.rule.mapWeightsByGame),Game.VALID_MAP_COUNT)],update,reSperadPlayer);
		}
		
		/* Get Map from Rule
		 */
		protected function getRandomMap():IMap
		{
			return this.rule.randomMapEnable.generateNew();//ALL_MAPS[exMath.random(Game.VALID_MAP_COUNT)].clone()
		}
		
		/* Change Map into the other
		 */
		public function changeMap(map:IMap,update:Boolean=true,reSperadPlayer:Boolean=false):void
		{
			//Remove and generateNew
			if(this._map!=null) this._map.deleteSelf();
			this._map=map.generateNew();
			if(update) this.forceMapDisplay();
			if(reSperadPlayer) this.spreadAllPlayer();
		}
		
		public function transformMap():void
		{
			this._entitySystem.removeAllProjectile();
			this._entitySystem.removeAllBonusBox();
			this.loadMap(false,true,true);
			//Call AI
			var players:Vector.<Player>=this.getAlivePlayers();
			for each(var player:Player in players)
			{
				if(player is Player) (player as Player).onMapTransform();
			}
			//Stat
			this._stat.mapTransformCount++;
		}
		
		public function isOutOfMap(x:Number,y:Number):Boolean
		{
			var outCount:uint=0
			var posNum:Number,posMaxNum:uint
			for(var i:uint=0;i<2;i++)
			{
				posNum=i==0?x:y
				posMaxNum=i==0?this.mapWidth:this.mapHeight
				if(posNum<0||posNum>=posMaxNum)
				{
					return true
				}
			}
			return false
		}
		
		public function isIntOutOfMap(x:int,y:int):Boolean
		{
			return (x<0||x>=this.mapWidth)||(y<0||y>=this.mapHeight);
		}
		
		//====Functions About Player====//
		protected function createPlayer(x:int,y:int,id:uint,team:PlayerTeam,isActive:Boolean=true):Player
		{
			return new Player(this,x,y,team,id,isActive)
		}
		
		public function addPlayer(id:uint,team:PlayerTeam,x:int,y:int,rot:uint=0,isActive:Boolean=true,name:String=null):Player
		{
			//Define
			var p:Player=createPlayer(x,y,id,team,isActive);
			this._entitySystem.registerPlayer(p);
			//Set
			p.rot=rot;
			p.customName=name==null?"P"+id:name;
			//Add
			this._playerContainer.addChild(p);
			//Return
			return p;
		}
		
		protected function createAI(x:int,y:int,team:PlayerTeam,isActive:Boolean=true):AIPlayer
		{
			return new AIPlayer(this,x,y,team,isActive)
		}
		
		public function addAI(team:PlayerTeam,x:int,y:int,rot:uint=0,isActive:Boolean=true,name:String=null):AIPlayer
		{
			//Define
			var p:AIPlayer=createAI(x,y,team,isActive);
			this._entitySystem.registerPlayer(p);
			//Set
			p.rot=rot;
			p.customName=name==null?this.autoGetAIName(p):name;
			//Add
			this._playerContainer.addChild(p);
			//Return
			return p;
		}
		
		public function autoGetAIName(player:AIPlayer):String
		{
			return "AI-"+this._entitySystem.AICount+"["+player.AIProgram.labelShort+"]";
		}
		
		public function spawnPlayersByRule():void
		{
			var i:uint,player:Player
			//Spawn Player
			for(i=0;i<this.rule.playerCount;i++)
			{
				player=addPlayer(i+1,this.rule.randomTeam,-1,-1,0,false)
				respawnPlayer(player)
				player.initVariablesByRule(this.rule.defaultWeaponID,this._tempUniformWeapon);
				player.gui.updateHealth();
			}
			//Spawn AIPlayer
			for(i=0;i<this.rule.AICount;i++)
			{
				player=addAI(this.rule.randomTeam,-1,-1,0,false)
				respawnPlayer(player)
				player.initVariablesByRule(this.rule.defaultWeaponID,this._tempUniformWeapon);
				player.gui.updateHealth();
			}
			//Active Player
			for each(player in this._entitySystem.players)
			{
				player.isActive=true
			}
		}
		
		public function teleportPlayerTo(player:Player,x:int,y:int,rotateTo:uint=GlobalRot.NULL,effect:Boolean=false):Player
		{
			player.isActive=false;
			if(GlobalRot.isValidRot(rotateTo)) player.setPositions(PosTransform.alignToEntity(x),PosTransform.alignToEntity(y),rotateTo);
			else player.setXY(PosTransform.alignToEntity(x),PosTransform.alignToEntity(y));
			//Bonus Test<For remove BUG
			this.bonusBoxTest(player,x,y);
			if(effect)
			{
				this.addTeleportEffect(player.entityX,player.entityY);
				//Stat
				player.stats.beTeleportCount++;
			}
			player.isActive=true;
			return player;
		}
		
		public function spreadPlayer(player:Player,rotatePlayer:Boolean=true,createEffect:Boolean=true):Player
		{
			if(player==null||player.isRespawning) return player;
			var p:iPoint=new iPoint(0,0);
			for(var i:uint=0;i<0xff;i++)
			{
				p.x=this.map.randomX;
				p.y=this.map.randomY;
				if(testPlayerCanPass(player,p.x,p.y,true,true))
				{
					this.teleportPlayerTo(player,p.x,p.y,(rotatePlayer?GlobalRot.RANDOM:GlobalRot.NULL),createEffect);
					break;
				}
			}
			//Debug: trace("Spread "+player.customName+" "+(i+1)+" times.")
			return player;
		}
		
		/**
		 * Respawn player to spawnpoint(if map contained)
		 * @param	player	The player will respawn.
		 * @return	The same as param:player.
		 */
		public function respawnPlayer(player:Player):Player
		{
			//Test
			if(player==null||player.isRespawning) return player;
			var p:iPoint=this.map.randomSpawnPoint;
			//Position offer
			if(p!=null) p=this.findFitSpawnPoint(player,p.x,p.y);
			//p as spawnpoint
			if(p==null) this.spreadPlayer(player,true,false);
			else player.setPositions(
				PosTransform.alignToEntity(p.x),
				PosTransform.alignToEntity(p.y),
				GlobalRot.RANDOM
			);
			//Spawn Effect
			this.addSpawnEffect(player.entityX,player.entityY);
			this.addPlayerDeathLightEffect2(player.entityX,player.entityY,player,true);
			//Return
			//Debug: trace("respawnPlayer:respawn "+player.customName+".")
			return player;
		}
		
		/**
		 * @param	x	SpawnPoint.x
		 * @param	y	SpawnPoint.y
		 * @return	The nearest point from SpawnPoint.
		 */
		protected function findFitSpawnPoint(player:Player,x:int,y:int):iPoint
		{
			//Older Code uses Open List/Close List
			/*{
				var oP:Vector.<uint>=new <uint>[UintPointCompress.compressFromPoint(x,y)];
				var wP:Vector.<uint>=new Vector.<uint>();
				var cP:Vector.<uint>=new Vector.<uint>();
				var tP:iPoint;
				while(oP.length>0)
				{
					for each(var p:uint in oP)
					{
						if(cP.indexOf(p)>=0) continue;
						tP=UintPointCompress.releaseFromUint(p);
						if(this.isIntOutOfMap(tP.x,tP.y)) continue;
						if(this.testPlayerCanPass(player,tP.x,tP.y,true,true)) return tP;
						wP.push(
							this.lockIPointInMap(UintPointCompress.compressFromPoint(tP.x-1,tP.y)),
							this.lockIPointInMap(UintPointCompress.compressFromPoint(tP.x+1,tP.y)),
							this.lockIPointInMap(UintPointCompress.compressFromPoint(tP.x,tP.y-1)),
							this.lockIPointInMap(UintPointCompress.compressFromPoint(tP.x,tP.y+1))
						);
						cP.push(p);
					}
					oP=oP.splice(0,oP.length).concat(wP);
					wP.splice(0,wP.length);
				}
			}*/
			//Newest code uses subFindSpawnPoint
			var p:iPoint=null;
			for(var i:uint=0;p==null&&i<(this.mapWidth+this.mapHeight);i++)
			{
				p=this.subFindSpawnPoint(player,x,y,i);
			}
			return p;
		}
		
		protected function subFindSpawnPoint(player:Player,x:int,y:int,r:int):iPoint
		{
			for(var cx:int=x-r;cx<=x+r;cx++)
			{
				for(var cy:int=y-r;cy<=y+r;cy++)
				{
					if(exMath.intAbs(cx-x)==r&&exMath.intAbs(cy-y)==r)
					{
						if(!this.isOutOfMap(cx,cy)&&this.testPlayerCanPass(player,cx,cy,true,true)) return new iPoint(cx,cy);
					}
				}
			}
			return null;
		}
		
		public function spreadAllPlayer():void
		{
			for each(var player:Player in this._entitySystem.players)
			{
				spreadPlayer(player)
			}
		}
		
		public function hitTestOfPlayer(p1:Player,p2:Player):Boolean
		{
			return (p1.getX()==p2.getX()&&p1.getY()==p2.getY())
		}
		
		public function hitTestPlayer(player:Player,x:int,y:int):Boolean
		{
			return (x==player.gridX&&y==player.gridY)
		}
		
		public function isHitAnyPlayer(x:int,y:int):Boolean
		{
			//Loop
			for each(var player:Player in this._entitySystem.players)
			{
				if(hitTestPlayer(player,x,y)) return true
			}
			//Return
			return false
		}
		
		public function isHitAnotherPlayer(player:Player):Boolean
		{
			//Loop
			for each(var p2:Player in this._entitySystem.players)
			{
				if(p2==player) continue
				if(hitTestOfPlayer(player,p2)) return true
			}
			//Return
			return false
		}
		
		public function hitTestOfPlayers(...players):Boolean
		{
			//Transform
			var _pv:Vector.<Player>=new Vector.<Player>
			var p:*
			for each(p in players)
			{
				if(p is Player)
				{
					_pv.push(p as Player)
				}
			}
			//Test
			for each(var p1:Player in _pv)
			{
				for each(var p2:Player in _pv)
				{
					if(p1==p2) continue
					if(hitTestOfPlayer(p1,p2)) return true
				}
			}
			//Return
			return false
		}
		
		public function getHitPlayers(x:Number,y:Number):Vector.<Player>
		{
			//Set
			var returnV:Vector.<Player>=new Vector.<Player>
			//Test
			for each(var player:Player in this._entitySystem.players)
			{
				if(hitTestPlayer(player,x,y))
				{
					returnV.push(player)
				}
			}
			//Return
			return returnV
		}
		
		public function getHitPlayerAt(x:int,y:int):Player
		{
			for each(var player:Player in this._entitySystem.players)
			{
				if(hitTestPlayer(player,x,y))
				{
					return player;
				}
			}
			return null;
		}
		
		public function randomizeAllPlayerTeam():void
		{
			for each(var player:Player in this._entitySystem.players)
			{
				this.randomizePlayerTeam(player)
			}
		}
		
		public function randomizePlayerTeam(player:Player):void
		{
			var tempT:PlayerTeam,i:uint=0;
			do
			{
				tempT=this.rule.randomTeam;
			}
			while(tempT==player.team&&++i<0xf);
			player.team=tempT;
		}
		
		public function setATeamToNotAIPlayer(team:PlayerTeam=null):void
		{
			var tempTeam:PlayerTeam=team==null?this.rule.randomTeam:team
			for each(var player:Player in this._entitySystem.players)
			{
				if(!Player.isAI(player)) player.team=tempTeam
			}
		}
		
		public function setATeamToAIPlayer(team:PlayerTeam=null):void
		{
			var tempTeam:PlayerTeam=team==null?this.rule.randomTeam:team
			for each(var player:Player in this._entitySystem.players)
			{
				if(Player.isAI(player)) player.team=tempTeam
			}
		}
		
		public function changeAllPlayerWeapon(weapon:WeaponType=null):void
		{
			if(weapon==null) weapon=WeaponType.RANDOM_AVAILABLE
			for each(var player:Player in this._entitySystem.players)
			{
				player.weapon=weapon
			}
		}
		
		public function changeAllPlayerWeaponRandomly():void
		{
			for each(var player:Player in this._entitySystem.players)
			{
				player.weapon=WeaponType.RANDOM_AVAILABLE
				player.weaponUsingCD=0
			}
		}
		
		public function movePlayer(player:Player,rot:uint,distance:Number):void
		{
			//Detect
			if(!player.isActive||!player.visible) return
			/*For Debug:trace("movePlayer:",player.customName,rot,"pos 1:",player.getX(),player.getY(),
						"pos 2:",player.getFrontX(distance),player.getFrontY(distance),
						"pos 3:",player.getFrontIntX(distance),player.getFrontIntY(distance))
			*/
			player.rot=rot
			if(testPlayerCanPassToFront(player)) player.setXY(player.frontX,player.frontY)
			this.onPlayerMove(player)
		}
		
		public function playerUseWeapon(player:Player,rot:uint,chargePercent:Number):void
		{
			//Test CD
			if(player.weaponUsingCD>0) return;
			//Set Variables
			var spawnX:Number=player.weapon.useOnCenter?player.entityX:player.getFrontIntX(GlobalGameVariables.PROJECTILES_SPAWN_DISTANCE);
			var spawnY:Number=player.weapon.useOnCenter?player.entityY:player.getFrontIntY(GlobalGameVariables.PROJECTILES_SPAWN_DISTANCE);
			//Use
			this.playerUseWeaponAt(player,player.weapon,spawnX,spawnY,rot,chargePercent,GlobalGameVariables.PROJECTILES_SPAWN_DISTANCE);
			//Set CD
			player.weaponUsingCD=_rule.weaponsNoCD?GlobalGameVariables.WEAPON_MIN_CD:player.operateFinalCD(player.weapon);
		}
		
		public function playerUseWeaponAt(player:Player,weapon:WeaponType,x:Number,y:Number,weaponRot:uint,chargePercent:Number,projectilesSpawnDistance:Number):void
		{
			//Set Variables
			var p:ProjectileCommon=null
			var centerX:Number=PosTransform.alignToEntity(PosTransform.alignToGrid(x))
			var centerY:Number=PosTransform.alignToEntity(PosTransform.alignToGrid(y))
			var frontBlock:BlockCommon
			var laserLength:Number=this.rule.defaultLaserLength
			if(WeaponType.isIncludeIn(weapon,WeaponType._LASERS)&&
			   !_rule.allowLaserThroughAllBlock)
			{
				laserLength=this.getLaserLength2(x,y,weaponRot)//-projectilesSpawnDistance
			}
			//Debug: trace("playerUseWeapon:","X=",player.getX(),spawnX,"Y:",player.getY(),y)
			//Summon Projectile
			switch(weapon)
			{
				case WeaponType.BULLET:
					p=new BulletBasic(this,x,y,player)
					break;
				case WeaponType.NUKE:
					p=new BulletNuke(this,x,y,player,chargePercent)
					break;
				case WeaponType.SUB_BOMBER:
					p=new SubBomber(this,x,y,player,chargePercent)
					break;
				case WeaponType.LASER:
					p=new LaserBasic(this,x,y,player,laserLength,chargePercent)
					break;
				case WeaponType.PULSE_LASER:
					p=new LaserPulse(this,x,y,player,laserLength,chargePercent)
					break;
				case WeaponType.TELEPORT_LASER:
					p=new LaserTeleport(this,x,y,player,laserLength)
					break;
				case WeaponType.ABSORPTION_LASER:
					p=new LaserAbsorption(this,x,y,player,laserLength)
					break;
				case WeaponType.WAVE:
					p=new Wave(this,x,y,player,chargePercent)
					break;
				case WeaponType.BLOCK_THROWER:
					var carryX:int=this.lockPosInMap(PosTransform.alignToGrid(centerX),true);
					var carryY:int=this.lockPosInMap(PosTransform.alignToGrid(centerY),false);
					frontBlock=this.getBlock(carryX,carryY);
					if(player.isCarriedBlock)
					{
						//Throw
						if(this.testCanPass(carryX,carryY,false,true,false,false,false))
						{
							//Add Block
							p=new ThrowedBlock(this,centerX,centerY,player,player.carriedBlock.clone(),weaponRot,chargePercent);
							//Clear
							player.setCarriedBlock(null);
						}
					}
					else if(chargePercent>=1)
					{
						//Carry
						if(frontBlock!=null&&this.testCarryableWithMap(frontBlock.attributes,this.map))
						{
							player.setCarriedBlock(frontBlock,false);
							this.setBlock(carryX,carryY,null);
							//Effect
							this.addBlockLightEffect2(centerX,centerY,frontBlock,true);
						}
					}
					break;
				case WeaponType.MELEE:
					
					break;
				case WeaponType.LIGHTNING:
					p=new Lightning(this,centerX,centerY,weaponRot,player,player.operateFinalLightningEnergy(100)*(0.25+chargePercent*0.75));
					break;
				case WeaponType.SHOCKWAVE_ALPHA:
					p=new ShockWaveBase(this,centerX,centerY,player,player==null?GameRule.DEFAULT_DRONE_WEAPON:player.droneWeapon,player.droneWeapon.chargePercentInDrone);
					break;
				case WeaponType.SHOCKWAVE_BETA:
					p=new ShockWaveBase(this,centerX,centerY,player,player==null?GameRule.DEFAULT_DRONE_WEAPON:player.droneWeapon,player.droneWeapon.chargePercentInDrone,1);
					break;
			}
			if(p!=null)
			{
				p.rot=weaponRot;
				this._entitySystem.registerProjectile(p);
				this._projectileContainer.addChild(p);
			}
		}
		
		protected function getLaserLength(player:Player,rot:uint):uint
		{
			return getLaserLength2(player.entityX,player.entityY,rot);
		}
		
		protected function getLaserLength2(eX:Number,eY:Number,rot:uint):uint
		{
			var vx:int=GlobalRot.towardX(rot)
			var vy:int=GlobalRot.towardY(rot)
			var cx:int,cy:int
			for(var i:uint=0;i<=this.rule.defaultLaserLength;i++)
			{
				cx=PosTransform.alignToGrid(eX+vx*i)
				cy=PosTransform.alignToGrid(eY+vy*i)
				if(!_map.getBlockAttributes(cx,cy).laserCanPass) break
			}
			return i
		}
		
		public function lockEntityInMap(entity:EntityCommon):void
		{
			var posNum:Number,posMaxNum:uint,posFunc:Function
			for(var i:uint=0;i<2;i++)
			{
				posNum=i==0?entity.entityX:entity.entityY
				posMaxNum=i==0?this.mapWidth:this.mapHeight
				posFunc=i==0?entity.setX:entity.setY
				if(posNum<0)
				{
					posFunc(posMaxNum+posNum)
				}
				if(posNum>=posMaxNum)
				{
					posFunc(posNum-posMaxNum)
				}
			}
		}
		
		public function lockPosInMap(posNum:Number,returnAsX:Boolean):Number
		{
			var posMaxNum:uint=returnAsX?this.mapWidth:this.mapHeight
			if(posNum<0) return lockPosInMap(posMaxNum+posNum,returnAsX)
			else if(posNum>=posMaxNum) return lockPosInMap(posNum-posMaxNum,returnAsX)
			else return posNum
		}
		
		public function lockIntPosInMap(posNum:int,returnAsX:Boolean):int
		{
			var posMaxNum:uint=returnAsX?this.mapWidth:this.mapHeight
			if(posNum<0) return lockIntPosInMap(posMaxNum+posNum,returnAsX)
			else if(posNum>=posMaxNum) return lockIntPosInMap(posNum-posMaxNum,returnAsX)
			else return posNum
		}
		
		public function lockIPointInMap(point:iPoint):iPoint
		{
			if(point==null) return null;
			point.x=exMath.lockInt(point.x,this.mapWidth);
			point.y=exMath.lockInt(point.y,this.mapHeight);
			return point;
		}
		
		public function removeAllPlayer(onlyDisplay:Boolean=false):void
		{
			//Display
			while(this._playerContainer.numChildren>0) this._playerContainer.removeChildAt(0);
			//Entity
			if(!onlyDisplay) this._entitySystem.removeAllPlayer();
		}
		
		//======Entity Functions======//
		public function updateProjectilesColor(player:Player=null):void
		{
			//null means update all projectiles
			for each(var projectile:ProjectileCommon in this._entitySystem.projectiles)
			{
				if(player==null||projectile.owner==player)
				{
					projectile.drawShape()
				}
			}
		}
		
		public function addBonusBox(x:int,y:int,type:BonusType):void
		{
			//Cannot override
			if(this.hasBonusBoxAt(x,y)) return;
			//Execute
			var bonusBox:BonusBox=new BonusBox(this,x,y,type);
			this._entitySystem.registerBonusBox(bonusBox);
			this._bonusBoxContainer.addChild(bonusBox);
			//Stat
			this._stat.bonusGenerateCount++;
		}
		
		protected function hasBonusBoxAt(x:int,y:int):Boolean
		{
			for each(var box:BonusBox in this.entitySystem.bonusBoxes)
			{
				if(box.gridX==x&&box.gridY==y) return true;
			}
			return false;
		}
		
		public function randomAddBonusBox(type:BonusType):void
		{
			var bonusBox:BonusBox=new BonusBox(this,x,y,type);
			var i:uint=0,rX:int,rY:int;
			do
			{
				rX=this._map.randomX;
				rY=this._map.randomY;
			}
			while(!this.testBonusBoxCanPlaceAt(rX,rY)&&i<0xff)
			this.addBonusBox(rX,rY,type);
		}
		
		public function randomAddRandomBonusBox():void
		{
			this.randomAddBonusBox(this.rule.randomBonusEnable);
		}
		
		public function fillBonusBox():void
		{
			for(var x:uint=0;x<this.map.mapWidth;x++)
			{
				for(var y:uint=0;y<this.map.mapHeight;y++)
				{
					if(this.testBonusBoxCanPlaceAt(x,y)) this.addBonusBox(x,y,this.rule.randomBonusEnable);
				}
			}
		}
		
		//======Effect Functions======//
		public function addEffectChild(effect:EffectCommon):void
		{
			if(effect.layer>0) this._effectContainerTop.addChild(effect)
			else if(effect.layer==0) this._effectContainerMiddle.addChild(effect)
			else this._effectContainerBottom.addChild(effect)
		}
		
		public function addSpawnEffect(x:Number,y:Number):void
		{
			this._effectSystem.addEffect(new EffectSpawn(this,x,y))
		}
		
		public function addTeleportEffect(x:Number,y:Number):void
		{
			this._effectSystem.addEffect(new EffectTeleport(this,x,y))
		}
		
		public function addPlayerDeathLightEffect(x:Number,y:Number,color:uint,rot:uint,aiPlayer:AIPlayer=null,reverse:Boolean=false):void
		{
			this._effectSystem.addEffect(new EffectPlayerDeathLight(this,x,y,rot,color,aiPlayer==null?null:aiPlayer.AILabel,reverse))
		}
		
		public function addPlayerDeathAlphaEffect(x:Number,y:Number,color:uint,rot:uint,aiPlayer:AIPlayer=null,reverse:Boolean=false):void
		{
			this._effectSystem.addEffect(new EffectPlayerDeathAlpha(this,x,y,rot,color,aiPlayer==null?null:aiPlayer.AILabel,reverse))
		}
		
		public function addPlayerDeathLightEffect2(x:Number,y:Number,player:Player,reverse:Boolean=false):void
		{
			this._effectSystem.addEffect(EffectPlayerDeathLight.fromPlayer(this,x,y,player,reverse))
		}
		
		public function addPlayerDeathAlphaEffect2(x:Number,y:Number,player:Player,reverse:Boolean=false):void
		{
			this._effectSystem.addEffect(EffectPlayerDeathAlpha.fromPlayer(this,x,y,player,reverse))
		}
		
		public function addPlayerLevelupEffect(x:Number,y:Number,color:uint,scale:Number):void
		{
			this._effectSystem.addEffect(new EffectPlayerLevelup(this,x,y,color,scale))
		}
		
		public function addBlockLightEffect(x:Number,y:Number,color:uint,alpha:uint,reverse:Boolean=false):void
		{
			this._effectSystem.addEffect(new EffectBlockLight(this,x,y,color,alpha,reverse));
		}
		
		public function addBlockLightEffect2(x:Number,y:Number,block:BlockCommon,reverse:Boolean=false):void
		{
			this._effectSystem.addEffect(EffectBlockLight.fromBlock(this,x,y,block,reverse));
		}
		
		public function addPlayerHurtEffect(player:Player,reverse:Boolean=false):void
		{
			this._effectSystem.addEffect(EffectPlayerHurt.fromPlayer(this,player,reverse))
		}
		
		//======Hook Functions======//
		public function onPlayerMove(player:Player):void
		{
			
		}
		
		public function onPlayerUse(player:Player,rot:uint,distance:Number):void
		{
			
		}
		
		public function onPlayerHurt(attacker:Player,victim:Player,damage:uint):void
		{
			//It's no meaningless of hurt NULL
			if(victim==null) return
			//Set Stats
			if(this.rule.recordPlayerStats)
			{
				victim.stats.damageBy+=damage
				victim.stats.addDamageByPlayerCount(attacker,damage)
				if(attacker!=null)
				{
					attacker.stats.causeDamage+=damage
					attacker.stats.addCauseDamagePlayerCount(victim,damage)
					if(victim.isSelf(attacker)) victim.stats.causeDamageOnSelf+=damage
					if(victim.isAlly(attacker)) victim.stats.damageByAlly+=damage
					if(attacker.isAlly(victim)) attacker.stats.causeDamageOnAlly+=damage
				}
			}
		}
		
		/**
		 * Deal the (victim&attacker)'s (stat&heal),add effect and reset (CD&charge)
		 * @param	attacker
		 * @param	victim
		 * @param	damage
		 */
		public function onPlayerDeath(attacker:Player,victim:Player,damage:uint):void
		{
			//It's no meaningless of kill NULL
			if(victim==null) return
			//Clear Heal
			victim.heal=0;
			//Add Effect
			addPlayerDeathLightEffect2(victim.entityX,victim.entityY,victim)
			addPlayerDeathAlphaEffect2(victim.entityX,victim.entityY,victim)
			//Set Victim
			victim.visible=false
			victim.isActive=false
			//victim.trunAllKeyUp()
			victim.resetCD()
			victim.resetCharge()
			if(Player.isAI(victim)) (victim as AIPlayer).resetAITick()
			//Set Respawn
			var deadX:int=victim.lockedEntityX,deadY:int=victim.lockedEntityY
			victim.setXY(this.rule.deadPlayerMoveToX,this.rule.deadPlayerMoveToY)
			victim.respawnTick=this.rule.defaultRespawnTime
			victim.gui.visible=false
			//Store Stats
			if(this.rule.recordPlayerStats)
			{
				victim.stats.deathCount++
				if(attacker!=null)
				{
					//Attacker
					attacker.stats.killCount++
					if(Player.isAI(victim)) attacker.stats.killAICount++
					attacker.stats.addKillPlayerCount(victim)
					if(attacker.isAlly(victim)) attacker.stats.killAllyCount++
					//Victim
					victim.stats.deathByPlayer++
					if(Player.isAI(attacker)) victim.stats.deathByAI++
					if(victim.isSelf(attacker)) victim.stats.suicideCount++
					if(victim.isAlly(attacker)) victim.stats.deathByAllyCount++
					victim.stats.addDeathByPlayerCount(attacker)
				}
			}
			//Add Bonus By Rule
			if(this.rule.bonusBoxSpawnAfterPlayerDeath&&
			   (this.rule.bonusBoxMaxCount<0||this._entitySystem.bonusBoxCount<this.rule.bonusBoxMaxCount)&&
			   this.testCanPass(deadX,deadY,true,false,true,true,true))
			{
				this.addBonusBox(deadX,deadY,this.rule.randomBonusEnable);
			}
			//If Game End
			this.testGameEnd();
		}
		
		public function onPlayerRespawn(player:Player):void
		{
			//Active
			player.health=player.maxHealth;
			player.isActive=true;
			//Visible
			player.visible=true;
			player.gui.visible=true;
			//Spread&Effect
			this.respawnPlayer(player);
		}
		
		public function prePlayerLocationChange(player:Player,oldX:Number,oldY:Number):void
		{
			this.moveOutTestPlayer(player,oldX,oldY);
		}
		
		public function onPlayerLocationChange(player:Player,newX:Number,newY:Number):void
		{
			//Detect
			if(!player.isActive||!player.visible) return;
			//TransForm Pos:Lock Player In Map
			if(isOutOfMap(player.entityX,player.entityY)) lockEntityInMap(player);
			player.dealMoveInTestOnLocationChange(newX,newY,true,true);
			this.bonusBoxTest(player,newX,newY);
		}
		
		public function onPlayerTeamsChange(event:GameRuleEvent):void
		{
			this.randomizeAllPlayerTeam();
		}
		
		public function onPlayerLevelup(player:Player):void
		{
			var color:uint;
			var i:uint=0;
			var nowE:uint=exMath.random(4);
			//Add buff of cd,resistance,radius,damage
			while(i<3)
			{
				switch(nowE)
				{
					case 1:
						color=BonusBoxSymbol.BUFF_CD_COLOR;
						player.buffCD+=this.rule.bonusBuffAdditionAmount;
						break;
					case 2:
						color=BonusBoxSymbol.BUFF_RESISTANCE_COLOR;
						player.buffResistance+=this.rule.bonusBuffAdditionAmount;
						break;
					case 3:
						color=BonusBoxSymbol.BUFF_RADIUS_COLOR;
						player.buffRadius+=this.rule.bonusBuffAdditionAmount;
						break;
					default:
						color=BonusBoxSymbol.BUFF_DAMAGE_COLOR;
						player.buffDamage+=this.rule.bonusBuffAdditionAmount;
				}
				nowE=(nowE+1)&3;
				i++;
				//Add Effect
				this.addPlayerLevelupEffect(player.entityX+(i&1)-0.5,player.entityY+(i>>1)-0.5,color,0.75);
			}
		}
		
		public function onRandomTick(x:int,y:int):void
		{
			//BonusBox(Supply)
			if(testCanPass(x,y,true,false,false,true,true))
			{
				if(this.getBlockAttributes(x,y).supplingBonus||
					((this.rule.bonusBoxMaxCount<0||this._entitySystem.bonusBoxCount<this.rule.bonusBoxMaxCount)&&
					UsefulTools.randomBoolean2(this.rule.bonusBoxSpawnChance)))
				{
					this.addBonusBox(x,y,this.rule.randomBonusEnable);
				}
			}
			//Other
			switch(this.getBlockType(x,y))
			{
				case BlockType.COLOR_SPAWNER:
					this.colorSpawnerSpawnBlock(x,y);
				break;
				case BlockType.LASER_TRAP:
					this.laserTrapShootLaser(x,y);
				break;
				case BlockType.MOVEABLE_WALL:
					this.moveableWallMove(x,y,this.getBlock(x,y));
				break;
				case BlockType.GATE_CLOSE:
					this.setBlock(x,y,BlockCommon.fromType(BlockType.GATE_OPEN));
				break;
			}
		}
		
		protected function onBlockUpdate(x:int,y:int,block:BlockCommon):void
		{
			this.updateMapDisplay(x,y,block);
			this.updateMapSize();
			this.moveInTestWithEntity();
		}
		
		//====Block Functions====//
		protected function colorSpawnerSpawnBlock(x:int,y:int):void
		{
			var randomX:int=x+exMath.random1()*(exMath.random(3))
			var randomY:int=y+exMath.random1()*(exMath.random(3))
			var block:ColoredBlock=new ColoredBlock(exMath.random(0xffffff))
			if(!this.isOutOfMap(randomX,randomY)&&this.isVoid(randomX,randomY))
			{
				this.setBlock(randomX,randomY,block)
				//Add Effect
				this.addBlockLightEffect2(PosTransform.alignToEntity(randomX),PosTransform.alignToEntity(randomY),block,false)
			}
		}
		
		protected function laserTrapShootLaser(x:int,y:int):void
		{
			var randomRot:uint,rotX:Number,rotY:Number,laserLength:Number;
			//add laser by owner=null
			var p:LaserBasic;
			var i:uint;
			do
			{
				randomRot=GlobalRot.RANDOM;
				rotX=PosTransform.alignToEntity(x)+GlobalRot.towardIntX(randomRot,GlobalGameVariables.PROJECTILES_SPAWN_DISTANCE);
				rotY=PosTransform.alignToEntity(y)+GlobalRot.towardIntY(randomRot,GlobalGameVariables.PROJECTILES_SPAWN_DISTANCE);
				if(isOutOfMap(rotX,rotY)) continue;
				laserLength=getLaserLength2(rotX,rotY,randomRot);
				if(laserLength<=0) continue;
				switch(exMath.random(4))
				{
					case 1:
						p=new LaserTeleport(this,rotX,rotY,null,laserLength);
						break;
					case 2:
						p=new LaserAbsorption(this,rotX,rotY,null,laserLength);
						break;
					case 3:
						p=new LaserPulse(this,rotX,rotY,null,laserLength);
						break;
					default:
						p=new LaserBasic(this,rotX,rotY,null,laserLength,1);
						break;
				}
				if(p!=null)
				{
					p.rot=randomRot;
					this.entitySystem.registerProjectile(p);
					this._projectileContainer.addChild(p);
					//trace("laser at"+"("+p.entityX+","+p.entityY+"),"+p.life,p.length,p.visible,p.alpha,p.owner);
				}
			}
			while(laserLength<=0&&++i<0x10)
		}
		
		protected function moveableWallMove(x:int,y:int,block:BlockCommon):void
		{
			var randomRot:uint,rotX:Number,rotY:Number,laserLength:Number;
			//add laser by owner=null
			var p:ThrowedBlock;
			var i:uint;
			do
			{
				randomRot=GlobalRot.RANDOM;
				rotX=x+GlobalRot.towardXInt(randomRot);
				rotY=y+GlobalRot.towardYInt(randomRot);
				if(this.isIntOutOfMap(rotX,rotY)||!this.testIntCanPass(rotX,rotY,false,true,false,false)) continue;
				p=new ThrowedBlock(this,PosTransform.alignToEntity(x),PosTransform.alignToEntity(y),null,block.clone(),randomRot,Math.random());
				this.setVoid(x,y);
				this.entitySystem.registerProjectile(p);
				this._projectileContainer.addChild(p);
				//trace("laser at"+"("+p.entityX+","+p.entityY+"),"+p.life,p.length,p.visible,p.alpha,p.owner);
				if(!(block is MoveableWall&&(block as MoveableWall).virus)) break;
			}
			while(++i<0x10)
		}
	}
}