package batr.game.main 
{
	import batr.common.*;
	import batr.general.*;
	
	import batr.game.map.*;
	import batr.game.main.*;
	import batr.game.model.*;
	import batr.game.events.*;
	
	import flash.events.EventDispatcher;
	
	/**
	 * This class contains the rules that can affects gameplay.
	 */
	public class GameRule extends EventDispatcher
	{
		//============Static Variables============//
		//========Rules========//
		//====Player====//
		protected static const d_playerCount:uint=1
		protected static const d_AICount:uint=3
		
		//====Team====//
		protected static const d_coloredTeamCount:uint=8
		protected static const d_grayscaleTeamCount:uint=3
		protected static const d_playerTeams:Vector.<PlayerTeam>=initPlayerTeams(d_coloredTeamCount,d_grayscaleTeamCount)
		/**
		 * Allows players change their teams by general means
		 */
		protected static const d_allowPlayerChangeTeam:Boolean=true
		
		//====GamePlay====//
		protected static const d_defaultHealth:uint=100
		protected static const d_defaultMaxHealth:uint=100
		/**
		 * Use as a uint with Infinity
		 */
		protected static const d_remainLifesPlayer:Number=Infinity
		protected static const d_remainLifesAI:Number=Infinity
		protected static const d_defaultRespawnTime:uint=3*GlobalGameVariables.TPS//tick
		protected static const d_deadPlayerMoveToX:Number=-10
		protected static const d_deadPlayerMoveToY:Number=-10
		protected static const d_recordPlayerStats:Boolean=true
		/**
		 * Negative Number means asphyxia can kill player
		 */
		protected static const d_playerAsphyxiaDamage:int=15
		
		//====Bonus====//
		/**
		 * negative number means infinity
		 */
		protected static const d_bonusBoxMaxCount:int=8
		/**
		 * [{Type:<Type>,Weight:<Number>},...]
		 */
		protected static const d_bonusBoxSpawnPotentials:Vector.<Object>=null
		
		/**
		 * null means all type can be spawned and they have same weight
		 */
		protected static const d_bonusBoxSpawnAfterPlayerDeath:Boolean=true
		
		//====Bonus's Buff====//
		/**
		 * Determines bonus(type=buffs)'s amount of addition
		 */
		protected static const d_bonusBuffAdditionAmount:uint=1
		/**
		 * Determines bonus(type=ADD_LIFE)'s amount of addition
		 */
		protected static const d_bonusMaxHealthAdditionAmount:uint=5
		
		//====Map====//
		/**
		 * [{map:<MAP>,weight:<Number>},...]
		 */
		protected static const d_mapRandomPotentials:Vector.<Object>=null
		protected static const d_initialMapID:int=-1
		/**
		 * The time of the map transform loop.
		 * stranded by second.
		 */
		protected static const d_mapTransformTime:uint=60
		
		//====Weapons====//
		protected static const d_enableWeapons:Vector.<WeaponType>=WeaponType._ALL_AVALIABLE_WEAPON
		protected static const d_defaultWeaponID:int=0
		protected static const d_defaultLaserLength:uint=32
		protected static const d_allowLaserThroughAllBlock:Boolean=false
		protected static const d_weaponsNoCD:Boolean=false
		
		//====End&Victory====//
		protected static const d_allowTeamVictory:Boolean=true;
		
		//========Preview========//
		public static const MENU_BACKGROUND:GameRule=GameRule.getBackgroundRule()
		
		public static const DEFAULT_DRONE_WEAPON:WeaponType=WeaponType.LASER
		
		private static function getBackgroundRule():GameRule
		{
			var rule:GameRule=new GameRule();
			rule.playerCount=0;
			rule.AICount=8;
			rule.defaultWeaponID=-2;
			return rule;
		}
		
		//============Static Getter And Setter============//
		
		//============Static Functions============//
		/**
		 * Create a list of PlayerTeam that have different colors.
		 * @param	coloredTeamCount	the number of team that color is colorful
		 * @param	grayscaleTeamCount	the number of team that color is grayscale
		 * @return	A list of PlayerTeam,contains different colors.
		 */
		protected static function initPlayerTeams(coloredTeamCount:uint,grayscaleTeamCount:uint):Vector.<PlayerTeam>
		{
			var returnTeams:Vector.<PlayerTeam>=new Vector.<PlayerTeam>();
			var h:uint,s:Number,v:Number,color:uint;
			var i:uint;
			//Grayscale Team
			h=0;s=0;
			for(i=0;i<grayscaleTeamCount;i++)
			{
				v=i/(grayscaleTeamCount-1)*100;
				color=Color.HSVtoHEX(h,s,v);
				returnTeams.push(new PlayerTeam(color));
			}
			h=0;s=100;v=100;
			//Colored Team
			for(i=0;i<coloredTeamCount;i++)
			{
				h=360*i/coloredTeamCount;
				color=Color.HSVtoHEX(h,s,v);
				returnTeams.push(new PlayerTeam(color));
			}
			return returnTeams;
		}
		
		//============Instance Variables============//
		//====rules====//
		//Player
		protected var _playerCount:uint
		protected var _AICount:uint
		
		//Team
		protected var _coloredTeamCount:uint
		protected var _grayscaleTeamCount:uint
		protected var _playerTeams:Vector.<PlayerTeam>
		protected var _allowPlayerChangeTeam:Boolean
		
		//GamePlay
		protected var _defaultHealth:uint
		protected var _defaultMaxHealth:uint
		protected var _remainLifesPlayer:Number
		protected var _remainLifesAI:Number
		protected var _defaultRespawnTime:uint
		protected var _deadPlayerMoveToX:Number
		protected var _deadPlayerMoveToY:Number
		protected var _recordPlayerStats:Boolean
		/**
		 * int.MAX_VALUE -> uint.MAX_VALUE
		 * Negative number -> uint.MAX_VALUE
		 * damage operator function=Game.operateFinalPlayerHurtDamage
		 */
		protected var _playerAsphyxiaDamage:int
		
		//Bonus
		/**
		 * Negative number means infinity
		 */
		protected var _bonusBoxMaxCount:int
		protected var _bonusBoxSpawnChance:Number=1/GlobalGameVariables.TPS/8//Spawn per tick
		protected var _bonusBoxSpawnPotentials:Vector.<Object>//[{type:<BonusBoxType>,weight:<Number>},...]
		protected var _bonusBoxSpawnAfterPlayerDeath:Boolean
		
		//Bonus's Buff
		protected var _bonusBuffAdditionAmount:uint
		protected var _bonusMaxHealthAdditionAmount:uint
		
		//Map
		/**
		 * Null means all type can be spawned and they have same weight
		 */
		protected var _mapRandomPotentials:Vector.<Object>//[{map:<IMAP>,weight:<Number>},...]
		protected var _initialMapID:int
		
		/**
		 * The unit is second
		 * 0 means never transform map by time
		 */
		protected var _mapTransformTime:uint
		
		//Weapons
		protected var _enableWeapons:Vector.<WeaponType>
		/**
		 * -1 means uniform random
		 * <-1 means certainly random
		 */
		protected var _defaultWeaponID:int
		protected var _defaultLaserLength:uint
		protected var _allowLaserThroughAllBlock:Boolean
		protected var _weaponsNoCD:Boolean
		
		//End&Victory
		protected var _allowTeamVictory:Boolean
		
		//============Constructor Function============//
		public function GameRule():void
		{
			super();
			loadAsDefault();
		}
		
		//============Destructor Function============//
		public function deleteSelf():void
		{
			this._bonusBoxSpawnPotentials=null;
			this._mapRandomPotentials=null;
			this._enableWeapons=null;
			this._playerTeams=null;
		}
		
		//============Instance Getter And Setter============//
		//Rule Random About
		public function get randomWeaponEnable():WeaponType
		{
			return this.enableWeapons[exMath.random(this.enableWeapons.length)];
		}
		
		public function get randomWeaponIDEnable():int
		{
			return WeaponType.toWeaponID(this.enableWeapons[exMath.random(this.enableWeapons.length)]);
		}
		
		public function get randomMapEnable():IMap
		{
			//Test
			if(this._mapRandomPotentials==null)
			{
				return Game.ALL_MAPS[exMath.random(Game.ALL_MAPS.length)];
			}
			//Add
			var maps:Vector.<IMap>=new Vector.<IMap>();
			var weights:Vector.<Number>=new Vector.<Number>();
			var sum:Number=0;
			for each(var mapPotential:Object in this._mapRandomPotentials)
			{
				if(mapPotential["map"] is IMap&&mapPotential["weight"] is Number)
				{
					maps.push(mapPotential["map"] as IMap);
					weights.push(Number(mapPotential["weight"]));
					sum+=Number(mapPotential["weight"]);
				}
			}
			var randomNum:Number=exMath.randomFloat(sum);
			//Choose
			for(var i:uint=0;i<weights.length;i++)
			{
				if(weights[i]>=randomNum&&randomNum<weights[i+1])
				{
					return maps[i];
				}
			}
			return null;
		}
		
		public function get randomBonusEnable():BonusType
		{
			//Test
			if(this._bonusBoxSpawnPotentials==null)
			{
				// return BonusType.RANDOM_AVALIABLE
				// 20230902: now initialize an equivalent potentials
				this._bonusBoxSpawnPotentials=BonusType.AVALIABLE_SPAWN_POTENTIALS;
			}
			//Add
			var types:Vector.<BonusType>=new Vector.<BonusType>();
			var weights:Vector.<Number>=new Vector.<Number>();
			var sum:Number=0;
			for each(var bonusPotential:Object in this._bonusBoxSpawnPotentials)
			{
				if(bonusPotential["type"] is BonusType&&bonusPotential["weight"] is Number)
				{
					//Filter
					if(
						// if the rule disallow player change their team, the type that potential can change player's team willn't be push
						!this._allowPlayerChangeTeam&&(
							bonusPotential["type"]==BonusType.RANDOM_CHANGE_TEAM||
							bonusPotential["type"]==BonusType.UNITE_PLAYER||
							bonusPotential["type"]==BonusType.UNITE_AI
						)
					) continue;
					//Push
					types.push(bonusPotential["type"] as BonusType);
					sum+=Number(bonusPotential["weight"]);
					weights.push(sum);
				}
			}
			var randomNum:Number=exMath.randomFloat(sum);
			//Choose
			for(var i:uint=0;i<weights.length;i++)
			{
				if(randomNum<=weights[i])
				{
					return types[i];
				}
			}
			trace("warn@GameRule.as: no bonus type is selected, return NULL!");
			return BonusType.NULL;
		}
		
		public function get randomTeam():PlayerTeam
		{
			if(this._playerTeams==null) return null
			return this._playerTeams[exMath.random(this._playerTeams.length)]
		}
		
		//====Rules====//
		//Player
		public function get playerCount():uint
		{
			return this._playerCount;
		}
		
		public function set playerCount(value:uint):void
		{
			if(value==this._playerCount) return;
			onVariableUpdate(this._playerCount,value);
			this._playerCount=value;
		}
		
		public function get AICount():uint
		{
			return this._AICount;
		}
		
		public function set AICount(value:uint):void
		{
			if(value==this._AICount) return;
			onVariableUpdate(this._AICount,value);
			this._AICount=value;
		}
		
		//Health
		public function get defaultHealth():uint
		{
			return this._defaultHealth;
		}
		
		public function set defaultHealth(value:uint):void
		{
			if(value==this._defaultHealth) return;
			onVariableUpdate(this._defaultHealth,value);
			this._defaultHealth=value;
		}
		
		public function get defaultMaxHealth():uint
		{
			return this._defaultMaxHealth;
		}
		
		public function set defaultMaxHealth(value:uint):void
		{
			if(value==this._defaultMaxHealth) return;
			onVariableUpdate(this._defaultMaxHealth,value);
			this._defaultMaxHealth=value;
		}
		
		//Bonus
		public function get bonusBoxMaxCount():int
		{
			return this._bonusBoxMaxCount;
		}
		
		public function set bonusBoxMaxCount(value:int):void
		{
			if(value==this._bonusBoxMaxCount) return;
			onVariableUpdate(this._bonusBoxMaxCount,value);
			this._bonusBoxMaxCount=value;
		}
		
		public function get bonusBoxSpawnChance():Number
		{
			return this._bonusBoxSpawnChance;
		}
		
		public function set bonusBoxSpawnChance(value:Number):void
		{
			if(value==this._bonusBoxSpawnChance) return;
			onVariableUpdate(this._bonusBoxSpawnChance,value);
			this._bonusBoxSpawnChance=value;
		}
		
		public function get bonusBoxSpawnPotentials():Vector.<Object>
		{
			return this._bonusBoxSpawnPotentials;
		}
		
		public function set bonusBoxSpawnPotentials(value:Vector.<Object>):void
		{
			if(value==this._bonusBoxSpawnPotentials) return
			var _v:Vector.<Object>=value
			for(var i:int=_v.length-1;i>=0;i--)
			{
				if(_v[i] is BonusType)
				{
					_v[i]={type:_v[i],weight:1}
					continue
				}
				if(!(_v[i].type is BonusType)||!(_v[i].weight is Number))
				{
					_v.splice(i,1)
					continue
				}
				if(isNaN(_v[i].weight))
				{
					_v[i].weight=1
				}
			}
			onVariableUpdate(this._bonusBoxSpawnPotentials,_v)
			this._bonusBoxSpawnPotentials=_v;
		}
		
		public function get bonusBoxSpawnAfterPlayerDeath():Boolean
		{
			return this._bonusBoxSpawnAfterPlayerDeath;
		}
		
		public function set bonusBoxSpawnAfterPlayerDeath(value:Boolean):void
		{
			if(value==this._bonusBoxSpawnAfterPlayerDeath) return;
			onVariableUpdate(this._bonusBoxSpawnAfterPlayerDeath,value);
			this._bonusBoxSpawnAfterPlayerDeath=value;
		}
		
		//Bonus's Buff
		public function get bonusBuffAdditionAmount():uint
		{
			return this._bonusBuffAdditionAmount;
		}
		
		public function set bonusBuffAdditionAmount(value:uint):void
		{
			if(value==this._bonusBuffAdditionAmount) return;
			onVariableUpdate(this._bonusBuffAdditionAmount,value);
			this._bonusBuffAdditionAmount=value;
		}
		
		public function get bonusMaxHealthAdditionAmount():uint
		{
			return this._bonusMaxHealthAdditionAmount;
		}
		
		public function set bonusMaxHealthAdditionAmount(value:uint):void
		{
			if(value==this._bonusMaxHealthAdditionAmount) return;
			onVariableUpdate(this._bonusMaxHealthAdditionAmount,value);
			this._bonusMaxHealthAdditionAmount=value;
		}
		
		//Map
		public function get mapRandomPotentials():Vector.<Object>
		{
			return this._mapRandomPotentials;
		}
		
		public function set mapRandomPotentials(value:Vector.<Object>):void
		{
			if(value==this._mapRandomPotentials) return
			var _v:Vector.<Object>=value
			for(var i:int=_v.length-1;i>=0;i--)
			{
				if(_v[i] is IMap)
				{
					_v[i]={map:_v[i],weight:1}
					continue
				}
				if(!(_v[i].map is IMap)||!(_v[i].weight is Number))
				{
					_v.splice(i,1)
					continue
				}
				if(isNaN(_v[i].weight))
				{
					_v[i].weight=1
				}
			}
			onVariableUpdate(this._mapRandomPotentials,_v)
			this._mapRandomPotentials=_v;
		}
		
		public function get mapWeightsByGame():Vector.<Number>
		{
			var wv:Vector.<Number>=new Vector.<Number>(Game.ALL_MAPS.length)
			for(var i:uint=0;i<=Game.ALL_MAPS.length;i++)
			{
				for(var map:Object in this.mapRandomPotentials)
				{
					if(map.map==Game.ALL_MAPS[i])
					{
						wv[i]=map.weight
					}
				}
			}
			return wv
		}
		
		public function get initialMapID():int
		{
			return this._initialMapID;
		}
		
		public function set initialMapID(value:int):void
		{
			if(value==this._initialMapID) return;
			onVariableUpdate(this._initialMapID,value);
			this._initialMapID=value;
		}
		
		public function get mapTransformTime():uint
		{
			return this._mapTransformTime;
		}
		
		public function set mapTransformTime(value:uint):void
		{
			if(value==this._mapTransformTime) return;
			onVariableUpdate(this._mapTransformTime,value);
			this._mapTransformTime=value;
		}
		
		/* The Copy Operation is in Menu:getRuleFromMenu
		 * The Negative Number returns null and The Game will be start as random map
		 */
		public function get initialMap():IMap
		{
			if(this._initialMapID<0) return null;
			return Game.getMapFromID(this._initialMapID);
		}
		
		/* The Map must be the true object in Game.ALL_MAPS not a clone!
		 * The initial map will be loaded in Game:loadMap
		 */
		public function set initialMap(value:IMap):void
		{
			this.initialMapID=Game.getIDFromMap(value);
		}
		
		//Weapon
		public function get defaultWeaponID():int
		{
			return this._defaultWeaponID;
		}
		
		public function set defaultWeaponID(value:int):void
		{
			if(value==this._defaultWeaponID) return;
			onVariableUpdate(this._defaultWeaponID,value);
			this._defaultWeaponID=value;
		}
		
		public function get defaultLaserLength():uint
		{
			return this._defaultLaserLength;
		}
		
		public function set defaultLaserLength(value:uint):void
		{
			if(value==this._defaultLaserLength) return;
			onVariableUpdate(this._defaultLaserLength,value);
			this._defaultLaserLength=value;
		}
		
		public function get allowLaserThroughAllBlock():Boolean
		{
			return this._allowLaserThroughAllBlock;
		}
		
		public function set allowLaserThroughAllBlock(value:Boolean):void
		{
			if(value==this._allowLaserThroughAllBlock) return;
			onVariableUpdate(this._allowLaserThroughAllBlock,value);
			this._allowLaserThroughAllBlock=value;
		}
		
		public function get weaponsNoCD():Boolean 
		{
			return this._weaponsNoCD;
		}
		
		public function set weaponsNoCD(value:Boolean):void
		{
			if(value==this._weaponsNoCD) return;
			onVariableUpdate(this._weaponsNoCD,value);
			this._weaponsNoCD=value;
		}
		
		//Respawn
		public function get defaultRespawnTime():uint 
		{
			return this._defaultRespawnTime;
		}
		
		public function set defaultRespawnTime(value:uint):void
		{
			if(value==this._defaultRespawnTime) return;
			onVariableUpdate(this._defaultRespawnTime,value);
			this._defaultRespawnTime=value;
		}
		
		public function get deadPlayerMoveToX():Number
		{
			return this._deadPlayerMoveToX;
		}
		
		public function set deadPlayerMoveToX(value:Number):void
		{
			if(value==this._deadPlayerMoveToX) return;
			onVariableUpdate(this._deadPlayerMoveToX,value);
			this._deadPlayerMoveToX=value;
		}
		
		public function get deadPlayerMoveToY():Number
		{
			return this._deadPlayerMoveToY;
		}
		
		public function set deadPlayerMoveToY(value:Number):void
		{
			if(value==this._deadPlayerMoveToY) return;
			onVariableUpdate(this._deadPlayerMoveToY,value);
			this._deadPlayerMoveToY=value;
		}
		
		//Life
		public function get remainLifesPlayer():Number
		{
			return this._remainLifesPlayer;
		}
		
		public function set remainLifesPlayer(value:Number):void
		{
			if(value==this._remainLifesPlayer) return;
			onVariableUpdate(this._remainLifesPlayer,value);
			this._remainLifesPlayer=value;
		}
		
		public function get remainLifesAI():Number
		{
			return this._remainLifesAI
		}
		
		public function set remainLifesAI(value:Number):void
		{
			if(value==this._remainLifesAI) return;
			onVariableUpdate(this._remainLifesAI,value);
			this._remainLifesAI=value;
		}
		
		//Stats
		public function get recordPlayerStats():Boolean
		{
			return this._recordPlayerStats;
		}
		
		public function set recordPlayerStats(value:Boolean):void
		{
			if(value==this._recordPlayerStats) return;
			onVariableUpdate(this._recordPlayerStats,value);
			this._recordPlayerStats=value;
		}
		
		//Weapon Enable
		public function get enableWeapons():Vector.<WeaponType>
		{
			return this._enableWeapons==null?WeaponType._ALL_AVALIABLE_WEAPON:this._enableWeapons;
		}
		
		public function set enableWeapons(value:Vector.<WeaponType>):void
		{
			if(value==this._enableWeapons) return;
			onVariableUpdate(this._enableWeapons,value);
			this._enableWeapons=value;
		}
		
		public function get enableWeaponCount():int
		{
			return this._enableWeapons==null?WeaponType._ALL_AVALIABLE_WEAPON.length:this._enableWeapons.length;
		}
		
		//Asphyxia Damage
		public function get playerAsphyxiaDamage():int 
		{
			return this._playerAsphyxiaDamage;
		}
		
		public function set playerAsphyxiaDamage(value:int):void
		{
			if(value==this._playerAsphyxiaDamage) return;
			onVariableUpdate(this._playerAsphyxiaDamage,value);
			this._playerAsphyxiaDamage=value;
		}
		
		//Team
		public function get coloredTeamCount():uint
		{
			return this._coloredTeamCount;
		}
		
		public function set coloredTeamCount(value:uint):void
		{
			if(value==this._coloredTeamCount) return;
			onVariableUpdate(this._coloredTeamCount,value);
			this._coloredTeamCount=value;
			this._playerTeams=initPlayerTeams(value,this._grayscaleTeamCount);
			dispatchEvent(new GameRuleEvent(GameRuleEvent.TEAMS_CHANGE));
		}
		
		public function get grayscaleTeamCount():uint
		{
			return this._grayscaleTeamCount;
		}
		
		public function set grayscaleTeamCount(value:uint):void
		{
			if(value==this._grayscaleTeamCount) return;
			onVariableUpdate(this._grayscaleTeamCount,value);
			this._grayscaleTeamCount=value;
			this._playerTeams=initPlayerTeams(this._coloredTeamCount,value);
			dispatchEvent(new GameRuleEvent(GameRuleEvent.TEAMS_CHANGE));
		}
		
		public function get playerTeams():Vector.<PlayerTeam>
		{
			return this._playerTeams;
		}

		public function get allowPlayerChangeTeam():Boolean
		{
			return this._allowPlayerChangeTeam;
		}
		
		public function set allowPlayerChangeTeam(value:Boolean):void
		{
			if(value==this._allowPlayerChangeTeam) return;
			onVariableUpdate(this._allowPlayerChangeTeam,value);
			this._allowPlayerChangeTeam=value;
		}
		
		//End&Victory
		public function get allowTeamVictory():Boolean 
		{
			return this._allowTeamVictory;
		}
		
		public function set allowTeamVictory(value:Boolean):void
		{
			if(value==this._allowTeamVictory) return;
			onVariableUpdate(this._allowTeamVictory,value);
			this._allowTeamVictory=value;
		}
		
		//============Instance Functions============//
		public function loadAsDefault():void
		{
			//Player
			this._playerCount=d_playerCount;
			this._AICount=d_AICount;
			//Health
			this._defaultHealth=d_defaultHealth;
			this._defaultMaxHealth=d_defaultMaxHealth;
			//Bonus
			this._bonusBoxMaxCount=d_bonusBoxMaxCount;
			this._bonusBoxSpawnPotentials=d_bonusBoxSpawnPotentials;
			this._bonusBoxSpawnAfterPlayerDeath=d_bonusBoxSpawnAfterPlayerDeath;
			//Bonus's Buff
			this._bonusBuffAdditionAmount=d_bonusBuffAdditionAmount;
			this._bonusMaxHealthAdditionAmount=d_bonusMaxHealthAdditionAmount;
			//Map
			this._mapRandomPotentials=d_mapRandomPotentials;
			this._initialMapID=d_initialMapID;
			this._mapTransformTime=d_mapTransformTime;
			//Weapon
			this._defaultWeaponID=d_defaultWeaponID;
			this._defaultLaserLength=d_defaultLaserLength;
			this._allowLaserThroughAllBlock=d_allowLaserThroughAllBlock;
			this._weaponsNoCD=d_weaponsNoCD;
			//Respawn
			this._defaultRespawnTime=d_defaultRespawnTime;
			this._deadPlayerMoveToX=d_deadPlayerMoveToX;
			this._deadPlayerMoveToY=d_deadPlayerMoveToY;
			//Life
			this._remainLifesPlayer=d_remainLifesPlayer;
			this._remainLifesAI=d_remainLifesAI;
			//Stat
			this._recordPlayerStats=d_recordPlayerStats;
			//Weapon Enable
			this._enableWeapons=d_enableWeapons;
			//Asphyxia Damage
			this._playerAsphyxiaDamage=d_playerAsphyxiaDamage;
			//Team
			this._playerTeams=d_playerTeams;
			this._allowPlayerChangeTeam=d_allowPlayerChangeTeam;
			//End&Victory
			this._allowTeamVictory=d_allowTeamVictory;
		}
		
		protected function onVariableUpdate(oldValue:*,newValue:*):void
		{
			dispatchEvent(new GameRuleEvent(GameRuleEvent.VARIABLE_UPDATE,oldValue,newValue));
		}
	}
}
