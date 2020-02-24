package batr.game.map 
{
	import batr.general.*;
	
	import batr.game.block.*;
	import batr.game.map.*;
	
	import flash.display.Sprite;
	
	public class MapDisplayer extends Sprite implements IMapDisplayer
	{
		//============Static Functions============//
		protected static function isBlockLocationEquals(block:BlockCommon,x:int,y:int):Boolean
		{
			return PosTransform.realPosToLocalPos(block.x)==x&&PosTransform.realPosToLocalPos(block.y)==y;
		}
		
		//============Constructor Function============//
		public function MapDisplayer():void
		{
			super();
		}
		
		//============Destructor Function============//
		public function deleteSelf():void
		{
			this.removeAllBlock();
		}
		
		//============Interface Functions============//
		public function hasBlock(x:int,y:int):Boolean
		{
			var b:BlockCommon;
			for(var i:int=0;i<this.numChildren;i++)
			{
				b=this.getBlockAsChildAt(i);
				if(b==null) continue;
				if(isBlockLocationEquals(b,x,y)) return true;
			}
			return false;
		}
		
		public function getBlock(x:int,y:int):BlockCommon
		{
			var b:BlockCommon;
			for(var i:int=0;i<this.numChildren;i++)
			{
				b=this.getBlockAsChildAt(i);
				if(b==null) continue;
				if(isBlockLocationEquals(b,x,y)) return b;
			}
			return null;
		}
		
		public function removeBlock(x:int,y:int):void
		{
			var b:BlockCommon;
			for(var i:int=0;i<this.numChildren;i++)
			{
				b=this.getBlockAsChildAt(i);
				if(b==null) continue;
				if(isBlockLocationEquals(b,x,y))
				{
					this.removeChildAt(i);
					b.deleteSelf();
				}
			}
		}
		
		public function removeAllBlock():void
		{
			var b:BlockCommon;
			for(var i:int=this.numChildren-1;i>=0;i--)
			{
				b=this.getBlockAsChildAt(i);
				if(b!=null) b.deleteSelf();
				this.removeChild(b);
			}
		}
		
		public function setBlock(x:int,y:int,block:BlockCommon,overwrite:Boolean=true):void
		{
			if(block==null) return;
			var iBlock:BlockCommon=this.getBlock(x,y);
			if(overwrite||!block.displayEquals(iBlock)) this.removeBlock(x,y);
			block.x=PosTransform.localPosToRealPos(x);
			block.y=PosTransform.localPosToRealPos(y);
			this.addChild(block);
		}
		
		//============Instance Functions============//
		private function getBlockAsChildAt(index:int):BlockCommon
		{
			if(index>=this.numChildren) return null;
			return this.getChildAt(index) as BlockCommon;
		}
	}
}