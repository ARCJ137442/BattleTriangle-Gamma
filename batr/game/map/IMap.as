package batr.game.map 
{
	import batr.common.*;
	
	import batr.game.block.*;
	
	public interface IMap 
	{
		//============Interface Functions============//
		function get mapWidth():uint
		function get mapHeight():uint
		function get randomX():int
		function get randomY():int
		function get allDefinedPositions():Vector.<iPoint>
		function clone(createBlock:Boolean=false):IMap
		function copyFrom(target:IMap,clearSelf:Boolean=false):void
		function hasBlock(x:int,y:int):Boolean
		function getBlock(x:int,y:int):BlockCommon
		function getBlockAttributes(x:int,y:int):BlockAttributes
		function getBlockType(x:int,y:int):BlockType
		function setBlock(x:int,y:int,block:BlockCommon):void
		function isVoid(x:int,y:int):Boolean
		function setVoid(x:int,y:int):void
		function removeAllBlock(deleteBlock:Boolean=false):void
		//Display About
		function setDisplayTo(target:IMapDisplayer):void
		function setDisplayToLayers(targetBottom:IMapDisplayer,targetMiddle:IMapDisplayer,targetTop:IMapDisplayer):void
		//AI About
		function getMatrixObject():Vector.<Vector.<Object>>
		function getMatrixInt():Vector.<Vector.<int>>
		function getMatrixUint():Vector.<Vector.<uint>>
		function getMatrixNumber():Vector.<Vector.<Number>>
		function getMatrixBoolean():Vector.<Vector.<Boolean>>
	}
}