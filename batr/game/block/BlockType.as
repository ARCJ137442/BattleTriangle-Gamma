package batr.game.block 
{
	import batr.common.*;
	import batr.general.*;
	
	import batr.game.block.*;
	import batr.game.block.blocks.*;
	
	public class BlockType extends TypeCommon
	{
		//============Static Variables============//
		public static const NULL:BlockType=null
		public static const ABSTRACT:BlockType=new BlockType("Abstract",null,BlockAttributes.ABSTRACT)
		
		public static const VOID:BlockType=new BlockType("Void",null,BlockAttributes.VOID).setMapColor(0xffffff)
		public static const WALL:BlockType=new BlockType("Wall",Wall,BlockAttributes.WALL).setMapColor(0x888888)
		public static const WATER:BlockType=new BlockType("Water",Water,BlockAttributes.WATER).setMapColor(0x00b0ff)
		public static const GLASS:BlockType=new BlockType("Glass",Glass,BlockAttributes.GLASS).setMapColor(0xeeeeee)
		public static const BEDROCK:BlockType=new BlockType("BedRock",Bedrock,BlockAttributes.BEDROCK).setMapColor(0x444444)
		public static const X_TRAP_HURT:BlockType=new BlockType("XTrapHurt",XTrap,BlockAttributes.X_TRAP_HURT).setMapColor(0xff8000)
		public static const X_TRAP_KILL:BlockType=new BlockType("XTrapKill",XTrap,BlockAttributes.X_TRAP_KILL).setMapColor(0xff0000)
		public static const X_TRAP_ROTATE:BlockType=new BlockType("XTrapRotate",XTrap,BlockAttributes.X_TRAP_ROTATE).setMapColor(0x0000ff)
		public static const COLORED_BLOCK:BlockType=new BlockType("ColoredBlock",ColoredBlock,BlockAttributes.COLORED_BLOCK)
		public static const COLOR_SPAWNER:BlockType=new BlockType("ColorSpawner",ColorSpawner,BlockAttributes.COLOR_SPAWNER).setMapColor(0xff00ff)
		public static const LASER_TRAP:BlockType=new BlockType("LaserTrap",LaserTrap,BlockAttributes.LASER_TRAP).setMapColor(0x00ffff)
		public static const METAL:BlockType=new BlockType("Metal",Metal,BlockAttributes.METAL).setMapColor(0x999999)
		public static const SPAWN_POINT_MARK:BlockType=new BlockType("SpawnPointMark",SpawnPointMark,BlockAttributes.SPAWN_POINT_MARK).setMapColor(0x6600ff)
		public static const SUPPLY_POINT:BlockType=new BlockType("Supplypoint",SupplyPoint,BlockAttributes.SUPPLY_POINT).setMapColor(0x66ff00)
		public static const GATE_OPEN:BlockType=new BlockType("GateOpen",Gate,BlockAttributes.GATE_OPEN).setMapColor(0xcccccc)
		public static const GATE_CLOSE:BlockType=new BlockType("GateClose",Gate,BlockAttributes.GATE_CLOSE).setMapColor(0x666666)
		
		public static const _SOLID_BLOCKS:Vector.<BlockType>=new <BlockType>[
		BlockType.WALL,BlockType.GLASS,BlockType.BEDROCK,
		BlockType.COLORED_BLOCK,BlockType.COLOR_SPAWNER,
		BlockType.LASER_TRAP,BlockType.METAL,BlockType.GATE_CLOSE];
		public static const _LIQUID_BLOCKS:Vector.<BlockType>=new <BlockType>[BlockType.WATER]
		public static const _GAS_BLOCKS:Vector.<BlockType>=new <BlockType>[BlockType.GATE_OPEN]
		public static const _BASE_BLOCKS:Vector.<BlockType>=new <BlockType>[SUPPLY_POINT]
		public static const _OTHER_BLOCKS:Vector.<BlockType>=new <BlockType>[BlockType.X_TRAP_HURT,BlockType.X_TRAP_KILL,BlockType.X_TRAP_ROTATE]
		public static const _NORMAL_BLOCKS:Vector.<BlockType>=_SOLID_BLOCKS.concat(_LIQUID_BLOCKS).concat(_GAS_BLOCKS).concat(_OTHER_BLOCKS);
		public static const _SPECIAL:Vector.<BlockType>=new <BlockType>[BlockType.VOID,BlockType.SPAWN_POINT_MARK]
		public static const _ALL_BLOCKS:Vector.<BlockType>=_NORMAL_BLOCKS.concat(_SPECIAL);
		
		//============Static Getter And Setter============//
		public static function get RANDOM_NORMAL():BlockType
		{
			return _NORMAL_BLOCKS[exMath.random(_NORMAL_BLOCKS.length)]
		}
		
		//============Static Functions============//
		public static function fromString(str:String):BlockType
		{
			for each(var type:BlockType in BlockType._NORMAL_BLOCKS)
			{
				if(type.name==str) return type
			}
			return NULL
		}
		
		public static function isIncludeIn(type:BlockType,types:Vector.<BlockType>):Boolean
		{
			for each(var type2:BlockType in types)
			{
				if(type==type2) return true
			}
			return false
		}
		
		public static function fromMapColor(color:uint):BlockType
		{
			for each(var type:BlockType in _ALL_BLOCKS)
			{
				if(type._mapColor==color) return type;
			}
			return BlockType.VOID;
		}
		
		//============Instance Variables============//
		protected var _currentBlock:Class
		protected var _currentAttributes:BlockAttributes
		
		/**
		 * Be use for BitMap importing.
		 */
		protected var _mapColor:uint=0xffffffff
		
		//============Constructor Function============//
		public function BlockType(name:String,currentBlock:Class=null,currentAttributes:BlockAttributes=null):void
		{
			super(name);
			this._currentBlock=currentBlock;
			this._currentAttributes=currentAttributes;
		}
		
		//============Instance Getter And Setter============//
		public override function get label():String
		{
			return "block";
		}
		
		public function get currentBlock():Class
		{
			return this._currentBlock;
		}
		
		public function get currentAttributes():BlockAttributes
		{
			return this._currentAttributes;
		}
		
		public function get mapColor():uint
		{
			return this._mapColor;
		}
		
		//============Instance Functions============//
		protected function setMapColor(color:uint):BlockType
		{
			this._mapColor=color;
			return this;
		}
	}
}