package batr.game.block 
{
	public class BlockAttributes 
	{
		//============Static Variables============//
		public static const NULL:BlockAttributes=null
		public static const ABSTRACT:BlockAttributes=new BlockAttributes()
		
		public static const VOID:BlockAttributes=new BlockAttributes(0xffffff,0x0).asGas
		public static const WALL:BlockAttributes=new BlockAttributes(0xBBBBBB).asSolid
		public static const WATER:BlockAttributes=new BlockAttributes(0x2222FF,0x40000000).asLiquid
		public static const GLASS:BlockAttributes=new BlockAttributes(0x000000,0x80000000).asTransParent
		public static const BEDROCK:BlockAttributes=new BlockAttributes(0x888888).asSolid.asUnbreakable
		public static const X_TRAP_HURT:BlockAttributes=new BlockAttributes(0xffff00,0xc0000000).asGas.asHurtZone
		public static const X_TRAP_KILL:BlockAttributes=new BlockAttributes(0xff0000,0xc0000000).asGas.asKillZone
		public static const COLORED_BLOCK:BlockAttributes=new BlockAttributes(0x000000).asSolid
		public static const COLOR_SPAWNER:BlockAttributes=new BlockAttributes(0x444444).asSolid
		public static const LASER_TRAP:BlockAttributes=new BlockAttributes(0x444444).asSolid
		
		//============Static Functions============//
		public static function fromType(type:BlockType):BlockAttributes
		{
			return type.currentAttributes
		}
		
		//============Instance Variables============//
		//Attributes
		public var playerCanPass:Boolean
		public var bulletCanPass:Boolean
		public var laserCanPass:Boolean
		public var isTransParent:Boolean
		/**
		 * NEGATIVE means Bottom,POSITIVE means Top,Zero Means Middle
		 */
		public var drawLayer:int
		/**
		 * Weapon:BlockThrower can carry
		 */
		public var isCarriable:Boolean
		/**
		 * -1 means no damage,the other NEGATIVE lower than -1 means they can kill player once a damage
		 */
		public var hurtPlayerDamage:int
		
		//Informations
		public var defaultPixelColor:uint
		/**
		 * Using UINT PERCENT!
		 */
		public var defaultPixelAlpha:uint
		
		//============Constructor Function============//
		public function BlockAttributes(defaultPixelColor:uint=0xffffff,defaultPixelAlpha:uint=uint.MAX_VALUE):void
		{
			this.defaultPixelColor=defaultPixelColor;
			this.defaultPixelAlpha=defaultPixelAlpha;
		}
		
		public function clone():BlockAttributes
		{
			var tempAttributes:BlockAttributes=new BlockAttributes()
			tempAttributes.playerCanPass=this.playerCanPass
			tempAttributes.bulletCanPass=this.bulletCanPass
			tempAttributes.laserCanPass=this.laserCanPass
			tempAttributes.isTransParent=this.isTransParent
			tempAttributes.drawLayer=this.drawLayer
			tempAttributes.isCarriable=this.isCarriable
			tempAttributes.hurtPlayerDamage=this.hurtPlayerDamage
			tempAttributes.defaultPixelAlpha=this.defaultPixelAlpha
			tempAttributes.defaultPixelColor=this.defaultPixelColor
			return tempAttributes
		}
		
		//============Destructor Function============//
		public function deleteSelf():void
		{
			
		}
		
		//============Instance Getter And Setter============//
		public function get asSolid():BlockAttributes
		{
			return this.loadAsSolid()
		}
		
		public function get asLiquid():BlockAttributes
		{
			return this.loadAsLiquid()
		}
		
		public function get asGas():BlockAttributes
		{
			return this.loadAsGas()
		}
		
		public function get asTransParent():BlockAttributes
		{
			return this.loadAsTransParent()
		}
		
		public function get asUnbreakable():BlockAttributes
		{
			return this.loadAsUnbreakable()
		}
		
		public function get asHurtZone():BlockAttributes
		{
			return this.loadAsHurtZone()
		}
		
		public function get asKillZone():BlockAttributes
		{
			return this.loadAsKillZone()
		}
		
		//============Instance Functions============//
		public function loadAsSolid():BlockAttributes
		{
			this.playerCanPass=false
			this.bulletCanPass=false
			this.laserCanPass=false
			this.isTransParent=false
			this.isCarriable=true
			this.drawLayer=0
			this.hurtPlayerDamage=-1
			return this
		}
		
		public function loadAsLiquid():BlockAttributes
		{
			this.playerCanPass=false
			this.bulletCanPass=true
			this.laserCanPass=true
			this.isTransParent=true
			this.isCarriable=false
			this.drawLayer=-1
			this.hurtPlayerDamage=-1
			return this
		}
		
		public function loadAsGas():BlockAttributes
		{
			this.playerCanPass=true
			this.bulletCanPass=true
			this.laserCanPass=true
			this.isTransParent=true
			this.isCarriable=false
			this.drawLayer=-1
			this.hurtPlayerDamage=-1
			return this
		}
		
		public function loadAsTransParent():BlockAttributes
		{
			this.playerCanPass=false
			this.bulletCanPass=false
			this.laserCanPass=true
			this.isTransParent=true
			this.isCarriable=true
			this.drawLayer=1
			this.hurtPlayerDamage=-1
			return this
		}
		
		public function loadAsUnbreakable():BlockAttributes
		{
			this.isCarriable=false
			return this
		}
		
		public function loadAsHurtZone(damage:int=10):BlockAttributes
		{
			this.hurtPlayerDamage=damage
			return this
		}
		
		public function loadAsKillZone():BlockAttributes
		{
			this.hurtPlayerDamage=-2
			return this
		}
	}
}