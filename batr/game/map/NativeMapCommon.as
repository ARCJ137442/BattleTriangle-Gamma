package batr.game.map 
{
	import batr.common.exMath;
	import batr.common.iPoint;
	import batr.common.UintPointCompress;
	
	import batr.game.map.IMapDisplayer;
	import batr.game.block.BlockType;
	import batr.game.block.BlockAttributes;
	import batr.game.block.BlockCommon;
	import batr.game.map.IMap;
	
	/**
	 * This class only achieved spawnpoints
	 */
	public class NativeMapCommon extends Object implements IMap
	{
		//============Instance Variables============//
		protected var _spawnPoints:Vector.<uint>=new Vector.<uint>();
		protected var _arena:Boolean=false;
		
		//============Constructor============//
		public function NativeMapCommon(arena:Boolean=false) 
		{
			super();
			this._arena=arena;
		}
		
		//============Interface Getter And Setter============//
		public function get mapWidth():uint
		{
			return 0;
		}
		
		public function get mapHeight():uint
		{
			return 0;
		}
		
		public function get randomX():int 
		{
			return 0;
		}
		
		public function get randomY():int
		{
			return 0;
		}
		
		public function get allDefinedPositions():Vector.<iPoint>
		{
			return null;
		}
		
		public function get spawnPoints():Vector.<uint>
		{
			return this._spawnPoints;
		}
		
		public function get numSpawnPoints():uint
		{
			return this._spawnPoints.length;
		}
		
		public function get hasSpawnPoint():Boolean
		{
			return this.numSpawnPoints>0;
		}
		
		public function get randomSpawnPoint():iPoint
		{
			if(this.hasSpawnPoint)
			{
				return UintPointCompress.releaseFromUint(this._spawnPoints[exMath.random(this.numSpawnPoints)]);
			}
			return null;
		}
		
		/**
		 * This property determines this map's
		 * switch/mechine/trap/spawner can be destroy or carry
		 * by Weapon BlockThrower.
		 */
		public function get isArenaMap():Boolean
		{
			return this._arena;
		}
		
		//============Tool Functions============//
		public function addSpawnPointWithMark(x:int,y:int):void
		{
			this.addSpawnPoint(UintPointCompress.compressFromPoint(x,y));
			this.setBlock(x,y,BlockCommon.fromType(BlockType.SPAWN_POINT_MARK));
		}
		
		//============Interface Functions============//
		public function clone(createBlock:Boolean=false):IMap 
		{
			return null;
		}
		
		/**
		 * only copy spawnpoints and _isArena
		 */
		public function copyFrom(target:IMap,clearSelf:Boolean=false):void
		{
			//spawnpoints
			this._spawnPoints=target.spawnPoints.concat();
			//isArena
			this._arena=target.isArenaMap;
		}
		
		public function hasBlock(x:int,y:int):Boolean
		{
			return false
		}
		
		public function getBlock(x:int,y:int):BlockCommon
		{
			return null;
		}
		
		public function getBlockAttributes(x:int,y:int):BlockAttributes 
		{
			return null;
		}
		
		public function getBlockType(x:int,y:int):BlockType 
		{
			return null;
		}
		
		public function setBlock(x:int,y:int,block:BlockCommon):void
		{
			return;
		}
		
		public function isVoid(x:int,y:int):Boolean 
		{
			return false;
		}
		
		public function setVoid(x:int,y:int):void
		{
			return;
		}
		
		public function removeAllBlock(deleteBlock:Boolean=false):void
		{
			return;
		}
		
		public function setDisplayTo(target:IMapDisplayer):void
		{
			return;
		}
		
		public function setDisplayToLayers(targetBottom:IMapDisplayer,targetMiddle:IMapDisplayer,targetTop:IMapDisplayer):void
		{
			return;
		}
		
		//========SpawnPoint About========//
		/**
		 * @param	p	the point uses UintPointCompress
		 */
		public function addSpawnPoint(p:uint):void
		{
			this._spawnPoints.push(p);
		}
		
		/**
		 * @param	p	the point uses UintPointCompress
		 */
		public function removeSpawnPoint(p:uint):void
		{
			for(var i:int=this._spawnPoints.length-1;i>0;--i)
			{
				if(this._spawnPoints[i]==p) this._spawnPoints.splice(i,1);
			}
		}
		
		public function clearSpawnPoints():void
		{
			this._spawnPoints.splice(0,this.numSpawnPoints);
		}
		
		//========AI About========//
		/**
		 * Get with Matrix[x][y].
		 * @return	The Matrix.
		 */
		public function getMatrixObject():Vector.<Vector.<Object>>
		{
			var result:Vector.<Vector.<Object>>=new Vector.<Vector.<Object>>(this.mapHeight);
			var vec:Vector.<Object>;
			for(var i:uint=0;i<this.mapHeight;i++)
			{
				vec=new Vector.<Object>(this.mapWidth);
				result[i]=vec;
			}
			return result;
		}
		
		/**
		 * Get with Matrix[x][y].
		 * @return	The Matrix.
		 */
		public function getMatrixInt():Vector.<Vector.<int>>
		{
			var result:Vector.<Vector.<int>>=new Vector.<Vector.<int>>(this.mapHeight);
			var vec:Vector.<int>;
			for(var i:uint=0;i<this.mapHeight;i++)
			{
				vec=new Vector.<int>(this.mapWidth);
				result[i]=vec;
			}
			return result;
		}
		
		/**
		 * Get with Matrix[x][y].
		 * @return	The Matrix.
		 */
		public function getMatrixUint():Vector.<Vector.<uint>>
		{
			var result:Vector.<Vector.<uint>>=new Vector.<Vector.<uint>>(this.mapHeight);
			var vec:Vector.<uint>;
			for(var i:uint=0;i<this.mapHeight;i++)
			{
				vec=new Vector.<uint>(this.mapWidth);
				result[i]=vec;
			}
			return result;
		}
		
		/**
		 * Get with Matrix[x][y].
		 * @return	The Matrix.
		 */
		public function getMatrixNumber():Vector.<Vector.<Number>>
		{
			var result:Vector.<Vector.<Number>>=new Vector.<Vector.<Number>>(this.mapHeight);
			var vec:Vector.<Number>;
			for(var i:uint=0;i<this.mapHeight;i++)
			{
				vec=new Vector.<Number>(this.mapWidth);
				result[i]=vec;
			}
			return result;
		}
		
		/**
		 * Get with Matrix[x][y].
		 * @return	The Matrix.
		 */
		public function getMatrixBoolean():Vector.<Vector.<Boolean>>
		{
			var result:Vector.<Vector.<Boolean>>=new Vector.<Vector.<Boolean>>(this.mapHeight);
			var vec:Vector.<Boolean>;
			for(var i:uint=0;i<this.mapHeight;i++)
			{
				vec=new Vector.<Boolean>(this.mapWidth);
				result[i]=vec;
			}
			return result;
		}
	}
}
