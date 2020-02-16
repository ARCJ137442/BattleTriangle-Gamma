package batr.general 
{
	/**
	 * All ChildClass:BlockType,EntityType,EffectType,WeaponType,BonusType
	 */
	public class TypeCommon extends Object
	{
		//============Static Variables============//
		
		//============Static Getter And Setter============//
		
		//============Static Functions============//
		public static function isIncludeIn(type:TypeCommon,types:Vector.<TypeCommon>):Boolean
		{
			for each(var type2:TypeCommon in types)
			{
				if(type===type2) return true;
			}
			return false;
		}
		
		//============Instance Variables============//
		protected var _name:String;
		
		//============Constructor Function============//
		public function TypeCommon(name:String)
		{
			super();
			this._name=name;
		}
		
		//============Instance Getter And Setter============//
		public function get name():String
		{
			return this._name;
		}
		
		public function get label():String
		{
			return "common";
		}
	}
}