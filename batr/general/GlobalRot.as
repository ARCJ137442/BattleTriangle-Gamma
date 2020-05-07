package batr.general 
{
	import batr.common.*;
	
	public class GlobalRot
	{
		//============Static Variables============//
		public static const NULL:uint=uint.MAX_VALUE
		
		public static const UP:uint=3
		public static const DOWN:uint=1
		public static const LEFT:uint=2
		public static const RIGHT:uint=0
		public static const DEFAULT:uint=RIGHT
		
		//============Static Getter ANd Setter============//
		public static function get RANDOM():uint
		{
			return exMath.random(4);
		}
		
		//============Static Functions============//
		public static function isValidRot(rot:uint):Boolean
		{
			return rot!=GlobalRot.NULL;
		}
		
		public static function toOpposite(rot:Number):Number
		{
			return (rot+2)&3;
		}
		
		public static function toOppositeInt(rot:uint):uint
		{
			return (rot+2)&3;
		}
		
		public static function rotate(rot:Number,angle:Number):Number
		{
			//angle is Local Rot.
			return lockToStandard(rot+angle);
		}
		
		public static function rotateInt(rot:uint,angle:int):uint
		{
			//angle is Local Rot.
			return lockIntToStandard(rot+angle);
		}
		
		public static function randomWithout(rot:uint):uint
		{
			return lockIntToStandard(rot+1+exMath.random(3));
		}
		
		public static function lockToStandard(rot:Number):Number
		{
			if(isNaN(rot)||!isFinite(rot)) return DEFAULT;
			if(rot<0) return lockToStandard(rot+4);
			if(rot>=4) return lockToStandard(rot-4);
			return rot;
		}
		
		public static function lockIntToStandard(rot:int):uint
		{
			if(rot<0) return lockIntToStandard(rot+4);
			return rot&3;
		}
		
		/**
		 * The Rot from target-this
		 * @param	xD	Distance X.
		 * @param	yD	Distance Y.
		 * @return
		 */
		public static function fromLinearDistance(xD:int,yD:int):uint
		{
			if((xD*yD)==0)
			{
				if(xD==0)
				{
					if(yD<0) return GlobalRot.UP
					else return GlobalRot.DOWN
				}
				if(yD==0)
				{
					if(xD>0) return GlobalRot.RIGHT
					else return GlobalRot.LEFT
				}
			}
			return GlobalRot.NULL;
		}
		
		public static function fromRealRot(rot:Number):Number
		{
			return lockToStandard(rot/90);
		}
		
		public static function toRealRot(rot:Number):Number
		{
			return rot*90;
		}
		
		public static function toRealIntRot(rot:int):int
		{
			return rot*90;
		}
		
		/** Use for express the currentRot in the containerRot
		 * 	examples:
		 * 	1.a rot out a object is 45°(local:0.5),
		 * 	2.the object's rot is 90°(local:1),
		 * 	3.then the value in of object is 315°(local:3.5).
		 */
		public static function globalToLocal(currentRot:Number,containerRot:Number):Number
		{
			return lockToStandard(currentRot-containerRot)
		}
		
		/** Use for express the currentRot out the containerRot
		 * 	examples:
		 * 	1.A rot in a object is 45°(local:0.5),
		 * 	2.The object's rot is 90°(local:1),
		 * 	3.Then the value out of object is 135°(local:1.5).
		 */
		public static function localToGlobal(currentRot:Number,containerRot:Number):Number
		{
			return lockToStandard(containerRot+currentRot)
		}
		
		public static function towardX(rot:Number,radius:Number=1):Number
		{
			if(rot is uint) return towardIntX(rot,radius);
			return exMath.redirectNum(radius*Math.cos(exMath.angleToArc(toRealRot(rot))),10000);
		}
		
		public static function towardY(rot:Number,radius:Number=1):Number
		{
			if(rot is uint) return towardIntY(rot,radius);
			return exMath.redirectNum(radius*Math.sin(exMath.angleToArc(toRealRot(rot))),10000);
		}
		
		public static function towardIntX(rot:uint,radius:Number=1):Number
		{
			return exMath.chi(rot+1)*radius;
		}
		
		public static function towardIntY(rot:uint,radius:Number=1):Number
		{
			return exMath.chi(rot)*radius;
		}
		
		public static function towardXInt(rot:uint,radius:int=1):int
		{
			return exMath.chi(rot+1)*radius;
		}
		
		public static function towardYInt(rot:uint,radius:int=1):int
		{
			return exMath.chi(rot)*radius;
		}
	}
}