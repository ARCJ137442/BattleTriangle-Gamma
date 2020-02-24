package batr.game.block 
{
	public class BlockAttributes 
	{
		//============Static Variables============//
		public static const NULL:BlockAttributes=null
		public static const ABSTRACT:BlockAttributes=new BlockAttributes()
		
		public static const VOID:BlockAttributes=new BlockAttributes(0xffffff,0x0).asGas
		public static const WALL:BlockAttributes=new BlockAttributes(0xBBBBBB).asSolid
		public static const WATER:BlockAttributes=new BlockAttributes(0x2222FF,0x40000000).asLiquid.asArenaBlock
		public static const GLASS:BlockAttributes=new BlockAttributes(0x000000,0x80000000).asTransParent.asArenaBlock
		public static const BEDROCK:BlockAttributes=new BlockAttributes(0x888888).asSolid.asUnbreakable
		public static const X_TRAP_HURT:BlockAttributes=new BlockAttributes(0xffff00,0xc0000000).asGas.asHurtZone.asArenaBlock
		public static const X_TRAP_KILL:BlockAttributes=new BlockAttributes(0xff0000,0xc0000000).asGas.asKillZone.asArenaBlock
		public static const X_TRAP_ROTATE:BlockAttributes=new BlockAttributes(0x0000ff,0xc0000000).asGas.asRotateZone.asArenaBlock
		public static const COLORED_BLOCK:BlockAttributes=new BlockAttributes(0x000000).asSolid
		public static const COLOR_SPAWNER:BlockAttributes=new BlockAttributes(0x444444).asSolid.asArenaBlock
		public static const LASER_TRAP:BlockAttributes=new BlockAttributes(0x444444).asSolid.asArenaBlock
		public static const METAL:BlockAttributes=new BlockAttributes(0x666666).asSolid.asMetal.asArenaBlock
		public static const SPAWN_POINT_MARK:BlockAttributes=new BlockAttributes(0x6666ff).asBase
		public static const SUPPLY_POINT:BlockAttributes=new BlockAttributes(0x66ff66).asBase.asSupplyPoint
		public static const GATE_OPEN:BlockAttributes=new BlockAttributes(0x888888,0x50000000).asGate
		public static const GATE_CLOSE:BlockAttributes=new BlockAttributes(0x888888).asGateClose
		
		//============Static Functions============//
		public static function fromType(type:BlockType):BlockAttributes
		{
			return type.currentAttributes;
		}
		
		//============Instance Variables============//
		//==Attributes==//
		public var playerCanPass:Boolean
		public var bulletCanPass:Boolean
		public var laserCanPass:Boolean
		public var isTransParent:Boolean
		/**
		 * NEGATIVE means Bottom,POSITIVE means Top,Zero Means Middle
		 */
		public var drawLayer:int=1
		/**
		 * Weapon:BlockThrower can carry
		 */
		public var isCarryable:Boolean=true
		/**
		 * Weapon:BlockThrower can carry
		 */
		public var isBreakable:Boolean=true
		/**
		 * -1 means is will damage player as axphyxia
		 * -2 means it will suppling player health and experience
		 * int.MIN_VALUE means no damage
		 * int.MAX_VALUE means they can kill player once a damage
		 */
		public var playerDamage:int=int.MIN_VALUE
		
		/**
		 * True means player/projectile will rotate when move in the block.
		 */
		public var rotateWhenMoveIn:Boolean=false
		
		/**
		 * this attribute determines electric flow in the block,
		 * 0 means lightning can flow in the block without energy
		 * energy-=electricResistance
		 */
		public var electricResistance:uint=100
		
		/**
		 * Cann't be control in Arena Map.
		 */
		public var unbreakableInArenaMap:Boolean=false
		
		/**
		 * Spawn BonusBox ignore max count.
		 */
		public var supplingBonus:Boolean=false
		
		//==Informations==//
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
			tempAttributes.isCarryable=this.isCarryable
			tempAttributes.isBreakable=this.isBreakable
			tempAttributes.playerDamage=this.playerDamage
			tempAttributes.rotateWhenMoveIn=this.rotateWhenMoveIn
			tempAttributes.electricResistance=this.electricResistance
			tempAttributes.unbreakableInArenaMap=this.unbreakableInArenaMap
			tempAttributes.supplingBonus=this.supplingBonus
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
			return this.loadAsSolid();
		}
		
		public function get asLiquid():BlockAttributes
		{
			return this.loadAsLiquid();
		}
		
		public function get asGas():BlockAttributes
		{
			return this.loadAsGas();
		}
		
		public function get asTransParent():BlockAttributes
		{
			return this.loadAsTransParent();
		}
		
		public function get asUnbreakable():BlockAttributes
		{
			return this.loadAsUnbreakable();
		}
		
		public function get asHurtZone():BlockAttributes
		{
			return this.loadAsHurtZone();
		}
		
		public function get asKillZone():BlockAttributes
		{
			return this.loadAsKillZone();
		}
		
		public function get asRotateZone():BlockAttributes
		{
			return this.loadAsRotateZone();
		}
		
		public function get asMetal():BlockAttributes
		{
			return this.loadAsMetal();
		}
		
		public function get asArenaBlock():BlockAttributes
		{
			return this.loadAsArenaBlock();
		}
		
		public function get asBase():BlockAttributes
		{
			return this.loadAsBase();
		}
		
		public function get asSupplyPoint():BlockAttributes
		{
			return this.loadAsSupplyPoint();
		}
		
		public function get asGate():BlockAttributes
		{
			return this.loadAsGate();
		}
		
		public function get asGateClose():BlockAttributes
		{
			return this.loadAsGateClose();
		}
		
		//============Instance Functions============//
		public function loadAsSolid():BlockAttributes
		{
			this.playerCanPass=false
			this.bulletCanPass=false
			this.laserCanPass=false
			this.isTransParent=false
			this.isCarryable=true
			this.isBreakable=true
			this.drawLayer=0
			this.playerDamage=-1
			this.rotateWhenMoveIn=false
			this.electricResistance=1000
			return this
		}
		
		public function loadAsLiquid():BlockAttributes
		{
			this.playerCanPass=false
			this.bulletCanPass=true
			this.laserCanPass=true
			this.isTransParent=true
			this.isCarryable=false
			this.isBreakable=true
			this.drawLayer=-1
			this.rotateWhenMoveIn=false
			this.electricResistance=5000
			return this
		}
		
		public function loadAsGas():BlockAttributes
		{
			this.playerCanPass=true
			this.bulletCanPass=true
			this.laserCanPass=true
			this.isTransParent=true
			this.isCarryable=false
			this.isBreakable=true
			this.drawLayer=-1
			this.rotateWhenMoveIn=false
			this.electricResistance=10
			return this
		}
		
		public function loadAsTransParent():BlockAttributes
		{
			this.playerCanPass=false
			this.bulletCanPass=false
			this.laserCanPass=true
			this.isTransParent=true
			this.isCarryable=true
			this.isBreakable=true
			this.drawLayer=1
			this.playerDamage=-1
			this.rotateWhenMoveIn=false
			this.electricResistance=2000
			return this
		}
		
		public function loadAsUnbreakable():BlockAttributes
		{
			this.isCarryable=false
			this.isBreakable=false
			return this
		}
		
		public function loadAsHurtZone(damage:int=10):BlockAttributes
		{
			this.playerDamage=damage
			return this
		}
		
		public function loadAsKillZone():BlockAttributes
		{
			this.playerDamage=int.MAX_VALUE
			return this
		}
		
		public function loadAsRotateZone():BlockAttributes
		{
			this.rotateWhenMoveIn=true
			return this
		}
		
		public function loadAsMetal():BlockAttributes
		{
			this.electricResistance=2
			return this
		}
		
		public function loadAsArenaBlock():BlockAttributes
		{
			this.unbreakableInArenaMap=true;
			return this;
		}
		
		public function loadAsSupplyPoint():BlockAttributes
		{
			this.playerDamage=-2;
			this.supplingBonus=true;
			return this;
		}
		
		public function loadAsBase():BlockAttributes
		{
			this.playerCanPass=true;
			this.bulletCanPass=false;
			this.laserCanPass=true;
			this.isTransParent=true;
			this.isCarryable=false;
			this.isBreakable=false;
			this.electricResistance=100;
			this.playerDamage=int.MIN_VALUE;
			this.drawLayer=-1;
			return this;
		}
		
		/**
		 * Gate Open
		 */
		public function loadAsGate():BlockAttributes
		{
			this.loadAsGas();
			this.isCarryable=true;
			this.unbreakableInArenaMap=true;
			this.drawLayer=-1;
			return this;
		}
		
		/**
		 * Gate Close
		 */
		public function loadAsGateClose():BlockAttributes
		{
			this.loadAsSolid();
			this.unbreakableInArenaMap=true;
			//No Damage on preMoveOut,still devloping
			this.playerDamage=-int.MIN_VALUE;
			return this;
		}
	}
}