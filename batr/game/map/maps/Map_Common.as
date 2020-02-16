package batr.game.map.maps 
{
	import batr.game.map.IMapDisplayer;
	import batr.game.block.BlockType;
	import batr.game.block.BlockAttributes;
	import batr.game.block.BlockCommon;
	import batr.common.iPoint;
	import batr.game.map.IMap;
	
	public class Map_Common extends Object implements IMap
	{
		//============Constructor============//
		public function Map_Common() 
		{
			super();
		}
		
		//============Interface Functions============//
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
		
		public function clone(createBlock:Boolean=false):IMap 
		{
			return null;
		}
		
		public function copyFrom(target:IMap,clearSelf:Boolean=false):void
		{
			return;
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
