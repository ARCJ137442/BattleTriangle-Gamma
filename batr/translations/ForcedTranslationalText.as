package batr.translations 
{
	import batr.game.entity.entities.players.Player;
	import batr.game.stat.PlayerStats;
	
	/**
	 * ...
	 * @author ARCJ137442
	 */
	public class ForcedTranslationalText extends TranslationalText 
	{
		//============Static Getter And Setter============//
		public static function getTextsByPlayerNames(players:Vector.<PlayerStats>):Vector.<TranslationalText>
		{
			var result:Vector.<TranslationalText>=new Vector.<TranslationalText>;
			for(var i:uint=0;i<players.length;i++)
			{
				result.push(
					new ForcedTranslationalText(
						null,null,players[i].profile.customName
					)
				);
			}
			return result;
		}
		
		//============Instance Variables============//
		protected var _forcedText:String;
		
		//============Constructor Function============//
		public function ForcedTranslationalText(translations:Translations,key:String=null,forcedText:String=null) 
		{
			super(translations,key);
			this._forcedText=forcedText;
		}
		
		override public function clone():TranslationalText
		{
			return new ForcedTranslationalText(this._translations,this._key,this._forcedText);
		}
		
		//============Destructor Function============//
		override public function deleteSelf():void
		{
			this._forcedText=null;
			super.deleteSelf();
		}
		
		//============Instance Getter And Setter============//
		public function get forcedText():String
		{
			return this._forcedText;
		}
		
		public function set forcedText(value:String):void
		{
			this._forcedText=value;
		}
		
		public override function get currentText():String
		{
			if(this._forcedText!=null) return this._forcedText;
			return super.currentText;
		}
		
		public function removeForce():TranslationalText
		{
			this._forcedText=null;
			return this;
		}
		
		public function setForce(value:String):TranslationalText
		{
			this._forcedText=null;
			return this;
		}
	}
}