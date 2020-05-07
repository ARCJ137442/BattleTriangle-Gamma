package batr.game.model 
{
	import batr.common.*;
	import batr.general.*;
	
	public class WeaponType extends TypeCommon
	{
		//============Static Variables============//
		public static const NULL:WeaponType=null
		public static const ABSTRACT:WeaponType=new WeaponType("Abstract",0,0)
		
		public static const BULLET:WeaponType=new WeaponType("Bullet",0.25,5).setExtraProperty(1,1)
		public static const NUKE:WeaponType=new WeaponType("Nuke",5,320,5,true,true,true).setExtraProperty(10,15)
		public static const SUB_BOMBER:WeaponType=new WeaponType("Sub Bomber",1,10,1).setExtraProperty(2,1)
		//public static const POISON_BOMB:WeaponType=new WeaponType("Poison Bomb",9,50)
		
		public static const LASER:WeaponType=new WeaponType("Laser",3,120,1).setExtraProperty(8,6)
		public static const PULSE_LASER:WeaponType=new WeaponType("Pulse Laser",0.5,5,0.5).setExtraProperty(3,3)
		public static const TELEPORT_LASER:WeaponType=new WeaponType("Teleport Laser",3.5,40).setExtraProperty(4,3)
		public static const ABSORPTION_LASER:WeaponType=new WeaponType("Absorption Laser",4,10).setExtraProperty(4,2)
		
		public static const WAVE:WeaponType=new WeaponType("Wave",0.5,20,2).setExtraProperty(3,3)//Full Charge
		//public static const CHAOS_RING:WeaponType=new WeaponType("Chaos Ring",7,20)
		
		//public static const T_BOMB:WeaponType=new WeaponType("T-Bomb",7.5,80)
		public static const MELEE:WeaponType=new WeaponType("Melee",0.25,5).setExtraProperty(5,3)
		public static const BLOCK_THROWER:WeaponType=new WeaponType("Block Thrower",.5,200,1,true,true,true).setExtraProperty(10,10)
		public static const LIGHTNING:WeaponType=new WeaponType("Lightning",0.75,20).setExtraProperty(12,10)
		
		//BOSS WEAPON
		public static const SHOCKWAVE_LASER:WeaponType=new WeaponType("ShockWave Laser",10,100).setExtraProperty(20,2)
		
		//WEAPON SET
		public static const _BULLETS:Vector.<WeaponType>=new <WeaponType>[WeaponType.BULLET,WeaponType.NUKE,WeaponType.SUB_BOMBER]
		public static const _LASERS:Vector.<WeaponType>=new <WeaponType>[WeaponType.LASER,WeaponType.PULSE_LASER,WeaponType.TELEPORT_LASER,WeaponType.ABSORPTION_LASER]
		//public static const _WAVES:Vector.<WeaponType>=new <WeaponType>[WeaponType.WAVE,WeaponType.CHAOS_RING]
		public static const _SPECIAL:Vector.<WeaponType>=new <WeaponType>[WeaponType.WAVE,WeaponType.MELEE,WeaponType.BLOCK_THROWER,WeaponType.LIGHTNING]
		public static const _BOSS_WEAPON:Vector.<WeaponType>=new <WeaponType>[WeaponType.SHOCKWAVE_LASER]
		public static const _ALL_WEAPON:Vector.<WeaponType>=_BULLETS.concat(_LASERS).concat(_SPECIAL)//.concat(_WAVES)
		
		public static const _ALL_AVALIABLE_WEAPON:Vector.<WeaponType>=new <WeaponType>[
			WeaponType.BULLET,
			WeaponType.NUKE,
			WeaponType.SUB_BOMBER,
			WeaponType.LASER,
			WeaponType.PULSE_LASER,
			WeaponType.TELEPORT_LASER,
			WeaponType.ABSORPTION_LASER,
			WeaponType.WAVE,
			WeaponType.BLOCK_THROWER,
			WeaponType.LIGHTNING,
			WeaponType.SHOCKWAVE_LASER];
		
		//============Static Getter And Setter============//
		public static function get label():String
		{
			return "weapon";
		}
		
		public static function get RANDOM_ID():uint
		{
			return exMath.random(_ALL_WEAPON.length)
		}
		
		public static function get RANDOM():WeaponType
		{
			return _ALL_WEAPON[WeaponType.RANDOM_ID]
		}
		
		public static function get RANDOM_AVAILABLE_ID():uint
		{
			return exMath.random(_ALL_AVALIABLE_WEAPON.length)
		}
		
		public static function get RANDOM_AVAILABLE():WeaponType
		{
			return _ALL_AVALIABLE_WEAPON[WeaponType.RANDOM_AVAILABLE_ID]
		}
		
		//============Static Functions============//
		public static function isValidWeaponID(id:int):Boolean
		{
			return (id>=0&&id<WeaponType._ALL_WEAPON.length)
		}
		
		public static function isValidAvailableWeaponID(id:int):Boolean
		{
			return (id>=0&&id<WeaponType._ALL_AVALIABLE_WEAPON.length)
		}
		
		public static function fromString(str:String):WeaponType
		{
			for each(var type:WeaponType in WeaponType._ALL_WEAPON)
			{
				if(type.name==str) return type
			}
			return NULL
		}
		
		/**
		 * Returns a WeaponType by ID in int.
		 * @param	id	A int determines weapon.
		 * @return	A weapontype based on id.
		 */
		public static function fromWeaponID(id:int):WeaponType
		{
			if(id<0||id>=_ALL_AVALIABLE_WEAPON.length) return null;
			return _ALL_AVALIABLE_WEAPON[id];
		}
		
		/**
		 * Returns a ID by WeaponType.
		 * @param	id	A int determines weapon.
		 * @return	A weapontype based on id.
		 */
		public static function toWeaponID(type:WeaponType):int
		{
			return WeaponType._ALL_AVALIABLE_WEAPON.indexOf(type);
		}
		
		public static function isIncludeIn(type:WeaponType,types:Vector.<WeaponType>):Boolean
		{
			return types.indexOf(type)>=0;
		}
		
		public static function isBulletWeapon(type:WeaponType):Boolean
		{
			return WeaponType.isIncludeIn(type,WeaponType._BULLETS);
		}
		
		public static function isLaserWeapon(type:WeaponType):Boolean
		{
			return WeaponType.isIncludeIn(type,WeaponType._LASERS);
		}
		
		public static function getRandomAvaliableWithout(weapon:WeaponType):WeaponType
		{
			var tempW:WeaponType,i:uint=0;
			do
			{
				tempW=WeaponType.RANDOM_AVAILABLE;
			}
			while(tempW==weapon&&++i<0xf);
			return tempW;
		}
		
		//============Instance Variables============//
		protected var _defaultCD:uint//Tick
		protected var _defaultChargeTime:uint//Tick
		protected var _defaultDamage:uint
		protected var _canHurtEnemy:Boolean
		protected var _canHurtSelf:Boolean
		protected var _canHurtAlly:Boolean
		
		//Extra
		protected var _extraDamageCoefficient:uint=5;
		protected var _extraResistanceCoefficient:uint=1;
		
		//============Constructor Function============//
		public function WeaponType(name:String,
								   defaultCD:Number=0,
								   defaultDamage:uint=1,
								   defaultChargeTime:Number=0,
								   canHurtEnemy:Boolean=true,
								   canHurtSelf:Boolean=false,
								   canHurtAlly:Boolean=false):void
		{
			//defaultCD,defaultChargeTime is Per Second
			super(name)
			this._defaultCD=defaultCD*GlobalGameVariables.TPS/2
			this._defaultDamage=defaultDamage
			this._defaultChargeTime=defaultChargeTime*GlobalGameVariables.TPS/2
			this._canHurtEnemy=canHurtEnemy
			this._canHurtSelf=canHurtSelf
			this._canHurtAlly=canHurtAlly
		}
		
		protected function setExtraProperty(damageCoefficient:uint,
										resistanceCoefficient:uint):WeaponType
		{
			this._extraDamageCoefficient=damageCoefficient;
			this._extraResistanceCoefficient=resistanceCoefficient;
			return this;
		}
		
		//============Instance Getter And Setter============//
		public override function get label():String
		{
			return "weapon";
		}
		
		/**
		 * Dynamic when Weapon List Changing
		 */
		public function get weaponID():int
		{
			return WeaponType.toWeaponID(this);
		}
		
		public function get defaultCD():uint
		{
			return this._defaultCD
		}
		
		public function get defaultDamage():uint
		{
			return this._defaultDamage
		}
		
		public function get defaultChargeTime():uint
		{
			return this._defaultChargeTime
		}
		
		public function get defaultDamageOutput():uint
		{
			return this._defaultDamage/(this._defaultCD+this._defaultChargeTime)
		}
		
		public function get weaponCanHurtEnemy():Boolean
		{
			return this._canHurtEnemy
		}
		
		public function get weaponCanHurtSelf():Boolean
		{
			return this._canHurtSelf
		}
		
		public function get weaponCanHurtAlly():Boolean
		{
			return this._canHurtAlly
		}
		
		//====Extra Property====//
		public function get extraDamageCoefficient():uint
		{
			return this._extraDamageCoefficient;
		}
		
		public function get extraResistanceCoefficient():uint
		{
			return this._extraResistanceCoefficient;
		}
		
		//============Instance Functions============//
		//====Buffed Property====//
		public function getBuffedDamage(defaultDamage:uint,buffDamage:uint,buffResistance:uint):uint
		{
			return Math.max(defaultDamage+buffDamage*this.extraDamageCoefficient-buffResistance*this.extraResistanceCoefficient,1);
		}
		
		public function getBuffedCD(buffCD:uint):uint
		{
			return Math.ceil(this.defaultCD/(1+buffCD/10));
		}
	}
}