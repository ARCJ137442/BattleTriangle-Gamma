package batr.game.model 
{
	import batr.common.*;
	import batr.general.*;
	
	public class GameModeType extends TypeCommon
	{
		//============Static Variables============//
		public static const NULL:GameModeType=null
		
		public static const REGULAR:GameModeType=new GameModeType("regular");
		public static const BATTLE:GameModeType=new GameModeType("battle");
		public static const SURVIVAL:GameModeType=new GameModeType("survival");
		
		public static const _ALL_TYPE:Vector.<GameModeType>=new <GameModeType>
		[
			REGULAR,BATTLE,SURVIVAL
		]
		
		//============Static Getter And Setter============//
		public static function get RANDOM():GameModeType
		{
			return GameModeType._ALL_TYPE[exMath.random(GameModeType._ALL_TYPE.length)]
		}
		
		public static function get NUM_TYPES():uint
		{
			return GameModeType._ALL_TYPE.length;
		}
		
		//============Static Functions============//
		public static function fromString(str:String):GameModeType
		{
			for each(var type:GameModeType in GameModeType._ALL_TYPE)
			{
				if(type.name==str) return type;
			}
			return NULL;
		}
		
		public static function isIncludeIn(type:GameModeType,types:Vector.<GameModeType>):Boolean
		{
			for each(var type2:GameModeType in types)
			{
				if(type===type2) return true;
			}
			return false;
		}
		
		//============Constructor Function============//
		public function GameModeType(name:String):void
		{
			super(name);
		}
		
		//============Instance Getter And Setter============//
		public override function get label():String
		{
			return "gameMode";
		}
	}
}