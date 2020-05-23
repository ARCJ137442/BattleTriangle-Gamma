package batr.game.effect 
{
	import batr.common.*;
	import batr.general.*;
	
	public class EffectType extends TypeCommon
	{
		//============Static Variables============//
		public static const NULL:EffectType=null
		public static const ABSTRACT:EffectType=new EffectType("Abstract")
		
		public static const EXPLODE:EffectType=new EffectType("Explode",1)
		public static const SPAWN:EffectType=new EffectType("Spawn",-1)
		public static const TELEPORT:EffectType=new EffectType("Teleport",-1)
		public static const PLAYER_DEATH_LIGHT:EffectType=new EffectType("PlayerDeathLight",1)
		public static const PLAYER_DEATH_ALPHA:EffectType=new EffectType("PlayerDeathAlpha",0)
		public static const PLAYER_HURT:EffectType=new EffectType("PlayerHurt",1)
		public static const PLAYER_LEVELUP:EffectType=new EffectType("PlayerLevelUp",1)
		public static const BLOCK_LIGHT:EffectType=new EffectType("BlockLight",1)
		
		public static const _ALL_EFFECT:Vector.<EffectType>=new <EffectType>[
			EffectType.EXPLODE,
			EffectType.SPAWN,
			EffectType.TELEPORT,
			EffectType.PLAYER_DEATH_LIGHT,
			EffectType.PLAYER_DEATH_ALPHA,
			EffectType.PLAYER_HURT,
			EffectType.PLAYER_LEVELUP,
			EffectType.BLOCK_LIGHT]
		
		//============Static Getter And Setter============//
		public static function get RANDOM():EffectType
		{
			return _ALL_EFFECT[exMath.random(_ALL_EFFECT.length)]
		}
		
		//============Static Functions============//
		public static function fromString(str:String):EffectType
		{
			for each(var type:EffectType in EffectType._ALL_EFFECT)
			{
				if(type.name==str) return type
			}
			return NULL
		}
		
		public static function isIncludeIn(type:EffectType,types:Vector.<EffectType>):Boolean
		{
			for each(var type2:EffectType in types)
			{
				if(type==type2) return true
			}
			return false
		}
		
		//============Instance Variables============//
		protected var _effectLayer:int
		
		//============Constructor Function============//
		public function EffectType(name:String,effectLayer:int=-1):void
		{
			super(name)
			this._effectLayer=effectLayer
		}
		
		//============Instance Getter And Setter============//
		public override function get label():String
		{
			return "effect";
		}
		
		/**
		 * GUI,HUD
		 * <Top>:POSITIVE
		 * MapTop,Projectile,MapMiddle,Player
		 * <Middle>:ZERO
		 * BonusBox,MapBottom
		 * <Bottom>:NEGATIVE
		 * Background
		 */
		public function get effectLayer():int
		{
			return this._effectLayer
		}
	}
}