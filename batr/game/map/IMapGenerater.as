package batr.game.map {

	import batr.game.block.*;

	public interface IMapGenerater {
		function generateTo(map:IMap, clearBefore:Boolean):IMap;
	}
}