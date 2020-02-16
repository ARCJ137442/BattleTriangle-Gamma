package batr.common 
{
	import flash.geom.Point;
	
	/**
	 * The point only contains intager position
	 */
	public class iPoint extends Object
	{
		//============Static Variables============//
		
		//============Static Functions============//
		public static function inventPoint(p:iPoint):iPoint
		{
			return new iPoint(p.y,p.x);
		}
		
		public static function getDistance(p1:iPoint,p2:iPoint):Number
		{
			return Math.sqrt((p1.x-p2.x)*(p2.x-p1.x)+(p1.y-p2.y)*(p2.y-p1.y));
		}
		
		public static function getManhattanDistance(p1:iPoint,p2:iPoint):Number
		{
			return exMath.intAbs(p1.x-p2.x)+exMath.intAbs(p1.y-p2.y);
		}
		
		public static function converToGeomPoint(p:iPoint):flash.geom.Point
		{
			return new flash.geom.Point(p.x,p.y);
		}
		
		public static function copy(p:iPoint):iPoint
		{
			return new iPoint(p.x,p.y)
		}
		
		//Use For AI
		
		/**
		 * R---S
		 * |   |
		 * |   |
		 * |   |
		 * T======
		 * S: Start
		 * T: Target
		 * R: Return
		 */
		public static function getLineTargetPoint(start:iPoint,target:iPoint,defaultReturnX:Boolean=true):iPoint
		{
			var xD:uint=exMath.intAbs(start.x-target.x);
			var yD:uint=exMath.intAbs(start.y-target.y);
			if(xD<yD||xD==yD&&defaultReturnX) return new iPoint(target.x,start.y);
			if(xD>yD) return new iPoint(start.x,target.y);
			return null;
		}
		
		/**
		 * R---S
		 * |   |
		 * |   |
		 * |   |
		 * T======
		 * S: Start
		 * T: Target
		 * R: Return
		 */
		public static function getLineTargetPoint2(sX:int,sY:int,tX:int,tY:int,defaultReturnX:Boolean=true):iPoint
		{
			var xD:uint=exMath.intAbs(sX-tX);
			var yD:uint=exMath.intAbs(sY-tY);
			if(xD<yD||xD==yD&&defaultReturnX) return new iPoint(tX,sY);
			if(xD>yD) return new iPoint(sX,tY);
			return null;
		}
		
		/**
		 * @param	s	start point
		 * @param	t	target point
		 * @return	The Distance.
		 */
		public static function getLineTargetDistance(s:iPoint,t:iPoint):int
		{
			return exMath.intMin(exMath.intAbs(s.x-t.x),exMath.intAbs(s.y-t.y))
		}
		
		/**
		 * @param	sX	start point x.
		 * @param	sY	start point y.
		 * @param	tX	target point x.
		 * @param	tY	target point y.
		 * @return	The Distance.
		 */
		public static function getLineTargetDistance2(sX:int,sY:int,tX:int,tY:int):int
		{
			return exMath.intMin(exMath.intAbs(sX-tX),exMath.intAbs(sY-tY))
		}
		
		//============Instance Variables============//
		public var x:int=0;
		public var y:int=0;
		
		//============Constructor Function============//
		public function iPoint(x:int,y:int):void
		{
			this.x=x;
			this.y=y;
		}
		
		//============Instance Functions============//
		public function toString():String
		{
			return "\u0028\u0078\u003d"+this.x+"\u002c\u0079\u003d"+this.y+"\u0029";
		}
		
		public function invent():iPoint
		{
			x^=y;
			y^=x;
			x^=y;
			return this;
		}
		
		public function clone():iPoint
		{
			return iPoint.copy(this);
		}
		
		public function copyFrom(source:iPoint):void
		{
			this.x=source.x;
			this.y=source.y;
		}
		
		public function getDistance(p:iPoint):Number
		{
			return iPoint.getDistance(this,p);
		}
		
		public function getManhattanDistance(p:iPoint):Number
		{
			return iPoint.getManhattanDistance(this,p);
		}
		
		public function equals(p:iPoint):Boolean
		{
			return this.x==p.x&&this.y==p.y;
		}
		
		public function isInSameLine(p:iPoint):Boolean
		{
			return this.x==p.x||this.y==p.y;
		}
	}
}