package batr.general 
{
	public class GlobalGameInformations 
	{
		//============Static Variables============//
		public static const GAME_NAME:String="Battle Triangle";
		public static const GAME_NAME_SHORT:String="BATR";
		public static const GAME_DEV_STAGE:String="Gamma";
		public static const GAME_VERSION_MAJOR:String="0.2.0";
		public static const GAME_VERSION_MAIN:String="alpha";
		public static const GAME_VERSION_BUILD:String="02";
		public static const GAME_UPDATE_LOG:String="Class refactor:Split EntityCommon to EntityInt and EntityFloat - Faild>>>Now Throwed Block can't move out of the map>>>Remove gradient of bullets>>>Fix bug in MAP_7>>>Optimize (Experience&Buff) System>>>Smarter AI>>>Bug Fix>>>Added Game Score Rank";
		
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
