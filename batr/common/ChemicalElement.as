package batr.common 
{
	public class ChemicalElement 
	{
		//============Static Variables============//
		private static const ELEMENTS:Vector.<ChemicalElement>=new Vector.<ChemicalElement>();
		
		private static const ZH_CN_ELEMENT_NAME:String="\u6c22\u6c26\u9502\u94cd\u787c\u78b3\u6c2e\u6c27\u6c1f\u6c16\u94a0\u9541\u94dd\u7845\u78f7\u786b\u6c2f\u6c29\u94be\u9499\u94aa\u949b\u9492\u94ec\u9530\u94c1\u94b4\u954d\u94dc\u950c\u9553\u9517\u7837\u7852\u6eb4\u6c2a\u94f7\u9536\u9487\u9506\u94cc\u94bc\u951d\u948c\u94d1\u94af\u94f6\u9549\u94df\u9521\u9511\u78b2\u7898\u6c19\u94ef\u94a1\u9567\u94c8\u9568\u9495\u94b7\u9490\u94d5\u9486\u94fd\u955d\u94ac\u94d2\u94e5\u9571\u9565\u94ea\u94bd\u94a8\u94fc\u9507\u94f1\u94c2\u91d1\u6c5e\u94ca\u94c5\u94cb\u948b\u7839\u6c21\u94ab\u956d\u9515\u948d\u9564\u94c0\u954e\u949a\u9545\u9514\u952b\u950e\u953f\u9544\u9494\u9518\u94f9\u9229\ud862\uddc0\ud862\udf4e\ud862\ude0f\ud862\udf46\u4951\u943d\u9300\u93b6\u9268\u9207\u9546\u925d"
		
		private static var _allowCreate:Boolean=false;
		
		public static const isInited:Boolean=cInit();
		
		//==============Static Functions==============//
		private function cInit():void
		{
			//Begin
			ChemicalElement._allowCreate=true;
			//Start
			addElement("H");
			addElement("He");
			addElement("Li");
			addElement("Be");
			addElement("B");
			addElement("C");
			addElement("N");
			addElement("O");
			addElement("F");
			addElement("Ne");
			addElement("Na");
			addElement("Mg");
			addElement("Al");
			addElement("Si");
			addElement("P");
			addElement("S");
			addElement("Cl");
			addElement("Ar");
			addElement("K");
			addElement("Ca");
			addElement("Sc");
			addElement("Ti");
			addElement("V");
			addElement("Cr");
			addElement("Mn");
			addElement("Fe");
			addElement("Co");
			addElement("Ni");
			addElement("Cu");
			addElement("Zn");
			addElement("Ga");
			addElement("Ge");
			addElement("As");
			addElement("Se");
			addElement("Br");
			addElement("Kr");
			addElement("Rb");
			addElement("Sr");
			addElement("Y");
			addElement("Zr");
			addElement("Nb");
			addElement("Mo");
			addElement("Tc");
			addElement("Ru");
			addElement("Rh");
			addElement("Pd");
			addElement("Ag");
			addElement("Cd");
			addElement("In");
			addElement("Sn");
			addElement("Sb");
			addElement("Te");
			addElement("I");
			addElement("Xe");
			addElement("Cs");
			addElement("Ba");
			addElement("La");
			addElement("Ce");
			addElement("Pr");
			addElement("Nd");
			addElement("Pm");
			addElement("Sm");
			addElement("Eu");
			addElement("Gd");
			addElement("Tb");
			addElement("Dy");
			addElement("Ho");
			addElement("Er");
			addElement("Tm");
			addElement("Yb");
			addElement("Lu");
			addElement("Hf");
			addElement("Ta");
			addElement("W");
			addElement("Re");
			addElement("Os");
			addElement("Ir");
			addElement("Pt");
			addElement("Au");
			addElement("Hg");
			addElement("Tl");
			addElement("Pb");
			addElement("Bi");
			addElement("Po");
			addElement("At");
			addElement("Rn");
			addElement("Fr");
			addElement("Ra");
			addElement("Ac");
			addElement("Th");
			addElement("Pa");
			addElement("U");
			addElement("Np");
			addElement("Pu");
			addElement("Am");
			addElement("Cm");
			addElement("Bk");
			addElement("Cf");
			addElement("Es");
			addElement("Fm");
			addElement("Md");
			addElement("No");
			addElement("Lr");
			addElement("Rf");
			addElement("Db");
			addElement("Sg");
			addElement("Bh");
			addElement("Hs");
			addElement("Mt");
			addElement("Ds");
			addElement("Rg");
			addElement("Cn");
			addElement("Nh");
			addElement("Fl");
			addElement("Mc");
			addElement("Lv");
			addElement("Ts");
			addElement("Og");
			//End
			ChemicalElement._allowCreate=false;
			return true;
		}
		
		private function addElement(sample:String,sampleCN:String=""):void
		{
			var element:ChemicalElement=new ChemicalElement(ChemicalElement.ELEMENTS.length+1,sample,sampleCN);
			ChemicalElement.ELEMENTS.push(element);
		}
		
		public function getElementFromSample(sample:String):ChemicalElement
		{
			for each(var element:ChemicalElement in ChemicalElement.ELEMENTS)
			{
				if(element.sample=sample) return element;
			}
			return null;
		}
		
		public function getElementFromOrdinal(ordinal:uint):ChemicalElement
		{
			if(ordinal<=ChemicalElement.ELEMENTS.length)
			{
				return ChemicalElement.ELEMENTS[ordinal-1]
			}
			return null;
		}
		
		//============Instance Variables============//
		protected var _sample:String;
		protected var _ordinal:uint;
		
		//============Constructor Function============//
		public function ChemicalElement(ordinal:uint,sample:String):void
		{
			if(!ChemicalElement._allowCreate)
			{
				throw new Error("Invalid constructor");
				return;
			}
			this._sample=sample;
			this._ordinal=ordinal;
		}
		
		//============Instance Getter And Setter============//
		protected function get hasCNSample():Boolean
		{
			return this._ordinal<=ZH_CN_ELEMENT_NAME.length;
		}
		
		public function get sample():String
		{
			return this._sample;
		}
		
		public function get sample_CN():String
		{
			if(this.hasCNSample) return ZH_CN_ELEMENT_NAME.charAt(this._ordinal-1);
			return "";
		}
		
		public function get ordinal():uint
		{
			return this._ordinal;
		}
	}
}