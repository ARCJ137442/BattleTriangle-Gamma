package batr.translations 
{
	import batr.common.*;
	import batr.general.*;
	
	import batr.game.block.*;
	import batr.game.entity.*;
	import batr.game.entity.ai.*;
	import batr.game.effect.*;
	import batr.game.model.*;
	import batr.game.map.*;
	import batr.game.main.*;
	import batr.game.events.*;
	
	import batr.menu.events.*;
	import batr.menu.objects.*;
	import batr.menu.objects.selecter.*;
	
	import batr.main.*;
	import batr.fonts.*;
	import batr.translations.*
	
	public class TranslationKey 
	{
		//============Static Variables============//
		//====Keys====//
		public static const NULL:String="";
		
		//batr.language
		public static const LANGUAGE_SELF:String="batr.language.self";
		
		//batr.code
		public static const INFINITY:String="batr.code.infinity";
		public static const TRUE:String="batr.code.true";
		public static const FALSE:String="batr.code.false";
		
		//batr.boolean
		public static const BOOLEAN_YES:String="batr.boolean.yes";
		public static const BOOLEAN_NO:String="batr.boolean.no";
		
		//batr.menu
		public static const LANGUAGE:String="batr.menu.language";
		public static const QUICK_GAME:String="batr.menu.quickGame";
		public static const SELECT_GAME:String="batr.menu.selectGame";
		public static const CUSTOM_MODE:String="batr.menu.customMode";
		public static const START:String="batr.menu.start";
		public static const ADVANCED:String="batr.menu.advanced";
		public static const SAVES:String="batr.menu.saves";
		public static const BACK:String="batr.menu.back";
		public static const CONTINUE:String="batr.menu.continue";
		public static const MAIN_MENU:String="batr.menu.mainMenu";
		
		//batr.select
		public static const PLAYER_COUNT:String="batr.select.playerCount";
		public static const AI_PLAYER_COUNT:String="batr.select.AIPlayerCount";
		public static const GAME_MODE:String="batr.select.gameMode";
		public static const INITIAL_MAP:String="batr.select.initialMap";
		
		//batr.game
		public static const GAME_RESULT:String="batr.game.gameResult";
		public static const NOTHING_WIN:String="batr.game.nothingWin";
		public static const WIN_SIGNLE_PLAYER:String="batr.game.winSinglePlayer";
		public static const WIN_MULTI_PLAYER:String="batr.game.winMultiPlayer";
		public static const WIN_PER_PLAYER:String="batr.game.winPerPlayer";
		public static const WIN_ALL_PLAYER:String="batr.game.winAllPlayer";
		
		//batr.game.map
		public static const MAP_RANDOM:String="batr.game.map.random";
		
		//batr.game.key
		public static const REMAIN_TRANSFORM_TIME:String="batr.game.key.mapTransformTime";
		public static const GAME_DURATION:String="batr.game.key.gameDuration";
		
		//batr.custom
		public static const DEFAULT_WEAPON:String="batr.custom.defaultWeapon";
		public static const DEFAULT_HEALTH:String="batr.custom.defaultHealth";
		public static const DEFAULT_MAX_HEALTH:String="batr.custom.defaultMaxHealth";
		public static const REMAIN_LIFES_PLAYER:String="batr.custom.remainLifesPlayer";
		public static const REMAIN_LIFES_AI:String="batr.custom.remainLifesAI";
		public static const MAX_BONUS_COUNT:String="batr.custom.maxBonusCount";
		public static const BONUS_SPAWN_AFTER_DEATH:String="batr.custom.bonusSpawnAfterPlayerDeath";
		public static const MAP_TRANSFORM_TIME:String="batr.custom.mapTransformTime";
		public static const WEAPONS_NO_CD:String="batr.custom.weaponsNoCD";
		public static const RESPAWN_TIME:String="batr.custom.respawnTime";
		public static const ASPHYXIA_DAMAGE:String="batr.custom.asphyxiaDamage";
		
		//batr.custom.property
		public static const CERTAINLY_DEAD:String="batr.custom.property.certainlyDead";
		public static const COMPLETELY_RANDOM:String="batr.custom.property.completelyRandom";
		public static const UNIFORM_RANDOM:String="batr.custom.property.uniformRandom";
		public static const NEVER:String="batr.custom.property.never";
		
		//============Constructor Function============//
		public function TranslationKey() 
		{
			throw new Error("Cannot construct this class!");
		}
		
		//============Static Getter And Setter===========//
		
		//============Static Functions===========//
		//========Common========//
		protected static function getCommonKey(label:String,name:String,suffix:String):String
		{
			return ("batr."+label+"."+name+"."+suffix);
		}
		
		//========Block========//
		public static function getTypeNameKey(type:TypeCommon):String
		{
			return TranslationKey.getCommonKey(type.label,type.name,"name");
		}
		
		public static function getTypeDescriptionKey(type:TypeCommon):String
		{
			return TranslationKey.getCommonKey(type.label,type.name,"description");
		}
		
		/**
		 * Returns a translational key(String) that can use for native text display.
		 * @param	type	a type extends TypeCommon.
		 * @param	isDescription	The boolean determines name/description.
		 * @return	A string based on the type.
		 */
		public static function getTypeKey(type:TypeCommon,isDescription:Boolean):String
		{
			return (isDescription?getTypeDescriptionKey:getTypeNameKey)(type);
		}
	}
}