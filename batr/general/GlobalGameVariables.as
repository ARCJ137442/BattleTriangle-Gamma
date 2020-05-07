package batr.general 
{
	import batr.fonts.*;
	
	import flash.text.Font;
	
	public class GlobalGameVariables 
	{
		//============Static Variables============//
		public static const DEFAULT_SIZE:uint=100
		public static const DEFAULT_SIZE_FRACTION:Number=1/Number(GlobalGameVariables.DEFAULT_SIZE)
		public static const DEFAULT_SCALE:Number=32/100
		public static const DISPLAY_SIZE:uint=768
		
		public static const TPS:uint=100
		public static const TICK_TIME_S:Number=1/TPS
		public static const TICK_TIME_MS:Number=TICK_TIME_S*1000
		//Timer:A delay lower than 20 milliseconds is not recommended
		
		public static const WEAPON_MIN_CD:uint=TPS/8
		public static const PROJECTILES_SPAWN_DISTANCE:Number=0.55
		
		public static const MAIN_FONT:Font=new MainFont()
		
		//============Static Getter And Setter============//
		public static function get DISPLAY_GRID_SIZE():Number
		{
			return DEFAULT_SIZE*DEFAULT_SCALE//32
		}
		
		public static function get DISPLAY_GRIDS():uint
		{
			return DISPLAY_SIZE/DISPLAY_GRID_SIZE//24
		}
		
		public static function get INTERNAL_DISPLAY_SIZE():uint
		{
			return DISPLAY_GRIDS*DEFAULT_SIZE//2400
		}
	}
}