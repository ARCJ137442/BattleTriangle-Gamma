//============Package============//
package batr.common {

	/* The common class calls <CustomRadixNumber>
	 * The Number-System can use for define some Custom-Radix-Mechanism
	 * The static class implements The Custom Radix Conversion of Unsigned-Integer(uint)
	 * The class can be create by operator new,likes [var a:CustomRadixNumber=new CustomRadixNumber()],but that also can be register at class
	 * The Custom-Number is express as String
	 * An example:The Radix-36 Number "a0" can be conver to uint(0*36^0+10*36^1)=360
	 * */

	//============Import Something============//

	//============Class Start============//
	public class CustomRadixNumber extends Object {
		//============Static Variables============//
		public static const CHAR_SET_ERROR_MESSAGE:String = "CharSet Error!";
		public static const DEFAULT_CHAR_SET:String = "0123456789";
		public static const DEFAULT_DOT_CHAR:String = ".";
		public static const DEFAULT_OPERATION_PRECISION:uint = 0x10;

		protected static var _instances:Vector.<CustomRadixNumber> = new Vector.<CustomRadixNumber>();

		//============Static Getter And Setter============//
		public static function get instanceCount():uint {
			return CustomRadixNumber._instances.length;
		}

		public static function get alInstances():Vector.<CustomRadixNumber> {
			return CustomRadixNumber._instances.concat();
		}

		//============Static Functions============//
		// Instance
		protected static function registerInstance(instance:CustomRadixNumber):void {
			CustomRadixNumber._instances.push(instance);
		}

		public static function registerMechanism(charSet:String, key:* = null):void {
			registerInstance(new CustomRadixNumber(charSet, key));
		}

		public static function getInstanceByKey(key:*, fromIndex:uint = 0, strictEqual:Boolean = false):CustomRadixNumber {
			for each (var instance:CustomRadixNumber in CustomRadixNumber._instances) {
				if (instance._key === key || !strictEqual && instance._key == key) {
					if (CustomRadixNumber._instances.indexOf(instance) >= fromIndex) {
						return instance;
					}
				}
			}
			return null;
		}

		// Tools
		protected static function isEmptyString(string:String):Boolean {
			return (string == null || string.length < 1);
		}

		protected static function dealCharSet(charSet:String):String {
			// Test
			if (charSet == null || charSet.length < 1)
				return "";
			// Set
			var returnCharSet:String = charSet;
			var char:String;
			var otherIndex:int;
			// Operation
			for (var i:uint = 0; i < charSet.length; i++) {
				char = charSet.charAt(i);
				otherIndex = charSet.indexOf(char, i + 1);
				if (otherIndex >= 0) {
					returnCharSet = returnCharSet.slice(0, i) + returnCharSet.slice(i + 1);
				}
			}
			// Output
			return returnCharSet;
		}

		public static function dealDotChar(dotChar:String):String {
			return dotChar.charAt(0);
		}

		//============Constructor Function============//
		public function CustomRadixNumber(charSet:String = DEFAULT_CHAR_SET, dotChar:String = DEFAULT_DOT_CHAR, key:* = null):void {
			// Test
			if (isEmptyString(charSet)) {
				throw new Error(CustomRadixNumber.CHAR_SET_ERROR_MESSAGE);
				return;
			}
			// Set
			this._charSet = dealCharSet(charSet);
			this._dotChar = dealDotChar(dotChar);
			this._key = key;
			// Register
			CustomRadixNumber.registerInstance(this);
		}

		//============Instance Variables============//
		protected var _charSet:String;
		protected var _dotChar:String;
		protected var _key:*;

		//============Instance Getter And Setter============//
		// Internal

		// Public
		public function get radix():uint {
			if (isEmptyString(this._charSet))
				return 0;
			return this._charSet.length;
		}

		public function get charSet():String {
			if (isEmptyString(this._charSet))
				return null;
			return this._charSet;
		}

		public function get key():* {
			return this._key;
		}

		//============Instance Functions============//
		/* This's the Main Function of Radix Conversion(unfinished).
		 * Functions:
		 * 	getWeightFromChar(char:String):uint
		 * 	fromNumberInt(number:uint):String
		 * 	toNumberInt(customNumber:String):uint
		 * 	fromNumberFloat(number:Number):String
		 * 	toNumberFloat(customNumber:String):Number
		 * */
		public function getWeightFromChar(char:String):uint {
			var weight:int = this._charSet.indexOf(char);
			return weight >= 0 ? weight : 0;
		}

		public function getCharFromWeight(weight:uint):String {
			var char:String = this._charSet.charAt(weight);
			return char;
		}

		public function fromNumberInt(number:Number):String {
			// Test
			if (number == 0)
				return getCharFromWeight(0);
			// Set
			var returnString:String = "";
			var radix:uint = this.radix;
			var tempNum:Number = Math.floor(number);
			var tempNum2:Number = 0;
			// Operation
			for (var i:uint = 0; i < 0x10000 && tempNum > 0; i++) {
				tempNum2 = tempNum % radix;
				tempNum -= tempNum2;
				tempNum /= radix;
				returnString = getCharFromWeight(tempNum2) + returnString;
			}
			// Output
			return returnString;
		}

		public function toNumberInt(customNumber:String):Number {
			// Test
			if (isEmptyString(customNumber))
				return 0;
			// Set
			var returnNumber:Number = 0;
			var radix:uint = this.radix;
			var tempNum:Number = 0;
			// Operation
			for (var i:int = customNumber.length - 1; i >= 0; i--) {
				tempNum = getWeightFromChar(customNumber.charAt(i)) * Math.pow(radix, customNumber.length - i - 1);
				returnNumber += tempNum;
			}
			// Output
			return returnNumber;
		}

		public function fromNumberFloat(number:Number, precision:uint = DEFAULT_OPERATION_PRECISION):String {
			// Test
			if (number == 0)
				return getCharFromWeight(0);
			// Set
			var returnString:String = "";
			var radix:uint = this.radix;
			var tempNum:Number = Math.floor(number); // int
			var tempNum2:Number = number - tempNum; // float
			var tempNum3:Number = 0;
			var i:int;
			// Operation
			// int
			returnString += fromNumberInt(tempNum);
			// float
			if (!isNaN(tempNum2) && tempNum2 != 0 && isFinite(tempNum2)) {
				// dot
				returnString += this._dotChar;
				// float
				for (i = 0; i < precision; i++) {
					tempNum3 = Math.floor(tempNum2 * radix);
					tempNum2 = tempNum2 * radix - tempNum3;
					returnString += getCharFromWeight(tempNum3);
				}
				for (i = returnString.length - 1; i >= 0; i--) {
					if (returnString.charAt(i) == getCharFromWeight(0)) {
						returnString = returnString.slice(0, returnString.length - 1);
					}
					else {
						break;
					}
				}
			}
			// Output
			return returnString;
		}

		public function toNumberFloat(customNumber:String):Number {
			// Test
			if (isEmptyString(customNumber))
				return 0;
			// Set
			var returnNumber:Number = 0;
			var radix:uint = this.radix;
			var customNumberParts:Array = customNumber.split(this._dotChar);
			var cNumInt:String = String(customNumberParts[0] == undefined ? "" : customNumberParts[0]);
			var cNumFloat:String = String(customNumberParts[1] == undefined ? "" : customNumberParts[1]);
			var tempNumInt:Number = 0;
			var tempNumFloat:Number = 0;
			var i:int;
			// Operation
			// int
			if (!isEmptyString(cNumInt))
				returnNumber += toNumberInt(cNumInt);
			// float
			if (!isEmptyString(cNumFloat))
				returnNumber += toNumberInt(cNumFloat) / Math.pow(radix, cNumFloat.length);
			// Output
			return returnNumber;
		}
	}
}