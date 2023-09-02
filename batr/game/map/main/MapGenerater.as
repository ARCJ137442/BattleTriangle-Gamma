package batr.game.map.main {

	import batr.common.*;
	import batr.general.*;

	import batr.game.block.*;
	import batr.game.block.blocks.*;
	import batr.game.map.*;
	import batr.game.map.main.*;

	/**
	 * ...
	 * @author ARCJ137442
	 */
	public class MapGenerater implements IMapGenerater {
		//============Static Variables============//
		private static var generateChaos:Function;

		//============Static Getter and Setter============//

		//============Static Functions============//

		//============Instance Variables============//
		protected var _generateFunc:Function;

		//============Constructor============//
		public function MapGenerater(generateFunc:Function):void {
			this._generateFunc = generateFunc;
		}

		/* INTERFACE batr.game.map.IMapGenerater */
		public function generateTo(map:IMap, clearBefore:Boolean):IMap {
			if (clearBefore)
				map.removeAllBlock();
			// trace("generateNew:generating!",this._generateFunc)
			if (this._generateFunc != null)
				return this._generateFunc(map);
			return map;
		}
	}
}