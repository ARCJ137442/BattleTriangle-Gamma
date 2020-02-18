package batr.common 
{
	public class ChemicalElement 
	{
		//============Static Variables============//
		private static const ELEMENTS:Vector.<ChemicalElement>=new Vector.<ChemicalElement>();
		
		private static var _allowCreate:Boolean=false;
		
		public static const isInited:Boolean=cInit();
		
		//==============Static Functions==============//
		private function cInit():void
		{
			//Begin
			ChemicalElement._allowCreate=true;
			//Start
			addElement("H","氢");
			addElement("He","氦");
			addElement("Li","锂");
			addElement("Be","铍");
			addElement("B","硼");
			addElement("C","碳");
			addElement("N","氮");
			addElement("O","氧");
			addElement("F","氟");
			addElement("Ne","氖");
			addElement("Na","钠");
			addElement("Mg","镁");
			addElement("Al","铝");
			addElement("Si","硅");
			addElement("P","磷");
			addElement("S","硫");
			addElement("Cl","氯");
			addElement("Ar","氩");
			addElement("K","钾");
			addElement("Ca","钙");
			addElement("Sc","钪");
			addElement("Ti","钛");
			addElement("V","钒");
			addElement("Cr","铬");
			addElement("Mn","锰");
			addElement("Fe","铁");
			addElement("Co","钴");
			addElement("Ni","镍");
			addElement("Cu","铜");
			addElement("Zn","锌");
			addElement("Ga","镓");
			addElement("Ge","锗");
			addElement("As","砷");
			addElement("Se","硒");
			addElement("Br","溴");
			addElement("Kr","氪");
			addElement("Rb","铷");
			addElement("Sr","锶");
			addElement("Y","钇");
			addElement("Zr","锆");
			addElement("Nb","铌");
			addElement("Mo","钼");
			addElement("Tc","锝");
			addElement("Ru","钌");
			addElement("Rh","铑");
			addElement("Pd","钯");
			addElement("Ag","银");
			addElement("Cd","镉");
			addElement("In","铟");
			addElement("Sn","锡");
			addElement("Sb","锑");
			addElement("Te","碲");
			addElement("I","碘");
			addElement("Xe","氙");
			addElement("Cs","铯");
			addElement("Ba","钡");
			addElement("La","镧");
			addElement("Ce","铈");
			addElement("Pr","镨");
			addElement("Nd","钕");
			addElement("Pm","钷");
			addElement("Sm","钐");
			addElement("Eu","铕");
			addElement("Gd","钆");
			addElement("Tb","铽");
			addElement("Dy","镝");
			addElement("Ho","钬");
			addElement("Er","铒");
			addElement("Tm","铥");
			addElement("Yb","镱");
			addElement("Lu","镥");
			addElement("Hf","铪");
			addElement("Ta","钽");
			addElement("W","钨");
			addElement("Re","铼");
			addElement("Os","锇");
			addElement("Ir","铱");
			addElement("Pt","铂");
			addElement("Au","金");
			addElement("Hg","汞");
			addElement("Tl","铊");
			addElement("Pb","铅");
			addElement("Bi","铋");
			addElement("Po","钋");
			addElement("At","砹");
			addElement("Rn","氡");
			addElement("Fr","钫");
			addElement("Ra","镭");
			addElement("Ac","锕");
			addElement("Th","钍");
			addElement("Pa","镤");
			addElement("U","铀");
			addElement("Np","镎");
			addElement("Pu","钚");
			addElement("Am","镅");
			addElement("Cm","锔");
			addElement("Bk","锫");
			addElement("Cf","锎");
			addElement("Es","锿");
			addElement("Fm","镄");
			addElement("Md","钔");
			addElement("No","锘");
			addElement("Lr","铹");
			addElement("Rf","鈩");
			addElement("Db","𨧀");
			addElement("Sg","𨭎");
			addElement("Bh","𨨏");
			addElement("Hs","𨭆");
			addElement("Mt","䥑");
			addElement("Ds","鐽");
			addElement("Rg","錀");
			addElement("Cn","鎶");
			addElement("Nh","鉨");
			addElement("Fl","鈇");
			addElement("Mc","镆");
			addElement("Lv","鉝");
			addElement("Ts","");
			addElement("Og","");
			//End
			ChemicalElement._allowCreate=false;
			return true;
		}
		
		private function addElement(name:String,nameCN:String=""):void
		{
			var element:ChemicalElement=new ChemicalElement(ChemicalElement.ELEMENTS.length+1,name,nameCN);
			ChemicalElement.ELEMENTS.push(element);
		}
		
		public function getElementFromName(name:String):ChemicalElement
		{
			for each(var element:ChemicalElement in ChemicalElement.ELEMENTS)
			{
				if(element.name=name) return element;
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
		protected var _name:String;
		protected var _nameCN:String;
		protected var _ordinal:uint;
		
		//============Constructor Function============//
		public function ChemicalElement(ordinal:uint,name:String,nameCN:String=""):void
		{
			if(!ChemicalElement._allowCreate)
			{
				throw new Error("Invalid constructor");
				return;
			}
			this._name=name;
			this._nameCN=nameCN;
			this._ordinal=ordinal;
		}
		
		//============Instance Getter And Setter============//
		public function get name():String
		{
			return this._name;
		}
		
		public function get nameCN():String
		{
			return this._nameCN;
		}
		
		public function get ordinal():uint
		{
			return this._ordinal;
		}
	}
}