package batr.general 
{
	public class PosTransform 
	{
		//============Static Variables============//
		
		//============Static Functions============//
		public static function alignToBlock(p:Number):Number
		{
			return p-0.5
		}
		
		public static function alignToEntity(p:Number):Number
		{
			return p+0.5
		}
		
		public static function alignToGrid(p:Number):Number
		{
			return p<0?-1:0+Math.floor(p)
		}
		
		public static function localPosToRealPos(p:Number):Number
		{
			return p*GlobalGameVariables.DEFAULT_SIZE
		}
		
		public static function realPosToLocalPos(p:Number):Number
		{
			return p/GlobalGameVariables.DEFAULT_SIZE
		}
	}
}