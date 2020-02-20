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
		//============Instance Variables============//
		protected var _rule:GameRule
		protected var _players:Vector.<PlayerStats>=new Vector.<PlayerStats>();
		
		//============Constructor Function============//
		public function GameStats(rule:GameRule):void
		{
			super();
			this.rule=rule;
		}
		
		//Unfinished
		public function clone():GameStats
		{
			
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
		
		//============Instance Functions============//
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