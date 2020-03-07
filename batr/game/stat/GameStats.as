package batr.game.stat 
{
	import batr.game.main.*;
	import batr.game.model.*;
	import batr.game.entity.entities.players.*;
	
	/**
	 * Thst's a stats(or scoreboard) use for a game
	 * @author ARCJ137442
	 */
	public class GameStats extends Object 
	{
		//============Static Functions============//
		
		//============Instance Variables============//
		protected var _rule:GameRule;
		protected var _players:Vector.<PlayerStats>=new Vector.<PlayerStats>();
		
		protected var _mapTransformCount:uint=0;
		protected var _bonusGenerateCount:uint=0;
		
		//============Constructor============//
		public function GameStats(rule:GameRule,players:Vector.<Player>=null):void
		{
			super();
			this.rule=rule;
			if(players!=null) this.loadPlayers(players);
		}
		
		//Unfinished
		public function clone():GameStats
		{
			return new GameStats(this._rule).setPlayers(this._players);
		}
		
		//============Destructor============//
		public function deleteSelf():void
		{
			this.rule=null;
			this.clearPlayers();
			this._players=null;
		}
		
		//============Instance Getter And Setter============//
		public function get rule():GameRule
		{
			return this._rule;
		}
		
		public function set rule(value:GameRule):void
		{
			this._rule=value;
		}
		
		public function get players():Vector.<PlayerStats>
		{
			return this._players;
		}
		
		public function get mapTransformCount():uint
		{
			return this._mapTransformCount;
		}
		
		public function set mapTransformCount(value:uint):void
		{
			this._mapTransformCount=value;
		}
		
		public function get bonusGenerateCount():uint
		{
			return this._bonusGenerateCount;
		}
		
		public function set bonusGenerateCount(value:uint):void
		{
			this._bonusGenerateCount=value;
		}
		
		//============Instance Functions============//
		public function setPlayers(players:Vector.<PlayerStats>):GameStats
		{
			this._players=players;
			return this;
		}
		
		public function loadPlayers(players:Vector.<Player>):void
		{
			for(var i:uint=0;i<players.length;i++)
			{
				this._players.push(players[i].stats.flushProfile());
			}
		}
		
		public function clearPlayers():void
		{
			this._players.splice(0,int.MAX_VALUE);
		}
		
		public function importPlayersFromGame(game:Game):void
		{
			for each(var player:Player in game.entitySystem.players)
			{
				if(player!=null) this._players.push(player.stats);
			}
		}
	}
}