package batr.common 
{
	public final class exMath
	{
		//==============Static Variables==============//
		private static var PrimeList:Vector.<uint>=new <uint>[2]
		
		//==============Static Functions==============//
		//==Special Function==//
		public static function $(x:Number):Number
		{
			return x>0?x:1/(-x)
		}
		
		public static function $i(x:Number,y:Number=NaN):Number
		{
			if(isNaN(y)) y=x<1?-1:1
			return y<0?-1/(x):x
		}
		
		/**
		 * A Function in Natrual Number.
		 * even(0,2,4,6,...)->0
		 * odd:
		 * >num[%4=1](1,5,9,...)->1
		 * >num[%4=3](3,7,11...)->-1
		 * Total list:[0,1,0,-1,0,1,0,-1,0,1,0,-1...]
		 * ASpecial Property: χ(x)*χ(y)=χ(x*y)
		 * @return	χ(x∈N)
		 */
		public static function chi(x:uint):int
		{
			return -(x&1)*((x&3)-2);
		}
		
		//==Int Function==//
		/**
		 * lash the number,keep the phase in Section[0,max);
		 * @param	n
		 * @param	max
		 * @return	the lashed number
		 */
		public static function lockNum(n:Number,max:Number):Number
		{
			if(n<0) return lockNum(n+max,max);
			if(n>=max) return lockNum(n-max,max);
			return n;
		}
		
		/**
		 * lash the intager,keep the phase in Section[0,max);
		 * @param	n
		 * @param	max
		 * @return	the lashed number
		 */
		public static function lockInt(n:int,max:int):int
		{
			if(n<0) return lockInt(n+max,max);
			if(n>=max) return lockInt(n-max,max);
			return n;
		}
		
		public static function intAbs(n:int):uint
		{
			return uint(n>=0?n:-n);
		}
		
		public static function intMax(a:int,b:int):int
		{
			return a>b?a:b;
		}
		
		public static function intMin(a:int,b:int):int
		{
			return a<b?a:b;
		}
		
		public static function mod(num:Number,modNum:Number):Number
		{
			return (num/modNum-Math.floor(num/modNum))*modNum
		}
		
		public static function redirectNum(num:Number,directNum:Number):Number
		{
			return Math.round(num*directNum)/directNum
		}
		
		//==Random About==//
		public static function randomFloat(x:Number):Number
		{
			return Math.random()*x;
		}
		
		/**
		 * @param	x	int.
		 * @return	uint
		 */
		public static function random(x:int):uint
		{
			return uint(randomFloat(x));
		}
		
		public static function random1():int
		{
			return Math.random()<0.5?-1:1;
		}
		
		public static function randomBetween(x:Number,y:Number):Number
		{
			var h:Number=Math.max(x,y);
			var l:Number=Math.min(x,y);
			return l+random(h-l);
		}
		
		public static function randomIntBetween(x:int,y:int):uint
		{
			var h:int=exMath.intMax(x,y);
			var l:int=exMath.intMin(x,y);
			return l+Math.random()*(h-l);
		}
		
		public static function NumTo1(x:Number):int
		{
			return x==0?0:(x>0?1:-1)
		}
		
		public static function isBetween(x:Number,n1:Number,n2:Number,
										 WithL:Boolean=false,
										 WithM:Boolean=false):Boolean
		{
			var m:Number=Math.max(n1,n2)
			var l:Number=Math.min(n1,n2)
			if(WithL&&WithM)
			{
				return x>=l&&x<=m
			}
			else if(WithL)
			{
				return x>=l&&x<m
			}
			else if(WithM)
			{
				return x>l&&x<=m
			}
			return x>l&&x<m
		}

		public static function randomByWeight(Weights:Array):uint
		{
			//Return Number Include 0
			if(Weights.length>=1)
			{
				var All=0;
				var i;
				for(i in Weights)
				{
					if(!isNaN(Number(Weights[i])))
					{
						All+=Number(Weights[i]);
					}
				}
				if(Weights.length==1)
				{
					return 0;
				}
				else
				{
					var R=Math.random()*All;
					for(i=0;i<Weights.length;i++)
					{
						var N=Number(Weights[i]);
						var rs=0;
						for(var l=0;l<i;l++)
						{
							rs+=Number(Weights[l]);
						}
						//trace(R+"|"+(rs+N)+">R>="+rs+","+(i+1))
						if(R>=rs&&R<rs+N)
						{
							return i;
						}
					}
				}
			}
			return random(Weights.length);
		}
		
		public static function randomByWeight2(...Weights):uint
		{
			return randomByWeight(Weights)
		}

		public static function randomByWeightV(Weights:Vector.<Number>):uint
		{
			if(Weights.length>=1)
			{
				var All=0;
				var i;
				for(i in Weights)
				{
					All+=Weights[i];
				}
				if(Weights.length==1)
				{
					return 0;
				}
				else
				{
					var R=Math.random()*All;
					for(i=0;i<Weights.length;i++)
					{
						var N=Weights[i];
						var rs=0;
						for(var l=0;l<i;l++)
						{
							rs+=Weights[l];
						}
						//trace(R+"|"+(rs+N)+">R>="+rs+","+(i+1))
						if(R>=rs&&R<rs+N)
						{
							return i;
						}
					}
				}
			}
			return random(Weights.length)+1;
		}

		public static function angleToArc(value:Number):Number
		{
			return value*Math.PI/180
		}

		public static function arcToAngle(value:Number):Number
		{
			return value/Math.PI*180
		}

		public static function getSum(A:Array):Number
		{
			var sum:Number=0;
			for each(var i in A)
			{
				if(i is Number&&!isNaN(i))
				{
					sum+=i;
				}
			}
			return sum;
		}

		public static function getSum2(V:Vector.<Number>):Number
		{
			var sum:Number=0;
			for each(var i:Number in V)
			{
				if(!isNaN(i))
				{
					sum+=i;
				}
			}
			return sum;
		}

		public static function getSum3(...numbers):Number
		{
			var sum:Number=0;
			for each(var i in numbers)
			{
				if(i is Number&&!isNaN(i))
				{
					sum+=i;
				}
			}
			return sum;
		}

		public static function getAverage(A:Array):Number
		{
			var sum:Number=0;
			var count:uint=0;
			for each(var i in A)
			{
				if(i is Number&&!isNaN(i))
				{
					sum+=i;
					count++
				}
			}
			return sum/count;
		}

		public static function getAverage2(V:Vector.<Number>):Number
		{
			var sum:Number=0;
			var count:uint=0;
			for each(var i:Number in V)
			{
				if(!isNaN(i))
				{
					sum+=i;
					count++
				}
			}
			return sum/count;
		}

		public static function getAverage3(...numbers):Number
		{
			var sum:Number=0;
			var count:uint=0;
			for each(var i in numbers)
			{
				if(i is Number&&!isNaN(i))
				{
					sum+=i;
					count++
				}
			}
			return sum/count;
		}
		
		public static function removeEmptyInArray(A:Array):void
		{
			for(var i:uint=Math.max(A.length-1,0);i>=0;i--)
			{
				if(A[i]==null||
				   isNaN(A[i]))
				{
					A.splice(i,1)
				}
			}
		}
		
		public static function removeEmptyInNumberVector(V:Vector.<Number>):void
		{
			for(var i:uint=Math.max(V.length-1,0);i>=0;i--)
			{
				if(isNaN(V[i]))
				{
					V.splice(i,1)
				}
			}
		}
		
		public static function removeEmptyIn(...List):void
		{
			for each(var i in List)
			{
				if(i is Array)
				{
					removeEmptyInArray(i)
				}
				if(i is Vector.<Number>)
				{
					removeEmptyInNumberVector(i)
				}
			}
		}
		
		public static function getDistance(x1:Number,y1:Number,
										   x2:Number,y2:Number):Number
		{
			return getDistance2(x1-x2,y1-y2)
		}
		
		public static function getDistance2(x:Number,y:Number):Number
		{
			return Math.sqrt(x*x+y*y)
		}
		
		public static function NumberBetween(x:Number,
											 num1:Number=Number.NEGATIVE_INFINITY,
											 num2:Number=Number.POSITIVE_INFINITY):Number
		{
			return Math.min(Math.max(num1,num2),Math.max(Math.min(num1,num2),x))
		}

		//Prime System
		public static function getPrimes(X:Number):Vector.<uint>
		{
			if(X>lastPrime)
			{
				lastPrime=X
				return PrimeList
			}
			else
			{
				for(var i:uint=0;i<PrimeList.length;i++)
				{
					if(PrimeList[i]>X)
					{
						return PrimeList.slice(0,i)
					}
				}
				return new Vector.<uint>()
			}
		}

		public static function getPrimeAt(X:Number):uint
		{
			var Vec:Vector.<uint>=new Vector.<uint>();
			var t;
			for(var i:uint=lastPrime;Vec.length<X;i+=10)
			{
				Vec=getPrimes(i);
			}
			if(Vec.length>=X)
			{
				return Vec[X-1];
			}
			return 2
		}

		public static function isPrime(X:Number):Boolean
		{
			if(Math.abs(X)<2)
			{
				return false;
			}
			if(X>lastPrime)
			{
				lastPrime=X
			}
			return PrimeList.every(function(p:uint,i:uint,v:Vector.<uint>):Boolean
										  {
											  return X%p!=0&&X!=p
										  })
		}
		
		private static function get lastPrime():uint
		{
			return uint(PrimeList[PrimeList.length-1])
		}
		
		private static function set lastPrime(Num:uint):void
		{
			for(var n:uint=lastPrime;n<=Num;n++)
			{
				if(PrimeList.every(function(p:uint,i:uint,v:Vector.<uint>):Boolean
										   {
											   return (n%p!=0&&n!=p)
										   }))
				{
					PrimeList.push(n);
				}
			}
		}
	}

}