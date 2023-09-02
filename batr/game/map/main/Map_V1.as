package batr.game.map.main
{
	import batr.common.*;
	import batr.general.*;
	import batr.game.block.blocks.XTrap;
	
	import batr.game.map.*;
	import batr.game.block.*;
	import batr.game.map.*;
	import batr.game.map.main.*;
	
	import flash.utils.getQualifiedClassName;
	
	/* This's a Game Map<Version 1>
	 * This Map only save BlockType,not BlockCommon
	 */
	public class Map_V1 extends NativeMapCommon
	{
		//============Static Variables============//
		protected static const _SIZE:uint=GlobalGameVariables.DISPLAY_GRIDS
		
		public static var EMPTY:Map_V1=new Map_V1("EMPTY")
		public static var FRAME:Map_V1=new Map_V1("FRAME")
		public static var MAP_1:Map_V1=new Map_V1("1")
		public static var MAP_2:Map_V1=new Map_V1("2")
		public static var MAP_3:Map_V1=new Map_V1("3")
		public static var MAP_4:Map_V1=new Map_V1("4")
		public static var MAP_5:Map_V1=new Map_V1("5")
		public static var MAP_6:Map_V1=new Map_V1("6")
		public static var MAP_7:Map_V1=new Map_V1("7")
		public static var MAP_8:Map_V1=new Map_V1("8")
		public static var MAP_9:Map_V1=new Map_V1("9")
		public static var MAP_A:Map_V1=new Map_V1("A",null,true)
		public static var MAP_B:Map_V1=new Map_V1("B",null,true)
		public static var MAP_C:Map_V1=new Map_V1("C",null,true)
		public static var MAP_D:Map_V1=new Map_V1("D",null,true)
		public static var MAP_E:Map_V1=new Map_V1("E",null,true)
		public static var MAP_F:Map_V1=new Map_V1("F",null,true)
		public static var MAP_G:Map_V1=new Map_V1("G",null,true)
		public static var MAP_H:Map_V1=new Map_V1("H",null,true)
		
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
			//====Basic Frame====//
			FRAME.fillBlock(0,0,_SIZE-1,_SIZE-1,BlockType.BEDROCK,true)
			//====Map 1====//
			MAP_1.copyContextFrom(FRAME)
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
			MAP_2.copyContextFrom(FRAME)
			{
				MAP_2.fillBlock(4,4,10,10,BlockType.WALL)
				MAP_2.fillBlock(4,13,10,19,BlockType.WALL)
				MAP_2.fillBlock(13,4,19,10,BlockType.WALL)
				MAP_2.fillBlock(13,13,19,19,BlockType.WALL)
			}
			//====Map 3====//
			MAP_3.copyContextFrom(FRAME)
			{
				for(iy=3;iy<_SIZE-4;iy+=4)
				{
					MAP_3.fillBlock(3,iy,20,iy+1,BlockType.WATER)
				}
			}
			//====Map 4====//
			MAP_4.copyContextFrom(FRAME)
			{
				MAP_4.fillBlock(3,3,20,4,BlockType.WALL)
				MAP_4.fillBlock(3,19,20,20,BlockType.WALL)
				MAP_4.fillBlock(11,5,12,18,BlockType.GLASS)
			}
			//====Map 5====//
			MAP_5._generater=new MapGenerater(function(map:IMap):IMap
			{
				map.copyContextFrom(Map_V1.FRAME);
				var randNum:int=24+exMath.random(47),randType:BlockType;
				var ix:int,iy:int;
				while(--randNum>0)
				{
					ix=map.randomX,iy=map.randomY;
					if(map.getBlockType(ix,iy)==BlockType.BEDROCK)
					{
						map.setVoid(ix,iy);
					}/*
					else if(UsefulTools.randomBoolean())
					{
						if(UsefulTools.randomBoolean(1,3))
						{
							map.setBlock(ix,iy,BlockCommon.fromType(BlockType.X_TRAP_KILL));
						}
						else
						{
							map.setBlock(ix,iy,BlockCommon.fromType(BlockType.X_TRAP_HURT));
						}
					}*/
					else
					{
						randType=BlockType.RANDOM_NORMAL;
						map.setBlock(ix,iy,BlockCommon.fromType(randType));
					}
				}
				return map;
			});
			//====Map 6====//
			MAP_6.copyContextFrom(FRAME)
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
			MAP_7.copyContextFrom(FRAME)
			{
				MAP_7.fillBlock(1,5,22,6,BlockType.WATER)//up side
				MAP_7.fillBlock(1,17,22,18,BlockType.WATER)//down side
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
			MAP_8.copyContextFrom(FRAME)
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
			MAP_9.copyContextFrom(EMPTY)
			{
				//left
				MAP_9.fillBlock(0,0,0,23,BlockType.LASER_TRAP);
				//right
				MAP_9.fillBlock(23,0,23,23,BlockType.LASER_TRAP);
				//center
				MAP_9.fillBlock(11,11,12,12,BlockType.COLOR_SPAWNER)//up side
			}
			//======Arena Maps======//
			//====Map A====//
			MAP_A.copyContextFrom(FRAME)
			{
				for(i=0;i<5;i++)
				{
					//base
					MAP_A.fillBlock(5,5+3*i,18,6+3*i,BlockType.WALL);
					if(i<4)
					{
						//lines
						MAP_A.fillBlock(6,7+3*i,17,7+3*i,BlockType.METAL);
						//corner
						MAP_A.fillBlock(1+(i>>1)*20,1+(i&1)*20,2+(i>>1)*20,2+(i&1)*20,BlockType.X_TRAP_ROTATE);
						MAP_A.addSpawnPointWithMark(2+(i>>1)*19,2+(i&1)*19);
					}
				}
			}
			//====Map B====//
			MAP_B.copyContextFrom(FRAME)
			{
				/**
				 * Spin 180*:x=23-x,y=23-y
				 * for fill:cross imput
				 */
				//corner spawnpoint
				for(i=0;i<4;i++) MAP_B.addSpawnPointWithMark(2+(i>>1)*19,2+(i&1)*19);
				//Metal Middle Line&Laser Trap
				//l
				MAP_B.fillBlock(0,9,13,9,BlockType.METAL);
				MAP_B.setBlock(14,9,BlockCommon.fromType(BlockType.LASER_TRAP));
				//r
				MAP_B.fillBlock(10,14,23,14,BlockType.METAL);
				MAP_B.setBlock(9,14,BlockCommon.fromType(BlockType.LASER_TRAP));
				//center X_TRAP_KILL
				MAP_B.fillBlock(11,11,12,12,BlockType.X_TRAP_KILL);
				//side water&spawner
				//l
				MAP_B.fillBlock(6,10,6,17,BlockType.WATER)
				MAP_B.setBlock(3,16,BlockCommon.fromType(BlockType.COLOR_SPAWNER));
				MAP_B.setBlock(3,12,BlockCommon.fromType(BlockType.COLOR_SPAWNER));
				//r
				MAP_B.fillBlock(17,6,17,13,BlockType.WATER)
				MAP_B.setBlock(20,7,BlockCommon.fromType(BlockType.COLOR_SPAWNER));
				MAP_B.setBlock(20,11,BlockCommon.fromType(BlockType.COLOR_SPAWNER));
				//up&down side X_TRAP_HURT/WATER/BEDROCK
				//u
				MAP_B.fillBlock(19,4,22,4,BlockType.BEDROCK)
				MAP_B.fillBlock(6,4,18,4,BlockType.WATER)
				MAP_B.fillBlock(6,2,20,2,BlockType.X_TRAP_HURT)
				//d
				MAP_B.fillBlock(1,19,4,19,BlockType.BEDROCK)
				MAP_B.fillBlock(5,19,17,19,BlockType.WATER)
				MAP_B.fillBlock(3,21,17,21,BlockType.X_TRAP_HURT)
				//corner X_TRAP_HURT/WATER
				//ul
				MAP_B.fillBlock(2,3,2,7,BlockType.X_TRAP_HURT)
				MAP_B.fillBlock(4,1,4,7,BlockType.WATER)
				//dr
				MAP_B.fillBlock(21,16,21,20,BlockType.X_TRAP_HURT)
				MAP_B.fillBlock(19,16,19,22,BlockType.WATER)
			}
			//====Map C====//
			MAP_C.copyContextFrom(FRAME)
			{
				//center C
				//h
				MAP_C.fillBlock(6,6,17,6,BlockType.BEDROCK)
				MAP_C.fillBlock(6,17,17,17,BlockType.BEDROCK)
				//l
				MAP_C.fillBlock(6,6,6,17,BlockType.BEDROCK)
				for(i=0;i<4;i++)
				{
					if(i<2)
					{
						//10*Spawner
						MAP_C.setBlock(6,6+i*11,BlockCommon.fromType(BlockType.COLOR_SPAWNER));
						MAP_C.setBlock(10,6+i*11,BlockCommon.fromType(BlockType.COLOR_SPAWNER));
						MAP_C.setBlock(13,6+i*11,BlockCommon.fromType(BlockType.COLOR_SPAWNER));
						MAP_C.setBlock(17,6+i*11,BlockCommon.fromType(BlockType.COLOR_SPAWNER));
						MAP_C.setBlock(6,10+i*3,BlockCommon.fromType(BlockType.COLOR_SPAWNER));
						//Spawnpoint/Wall,l
						MAP_C.addSpawnPointWithMark(3,11+i);
						MAP_C.setBlock(3,10+i*3,BlockCommon.fromType(BlockType.WALL));
						//water/wall,r
						MAP_C.setBlock(20,11+i,BlockCommon.fromType(BlockType.WATER));
						MAP_C.setBlock(20,10+i*3,BlockCommon.fromType(BlockType.WALL));
					}
					//Spawnpoint/Wall,u&d
					MAP_C.addSpawnPointWithMark(11+(i&1),3+17*(i>>1));
					MAP_C.setBlock(10+(i&1)*3,3+17*(i>>1),BlockCommon.fromType(BlockType.WALL));
					//corner LaserTrap/XTrapHurt
					MAP_C.setBlock(3+(i>>1)*17,3+(i&1)*17,BlockCommon.fromType(BlockType.LASER_TRAP));
					MAP_C.setBlock(2+(i>>1)*17,3+(i&1)*17,BlockCommon.fromType(BlockType.X_TRAP_HURT));
					MAP_C.setBlock(3+(i>>1)*17,2+(i&1)*17,BlockCommon.fromType(BlockType.X_TRAP_HURT));
					MAP_C.setBlock(4+(i>>1)*17,3+(i&1)*17,BlockCommon.fromType(BlockType.X_TRAP_HURT));
					MAP_C.setBlock(3+(i>>1)*17,4+(i&1)*17,BlockCommon.fromType(BlockType.X_TRAP_HURT));
				}
			}
			//====Map D====//
			MAP_D.copyContextFrom(FRAME)
			{
				for(i=0;i<4;i++)
				{
					//Water Circle
					//long_line
					MAP_D.fillBlock(9+(i>>1)*2,4+(i&1)*15,12+(i>>1)*2,4+(i&1)*15,BlockType.WATER)
					MAP_D.fillBlock(4+(i&1)*15,9+(i>>1)*2,4+(i&1)*15,12+(i>>1)*2,BlockType.WATER)
					//2x line
					//h
					MAP_D.setBlock(7+(i>>1)*8,5+(i&1)*13,BlockCommon.fromType(BlockType.WATER));
					MAP_D.setBlock(8+(i>>1)*8,5+(i&1)*13,BlockCommon.fromType(BlockType.WATER));
					//v
					MAP_D.setBlock(5+(i&1)*13,7+(i>>1)*8,BlockCommon.fromType(BlockType.WATER));
					MAP_D.setBlock(5+(i&1)*13,8+(i>>1)*8,BlockCommon.fromType(BlockType.WATER));
					//point
					MAP_D.setBlock(6+(i>>1)*11,6+(i&1)*11,BlockCommon.fromType(BlockType.WATER));
					if(i<2)
					{
						//Spawnpoint/Wall,d
						MAP_D.addSpawnPointWithMark(11+i,21);
						MAP_D.setBlock(10+i*3,21,BlockCommon.fromType(BlockType.WALL));
					}
					//corner spawner
					MAP_D.setBlock(4+(i>>1)*15,4+(i&1)*15,BlockCommon.fromType(BlockType.COLOR_SPAWNER));
					//Spawnpoint/Wall,l&r
					MAP_D.addSpawnPointWithMark(2+19*(i>>1),11+(i&1));
					MAP_D.setBlock(2+19*(i>>1),10+(i&1)*3,BlockCommon.fromType(BlockType.WALL));
					//center band
					MAP_D.setBlock(11+(i>>1),10+(i&1)*3,BlockCommon.fromType(BlockType.LASER_TRAP));
				}
				//XTrapRotate,u
				MAP_D.fillBlock(11,3,12,4,BlockType.X_TRAP_ROTATE)
				//XTrapKill,l
				MAP_D.fillBlock(7,10,10,13,BlockType.X_TRAP_KILL)
				//XTrapHurt,r
				MAP_D.fillBlock(13,10,16,13,BlockType.X_TRAP_HURT)
			}
			//====Map E====//
			MAP_E.copyContextFrom(FRAME)
			{
				for(i=0;i<4;i++) MAP_E.addSpawnPointWithMark(2+(i>>1)*19,2+(i&1)*19);
				//Center E
				fillReflectBlock(MAP_E,false,true,6,6,17,7,BlockType.BEDROCK)
				MAP_E.fillBlock(6,8,7,15,BlockType.BEDROCK)
				MAP_E.fillBlock(6,11,17,12,BlockType.BEDROCK)
				//corner water/laserTrap
				fillReflectBlock(MAP_E,true,true,4,1,4,5,BlockType.WATER);
				setReflectBlock(MAP_E,true,true,6,6,BlockCommon.fromType(BlockType.LASER_TRAP))
				//1x1 Water,l
				setReflectBlock(MAP_E,false,true,2,4,BlockCommon.fromType(BlockType.WATER))
				//killTrap/spawner,l
				setReflectBlock(MAP_E,false,true,3,11,BlockCommon.fromType(BlockType.COLOR_SPAWNER))
				setReflectBlock(MAP_E,false,true,1,11,BlockCommon.fromType(BlockType.X_TRAP_KILL))
				setReflectBlock(MAP_E,false,true,5,11,BlockCommon.fromType(BlockType.X_TRAP_KILL))
				fillReflectBlock(MAP_E,false,true,1,7,2,7,BlockType.X_TRAP_KILL)
				fillReflectBlock(MAP_E,false,true,4,7,5,7,BlockType.X_TRAP_KILL)
				fillReflectBlock(MAP_E,false,true,2,9,4,9,BlockType.X_TRAP_KILL)
				//water/rotate/supply,u&d
				fillReflectBlock(MAP_E,false,true,6,4,18,4,BlockType.WATER)
				fillReflectBlock(MAP_E,false,true,9,9,18,9,BlockType.WATER)
				MAP_E.fillBlock(19,6,19,17,BlockType.WATER)
				fillReflectBlock(MAP_E,false,true,15,1,15,3,BlockType.X_TRAP_ROTATE)
				MAP_E.setBlock(19,11,BlockCommon.fromType(BlockType.X_TRAP_ROTATE))
				MAP_E.setBlock(19,12,BlockCommon.fromType(BlockType.X_TRAP_ROTATE))
				setReflectBlock(MAP_E,false,true,17,2,BlockCommon.fromType(BlockType.SUPPLY_POINT))
				//hurt,r
				MAP_E.fillBlock(21,4,21,19,BlockType.X_TRAP_HURT)
			}
			//====Map F====//
			MAP_F.copyContextFrom(EMPTY)
			{
				//Center spawnPoint
				for(i=0;i<4;i++) MAP_F.addSpawnPointWithMark(11+(i>>1),11+(i&1));
				//Bedrock&Gate
				setReflectBlock(MAP_F,true,true,1,1,BlockCommon.fromType(BlockType.BEDROCK))
				fillReflectMirrorBlock(MAP_F,true,true,2,1,8,1,BlockType.BEDROCK)
				setReflectMirrorBlock(MAP_F,true,true,1,0,BlockCommon.fromType(BlockType.GATE_OPEN))
				setReflectMirrorBlock(MAP_F,true,true,9,1,BlockCommon.fromType(BlockType.GATE_OPEN))
				//Traps/gate/supply
				setReflectBlock(MAP_F,true,true,3,3,BlockCommon.fromType(BlockType.X_TRAP_KILL))
				setReflectBlock(MAP_F,true,true,5,5,BlockCommon.fromType(BlockType.X_TRAP_HURT))
				setReflectBlock(MAP_F,true,true,7,7,BlockCommon.fromType(BlockType.X_TRAP_HURT))
				setReflectBlock(MAP_F,true,true,6,6,BlockCommon.fromType(BlockType.SUPPLY_POINT))
				setReflectMirrorBlock(MAP_F,true,true,7,5,BlockCommon.fromType(BlockType.X_TRAP_HURT))
				setReflectMirrorBlock(MAP_F,true,true,6,5,BlockCommon.fromType(BlockType.X_TRAP_ROTATE))
				setReflectMirrorBlock(MAP_F,true,true,7,6,BlockCommon.fromType(BlockType.X_TRAP_ROTATE))
				//Water/Trap/spawner/gate,c
				fillReflectMirrorBlock(MAP_F,true,true,10,1,10,6,BlockType.WATER)
				setReflectBlock(MAP_F,true,true,8,8,BlockCommon.fromType(BlockType.COLOR_SPAWNER))
				setReflectMirrorBlock(MAP_F,true,true,9,8,BlockCommon.fromType(BlockType.LASER_TRAP))
				setReflectMirrorBlock(MAP_F,true,true,10,7,BlockCommon.fromType(BlockType.GATE_OPEN))
				setReflectMirrorBlock(MAP_F,true,true,10,8,BlockCommon.fromType(BlockType.BEDROCK))
				setReflectMirrorBlock(MAP_F,true,true,11,8,BlockCommon.fromType(BlockType.GATE_OPEN))
			}
			//====Map G====//
			MAP_G.copyContextFrom(FRAME)
			{
				fillReflectMirrorBlock(MAP_G,true,true,3,3,8,3,BlockType.BEDROCK);
				setReflectMirrorBlock(MAP_G,true,true,1,1,BlockCommon.fromType(BlockType.MOVEABLE_WALL));
				MAP_G.fillBlock(4,4,19,19,BlockType.GATE_OPEN,false);
				for(i=0;i<4;i++) MAP_G.addSpawnPointWithMark(2+(i>>1)*19,2+(i&1)*19);
			}
			//====Map H====//
			MAP_H.copyContextFrom(FRAME)
			{
				fillReflectMirrorBlock(MAP_H,true,true,4,4,9,4,BlockType.BEDROCK);
				ix=UsefulTools.randomBoolean()?0:9;
				iy=UsefulTools.randomBoolean()?0:9;
				MAP_H.fillBlock(5+ix,5+iy,9+ix,9+iy,BlockType.MOVEABLE_WALL,false);
				for(i=10;i<=13;i++)
				{
					//x
					MAP_H.addSpawnPointWithMark(i, 4);
					MAP_H.addSpawnPointWithMark(i, 19);
					//y
					MAP_H.addSpawnPointWithMark(4, i);
					MAP_H.addSpawnPointWithMark(19, i);
				}
			}
			//Set Variables//
			return true;
		}
		
		protected static function setReflectBlock(map:Map_V1,rX:Boolean,rY:Boolean,x:int,y:int,block:BlockCommon):void
		{
			map.setBlock(x,y,block);
			if(rX) map.setBlock(23-x,y,block);
			if(rY)
			{
				map.setBlock(x,23-y,block);
				if(rX) map.setBlock(23-x,23-y,block);
			}
		}
		
		protected static function fillReflectBlock(map:Map_V1,rX:Boolean,rY:Boolean,x1:int,y1:int,x2:int,y2:int,type:BlockType,outline:Boolean=false):void
		{
			map.fillBlock(x1,y1,x2,y2,type,outline);
			if(rX) map.fillBlock(23-x2,y1,23-x1,y2,type,outline);
			if(rY)
			{
				map.fillBlock(x1,23-y2,x2,23-y1,type,outline);
				if(rX) map.fillBlock(23-x2,23-y2,23-x1,23-y1,type,outline);
			}
		}
		
		protected static function setMirrorBlock(map:Map_V1,x:int,y:int,block:BlockCommon):void
		{
			map.setBlock(y,x,block);
		}
		
		protected static function fillMirrorBlock(map:Map_V1,x1:int,y1:int,x2:int,y2:int,type:BlockType,outline:Boolean=false):void
		{
			map.fillBlock(y1,x1,y2,x2,type,outline);
		}
		
		protected static function setReflectMirrorBlock(map:Map_V1,rX:Boolean,rY:Boolean,x:int,y:int,block:BlockCommon):void
		{
			setReflectBlock(map,rX,rY,x,y,block);
			setReflectBlock(map,rY,rX,y,x,block);
		}
		
		protected static function fillReflectMirrorBlock(map:Map_V1,rX:Boolean,rY:Boolean,x1:int,y1:int,x2:int,y2:int,type:BlockType,outline:Boolean=false):void
		{
			fillReflectBlock(map,rX,rY,x1,y1,x2,y2,type,outline);
			fillReflectBlock(map,rY,rX,y1,x1,y2,x2,type,outline);
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
		protected var _context:Object=new Object();
		protected var _generater:IMapGenerater;
		
		//============Constructor============//
		public function Map_V1(name:String=null,context:Object=null,isArena:Boolean=false):void
		{
			super(name,isArena);
			if(context!=null) this._context=context;
		}
		
		//============Destructor============//
		public override function deleteSelf():void
		{
			this.removeAllBlock();
			this._context=null;
			this._generater=null;
			super.deleteSelf();
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
		
		public override function get allMapPositions():Vector.<iPoint>
		{
			var returnPoints:Vector.<iPoint>=new Vector.<iPoint>()
			for(var x:uint=0;x<this.mapWidth;x++)
			{
				for(var y:uint=0;y<this.mapHeight;y++)
				{
					returnPoints.push(new iPoint(x,y))
				}
			}
			return returnPoints
		}
		
		/**
		 * truly overrite virual function
		 */
		public override function clone(createBlock:Boolean=true):IMap
		{
			//context
			var tempContext:Object=new Object()
			var block:BlockCommon
			for(var index:String in this._context)
			{
				block=(this._context[index] as BlockCommon)
				if(block==null) continue
				block=createBlock?block.clone():block
				tempContext[index]=block
			}
			//construct(included isArena)
			var copy:Map_V1=new Map_V1(this._name,tempContext,this._arena)
			//spawnPoints
			copy._spawnPoints=this._spawnPoints.concat()
			//generater
			copy._generater=this._generater
			//return
			return copy
		}
		
		public override function copyFrom(target:IMap,clearSelf:Boolean=false,createBlock:Boolean=true):void
		{
			//context
			this.copyContextFrom(target,clearSelf,createBlock);
			//super
			super.copyFrom(target,clearSelf,createBlock);
		}
		
		public override function copyContextFrom(target:IMap,clearSelf:Boolean=false,createBlock:Boolean=true):void
		{
			//clear
			if(clearSelf) this.removeAllBlock()
			//context
			var points:Vector.<iPoint>=target.allDefinedPositions
			var block:BlockCommon
			for each(var point:iPoint in points)
			{
				block=target.getBlock(point.x,point.y);
				this._setBlock(point.x,point.y,createBlock?block.clone():block)
			}
			//super
			super.copyContextFrom(target,clearSelf,createBlock)
		}
		
		/**
		 * construct new map.
		 * If has generater,generate to new map
		 * Else clone self
		 * @return
		 */
		public override function generateNew():IMap
		{
			//trace("generateNew:",this===MAP_5,this._generater)
			if(this._generater!=null) return this._generater.generateTo(this.clone(),true);
			return super.generateNew();
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
			return this._getBlock(x,y);
		}
		
		public override function getBlockAttributes(x:int,y:int):BlockAttributes
		{
			if(hasBlock(x,y)) return this._getBlock(x,y).attributes;
			else return BlockAttributes.VOID;
		}
		
		public override function getBlockType(x:int,y:int):BlockType
		{
			if(hasBlock(x,y)) return this._getBlock(x,y).type;
			else return BlockType.VOID;
		}
		
		public override function setBlock(x:int,y:int,block:BlockCommon):void
		{
			this._setBlock(x,y,block);
		}
		
		public override function isVoid(x:int,y:int):Boolean
		{
			return (!this.hasBlock(x,y)||this.getBlockType(x,y)==BlockType.VOID);
		}
		
		public override function setVoid(x:int,y:int):void
		{
			this._setVoid(x,y);
		}
		
		public override function removeAllBlock(deleteBlock:Boolean=true):void
		{
			//trace(this+":removeAllBlock!")
			var block:BlockCommon;
			for(var key:String in this._context)
			{
				block=this._context[key] as BlockCommon
				if(deleteBlock&&block!=null) block.deleteSelf();
				delete this._context[key];
			}
		}
		
		public override function setDisplayTo(target:IMapDisplayer):void
		{
			target.removeAllBlock();
			var ix:int,iy:int,iBlock:BlockCommon;
			for(var index:String in this._context)
			{
				ix=indexToPoint(index).x;
				iy=indexToPoint(index).y;
				iBlock=this._getBlock(ix,iy);
				target.setBlock(ix,iy,iBlock);
			}
		}
		
		public override function forceDisplayToLayers(targetBottom:IMapDisplayer,targetMiddle:IMapDisplayer,targetTop:IMapDisplayer):void
		{
			targetBottom.removeAllBlock();
			targetMiddle.removeAllBlock();
			targetTop.removeAllBlock();
			var ix:int,iy:int,iBlock:BlockCommon,iLayer:int
			for(var index:String in this._context)
			{
				ix=indexToPoint(index).x
				iy=indexToPoint(index).y
				iBlock=this._getBlock(ix,iy)
				if(iBlock==null) continue
				iLayer=iBlock.attributes.drawLayer
				NativeMapCommon.getTargetByLayer(iLayer,targetTop,targetBottom,targetMiddle).setBlock(ix,iy,iBlock)
			}
		}
		
		//============Instance Funcitons============//
		//========Core========//
		protected function _getBlock(x:int,y:int):BlockCommon
		{
			var block:BlockCommon=this._context[pointToIndex(x,y)] as BlockCommon;
			return block==null?BlockCommon.fromType(BlockType.NULL):block;
		}
		
		protected function _setBlock(x:int,y:int,block:BlockCommon):void
		{
			if(block==null) _setVoid(x,y);
			this._context[pointToIndex(x,y)]=block;
		}
		
		protected function _setVoid(x:int,y:int):void
		{
			delete this._context[pointToIndex(x,y)];
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
					if(!outline||outline&&((xi==xm||xi==xl)||(yi==ym||yi==yl)))
					{
						this._setBlock(xi,yi,BlockCommon.fromType(type))
					}
				}
			}
			return this;
		}
		
		public function fillBlock2(x1:int,y1:int,x2:int,y2:int,
								  block:BlockCommon,
								  outline:Boolean=false):Map_V1 
		{
			var xl:int=Math.min(x1,x2),xm:int=Math.max(x1,x2)
			var yl:int=Math.min(y1,y2),ym:int=Math.max(y1,y2)
			var xi:int,yi:int
			for(xi=xl;xi<=xm;xi++)
			{
				for(yi=yl;yi<=ym;yi++)
				{
					if(!outline||outline&&((xi==xm||xi==xl)||(yi==ym||yi==yl)))
					{
						this._setBlock(xi,yi,block.clone())
					}
				}
			}
			return this;
		}
	}
}