package batr.common
{
	import flash.utils.getTimer;
	import flash.utils.ByteArray;
	import flash.display.*;

	public final class UsefulTools
	{
		//================Static Variables================//
		
		//================Static Functions================//
		//============Math Methods============//
		public static function NumberToPercent(x:Number,floatCount:uint=0):String
		{
			if(floatCount>0)
			{
				var pow:uint=Math.pow(10,floatCount)
				var returnNum:Number=Math.floor(x*pow*100)/pow
				return returnNum+"%"
			}
			return Math.round(x*100)+"%"
		}
		
		public static function NTP(x:Number,floatCount:uint=0):String
		{
			return NumberToPercent(x,floatCount)
		}
		
		/**
		 * Lock uint[0,uint.MAX_VALUE] into Number[0,1].
		 * @param	value	uint.
		 * @return	Number between 0~1.
		 */
		public static function uintToPercent(value:uint):Number
		{
			return value/uint.MAX_VALUE;
		}
		
		/**
		 * The reverse function based function:uintToPercent.
		 * @param	value	Number 0~1.
		 * @return	uint.
		 */
		public static function percentToUint(value:Number):uint
		{
			return uint(value*uint.MAX_VALUE);
		}
		
		//============Display Methods============//
		public static function removeChildIfContains(parent:DisplayObjectContainer,child:DisplayObject):void
		{
			if(child!=null&&parent.contains(child)) parent.removeChild(child)
		}
		
		public static function removeAllChilds(container:DisplayObjectContainer):void
		{
			while(container.numChildren>0)
			{
				container.removeChildAt(0)
			}
		}
		
		//============Boolean Methods============//
		public static function randomBoolean(trueWeight:uint=1,falseWeight:uint=1):Boolean
		{
			return exMath.random(trueWeight+falseWeight)<trueWeight
		}
		
		public static function randomBoolean2(chance:Number=0.5):Boolean
		{
			return (Math.random()<=chance)
		}
		
		public static function binaryToBooleans(bin:uint,length:uint=0):Vector.<Boolean>
		{
			var l:uint=Math.max(bin.toString(2).length,length)
			var V:Vector.<Boolean>=new Vector.<Boolean>(l,true)
			for(var i:uint=0;i<l;i++)
			{
				V[i]=Boolean(bin>>i&1)
			}
			return V
		}
		
		public static function booleansToBinary(...boo):uint
		{
			var args:Vector.<Boolean>=new Vector.<Boolean>
			for (var i:uint=0;i<boo.length;i++)
			{
				if(boo[i] is Boolean) args[i]=boo[i]
			}
			return booleansToBinary2(args);
		}
		
		public static function booleansToBinary2(boo:Vector.<Boolean>):uint
		{
			var l:uint=boo.length
			var uin:uint=0
			for (var i:int=l-1;i>=0;i--)
			{
				uin|=uint(boo[i])<<i
			}
			return uin;
		}
		
		//============String Methods============//
		public static function hasSpellInString(spell:String,string:String):Boolean
		{
			return (string.toLowerCase().indexOf(spell)>=0)
		}

		public static function startswith(string:String,start:String):Boolean
		{
			return (string.indexOf(start)==0)
		}

		//============Code Methods============//
		public static function returnRandom(...Paras):*
		{
			return Paras[exMath.random(Paras.length)]
		}
		
		public static function returnRandom2(Paras:*):*
		{
			if(Paras is Array||Paras is Vector)
			{
				return Paras[exMath.random(Paras.length)]
			}
			else
			{
				return returnRandom3(Paras)
			}
		}
		
		public static function returnRandom3(Paras:*):*
		{
			var Arr:Array=new Array
			for each(var tempVar:* in Paras)
			{
				Arr.push(tempVar)
			}
			return
		}
		
		public static function getPropertyInObject(arr:Array,pro:String):Array
		{
			var ra:Array=new Array()
			for (var i:uint=0;i<arr.length;i++)
			{
				if(pro in arr[i])
				{
					ra.push(arr[i][pro]);
				}
			}
			return ra;
		}
		
		public static function copyObject(object:Object):Object
		{
			var tempObject:ByteArray=new ByteArray()
			tempObject.writeObject(object)
			tempObject.position=0
			return tempObject.readObject() as Object
		}
		
		public static function IsiA(Input:*,Arr:*):Boolean
		{
			if(Arr is Array||Arr is Vector)
			return (Arr.indexOf(Input)>=0)
			else return (Input in Arr)
		}
		
		public static function SinA(Input:*,Arr:Array,Count:uint=0):uint
		{
			if(isEmptyArray(Arr))
			{
				return 0
			}
			var tempCount:uint=Count
			for (var ts:int=Arr.length-1;ts>=0;ts--)
			{
				if(tempCount>0||Count==0)
				{
					if(Input is Array)
					{
						if(IsiA(Arr[ts],Input))
						{
							Arr.splice(ts,1)
							if(tempCount>0) tempCount--
						}
					}
					else if(Arr[ts]==Input)
					{
						Arr.splice(ts,1)
						if(tempCount>0) tempCount--
					}
				}
				else
				{
					break
				}
			}
			return Count-tempCount
		}

		public static function isEmptyArray(A:Array):Boolean
		{
			return (A==null||A.length<1)
		}

		public static function isEmptyString(S:String):Boolean
		{
			return (S==null||S.length<1)
		}

		public static function isEqualArray(A:Array,B:Array):Boolean
		{
			if(A.length!=B.length)
			{
				return false;
			}
			else
			{
				for (var i=0;i<A.length;i++)
				{
					if(A[i]!=B[i]&&A[i]!=null&&B[i]!=null)
					{
						return false;
					}
				}
				return true;
			}
		}
		
		public static function isEqualObject(A:Object,B:Object,
											 IgnoreUnique:Boolean=false,
											 IgnoreVariable:Boolean=false,
											 DontDetectB:Boolean=false):Boolean
		{
			for(var i in A)
			{
				var fa:*=A[i]
				if(B.hasOwnProperty(i)||IgnoreUnique)
				{
					var fb:*=B[i]
					if(!IgnoreVariable)
					{
						if(isPrimitive(fa)==isComplex(fb))
						{
							return false
						}
						else if(isPrimitive(fa))
						{
							if(fa!=fb)
							{
								return false
							}
						}
						else
						{
							if(!isEqualObject(fa,fb))
							{
								return false
							}
						}
					}
				}
				else
				{
					return false
				}
			}
			if(!DontDetectB)
			{
				if(!isEqualObject(B,A,IgnoreUnique,IgnoreVariable,true))
				{
					return false
				}
			}
			return true
		}
		
		public static function isPrimitive(Variable:*):Boolean
		{
			if(Variable==undefined||
			   Variable is Boolean||
			   Variable is int||
			   Variable is null||
			   Variable is Number||
			   Variable is String||
			   Variable is uint/*||
			   Variable is void*/)
			{
				return true
			}
			return false
		}
		
		public static function isComplex(Variable:*):Boolean
		{
			return !isPrimitive(Variable)
		}
	}
}