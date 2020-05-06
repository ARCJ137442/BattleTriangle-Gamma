package batr.game.model 
{
	import batr.common.*;
	import batr.general.*;
	
	public class BonusType extends TypeCommon
	{
		//============Static Variables============//
		public static const NULL:BonusType=null
		
		//Health,Life
		public static const ADD_HEALTH:BonusType=new BonusType("addHealth")
		public static const ADD_HEAL:BonusType=new BonusType("addHeal")
		public static const ADD_LIFE:BonusType=new BonusType("addLife")
		
		//Weapon
		public static const RANDOM_WEAPON:BonusType=new BonusType("randomWeapon")
		
		//Attributes&Experience
		public static const BUFF_DAMAGE:BonusType=new BonusType("buffDamage")
		public static const BUFF_CD:BonusType=new BonusType("buffCD")
		public static const BUFF_RESISTANCE:BonusType=new BonusType("buffResistance")
		public static const BUFF_RADIUS:BonusType=new BonusType("buffRadius")
		
		public static const ADD_EXPERIENCE:BonusType=new BonusType("addExperience")
		
		//Teleport
		public static const RANDOM_TELEPORT:BonusType=new BonusType("randomTeleport")
		
		//Team
		public static const RANDOM_CHANGE_TEAM:BonusType=new BonusType("randomChangeTeam")
		public static const UNITE_PLAYER:BonusType=new BonusType("unitePlayer")
		public static const UNITE_AI:BonusType=new BonusType("uniteAI")
		
		//General
		public static const _ABOUT_HEALTH:Vector.<BonusType>=new <BonusType>[BonusType.ADD_HEALTH,BonusType.ADD_HEAL,BonusType.ADD_LIFE]
		public static const _ABOUT_WEAPON:Vector.<BonusType>=new <BonusType>[BonusType.RANDOM_WEAPON]
		public static const _ABOUT_ATTRIBUTES:Vector.<BonusType>=new <BonusType>[BonusType.ADD_EXPERIENCE,BonusType.BUFF_CD,BonusType.BUFF_DAMAGE,BonusType.BUFF_RADIUS,BonusType.BUFF_RESISTANCE]
		public static const _ABOUT_TEAM:Vector.<BonusType>=new <BonusType>[BonusType.RANDOM_CHANGE_TEAM]
		public static const _OTHER:Vector.<BonusType>=new <BonusType>[BonusType.RANDOM_TELEPORT]
		//Unused:Unition
		public static const _UNUSED:Vector.<BonusType>=new <BonusType>[BonusType.UNITE_PLAYER,BonusType.UNITE_AI]
		public static const _ALL_AVALIABLE_TYPE:Vector.<BonusType>=BonusType._OTHER.concat(BonusType._ABOUT_HEALTH,BonusType._ABOUT_WEAPON,BonusType._ABOUT_ATTRIBUTES,BonusType._ABOUT_TEAM)
		public static const _ALL_TYPE:Vector.<BonusType>=BonusType._ALL_AVALIABLE_TYPE.concat(BonusType._UNUSED)
		
		//============Static Getter And Setter============//
		public static function get RANDOM():BonusType
		{
			return _ALL_TYPE[exMath.random(_ALL_TYPE.length)]
		}
		
		public static function get RANDOM_AVALIABLE():BonusType
		{
			return _ALL_AVALIABLE_TYPE[exMath.random(_ALL_AVALIABLE_TYPE.length)]
		}
		
		//============Static Functions============//
		public static function fromString(str:String):BonusType
		{
			for each(var type:BonusType in BonusType._ALL_TYPE)
			{
				if(type.name==str) return type;
			}
			return NULL;
		}
		
		public static function isIncludeIn(type:BonusType,types:Vector.<BonusType>):Boolean
		{
			for each(var type2:BonusType in types)
			{
				if(type==type2) return true;
			}
			return false;
		}
		
		//============Constructor Function============//
		public function BonusType(name:String):void
		{
			super(name);
		}
		
		//============Instance Getter And Setter============//
		public override function get label():String
		{
			return "bonus";
		}
	}
}
