package batr.game.map 
{
	import batr.game.block.*;
	
	public interface IMapDisplayer
	{
		function hasBlock(x:int,y:int):Boolean
		function getBlock(x:int,y:int):BlockCommon
		function removeBlock(x:int,y:int):void
		function removeAllBlock():void
		function setBlock(x:int,y:int,block:BlockCommon,overwrite:Boolean=true):void
	}
}