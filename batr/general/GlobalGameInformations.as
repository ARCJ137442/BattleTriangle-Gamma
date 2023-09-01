package batr.general 
{
	public class GlobalGameInformations 
	{
		//============Static Variables============//
		public static const GAME_NAME:String="Battle Triangle";
		public static const GAME_NAME_SHORT:String="BATR";
		public static const GAME_DEV_STAGE:String="Gamma";
		public static const GAME_VERSION_MAJOR:String="0.2.0";
		//WILL REMOVE WHEN DEVELOP 0.2.1: "In order to synchronize the in-game CD with the real CD<Will be removed in 0.2.1>"
		public static const GAME_VERSION_MAIN:String="alpha";
		public static const GAME_VERSION_BUILD:String="06";
		public static const GAME_UPDATE_LOG:String="Debug Key: Fine game speed adjustment";
		
		//============Static Getter And Setter============//
		public static function get GAME_FULL_NAME():String
		{
			return GAME_NAME+" "+GAME_DEV_STAGE+" "+GAME_FULL_VERSION;
		}
		
		public static function get GAME_FULL_VERSION():String
		{
			return "v"+GAME_VERSION_MAJOR+"-"+GAME_VERSION_MAIN+"."+GAME_VERSION_BUILD;
		}
		
		//============Static Functions============//
		public static function toString():String
		{
			return GlobalGameInformations.GAME_FULL_NAME;
		}
	}
}
