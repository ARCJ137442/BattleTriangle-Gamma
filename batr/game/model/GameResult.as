package batr.game.model 
{
	import batr.common.*;
	import batr.general.*;
	import batr.translations.ForcedTranslationalText;
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
		//============Static Functions============//
		protected static function scoreCompareFunc(x:PlayerStats,y:PlayerStats):int
		{
			return exMath.sgn(y.totalScore-x.totalScore);
		}
		
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
			this._message=null
			this._stats=null;
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
		
		public function get rankingText():ForcedTranslationalText
		{
			//W.I.P
			var text:String="";
			var sortedStatList:Vector.<PlayerStats>=this._stats.players.concat().sort(scoreCompareFunc);
			var currentStats:PlayerStats;
			for(var i:int=0;i<sortedStatList.length;i++)
			{
				currentStats=sortedStatList[i];
				text+=currentStats.profile.customName+"\t\t\t"+currentStats.totalScore+"\n";
			}
			return new ForcedTranslationalText(null,null,text);
		}
		
		//============Instance Functions============//
	}
}