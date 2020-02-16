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
		
		public static const VOID:BlockType=new BlockType("Void",null,BlockAttributes.VOID)
		public static const WALL:BlockType=new BlockType("Wall",Wall,BlockAttributes.WALL)
		public static const WATER:BlockType=new BlockType("Water",Water,BlockAttributes.WATER)
		public static const GLASS:BlockType=new BlockType("Glass",Glass,BlockAttributes.GLASS)
		public static const BEDROCK:BlockType=new BlockType("BedRock",Bedrock,BlockAttributes.BEDROCK)
		public static const X_TRAP_HURT:BlockType=new BlockType("XTrapHurt",XTrap,BlockAttributes.X_TRAP_HURT)
		public static const X_TRAP_KILL:BlockType=new BlockType("XTrapKill",XTrap,BlockAttributes.X_TRAP_KILL)
		public static const COLORED_BLOCK:BlockType=new BlockType("ColoredBlock",ColoredBlock,BlockAttributes.COLORED_BLOCK)
		public static const COLOR_SPAWNER:BlockType=new BlockType("ColorSpawner",ColorSpawner,BlockAttributes.COLOR_SPAWNER)
		public static const LASER_TRAP:BlockType=new BlockType("LaserTrap",LaserTrap,BlockAttributes.LASER_TRAP)
		
		public static const _SOLID_BLOCKS:Vector.<BlockType>=new <BlockType>[
		BlockType.WALL,BlockType.GLASS,BlockType.BEDROCK,
		BlockType.COLORED_BLOCK,BlockType.COLOR_SPAWNER,LASER_TRAP]
		public static const _LIQUID_BLOCKS:Vector.<BlockType>=new <BlockType>[BlockType.WATER]
		public static const _GAS_BLOCKS:Vector.<BlockType>=new <BlockType>[BlockType.NULL]
		public static const _OTHER_BLOCKS:Vector.<BlockType>=new <BlockType>[BlockType.X_TRAP_HURT,BlockType.X_TRAP_KILL]
		public static const _ALL_BLOCK:Vector.<BlockType>=_SOLID_BLOCKS.concat(_LIQUID_BLOCKS).concat(_GAS_BLOCKS).concat(_OTHER_BLOCKS)
		
		//============Static Getter And Setter============//
		public static function get RANDOM():BlockType
		{
			return _ALL_BLOCK[exMath.random(_ALL_BLOCK.length)]
		}
		
		//============Static Functions============//
		public static function fromString(str:String):BlockType
		{
			for each(var type:BlockType in BlockType._ALL_BLOCK)
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
		
		//============Instance Variables============//
		protected var _currentBlock:Class
		protected var _currentAttributes:BlockAttributes
		
		//============Constructor Function============//
		public function BlockType(name:String,currentBlock:Class=null,currentAttributes:BlockAttributes=null):void
		{
			super(name)
			this._currentBlock=currentBlock
			this._currentAttributes=currentAttributes
		}
		
		//============Instance Getter And Setter============//
		public override function get label():String
		{
			return "block";
		}
		
		public function get currentBlock():Class
		{
			return this._currentBlock
		}
		
		public function get currentAttributes():BlockAttributes
		{
			return this._currentAttributes
		}
	}
}