package batr.game.map.maps 
{
	import batr.common.*;
	import batr.general.*;
	
	import batr.game.map.*;
	import batr.game.block.*;
	import batr.game.map.*;
	import batr.game.map.maps.*;
	
	import flash.utils.getQualifiedClassName;
	
	/* This's a Game Map<Version 1>
	 * This Map only save BlockType,not BlockCommon
	 */
	public class Map_V1 extends Map_Common
	{
		//============Static Variables============//
		protected static const _SIZE:uint=GlobalGameVariables.DISPLAY_GRIDS
		
		public static var EMPTY:Map_V1
		public static var BASIC_FRAME:Map_V1
		public static var MAP_1:Map_V1
		public static var MAP_2:Map_V1
		public static var MAP_3:Map_V1
		public static var MAP_4:Map_V1
		public static var MAP_5:Map_V1
		public static var MAP_6:Map_V1
		public static var MAP_7:Map_V1
		public static var MAP_8:Map_V1
		public static var MAP_9:Map_V1
		
		protected static var isInited:Boolean=cInit()
		
		//============Static Functions============//
		public static function pointToIndex(x:int,y:int):String
		{
			return String(x+"_"+y)
		}
		
		public static function indexToPoint(str:String):iPoint
		{
			var s:Array=str.split("_")
			return new iPoint(int(s[0]),int(s[1]))
		}
		
		protected static function cInit():Boolean
		{
			//if(isInited) return
			//========Init Maps========//
			var i:uint,ix:uint,iy:uint
			EMPTY=new Map_V1()
			BASIC_FRAME=new Map_V1()
			MAP_1=new Map_V1()
			MAP_2=new Map_V1()
			MAP_3=new Map_V1()
			MAP_4=new Map_V1()
			MAP_5=new Map_V1()
			MAP_6=new Map_V1()
			MAP_7=new Map_V1()
			MAP_8=new Map_V1()
			MAP_9=new Map_V1()
			//====Basic Frame====//
			BASIC_FRAME.fillBlock(0,0,_SIZE-1,_SIZE-1,
								  BlockType.BEDROCK,true)
			//====Map 1====//
			MAP_1.copyFrom(BASIC_FRAME)
			{
				for(ix=3;ix<_SIZE-4;ix+=4)
				{
					for(iy=3;iy<_SIZE-4;iy+=4)
					{
						MAP_1.fillBlock(ix,iy,ix+1,iy+1,BlockType.WALL)
					}
				}
			}
			//====Map 2====//
			MAP_2.copyFrom(BASIC_FRAME)
			{
				MAP_2.fillBlock(4,4,10,10,BlockType.WALL)
				MAP_2.fillBlock(4,13,10,19,BlockType.WALL)
				MAP_2.fillBlock(13,4,19,10,BlockType.WALL)
				MAP_2.fillBlock(13,13,19,19,BlockType.WALL)
			}
			//====Map 3====//
			MAP_3.copyFrom(BASIC_FRAME)
			{
				for(iy=3;iy<_SIZE-4;iy+=4)
				{
					MAP_3.fillBlock(3,iy,20,iy+1,BlockType.WATER)
				}
			}
			//====Map 4====//
			MAP_4.copyFrom(BASIC_FRAME)
			{
				MAP_4.fillBlock(3,3,20,4,BlockType.WALL)
				MAP_4.fillBlock(3,19,20,20,BlockType.WALL)
				MAP_4.fillBlock(11,5,12,18,BlockType.GLASS)
			}
			//====Map 5====//
			MAP_5.copyFrom(BASIC_FRAME)
			{
				var randNum:uint=16+exMath.random(47)
				for(i=0;i<randNum;i++)
				{
					ix=MAP_5.randomX,iy=MAP_5.randomY
					if(UsefulTools.randomBoolean())
					{
						if(UsefulTools.randomBoolean(1,3))
						{
							MAP_5.setBlock(ix,iy,BlockCommon.fromType(BlockType.X_TRAP_KILL))
						}
						else
						{
							MAP_5.setBlock(ix,iy,BlockCommon.fromType(BlockType.X_TRAP_HURT))
						}
					}
					else if(MAP_5.getBlockType(ix,iy)==BlockType.BEDROCK)
					{
						MAP_5.setVoid(ix,iy)
					}
					else
					{
						MAP_5.setBlock(ix,iy,BlockCommon.fromType(BlockType.RANDOM))
					}
				}
			}
			//====Map 6====//
			MAP_6.copyFrom(BASIC_FRAME)
			{
				MAP_6.setBlock(3,3,BlockCommon.fromType(BlockType.COLOR_SPAWNER))
				MAP_6.setBlock(3,20,BlockCommon.fromType(BlockType.COLOR_SPAWNER))
				MAP_6.setBlock(20,3,BlockCommon.fromType(BlockType.COLOR_SPAWNER))
				MAP_6.setBlock(20,20,BlockCommon.fromType(BlockType.COLOR_SPAWNER))//1
				MAP_6.setBlock(20,9,BlockCommon.fromType(BlockType.COLOR_SPAWNER))
				MAP_6.setBlock(20,14,BlockCommon.fromType(BlockType.COLOR_SPAWNER))//x+
				MAP_6.setBlock(3,9,BlockCommon.fromType(BlockType.COLOR_SPAWNER))
				MAP_6.setBlock(3,14,BlockCommon.fromType(BlockType.COLOR_SPAWNER))//x-
				MAP_6.setBlock(9,20,BlockCommon.fromType(BlockType.COLOR_SPAWNER))
				MAP_6.setBlock(14,20,BlockCommon.fromType(BlockType.COLOR_SPAWNER))//y+
				MAP_6.setBlock(9,3,BlockCommon.fromType(BlockType.COLOR_SPAWNER))
				MAP_6.setBlock(14,3,BlockCommon.fromType(BlockType.COLOR_SPAWNER))//y-
				MAP_6.fillBlock(4,20,8,20,BlockType.GLASS)
				MAP_6.fillBlock(15,20,19,20,BlockType.GLASS)//#y+
				MAP_6.fillBlock(4,3,8,3,BlockType.GLASS)
				MAP_6.fillBlock(15,3,19,3,BlockType.GLASS)//#y-
				MAP_6.fillBlock(20,4,20,8,BlockType.GLASS)
				MAP_6.fillBlock(20,15,20,19,BlockType.GLASS)//#x+
				MAP_6.fillBlock(3,4,3,8,BlockType.GLASS)
				MAP_6.fillBlock(3,15,3,19,BlockType.GLASS)//#x-
				MAP_6.fillBlock(9,9,14,14,BlockType.X_TRAP_HURT,true)
				MAP_6.fillBlock(11,11,12,12,BlockType.X_TRAP_KILL,true)
			}
			//====Map 7====//
			MAP_7.copyFrom(BASIC_FRAME)
			{
				MAP_7.fillBlock(1,5,23,6,BlockType.WATER)//up side
				MAP_7.fillBlock(1,17,23,18,BlockType.WATER)//down side
				MAP_7.setBlock(10,10,BlockCommon.fromType(BlockType.COLOR_SPAWNER))
				MAP_7.setBlock(10,13,BlockCommon.fromType(BlockType.COLOR_SPAWNER))
				MAP_7.setBlock(13,10,BlockCommon.fromType(BlockType.COLOR_SPAWNER))
				MAP_7.setBlock(13,13,BlockCommon.fromType(BlockType.COLOR_SPAWNER))
				MAP_7.fillBlock(9,11,9,12,BlockType.X_TRAP_KILL)//x-
				MAP_7.fillBlock(11,9,12,9,BlockType.X_TRAP_KILL)//y-
				MAP_7.fillBlock(14,11,14,12,BlockType.X_TRAP_KILL)//x+
				MAP_7.fillBlock(11,14,12,14,BlockType.X_TRAP_KILL)//y+
			}
			//====Map 8====//
			MAP_8.copyFrom(BASIC_FRAME)
			{
				//hole
				MAP_8.fillBlock(0,12,0,13,BlockType.VOID)
				MAP_8.fillBlock(23,12,23,13,BlockType.VOID)
				//down
				drawLaserTrapDownPillar(MAP_8,4);
				drawLaserTrapDownPillar(MAP_8,14);
				//up
				drawLaserTrapUpPillar(MAP_8,9);
				drawLaserTrapUpPillar(MAP_8,19);
			}
			//====Map 9====//
			MAP_9.copyFrom(EMPTY)
			{
				//left
				MAP_9.fillBlock(0,0,0,23,BlockType.LASER_TRAP);
				//right
				MAP_9.fillBlock(23,0,23,23,BlockType.LASER_TRAP);
				//center
				MAP_7.fillBlock(12,12,13,13,BlockType.COLOR_SPAWNER)//up side
			}
			//Set Variables//
			return true;
		}
		
		//Sub Graphics functions
		protected static function drawLaserTrapDownPillar(map:Map_V1,rootX:uint):void
		{
			map.fillBlock(rootX-1,1,rootX-1,18,BlockType.WALL)
			map.fillBlock(rootX+1,1,rootX+1,18,BlockType.WALL)
			map.fillBlock(rootX,1,rootX,18,BlockType.BEDROCK)
			map.setBlock(rootX,19,BlockCommon.fromType(BlockType.LASER_TRAP))
			map.setBlock(rootX+1,19,BlockCommon.fromType(BlockType.GLASS))
			map.setBlock(rootX-1,19,BlockCommon.fromType(BlockType.GLASS))
			map.setBlock(rootX,20,BlockCommon.fromType(BlockType.GLASS))
			map.setBlock(rootX+1,20,BlockCommon.fromType(BlockType.WALL))
			map.setBlock(rootX-1,20,BlockCommon.fromType(BlockType.WALL))
		}
		
		protected static function drawLaserTrapUpPillar(map:Map_V1,rootX:uint):void
		{
			map.fillBlock(rootX-1,22,rootX-1,5,BlockType.WALL)
			map.fillBlock(rootX+1,22,rootX+1,5,BlockType.WALL)
			map.fillBlock(rootX,22,rootX,5,BlockType.BEDROCK)
			map.setBlock(rootX,4,BlockCommon.fromType(BlockType.LASER_TRAP))
			map.setBlock(rootX+1,4,BlockCommon.fromType(BlockType.GLASS))
			map.setBlock(rootX-1,4,BlockCommon.fromType(BlockType.GLASS))
			map.setBlock(rootX,3,BlockCommon.fromType(BlockType.GLASS))
			map.setBlock(rootX+1,3,BlockCommon.fromType(BlockType.WALL))
			map.setBlock(rootX-1,3,BlockCommon.fromType(BlockType.WALL))
		}
		
		protected static function drawLaserTrapBox(map:Map_V1,x:int,y:int):void
		{
			map.setBlock(x,y,BlockCommon.fromType(BlockType.LASER_TRAP))
			map.setBlock(x+1,y,BlockCommon.fromType(BlockType.GLASS))
			map.setBlock(x-1,y,BlockCommon.fromType(BlockType.GLASS))
			map.setBlock(x,y-1,BlockCommon.fromType(BlockType.GLASS))
			map.setBlock(x,y+1,BlockCommon.fromType(BlockType.GLASS))
			map.setBlock(x+1,y-1,BlockCommon.fromType(BlockType.WALL))
			map.setBlock(x-1,y-1,BlockCommon.fromType(BlockType.WALL))
			map.setBlock(x+1,y+1,BlockCommon.fromType(BlockType.WALL))
			map.setBlock(x-1,y+1,BlockCommon.fromType(BlockType.WALL))
		}
		
		//============Instance Variables============//
		protected var _context:Object=new Object()
		
		//============Constructor============//
		public function Map_V1(context:Object=null):void
		{
			if(context!=null) this._context=context;
		}
		
		//============Instance Getter And Setter============//
		
		//============Interface Functions============//
		public override function get mapWidth():uint
		{
			return GlobalGameVariables.DISPLAY_GRIDS
		}
		
		public override function get mapHeight():uint
		{
			return GlobalGameVariables.DISPLAY_GRIDS
		}
		
		public override function get randomX():int
		{
			return exMath.random(this.mapWidth)
		}
		
		public override function get randomY():int
		{
			return exMath.random(this.mapHeight)
		}
		
		public override function get allDefinedPositions():Vector.<iPoint>
		{
			var returnPoints:Vector.<iPoint>=new Vector.<iPoint>()
			if(this._context==null) return returnPoints
			for(var key:String in this._context)
			{
				returnPoints.push(indexToPoint(key))
			}
			return returnPoints
		}
		
		public override function clone(createBlock:Boolean=true):IMap
		{
			var tempContext:Object=new Object()
			var context:BlockCommon
			for(var index:String in this._context)
			{
				context=(this._context[index] as BlockCommon)
				if(context==null) continue
				context=createBlock?context.clone():context
				tempContext[index]=context
			}
			var copy:IMap=new Map_V1(tempContext)
			return copy
		}
		
		public override function copyFrom(target:IMap,clearSelf:Boolean=false):void
		{
			if(clearSelf) this.removeAllBlock(false)
			var points:Vector.<iPoint>=target.allDefinedPositions
			for each(var point:iPoint in points)
			{
				this._setBlock(point.x,point.y,target.getBlock(point.x,point.y))
			}
		}
		
		public override function hasBlock(x:int,y:int):Boolean
		{
			if(this.getBlock(x,y)==null)
			{
				this._setVoid(x,y)
				return false
			}
			return this._context.hasOwnProperty(pointToIndex(x,y))
		}
		
		public override function getBlock(x:int,y:int):BlockCommon
		{
			return this._getBlock(x,y)
		}
		
		public override function getBlockAttributes(x:int,y:int):BlockAttributes
		{
			if(hasBlock(x,y))
			{
				return this._getBlock(x,y).attributes
			}
			else
			{
				return BlockAttributes.VOID
			}
		}
		
		public override function getBlockType(x:int,y:int):BlockType
		{
			if(hasBlock(x,y))
			{
				return this._getBlock(x,y).type
			}
			else
			{
				return BlockType.VOID
			}
		}
		
		public override function setBlock(x:int,y:int,block:BlockCommon):void
		{
			this._setBlock(x,y,block)
		}
		
		public override function isVoid(x:int,y:int):Boolean
		{
			return (!this.hasBlock(x,y)||this.getBlockType(x,y)==BlockType.VOID)
		}
		
		public override function setVoid(x:int,y:int):void
		{
			this._setVoid(x,y)
		}
		
		public override function removeAllBlock(deleteBlock:Boolean=false):void
		{
			//trace(this+":removeAllBlock!")
			for(var key:String in this._context)
			{
				delete this._context[key]
			}
		}
		
		public override function setDisplayTo(target:IMapDisplayer):void 
		{
			target.removeAllBlock()
			var ix:int,iy:int,iBlock:BlockCommon
			for(var index:String in this._context)
			{
				ix=indexToPoint(index).x
				iy=indexToPoint(index).y
				iBlock=this._getBlock(ix,iy)
				target.setBlock(ix,iy,iBlock)
			}
		}
		
		public override function setDisplayToLayers(targetBottom:IMapDisplayer,
										   targetMiddle:IMapDisplayer,
										   targetTop:IMapDisplayer):void
		{
			targetBottom.removeAllBlock()
			targetMiddle.removeAllBlock()
			targetTop.removeAllBlock()
			var target:IMapDisplayer
			var ix:int,iy:int,iBlock:BlockCommon,iLayer:int
			for(var index:String in this._context)
			{
				ix=indexToPoint(index).x
				iy=indexToPoint(index).y
				iBlock=this._getBlock(ix,iy)
				if(iBlock==null) continue
				iLayer=iBlock.attributes.drawLayer
				if(iLayer>0) target=targetTop
				else if(iLayer<0) target=targetBottom
				else target=targetMiddle
				if(target!=null) target.setBlock(ix,iy,iBlock)
			}
		}
		
		//============Instance Funcitons============//
		//========Core========//
		protected function _getBlock(x:int,y:int):BlockCommon
		{
			var block:BlockCommon=this._context[pointToIndex(x,y)] as BlockCommon
			return block==null?BlockCommon.fromType(BlockType.NULL):block
		}
		
		protected function _setBlock(x:int,y:int,block:BlockCommon):void
		{
			if(block==null) _setVoid(x,y)
			this._context[pointToIndex(x,y)]=block
		}
		
		protected function _setVoid(x:int,y:int):void
		{
			delete this._context[pointToIndex(x,y)]
		}
		
		public function fillBlock(x1:int,y1:int,x2:int,y2:int,
								  type:BlockType,
								  outline:Boolean=false):Map_V1 
		{
			var xl:int=Math.min(x1,x2),xm:int=Math.max(x1,x2)
			var yl:int=Math.min(y1,y2),ym:int=Math.max(y1,y2)
			var xi:int,yi:int
			for(xi=xl;xi<=xm;xi++)
			{
				for(yi=yl;yi<=ym;yi++)
				{
					if(!outline||
					   outline&&((xi==xm||xi==xl)||(yi==ym||yi==yl)))
					{
						this._setBlock(xi,yi,BlockCommon.fromType(type))
					}
				}
			}
			return this
		}
	}
}