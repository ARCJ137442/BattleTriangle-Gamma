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
		function get spawnPoints():Vector.<uint>
		function get numSpawnPoints():uint
		function get hasSpawnPoint():Boolean
		function get randomSpawnPoint():iPoint
		function get isArenaMap():Boolean
		function get name():String
		function clone(createBlock:Boolean=false):IMap
		function copyContextFrom(target:IMap,clearSelf:Boolean=false):void
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
		function forceDisplayToLayers(targetBottom:IMapDisplayer,targetMiddle:IMapDisplayer,targetTop:IMapDisplayer):void
		function updateDisplayToLayers(x:int,y:int,block:BlockCommon,targetBottom:IMapDisplayer,targetMiddle:IMapDisplayer,targetTop:IMapDisplayer):void
		//SpawnPoint About
		function addSpawnPoint(p:uint):void
		function removeSpawnPoint(p:uint):void
		function clearSpawnPoints():void
		//AI About
		function getMatrixObject():Vector.<Vector.<Object>>
		function getMatrixInt():Vector.<Vector.<int>>
		function getMatrixUint():Vector.<Vector.<uint>>
		function getMatrixNumber():Vector.<Vector.<Number>>
		function getMatrixBoolean():Vector.<Vector.<Boolean>>
	}
}