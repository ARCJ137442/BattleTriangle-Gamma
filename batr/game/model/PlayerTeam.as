package batr.game.model 
{
	public class PlayerTeam extends Object
	{
		//============Static Variables============//
		public static const isInited:Boolean=cInit()
		
		//============Static Getter And Setter============//
		
		//============Static Functions============//
		protected static function cInit():Boolean
		{
			return true;
		}
		
		//============Instance Variables============//
		protected var _defaultColor:uint
		
		//============Constructor Function============//
		public function PlayerTeam(color:uint=0x000000):void
		{
			this._defaultColor=color;
		}
		
		//============Destructor Function============//
		public function deleteSelf():void
		{
			this._defaultColor=0x000000;
		}
		
		//============Copy Constructor Function============//
		public function clone():PlayerTeam
		{
			return new PlayerTeam(this._defaultColor);
		}
		
		//============Instance Getter And Setter============//
		public function get defaultColor():uint
		{
			return this._defaultColor;
		}
		
		//============Instance Functions============//
	}
}