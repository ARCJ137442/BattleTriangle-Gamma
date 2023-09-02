package batr.translations {

	import batr.general.*;
	import batr.game.block.*;
	import batr.game.effect.*;
	import batr.game.entity.*;
	import batr.game.model.*;

	internal class DefaultNativeTranslations {
		//============Constructor Function============//
		public function DefaultNativeTranslations():void {
			throw new Error("Cannot construct this class!");
		}

		//============Default Translations(Static)============//
		//========Translations Create And Get========//
		public static function get EN_US():Translations {
			// EN_US._getFunction=DefaultNativeTranslations.getDefaultTranslation;//=Translations.fromStringArr2("")
			return new Translations(
					// batr.language
					TranslationKey.LANGUAGE_SELF, "English",
					// batr.code
					TranslationKey.INFINITY, "Infinity",
					TranslationKey.TRUE, "True",
					TranslationKey.FALSE, "False",
					// batr.boolean
					TranslationKey.BOOLEAN_YES, "Yes",
					TranslationKey.BOOLEAN_NO, "No",
					// batr.menu
					TranslationKey.LANGUAGE, "Language",
					TranslationKey.QUICK_GAME, "Quick Game",
					TranslationKey.SELECT_GAME, "Select Game",
					TranslationKey.CUSTOM_MODE, "Custom Mode",
					TranslationKey.START, "Start",
					TranslationKey.ADVANCED, "Advanced",
					TranslationKey.ADVANCED_CONFIG, "Config File",
					TranslationKey.SAVES, "Saves",
					TranslationKey.BACK, "Back",
					TranslationKey.CONTINUE, "Continue",
					TranslationKey.MAIN_MENU, "Main Menu",
					TranslationKey.GLOBAL_STAT, "Global Stat",
					TranslationKey.SCORE_RANKING, "Score Ranking",
					TranslationKey.PAUSED, "Paused",
					TranslationKey.RESTART, "Restart",
					// batr.custom
					TranslationKey.DEFAULT_WEAPON, "Default Weapon",
					TranslationKey.DEFAULT_HEALTH, "Default Health",
					TranslationKey.DEFAULT_MAX_HEALTH, "Default MaxHealth",
					TranslationKey.REMAIN_LIFES_PLAYER, "Player Remain Lifes",
					TranslationKey.REMAIN_LIFES_AI, "AI Remain Lifes",
					TranslationKey.MAX_BONUS_COUNT, "Max Bonus Count",
					TranslationKey.BONUS_SPAWN_AFTER_DEATH, "Bonus Spawn After Death",
					TranslationKey.MAP_TRANSFORM_TIME, "Map Transfor Time(s)",
					TranslationKey.WEAPONS_NO_CD, "Weapons No CD",
					TranslationKey.RESPAWN_TIME, "Respawn Time(s)",
					TranslationKey.ASPHYXIA_DAMAGE, "Asphyxia Damage",
					// batr.select
					TranslationKey.PLAYER_COUNT, "Player Count",
					TranslationKey.AI_PLAYER_COUNT, "AIPlayer Count",
					TranslationKey.GAME_MODE, "Game Mode",
					TranslationKey.INITIAL_MAP, "Initial Map",
					TranslationKey.LOCK_TEAMS, "Lock Teams",
					// batr.game
					TranslationKey.GAME_RESULT, "Game Result",
					TranslationKey.NOTHING_WIN, "No player wins in the game",
					TranslationKey.WIN_SIGNLE_PLAYER, " wins in the game",
					TranslationKey.WIN_MULTI_PLAYER, " win in the game",
					TranslationKey.WIN_PER_PLAYER, " players win in the game",
					TranslationKey.WIN_ALL_PLAYER, "All players win in the game",
					TranslationKey.FILL_FRAME_OFF, "Fill Frame:Off",
					TranslationKey.FILL_FRAME_ON, "Fill Frame:On",
					// batr.game.map
					TranslationKey.MAP_RANDOM, "Random",
					// batr.game.key
					TranslationKey.REMAIN_TRANSFORM_TIME, "Remain Transform Time",
					TranslationKey.GAME_DURATION, "Game Duration",
					// batr.stat
					TranslationKey.TRANSFORM_MAP_COUNT, "Map Transform Count",
					TranslationKey.BONUS_GENERATE_COUNT, "Bonus Generate Count",
					// batr.stat.player
					TranslationKey.FINAL_LEVEL, "Final Level",
					TranslationKey.KILL_COUNT, "Kill Count",
					TranslationKey.DEATH_COUNT, "Death Count",
					TranslationKey.DEATH_BY_PLAYER_COUNT, "Death by Player Count",
					TranslationKey.CURSE_DAMAGE, "Cause Damage",
					TranslationKey.DAMAGE_BY, "Damage By",
					TranslationKey.PICKUP_BONUS, "Ppckup Bonus",
					TranslationKey.BE_TELEPORT_COUNT, "Be Teleport Count",
					TranslationKey.TOTAL_SCORE, "Total Score",
					// batr.custom.property
					TranslationKey.COMPLETELY_RANDOM, "C-Random",
					TranslationKey.UNIFORM_RANDOM, "U-Random",
					TranslationKey.CERTAINLY_DEAD, "Certainly Dead",
					TranslationKey.NEVER, "Never",
					// GameModeTypes
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

		public static function get ZH_CN():Translations {
			return new Translations(
					// batr.language
					TranslationKey.LANGUAGE_SELF, "简体中文",
					// batr.code
					TranslationKey.INFINITY, "无限",
					TranslationKey.TRUE, "真",
					TranslationKey.FALSE, "假",
					// batr.boolean
					TranslationKey.BOOLEAN_YES, "是",
					TranslationKey.BOOLEAN_NO, "否",
					// batr.menu
					TranslationKey.LANGUAGE, "语言",
					TranslationKey.QUICK_GAME, "快速游戏",
					TranslationKey.SELECT_GAME, "选择游戏",
					TranslationKey.CUSTOM_MODE, "自定义模式",
					TranslationKey.START, "开始",
					TranslationKey.ADVANCED, "高级",
					TranslationKey.ADVANCED_CONFIG, "配置文件",
					TranslationKey.SAVES, "存档",
					TranslationKey.BACK, "返回",
					TranslationKey.CONTINUE, "继续",
					TranslationKey.MAIN_MENU, "主界面",
					TranslationKey.GLOBAL_STAT, "全局统计",
					TranslationKey.SCORE_RANKING, "总分排行",
					TranslationKey.PAUSED, "已暂停",
					TranslationKey.RESTART, "重新开始",
					// batr.custom
					TranslationKey.DEFAULT_WEAPON, "默认武器",
					TranslationKey.DEFAULT_HEALTH, "默认生命值",
					TranslationKey.DEFAULT_MAX_HEALTH, "默认最大生命值",
					TranslationKey.REMAIN_LIFES_PLAYER, "玩家剩余生命",
					TranslationKey.REMAIN_LIFES_AI, "AI剩余生命",
					TranslationKey.MAX_BONUS_COUNT, "最大奖励箱数",
					TranslationKey.BONUS_SPAWN_AFTER_DEATH, "奖励箱死后生成",
					TranslationKey.MAP_TRANSFORM_TIME, "地图变换时间(s)",
					TranslationKey.WEAPONS_NO_CD, "武器无冷却",
					TranslationKey.RESPAWN_TIME, "重生时间(s)",
					TranslationKey.ASPHYXIA_DAMAGE, "窒息伤害",
					// batr.select
					TranslationKey.PLAYER_COUNT, "玩家数量",
					TranslationKey.AI_PLAYER_COUNT, "AI玩家数量",
					TranslationKey.GAME_MODE, "游戏模式",
					TranslationKey.INITIAL_MAP, "初始地图",
					TranslationKey.LOCK_TEAMS, "锁定队伍",
					// batr.game
					TranslationKey.GAME_RESULT, "游戏结果",
					TranslationKey.NOTHING_WIN, "没有玩家在游戏中胜利",
					TranslationKey.WIN_SIGNLE_PLAYER, "在游戏中胜利",
					TranslationKey.WIN_MULTI_PLAYER, "在游戏中胜利",
					TranslationKey.WIN_PER_PLAYER, "个玩家在游戏中胜利",
					TranslationKey.WIN_ALL_PLAYER, "所有玩家在游戏中胜利",
					TranslationKey.FILL_FRAME_OFF, "补帧关闭",
					TranslationKey.FILL_FRAME_ON, "补帧开启",
					// batr.game.map
					TranslationKey.MAP_RANDOM, "随机",
					// batr.game.key
					TranslationKey.REMAIN_TRANSFORM_TIME, "剩余变换时间",
					TranslationKey.GAME_DURATION, "游戏时长",
					// batr.stat
					TranslationKey.TRANSFORM_MAP_COUNT, "地图变换次数",
					TranslationKey.BONUS_GENERATE_COUNT, "奖励箱生成数",
					// batr.stat.player
					TranslationKey.FINAL_LEVEL, "最终等级",
					TranslationKey.KILL_COUNT, "\n击杀数",
					TranslationKey.DEATH_COUNT, "\n死亡数",
					TranslationKey.DEATH_BY_PLAYER_COUNT, "\n被玩家击杀数",
					TranslationKey.CURSE_DAMAGE, "\n造成伤害",
					TranslationKey.DAMAGE_BY, "\n受到伤害",
					TranslationKey.PICKUP_BONUS, "拾取奖励箱",
					TranslationKey.BE_TELEPORT_COUNT, "被传送次数",
					TranslationKey.TOTAL_SCORE, "总分",
					// batr.custom.property
					TranslationKey.COMPLETELY_RANDOM, "完全随机",
					TranslationKey.UNIFORM_RANDOM, "统一随机",
					TranslationKey.CERTAINLY_DEAD, "必死",
					TranslationKey.NEVER, "从不",
					// BlockTypes
					TranslationKey.getTypeNameKey(BlockType.VOID),
					"空位",
					TranslationKey.getTypeNameKey(BlockType.WALL),
					"墙",
					TranslationKey.getTypeNameKey(BlockType.WATER),
					"水",
					TranslationKey.getTypeNameKey(BlockType.GLASS),
					"玻璃",
					TranslationKey.getTypeNameKey(BlockType.BEDROCK),
					"基岩",
					TranslationKey.getTypeNameKey(BlockType.X_TRAP_HURT),
					"X陷阱-伤害",
					TranslationKey.getTypeNameKey(BlockType.X_TRAP_KILL),
					"X陷阱-死亡",
					TranslationKey.getTypeNameKey(BlockType.X_TRAP_ROTATE),
					"X陷阱-旋转",
					TranslationKey.getTypeNameKey(BlockType.COLORED_BLOCK),
					"色块",
					TranslationKey.getTypeNameKey(BlockType.COLOR_SPAWNER),
					"色块生成器",
					TranslationKey.getTypeNameKey(BlockType.LASER_TRAP),
					"激光陷阱",
					TranslationKey.getTypeNameKey(BlockType.METAL),
					"金属",
					// EntityTypes
					TranslationKey.getTypeNameKey(EntityType.BULLET_BASIC),
					"基础子弹",
					TranslationKey.getTypeNameKey(EntityType.BULLET_NUKE),
					"核弹",
					TranslationKey.getTypeNameKey(EntityType.SUB_BOMBER),
					"子轰炸机",
					TranslationKey.getTypeNameKey(EntityType.LASER_BASIC),
					"基础激光",
					TranslationKey.getTypeNameKey(EntityType.LASER_PULSE),
					"脉冲激光",
					TranslationKey.getTypeNameKey(EntityType.LASER_TELEPORT),
					"传送激光",
					TranslationKey.getTypeNameKey(EntityType.LASER_ABSORPTION),
					"吸收激光",
					TranslationKey.getTypeNameKey(EntityType.WAVE),
					"波浪",
					TranslationKey.getTypeNameKey(EntityType.THROWED_BLOCK),
					"掷出的方块",
					TranslationKey.getTypeNameKey(EntityType.BONUS_BOX),
					"奖励箱",
					TranslationKey.getTypeNameKey(EntityType.PLAYER),
					"玩家",
					TranslationKey.getTypeNameKey(EntityType.AI_PLAYER),
					"AI玩家",
					// EffectTypes
					TranslationKey.getTypeNameKey(EffectType.EXPLODE),
					"爆炸",
					TranslationKey.getTypeNameKey(EffectType.SPAWN),
					"重生",
					TranslationKey.getTypeNameKey(EffectType.TELEPORT),
					"传送",
					TranslationKey.getTypeNameKey(EffectType.PLAYER_DEATH_LIGHT),
					"玩家死亡炫光",
					TranslationKey.getTypeNameKey(EffectType.PLAYER_DEATH_ALPHA),
					"玩家死亡淡出",
					TranslationKey.getTypeNameKey(EffectType.PLAYER_LEVELUP),
					"玩家升级",
					TranslationKey.getTypeNameKey(EffectType.BLOCK_LIGHT),
					"方块高亮",
					// WeaponTypes
					TranslationKey.getTypeNameKey(WeaponType.BULLET),
					"子弹",
					TranslationKey.getTypeNameKey(WeaponType.NUKE),
					"核弹",
					TranslationKey.getTypeNameKey(WeaponType.SUB_BOMBER),
					"子轰炸机",
					TranslationKey.getTypeNameKey(WeaponType.TRACKING_BULLET),
					"追踪子弹",
					TranslationKey.getTypeNameKey(WeaponType.LASER),
					"激光",
					TranslationKey.getTypeNameKey(WeaponType.PULSE_LASER),
					"脉冲激光",
					TranslationKey.getTypeNameKey(WeaponType.TELEPORT_LASER),
					"传送激光",
					TranslationKey.getTypeNameKey(WeaponType.ABSORPTION_LASER),
					"吸收激光",
					TranslationKey.getTypeNameKey(WeaponType.WAVE),
					"波浪",
					TranslationKey.getTypeNameKey(WeaponType.BLOCK_THROWER),
					"方块投掷者",
					TranslationKey.getTypeNameKey(WeaponType.MELEE),
					"近战",
					TranslationKey.getTypeNameKey(WeaponType.LIGHTNING),
					"闪电",
					TranslationKey.getTypeNameKey(WeaponType.SHOCKWAVE_ALPHA),
					"冲击波-α",
					TranslationKey.getTypeNameKey(WeaponType.SHOCKWAVE_BETA),
					"冲击波-β",
					// GameModeTypes
					TranslationKey.getTypeNameKey(GameModeType.REGULAR),
					"正常",
					TranslationKey.getTypeNameKey(GameModeType.BATTLE),
					"混战",
					TranslationKey.getTypeNameKey(GameModeType.SURVIVAL),
					"生存",
					TranslationKey.getTypeNameKey(GameModeType.HARD),
					"困难"
				);
		}

		public static function getDefaultTranslation(key:String):String {
			var type:TypeCommon;
			// Block Type
			for each (type in BlockType._NORMAL_BLOCKS) {
				if (type == null)
					continue;
				if (key == TranslationKey.getTypeNameKey(type))
					return type.name;
			}
			// Entity Type
			for each (type in EntityType._ALL_ENTITY) {
				if (type == null)
					continue;
				if (key == TranslationKey.getTypeNameKey(type))
					return type.name;
			}
			// Effect Type
			for each (type in EffectType._ALL_EFFECT) {
				if (type == null)
					continue;
				if (key == TranslationKey.getTypeNameKey(type))
					return type.name;
			}
			// Weapon Type
			for each (type in WeaponType._ALL_WEAPON) {
				if (type == null)
					continue;
				if (key == TranslationKey.getTypeNameKey(type))
					return type.name;
			}
			// Bonus Type
			for each (type in BonusType._ALL_TYPE) {
				if (type == null)
					continue;
				if (key == TranslationKey.getTypeNameKey(type))
					return type.name;
			}
			// Else
			return TranslationKey.NULL;
		}
	}
}