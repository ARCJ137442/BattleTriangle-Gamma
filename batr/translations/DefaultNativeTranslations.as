package batr.translations 
{
	import batr.general.*;
	import batr.game.block.*;
	import batr.game.effect.*;
	import batr.game.entity.*;
	import batr.game.model.*;
	
	internal class DefaultNativeTranslations 
	{
		//============Constructor Function============//
		public function DefaultNativeTranslations():void
		{
			throw new Error("Cannot construct this class!");
		}
		
		//============Default Translations(Static)============//
		//========Translations Create And Get========//
		public static function get EN_US():Translations
		{
			//EN_US._getFunction=DefaultNativeTranslations.getDefaultTranslation;//=Translations.fromStringArr2("")
			return new Translations(
				//batr.language
				TranslationKey.LANGUAGE_SELF,"English",
				//batr.code
				TranslationKey.INFINITY,"Infinity",
				TranslationKey.TRUE,"True",
				TranslationKey.FALSE,"False",
				//batr.boolean
				TranslationKey.BOOLEAN_YES,"Yes",
				TranslationKey.BOOLEAN_NO,"No",
				//batr.menu
				TranslationKey.LANGUAGE,"Language",
				TranslationKey.QUICK_GAME,"Quick Game",
				TranslationKey.SELECT_GAME,"Select Game",
				TranslationKey.CUSTOM_MODE,"Custom Mode",
				TranslationKey.START,"Start",
				TranslationKey.ADVANCED,"Advanced",
				TranslationKey.ADVANCED_CONFIG,"Config File",
				TranslationKey.SAVES,"Saves",
				TranslationKey.BACK,"Back",
				TranslationKey.CONTINUE,"Continue",
				TranslationKey.MAIN_MENU,"Main Menu",
				TranslationKey.GLOBAL_STAT,"Global Stat",
				TranslationKey.SCORE_RANKING,"Score Ranking",
				TranslationKey.PAUSED,"Paused",
				TranslationKey.RESTART,"Restart",
				//batr.custom
				TranslationKey.DEFAULT_WEAPON,"Default Weapon",
				TranslationKey.DEFAULT_HEALTH,"Default Health",
				TranslationKey.DEFAULT_MAX_HEALTH,"Default MaxHealth",
				TranslationKey.REMAIN_LIFES_PLAYER,"Player Remain Lifes",
				TranslationKey.REMAIN_LIFES_AI,"AI Remain Lifes",
				TranslationKey.MAX_BONUS_COUNT,"Max Bonus Count",
				TranslationKey.BONUS_SPAWN_AFTER_DEATH,"Bonus Spawn After Death",
				TranslationKey.MAP_TRANSFORM_TIME,"Map Transfor Time(s)",
				TranslationKey.WEAPONS_NO_CD,"Weapons No CD",
				TranslationKey.RESPAWN_TIME,"Respawn Time(s)",
				TranslationKey.ASPHYXIA_DAMAGE,"Asphyxia Damage",
				//batr.select
				TranslationKey.PLAYER_COUNT,"Player Count",
				TranslationKey.AI_PLAYER_COUNT,"AIPlayer Count",
				TranslationKey.GAME_MODE,"Game Mode",
				TranslationKey.INITIAL_MAP,"Initial Map",
				TranslationKey.LOCK_TEAMS,"Lock Teams",
				//batr.game
				TranslationKey.GAME_RESULT,"Game Result",
				TranslationKey.NOTHING_WIN,"No player wins in the game",
				TranslationKey.WIN_SIGNLE_PLAYER," wins in the game",
				TranslationKey.WIN_MULTI_PLAYER," win in the game",
				TranslationKey.WIN_PER_PLAYER," players win in the game",
				TranslationKey.WIN_ALL_PLAYER,"All players win in the game",
				TranslationKey.FILL_FRAME_OFF,"Fill Frame:Off",
				TranslationKey.FILL_FRAME_ON,"Fill Frame:On",
				//batr.game.map
				TranslationKey.MAP_RANDOM,"Random",
				//batr.game.key
				TranslationKey.REMAIN_TRANSFORM_TIME,"Remain Transform Time",
				TranslationKey.GAME_DURATION,"Game Duration",
				//batr.stat
				TranslationKey.TRANSFORM_MAP_COUNT,"Map Transform Count",
				TranslationKey.BONUS_GENERATE_COUNT,"Bonus Generate Count",
				//batr.stat.player
				TranslationKey.FINAL_LEVEL,"Final Level",
				TranslationKey.KILL_COUNT,"Kill Count",
				TranslationKey.DEATH_COUNT,"Death Count",
				TranslationKey.DEATH_BY_PLAYER_COUNT,"Death by Player Count",
				TranslationKey.CURSE_DAMAGE,"Cause Damage",
				TranslationKey.DAMAGE_BY,"Damage By",
				TranslationKey.PICKUP_BONUS,"Ppckup Bonus",
				TranslationKey.BE_TELEPORT_COUNT,"Be Teleport Count",
				TranslationKey.TOTAL_SCORE,"Total Score",
				//batr.custom.property
				TranslationKey.COMPLETELY_RANDOM,"C-Random",
				TranslationKey.UNIFORM_RANDOM,"U-Random",
				TranslationKey.CERTAINLY_DEAD,"Certainly Dead",
				TranslationKey.NEVER,"Never",
				//GameModeTypes
				TranslationKey.getTypeNameKey(GameModeType.REGULAR),
					"Regular",
				TranslationKey.getTypeNameKey(GameModeType.BATTLE),
					"Battle",
				TranslationKey.getTypeNameKey(GameModeType.SURVIVAL),
					"Survival",
				TranslationKey.getTypeNameKey(GameModeType.HARD),
					"Hard"
			);
		}
		
		public static function get ZH_CN():Translations
		{
			return new Translations(
				//batr.language
				TranslationKey.LANGUAGE_SELF,"\u7b80\u4f53\u4e2d\u6587",
				//batr.code
				TranslationKey.INFINITY,"\u65e0\u9650",
				TranslationKey.TRUE,"\u771f",
				TranslationKey.FALSE,"\u5047",
				//batr.boolean
				TranslationKey.BOOLEAN_YES,"\u662f",
				TranslationKey.BOOLEAN_NO,"\u5426",
				//batr.menu
				TranslationKey.LANGUAGE,"\u8bed\u8a00",
				TranslationKey.QUICK_GAME,"\u5feb\u901f\u6e38\u620f",
				TranslationKey.SELECT_GAME,"\u9009\u62e9\u6e38\u620f",
				TranslationKey.CUSTOM_MODE,"\u81ea\u5b9a\u4e49\u6a21\u5f0f",
				TranslationKey.START,"\u5f00\u59cb",
				TranslationKey.ADVANCED,"\u9ad8\u7ea7",
				TranslationKey.ADVANCED_CONFIG,"\u914d\u7f6e\u6587\u4ef6",
				TranslationKey.SAVES,"\u5b58\u6863",
				TranslationKey.BACK,"\u8fd4\u56de",
				TranslationKey.CONTINUE,"\u7ee7\u7eed",
				TranslationKey.MAIN_MENU,"\u4e3b\u754c\u9762",
				TranslationKey.GLOBAL_STAT,"\u5168\u5c40\u7edf\u8ba1",
				TranslationKey.SCORE_RANKING,"\u603b\u5206\u6392\u884c",
				TranslationKey.PAUSED,"\u5df2\u6682\u505c",
				TranslationKey.RESTART,"\u91cd\u65b0\u5f00\u59cb",
				//batr.custom
				TranslationKey.DEFAULT_WEAPON,"\u9ed8\u8ba4\u6b66\u5668",
				TranslationKey.DEFAULT_HEALTH,"\u9ed8\u8ba4\u751f\u547d\u503c",
				TranslationKey.DEFAULT_MAX_HEALTH,"\u9ed8\u8ba4\u6700\u5927\u751f\u547d\u503c",
				TranslationKey.REMAIN_LIFES_PLAYER,"\u73a9\u5bb6\u5269\u4f59\u751f\u547d",
				TranslationKey.REMAIN_LIFES_AI,"\u0041\u0049\u5269\u4f59\u751f\u547d",
				TranslationKey.MAX_BONUS_COUNT,"\u6700\u5927\u5956\u52b1\u7bb1\u6570",
				TranslationKey.BONUS_SPAWN_AFTER_DEATH,"\u5956\u52b1\u7bb1\u6b7b\u540e\u751f\u6210",
				TranslationKey.MAP_TRANSFORM_TIME,"\u5730\u56fe\u53d8\u6362\u65f6\u95f4\u0028\u0073\u0029",
				TranslationKey.WEAPONS_NO_CD,"\u6b66\u5668\u65e0\u51b7\u5374",
				TranslationKey.RESPAWN_TIME,"\u91cd\u751f\u65f6\u95f4\u0028\u0073\u0029",
				TranslationKey.ASPHYXIA_DAMAGE,"\u7a92\u606f\u4f24\u5bb3",
				//batr.select
				TranslationKey.PLAYER_COUNT,"\u73a9\u5bb6\u6570\u91cf",
				TranslationKey.AI_PLAYER_COUNT,"\u0041\u0049\u73a9\u5bb6\u6570\u91cf",
				TranslationKey.GAME_MODE,"\u6e38\u620f\u6a21\u5f0f",
				TranslationKey.INITIAL_MAP,"\u521d\u59cb\u5730\u56fe",
				TranslationKey.LOCK_TEAMS,"\u9501\u5b9a\u961f\u4f0d",
				//batr.game
				TranslationKey.GAME_RESULT,"\u6e38\u620f\u7ed3\u679c",
				TranslationKey.NOTHING_WIN,"\u6ca1\u6709\u73a9\u5bb6\u5728\u6e38\u620f\u4e2d\u80dc\u5229",
				TranslationKey.WIN_SIGNLE_PLAYER,"\u5728\u6e38\u620f\u4e2d\u80dc\u5229",
				TranslationKey.WIN_MULTI_PLAYER,"\u5728\u6e38\u620f\u4e2d\u80dc\u5229",
				TranslationKey.WIN_PER_PLAYER,"\u4e2a\u73a9\u5bb6\u5728\u6e38\u620f\u4e2d\u80dc\u5229",
				TranslationKey.WIN_ALL_PLAYER,"\u6240\u6709\u73a9\u5bb6\u5728\u6e38\u620f\u4e2d\u80dc\u5229",
				TranslationKey.FILL_FRAME_OFF,"\u8865\u5e27\u5173\u95ed",
				TranslationKey.FILL_FRAME_ON,"\u8865\u5e27\u5f00\u542f",
				//batr.game.map
				TranslationKey.MAP_RANDOM,"\u968f\u673a",
				//batr.game.key
				TranslationKey.REMAIN_TRANSFORM_TIME,"\u5269\u4f59\u53d8\u6362\u65f6\u95f4",
				TranslationKey.GAME_DURATION,"\u6e38\u620f\u65f6\u957f",
				//batr.stat
				TranslationKey.TRANSFORM_MAP_COUNT,"\u5730\u56fe\u53d8\u6362\u6b21\u6570",
				TranslationKey.BONUS_GENERATE_COUNT,"\u5956\u52b1\u7bb1\u751f\u6210\u6570",
				//batr.stat.player
				TranslationKey.FINAL_LEVEL,"\u6700\u7ec8\u7b49\u7ea7",
				TranslationKey.KILL_COUNT,"\u000a\u51fb\u6740\u6570",
				TranslationKey.DEATH_COUNT,"\u000a\u6b7b\u4ea1\u6570",
				TranslationKey.DEATH_BY_PLAYER_COUNT,"\u000a\u88ab\u73a9\u5bb6\u51fb\u6740\u6570",
				TranslationKey.CURSE_DAMAGE,"\u000a\u9020\u6210\u4f24\u5bb3",
				TranslationKey.DAMAGE_BY,"\u000a\u53d7\u5230\u4f24\u5bb3",
				TranslationKey.PICKUP_BONUS,"\u62fe\u53d6\u5956\u52b1\u7bb1",
				TranslationKey.BE_TELEPORT_COUNT,"\u88ab\u4f20\u9001\u6b21\u6570",
				TranslationKey.TOTAL_SCORE,"\u603b\u5206",
				//batr.custom.property
				TranslationKey.COMPLETELY_RANDOM,"\u5b8c\u5168\u968f\u673a",
				TranslationKey.UNIFORM_RANDOM,"\u7edf\u4e00\u968f\u673a",
				TranslationKey.CERTAINLY_DEAD,"\u5fc5\u6b7b",
				TranslationKey.NEVER,"\u4ece\u4e0d",
				//BlockTypes
				TranslationKey.getTypeNameKey(BlockType.VOID),
					"\u7a7a\u4f4d",
				TranslationKey.getTypeNameKey(BlockType.WALL),
					"\u5899",
				TranslationKey.getTypeNameKey(BlockType.WATER),
					"\u6c34",
				TranslationKey.getTypeNameKey(BlockType.GLASS),
					"\u73bb\u7483",
				TranslationKey.getTypeNameKey(BlockType.BEDROCK),
					"\u57fa\u5ca9",
				TranslationKey.getTypeNameKey(BlockType.X_TRAP_HURT),
					"\u0058\u9677\u9631\u002d\u4f24\u5bb3",
				TranslationKey.getTypeNameKey(BlockType.X_TRAP_KILL),
					"\u0058\u9677\u9631\u002d\u6b7b\u4ea1",
				TranslationKey.getTypeNameKey(BlockType.X_TRAP_ROTATE),
					"\u0058\u9677\u9631\u002d\u65cb\u8f6c",
				TranslationKey.getTypeNameKey(BlockType.COLORED_BLOCK),
					"\u8272\u5757",
				TranslationKey.getTypeNameKey(BlockType.COLOR_SPAWNER),
					"\u8272\u5757\u751f\u6210\u5668",
				TranslationKey.getTypeNameKey(BlockType.LASER_TRAP),
					"\u6fc0\u5149\u9677\u9631",
				TranslationKey.getTypeNameKey(BlockType.METAL),
					"\u91d1\u5c5e",
				//EntityTypes
				TranslationKey.getTypeNameKey(EntityType.BULLET_BASIC),
					"\u57fa\u7840\u5b50\u5f39",
				TranslationKey.getTypeNameKey(EntityType.BULLET_NUKE),
					"\u6838\u5f39",
				TranslationKey.getTypeNameKey(EntityType.SUB_BOMBER),
					"\u5b50\u8f70\u70b8\u673a",
				TranslationKey.getTypeNameKey(EntityType.LASER_BASIC),
					"\u57fa\u7840\u6fc0\u5149",
				TranslationKey.getTypeNameKey(EntityType.LASER_PULSE),
					"\u8109\u51b2\u6fc0\u5149",
				TranslationKey.getTypeNameKey(EntityType.LASER_TELEPORT),
					"\u4f20\u9001\u6fc0\u5149",
				TranslationKey.getTypeNameKey(EntityType.LASER_ABSORPTION),
					"\u5438\u6536\u6fc0\u5149",
				TranslationKey.getTypeNameKey(EntityType.WAVE),
					"\u6ce2\u6d6a",
				TranslationKey.getTypeNameKey(EntityType.THROWED_BLOCK),
					"\u63b7\u51fa\u7684\u65b9\u5757",
				TranslationKey.getTypeNameKey(EntityType.BONUS_BOX),
					"\u5956\u52b1\u7bb1",
				TranslationKey.getTypeNameKey(EntityType.PLAYER),
					"\u73a9\u5bb6",
				TranslationKey.getTypeNameKey(EntityType.AI_PLAYER),
					"\u0041\u0049\u73a9\u5bb6",
				//EffectTypes
				TranslationKey.getTypeNameKey(EffectType.EXPLODE),
					"\u7206\u70b8",
				TranslationKey.getTypeNameKey(EffectType.SPAWN),
					"\u91cd\u751f",
				TranslationKey.getTypeNameKey(EffectType.TELEPORT),
					"\u4f20\u9001",
				TranslationKey.getTypeNameKey(EffectType.PLAYER_DEATH_LIGHT),
					"\u73a9\u5bb6\u6b7b\u4ea1\u70ab\u5149",
				TranslationKey.getTypeNameKey(EffectType.PLAYER_DEATH_ALPHA),
					"\u73a9\u5bb6\u6b7b\u4ea1\u6de1\u51fa",
				TranslationKey.getTypeNameKey(EffectType.PLAYER_LEVELUP),
					"\u73a9\u5bb6\u5347\u7ea7",
				TranslationKey.getTypeNameKey(EffectType.BLOCK_LIGHT),
					"\u65b9\u5757\u9ad8\u4eae",
				//WeaponTypes
				TranslationKey.getTypeNameKey(WeaponType.BULLET),
					"\u5b50\u5f39",
				TranslationKey.getTypeNameKey(WeaponType.NUKE),
					"\u6838\u5f39",
				TranslationKey.getTypeNameKey(WeaponType.SUB_BOMBER),
					"\u5b50\u8f70\u70b8\u673a",
				TranslationKey.getTypeNameKey(WeaponType.TRACKING_BULLET),
					"\u8ffd\u8e2a\u5b50\u5f39",
				TranslationKey.getTypeNameKey(WeaponType.LASER),
					"\u6fc0\u5149",
				TranslationKey.getTypeNameKey(WeaponType.PULSE_LASER),
					"\u8109\u51b2\u6fc0\u5149",
				TranslationKey.getTypeNameKey(WeaponType.TELEPORT_LASER),
					"\u4f20\u9001\u6fc0\u5149",
				TranslationKey.getTypeNameKey(WeaponType.ABSORPTION_LASER),
					"\u5438\u6536\u6fc0\u5149",
				TranslationKey.getTypeNameKey(WeaponType.WAVE),
					"\u6ce2\u6d6a",
				TranslationKey.getTypeNameKey(WeaponType.BLOCK_THROWER),
					"\u65b9\u5757\u6295\u63b7\u8005",
				TranslationKey.getTypeNameKey(WeaponType.MELEE),
					"\u8fd1\u6218",
				TranslationKey.getTypeNameKey(WeaponType.LIGHTNING),
					"\u95ea\u7535",
				TranslationKey.getTypeNameKey(WeaponType.SHOCKWAVE_ALPHA),
					"\u51b2\u51fb\u6ce2\u002d\u03b1",
				TranslationKey.getTypeNameKey(WeaponType.SHOCKWAVE_BETA),
					"\u51b2\u51fb\u6ce2\u002d\u03b2",
				//GameModeTypes
				TranslationKey.getTypeNameKey(GameModeType.REGULAR),
					"\u6b63\u5e38",
				TranslationKey.getTypeNameKey(GameModeType.BATTLE),
					"\u6df7\u6218",
				TranslationKey.getTypeNameKey(GameModeType.SURVIVAL),
					"\u751f\u5b58",
				TranslationKey.getTypeNameKey(GameModeType.HARD),
					"\u56f0\u96be"
			);
		}
		
		public static function getDefaultTranslation(key:String):String
		{
			var type:TypeCommon;
			//Block Type
			for each(type in BlockType._NORMAL_BLOCKS)
			{
				if(type==null) continue;
				if(key==TranslationKey.getTypeNameKey(type)) return type.name;
			}
			//Entity Type
			for each(type in EntityType._ALL_ENTITY)
			{
				if(type==null) continue;
				if(key==TranslationKey.getTypeNameKey(type)) return type.name;
			}
			//Effect Type
			for each(type in EffectType._ALL_EFFECT)
			{
				if(type==null) continue;
				if(key==TranslationKey.getTypeNameKey(type)) return type.name;
			}
			//Weapon Type
			for each(type in WeaponType._ALL_WEAPON)
			{
				if(type==null) continue;
				if(key==TranslationKey.getTypeNameKey(type)) return type.name;
			}
			//Bonus Type
			for each(type in BonusType._ALL_TYPE)
			{
				if(type==null) continue;
				if(key==TranslationKey.getTypeNameKey(type)) return type.name;
			}
			//Else
			return TranslationKey.NULL
		}
	}
}