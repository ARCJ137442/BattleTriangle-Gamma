package batr.game.model 
{
	import batr.common.*;
	import batr.general.*;
	import batr.translations.TranslationalText;
	
	import batr.game.block.*;
	import batr.game.map.*;
	import batr.game.main.*;
	import batr.game.model.*;
	import batr.game.stat.*;
	
	/**
	 * The result stores informations by game,at game end.
	 * @author ARCJ137442
	 */
	public class GameResult extends Object
	{
		//============Instance Variables============//
		protected var _stats:GameStats
		protected var _message:TranslationalText
		
		//============Constructor============//
		public function GameResult(host:Game,message:TranslationalText,stats:GameStats):void
		{
			super();
			this._message=message;
			this._stats=stats;
		}
		
		//============Destructor============//
		public function deleteSelf():void
		{
			
		}
		
		//============Instance Getter And Setter============//
		public function get message():TranslationalText
		{
			return this._message;
		}
		
		public function get stats():GameStats
		{
			return this._stats;
		}
		
		//============Instance Functions============//
	}
}