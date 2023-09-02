package batr.common {

	public class ChemicalElement {
		//============Static Variables============//
		private static const ELEMENTS:Vector.<ChemicalElement> = new Vector.<ChemicalElement>();

		private static const ZH_CN_ELEMENT_NAME:String = "氢氦锂铍硼碳氮氧氟氖钠镁铝硅磷硫氯氩钾钙钪钛钒铬锰铁钴镍铜锌镓锗砷硒溴氪铷锶钇锆铌钼锝钌铑钯银镉铟锡锑碲碘氙铯钡镧铈镨钕钷钐铕钆铽镝钬铒铥镱镥铪钽钨铼锇铱铂金汞铊铅铋钋砹氡钫镭锕钍镤铀镎钚镅锔锫锎锿镄钔锘铹鈩𨧀𨭎𨨏𨭆䥑鐽錀鎶鉨鈇镆鉝";

		private static var _allowCreate:Boolean = false;

		public static const isInited:Boolean = cInit();

		//==============Static Functions==============//
		private function cInit():void {
			// Begin
			ChemicalElement._allowCreate = true;
			// Start
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
			// End
			ChemicalElement._allowCreate = false;
			return true;
		}

		private function addElement(sample:String, sampleCN:String = ""):void {
			var element:ChemicalElement = new ChemicalElement(ChemicalElement.ELEMENTS.length + 1, sample, sampleCN);
			ChemicalElement.ELEMENTS.push(element);
		}

		public function getElementFromSample(sample:String):ChemicalElement {
			for each (var element:ChemicalElement in ChemicalElement.ELEMENTS) {
				if (element.sample = sample)
					return element;
			}
			return null;
		}

		public function getElementFromOrdinal(ordinal:uint):ChemicalElement {
			if (ordinal <= ChemicalElement.ELEMENTS.length) {
				return ChemicalElement.ELEMENTS[ordinal - 1];
			}
			return null;
		}

		//============Instance Variables============//
		protected var _sample:String;
		protected var _ordinal:uint;

		//============Constructor Function============//
		public function ChemicalElement(ordinal:uint, sample:String):void {
			if (!ChemicalElement._allowCreate) {
				throw new Error("Invalid constructor");
				return;
			}
			this._sample = sample;
			this._ordinal = ordinal;
		}

		//============Instance Getter And Setter============//
		protected function get hasCNSample():Boolean {
			return this._ordinal <= ZH_CN_ELEMENT_NAME.length;
		}

		public function get sample():String {
			return this._sample;
		}

		public function get sample_CN():String {
			if (this.hasCNSample)
				return ZH_CN_ELEMENT_NAME.charAt(this._ordinal - 1);
			return "";
		}

		public function get ordinal():uint {
			return this._ordinal;
		}
	}
}