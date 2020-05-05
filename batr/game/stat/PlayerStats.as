package batr.game.stat 
{
	import batr.common.*;
	import batr.game.entity.entities.players.*;
	import batr.game.entity.model.*;
	
	import flash.utils.Dictionary;
	
	/* Thst's a stats(or scoreboard) use for a player
	 * */
	public class PlayerStats
	{
		//============Instance Variables============//
		//Profile
		protected var _profile:IPlayerProfile=null
		
		//kills and deaths
		protected var _killCount:uint=0
		protected var _killAICount:uint=0
		protected var _deathCount:uint=0
		protected var _deathByPlayer:uint=0
		protected var _deathByAI:uint=0
		protected var _killPlayers:Stat_PlayerCount=new Stat_PlayerCount()
		protected var _deathByPlayers:Stat_PlayerCount=new Stat_PlayerCount()
		protected var _causeDamage:uint=0
		protected var _damageBy:uint=0
		protected var _causeDamagePlayers:Stat_PlayerCount=new Stat_PlayerCount()
		protected var _damageByPlayers:Stat_PlayerCount=new Stat_PlayerCount()
		protected var _suicideCount:uint=0
		protected var _killAllyCount:uint=0
		protected var _deathByAllyCount:uint=0
		protected var _causeDamageOnSelf:uint=0
		protected var _causeDamageOnAlly:uint=0
		protected var _damageByAlly:uint=0
		
		//weapons
		
		//bonus boxes
		protected var _pickupBonusBoxCount:uint=0
		
		//misc
		protected var _beTeleportCount:uint=0;
		
		//============Constructor============//
		public function PlayerStats(owner:Player):void
		{
			this._profile=owner as IPlayerProfile;
		}
		
		//============Destructor============//
		public function deleteSelf():void
		{
			this._profile=null;
			this._killPlayers.deleteSelf();
			this._deathByPlayers.deleteSelf();
			this._causeDamagePlayers.deleteSelf();
			this._damageByPlayers.deleteSelf();
		}
		
		//============Instance Getter And Setter============//
		public function get profile():IPlayerProfile
		{
			return this._profile;
		}
		
		public function get killCount():uint
		{
			return this._killCount;
		}
		
		public function set killCount(value:uint):void
		{
			this._killCount=value;
		}
		
		public function get killAICount():uint
		{
			return this._killAICount;
		}
		
		public function set killAICount(value:uint):void
		{
			this._killAICount=value;
		}
		
		public function get deathCount():uint
		{
			return this._deathCount;
		}
		
		public function set deathCount(value:uint):void
		{
			this._deathCount=value;
		}
		
		public function get deathByPlayer():uint
		{
			return this._deathByPlayer;
		}
		
		public function set deathByPlayer(value:uint):void
		{
			this._deathByPlayer=value;
		}
		
		public function get deathByAI():uint
		{
			return this._deathByAI;
		}
		
		public function set deathByAI(value:uint):void
		{
			this._deathByAI=value;
		}
		
		public function get causeDamage():uint
		{
			return this._causeDamage;
		}
		
		public function set causeDamage(value:uint):void
		{
			this._causeDamage=value;
		}
		
		public function get damageBy():uint
		{
			return this._damageBy;
		}
		
		public function set damageBy(value:uint):void
		{
			this._damageBy=value;
		}
		
		public function get suicideCount():uint
		{
			return this._suicideCount;
		}
		
		public function set suicideCount(value:uint):void
		{
			this._suicideCount=value;
		}
		
		public function get killAllyCount():uint
		{
			return this._killAllyCount;
		}
		
		public function set killAllyCount(value:uint):void
		{
			this._killAllyCount=value;
		}
		
		public function get deathByAllyCount():uint
		{
			return this._deathByAllyCount;
		}
		
		public function set deathByAllyCount(value:uint):void
		{
			this._deathByAllyCount=value;
		}
		
		public function get causeDamageOnSelf():uint
		{
			return this._causeDamageOnSelf;
		}
		
		public function set causeDamageOnSelf(value:uint):void
		{
			this._causeDamageOnSelf=value;
		}
		
		public function get causeDamageOnAlly():uint
		{
			return this._causeDamageOnAlly;
		}
		
		public function set causeDamageOnAlly(value:uint):void
		{
			this._causeDamageOnAlly=value;
		}
		
		public function get damageByAlly():uint
		{
			return this._damageByAlly;
		}
		
		public function set damageByAlly(value:uint):void
		{
			this._damageByAlly=value;
		}
		
		public function get pickupBonusBoxCount():uint
		{
			return this._pickupBonusBoxCount;
		}
		
		public function set pickupBonusBoxCount(value:uint):void
		{
			this._pickupBonusBoxCount=value;
		}
		
		public function get beTeleportCount():uint
		{
			return this._beTeleportCount;
		}
		
		public function set beTeleportCount(value:uint):void
		{
			this._beTeleportCount=value;
		}
		
		//Game Score about Playing
		public function get totalScore():uint
		{
			return exMath.intMax(
			this.profile.level*50+this.profile.experience*5+
			this.killAllyCount-this.suicideCount,
			0)+exMath.intMax(this.pickupBonusBoxCount*10+this.killCount*2-this.deathCount,0)*50+exMath.intMax(this.causeDamage-this.damageBy,0)
		}
		
		//============Instance Functions============//
		//About Profile
		/**
		 * If profile is player,then conver it to PlayeProfile.
		 * @return	this
		 */
		public function flushProfile():PlayerStats
		{
			if(this._profile is Player) this._profile=new PlayerProfile(this._profile);
			return this;
		}
		
		public function redirectPlayer(player:Player):PlayerStats
		{
			this._profile=player;
			return this;
		}
		
		//Kill And Death By
		public function getKillPlayerCount(player:Player):uint
		{
			return this._killPlayers.getPlayerValue(player)
		}
		
		public function getDeathByPlayerCount(player:Player):uint
		{
			return this._deathByPlayers.getPlayerValue(player)
		}
		
		public function setKillPlayerCount(player:Player,value:uint):void
		{
			this._killPlayers.setPlayerValue(player,value)
		}
		
		public function setDeathByPlayerCount(player:Player,value:uint):void
		{
			this._deathByPlayers.setPlayerValue(player,value)
		}
		
		public function addKillPlayerCount(player:Player,value:uint=1):void
		{
			this._killPlayers.setPlayerValue(player,getKillPlayerCount(player)+value)
		}
		
		public function addDeathByPlayerCount(player:Player,value:uint=1):void
		{
			this._deathByPlayers.setPlayerValue(player,getDeathByPlayerCount(player)+value)
		}
		//Cause Damage And Damage By
		public function getCauseDamagePlayerCount(player:Player):uint
		{
			return this._causeDamagePlayers.getPlayerValue(player)
		}
		
		public function getDamageByPlayerCount(player:Player):uint
		{
			return this._damageByPlayers.getPlayerValue(player)
		}
		
		public function setCauseDamagePlayerCount(player:Player,value:uint):void
		{
			this._causeDamagePlayers.setPlayerValue(player,value)
		}
		
		public function setDamageByPlayerCount(player:Player,value:uint):void
		{
			this._damageByPlayers.setPlayerValue(player,value)
		}
		
		public function addCauseDamagePlayerCount(player:Player,value:uint=1):void
		{
			this._causeDamagePlayers.setPlayerValue(player,getCauseDamagePlayerCount(player)+value)
		}
		
		public function addDamageByPlayerCount(player:Player,value:uint=1):void
		{
			this._damageByPlayers.setPlayerValue(player,getDamageByPlayerCount(player)+value)
		}
	}
}

import batr.game.entity.entities.players.*;

import flash.utils.Dictionary;

class Stat_PlayerCount
{
	//============Instance Variables============//
	protected var _dictionary:Dictionary=new Dictionary(true)
	
	//============Constructor Function============//
	public function Stat_PlayerCount(...params):void
	{
		setPlayerValues2(params)
	}
	
	//============Instance Functions============//
	public function getPlayerValue(player:Player):uint
	{
		if(player==null) return 0
		return uint(this._dictionary[player])
	}
	
	public function setPlayerValue(player:Player,value:uint):void
	{
		if(player==null) return
		this._dictionary[player]=value
	}
	
	public function setPlayerValues(...params):void
	{
		setPlayerValues2(params)
	}
	
	public function setPlayerValues2(params:Array):void
	{
		var player:Player,count:uint
		for(var i:uint=0;i<params.length-1;i+=2)
		{
			player=params[i] as Player
			count=uint(params[i+1])
			setPlayerValue(player,count)
		}
	}
	
	public function resetPlayerValue(player:Player):void
	{
		if(player==null) return
		this._dictionary[player]=0
	}
	
	public function deleteSelf():void
	{
		for(var p in this._dictionary)
		{
			delete this._dictionary[p]
		}
		this._dictionary=null
	}
}