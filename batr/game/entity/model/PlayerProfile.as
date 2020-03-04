package batr.game.entity.model 
{
	import batr.game.entity.entities.players.Player;
	/**
	 * ...
	 * @author ARCJ137442
	 */
	public class PlayerProfile implements IPlayerProfile 
	{
		//============Instance Variables============//
		protected var _customName:String;
		protected var _experience:uint;
		protected var _level:uint;
		protected var _teamColor:uint;
		
		//============Constructor============//
		public function PlayerProfile(profile:IPlayerProfile=null):void
		{
			if(profile==null) return;
			this.copyFrom(profile);
		}
		
		public function copyFrom(profile:IPlayerProfile):void
		{
			this._customName=profile.customName;
			this._experience=profile.experience;
			this._level=profile.level;
			this._teamColor=profile.teamColor;
		}
		
		//============Instance Functions============//
		/* INTERFACE batr.game.entity.model.IPlayerProfile */
		public function get customName():String
		{
			return this._customName;
		}
		
		public function get experience():uint
		{
			return this._experience;
		}
		
		public function get level():uint
		{
			return this._level;
		}
		
		public function get teamColor():uint
		{
			return this._teamColor;
		}
	}
}