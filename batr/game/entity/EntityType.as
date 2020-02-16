package batr.game.entity 
{
	import batr.common.*;
	import batr.general.*;
	
	public class EntityType extends TypeCommon
	{
		//============Static Variables============//
		public static const NULL:EntityType=null
		public static const ABSTRACT:EntityType=new EntityType("Abstract")
		
		public static const BULLET_BASIC:EntityType=new EntityType("BulletBasic")
		public static const BULLET_NUKE:EntityType=new EntityType("BulletNuke")
		//public static const BULLET_POISON:EntityType=new EntityType("BulletPoison")
		public static const LASER_BASIC:EntityType=new EntityType("LaserBasic")
		public static const LASER_CONTINUOUS:EntityType=new EntityType("LaserContinuous")
		public static const LASER_TELEPORT:EntityType=new EntityType("LaserTeleport")
		public static const LASER_ABSORPTION:EntityType=new EntityType("LaserAbsorption")
		public static const WAVE:EntityType=new EntityType("Wave")
		public static const THROWED_BLOCK:EntityType=new EntityType("ThrowedBlock")
		//public static const CHAOS_RING:EntityType=new EntityType("ChaosRing")
		//public static const T_BOMB:EntityType=new EntityType("TBomb")
		public static const BONUS_BOX:EntityType=new EntityType("BonusBox")
		
		public static const PLAYER:EntityType=new EntityType("Player")
		public static const AI_PLAYER:EntityType=new EntityType("AIPlayer")
		
		public static const _BULLETS:Vector.<EntityType>=new <EntityType>[EntityType.BULLET_BASIC,EntityType.BULLET_NUKE]//,EntityType.BULLET_POISON
		public static const _LASERS:Vector.<EntityType>=new <EntityType>[EntityType.LASER_BASIC,EntityType.LASER_CONTINUOUS,EntityType.LASER_TELEPORT,EntityType.LASER_ABSORPTION]
		//public static const _WAVES:Vector.<EntityType>=new <EntityType>[EntityType.WAVE,EntityType.CHAOS_RING]
		public static const _PROJECTILES:Vector.<EntityType>=new <EntityType>[EntityType.WAVE,EntityType.THROWED_BLOCK].concat(EntityType._BULLETS,EntityType._LASERS)//EntityType.T_BOMB,EntityType._WAVES
		public static const _ALL_ENTITY:Vector.<EntityType>=new <EntityType>[EntityType.PLAYER,EntityType.BONUS_BOX].concat(EntityType._PROJECTILES)
		
		//============Static Getter And Setter============//
		public static function get RANDOM():EntityType
		{
			return _ALL_ENTITY[exMath.random(_ALL_ENTITY.length)]
		}
		
		//============Static Functions============//
		public static function fromString(str:String):EntityType
		{
			for each(var type:EntityType in EntityType._ALL_ENTITY)
			{
				if(type.name==str) return type
			}
			return NULL
		}
		
		public static function isIncludeIn(type:EntityType,types:Vector.<EntityType>):Boolean
		{
			for each(var type2:EntityType in types)
			{
				if(type===type2) return true;
			}
			return false;
		}
		
		//============Constructor Function============//
		public function EntityType(name:String):void
		{
			super(name);
		}
		
		//============Instance Getter And Setter============//
		public override function get label():String
		{
			return "entity";
		}
	}
}