package batr.translations 
{
	import batr.game.block.BlockType;
	import batr.game.effect.EffectType;
	import batr.game.entity.EntityType;
	import batr.game.model.BonusType;
	import batr.game.model.WeaponType;
	import batr.game.model.GameModeType;
	import batr.game.main.Game;
	import batr.game.main.GameRule;
	
	public class TranslationalText
	{
		//============Static Variables============//
		
		//============Static Getter And Setter============//
		public static function getTextsByAllBlocks(translations:Translations,isDescription:Boolean):Vector.<TranslationalText>
		{
			var result:Vector.<TranslationalText>=new Vector.<TranslationalText>();
			for each(var type:BlockType in BlockType._NORMAL_BLOCKS)
			{
				result.push(new TranslationalText(translations,TranslationKey.getTypeKey(type,isDescription)));
			}
			return result;
		}
		
		public static function getTextsByAllEntities(translations:Translations,isDescription:Boolean):Vector.<TranslationalText>
		{
			var result:Vector.<TranslationalText>=new Vector.<TranslationalText>();
			for each(var type:EntityType in EntityType._ALL_ENTITY)
			{
				result.push(new TranslationalText(translations,TranslationKey.getTypeKey(type,isDescription)));
			}
			return result;
		}
		
		public static function getTextsByAllEffects(translations:Translations,isDescription:Boolean):Vector.<TranslationalText>
		{
			var result:Vector.<TranslationalText>=new Vector.<TranslationalText>();
			for each(var type:EffectType in EffectType._ALL_EFFECT)
			{
				result.push(new TranslationalText(translations,TranslationKey.getTypeKey(type,isDescription)));
			}
			return result;
		}
		
		public static function getTextsByAllAvaliableWeapons(translations:Translations,isDescription:Boolean):Vector.<TranslationalText>
		{
			var result:Vector.<TranslationalText>=new Vector.<TranslationalText>();
			for each(var type:WeaponType in WeaponType._ALL_AVALIABLE_WEAPON)
			{
				result.push(new TranslationalText(translations,TranslationKey.getTypeKey(type,isDescription)));
			}
			return result;
		}
		
		public static function getTextsByAllBonus(translations:Translations,isDescription:Boolean):Vector.<TranslationalText>
		{
			var result:Vector.<TranslationalText>=new Vector.<TranslationalText>();
			for each(var type:BonusType in BonusType._ALL_TYPE)
			{
				result.push(new TranslationalText(translations,TranslationKey.getTypeKey(type,isDescription)));
			}
			return result;
		}
		
		public static function getTextsByAllGameModes(translations:Translations,isDescription:Boolean):Vector.<TranslationalText>
		{
			var result:Vector.<TranslationalText>=new Vector.<TranslationalText>();
			for each(var type:GameModeType in GameModeType._ALL_TYPE)
			{
				result.push(new TranslationalText(translations,TranslationKey.getTypeKey(type,isDescription)));
			}
			return result;
		}
		
		public static function getTextsByTranslations(translations:Translations):Vector.<TranslationalText>
		{
			var result:Vector.<TranslationalText>=new Vector.<TranslationalText>();
			for each(var t:Translations in Translations.translationsList)
			{
				result.push(new TranslationalText(translations,TranslationKey.LANGUAGE))
			}
			return result;
		}
		
		public static function getTextsByRuleWeapons(rule:GameRule,translations:Translations,isDescription:Boolean):Vector.<TranslationalText>
		{
			var result:Vector.<TranslationalText>=new Vector.<TranslationalText>();
			for(var i:uint=0;i<rule.enableWeaponCount;i++)
			{
				result.push(new TranslationalText(translations,TranslationKey.getTypeKey(rule.enableWeapons[i],isDescription)));
			}
			return result;
		}
		
		public static function getTextsByLanguages():Vector.<TranslationalText>
		{
			var result:Vector.<TranslationalText>=new Vector.<TranslationalText>();
			for(var i:uint=0;i<Translations.numTranslations;i++)
			{
				result.push(new TranslationalText(Translations.translationsList[i],TranslationKey.LANGUAGE_SELF));
			}
			return result;
		}
		
		public static function getTextsByMapNames():Vector.<TranslationalText>
		{
			var result:Vector.<TranslationalText>=new Vector.<TranslationalText>();
			for(var i:uint=0;i<Game.VALID_MAP_COUNT;i++)
			{
				result.push(new ForcedTranslationalText(null,null,Game.ALL_MAPS[i].name));
			}
			return result;
		}
		
		//============Static Functions============//
		public static function fromString(value:String):TranslationalText
		{
			return new TranslationalText(null,null);
		}
		
		//============Instance Variables============//
		protected var _key:String;
		protected var _translations:Translations;
		
		//============Constructor Function============//
		public function TranslationalText(translations:Translations,key:String=null):void
		{
			this._translations=translations;
			this._key=key;
		}
		
		public function clone():TranslationalText
		{
			return new TranslationalText(this._translations,this._key);
		}
		
		//============Destructor Function============//
		public function deleteSelf():void
		{
			this._key=null;
		}
		
		//============Instance Getter And Setter============//
		public function get key():String
		{
			return this._key;
		}
		
		public function set key(value:String):void
		{
			this._key=value;
		}
		
		public function get translations():Translations
		{
			return this._translations;
		}
		
		public function set translations(value:Translations):void
		{
			this._translations=value;
		}
		
		public function get currentText():String
		{
			if(this._translations==null) return null;
			return this._translations.getTranslation(this._key);
		}
		
		//============Instance Functions============//
		public function toString():String
		{
			return this.currentText;
		}
	}
}