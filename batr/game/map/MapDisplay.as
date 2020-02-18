package batr.game.map 
{
	import batr.general.*;
	
	import batr.game.block.*;
	import batr.game.map.*;
	
	import flash.display.Sprite;
	
	public class MapDisplay extends Sprite implements IMapDisplayer
	{
		//============Constructor Function============//
		public function MapDisplay()
		{
			super();
		}
		
		//============Destructor Function============//
		public function deleteSelf():void
		{
			this.removeAllBlock();
		}
		
		//============Instance Functions============//
		public function hasBlock(x:int,y:int):Boolean
		{
			var b:BlockCommon;
			for(var i:int=0;i<this.numChildren;i++)
			{
				b=this.getChildAt(i) as BlockCommon;
				if(b==null) continue;
				if(b.x/GlobalGameVariables.DEFAULT_SIZE==x&&
				   b.y/GlobalGameVariables.DEFAULT_SIZE==y)
				{
					return true;
				}
			}
			return false;
		}
		
		public function getBlock(x:int,y:int):BlockCommon
		{
			var b:BlockCommon;
			for(var i:int=0;i<this.numChildren;i++)
			{
				b=this.getChildAt(i) as BlockCommon;
				if(b==null) continue;
				if(b.x/GlobalGameVariables.DEFAULT_SIZE==x&&
				   b.y/GlobalGameVariables.DEFAULT_SIZE==y)
				{
					return b;
				}
			}
			return null;
		}
		
		public function removeBlock(x:int,y:int):void
		{
			var b:BlockCommon;
			for(var i:int=0;i<this.numChildren;i++)
			{
				b=this.getChildAt(i) as BlockCommon;
				if(b==null) continue;
				if(b.x/GlobalGameVariables.DEFAULT_SIZE==x&&
				   b.y/GlobalGameVariables.DEFAULT_SIZE==y)
				{
					this.removeChildAt(i);
				}
			}
		}
		
		public function removeAllBlock():void
		{
			for(var i:int=this.numChildren-1;i>=0;i--)
			{
				this.removeChildAt(i);
			}
		}
		
		public function setBlock(x:int,y:int,block:BlockCommon,overwrite:Boolean=true):void
		{
			if(overwrite) this.removeBlock(x,y);
			if(block==null) return;
			block.x=PosTransform.localPosToRealPos(x);
			block.y=PosTransform.localPosToRealPos(y);
			this.addChild(block);
		}
	}
}