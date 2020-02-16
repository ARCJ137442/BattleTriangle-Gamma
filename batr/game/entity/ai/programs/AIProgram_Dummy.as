package batr.game.entity.ai.programs 
{
	import batr.common.*;
	import batr.general.*;
	import batr.game.entity.ai.*;
	import batr.game.entity.entities.*;
	import batr.game.entity.entities.players.*;
	
	/**
	 * Random move and Always Press Use.
	 */
	public class AIProgram_Dummy implements IAIProgram
	{
		//============Static Variables============//
		public static const LABEL:String="Dummy";
		public static const LABEL_SHORT:String="D";
		
		//============Instance Variables============//
		protected var _moveSum:uint
		protected var _moveMaxSum:uint=4+exMath.random(16)
		protected var _tempRot:uint
		
		//============Constructor Function============//
		public function AIProgram_Dummy():void
		{
			
		}
		
		//============Destructor Function============//
		public function deleteSelf():void
		{
			this._moveSum=0;
			this._moveMaxSum=0;
			this._tempRot=0;
		}
		
		/*====INTERFACE batr.Game.AI.IAIPlayerAI====*/
		/*========AI Getter And Setter========*/
		public function get label():String
		{
			return AIProgram_Dummy.LABEL;
		}
		
		public function get labelShort():String 
		{
			return AIProgram_Dummy.LABEL_SHORT;
		}
		
		public function get referenceSpeed():uint
		{
			return 12+Math.pow(exMath.random(5),2);
		}
		
		/*========AI Program Main========*/
		public function requestActionOnTick(player:AIPlayer):AIPlayerAction
		{
			if(player==null) return AIPlayerAction.NULL
			if(!player.isPress_Use) return AIPlayerAction.PRESS_KEY_USE
			if(this._moveSum>=this._moveMaxSum||
			   !player.host.testPlayerFrontCanPass(player))
			{
				this._moveSum=0
				var i:uint=0
				do
				{
					this._tempRot=GlobalRot.RANDOM
					i++
				}
				while(i<=8&&!player.host.testPlayerFrontCanPass(player,this._tempRot,true))
				player.addActionToThread(AIPlayerAction.DISABLE_CHARGE)
				return AIPlayerAction.getTrunActionFromEntityRot(this._tempRot)
			}
			this._moveSum++
			return AIPlayerAction.MOVE_FORWARD
			return AIPlayerAction.NULL
		}
		
		public function requestActionOnCauseDamage(player:AIPlayer,damage:uint,victim:Player):AIPlayerAction
		{
			return AIPlayerAction.NULL
		}
		
		public function requestActionOnHurt(player:AIPlayer,damage:uint,attacker:Player):AIPlayerAction
		{
			return AIPlayerAction.NULL
		}
		
		public function requestActionOnKill(player:AIPlayer,damage:uint,victim:Player):AIPlayerAction
		{
			return AIPlayerAction.NULL
		}
		
		public function requestActionOnDeath(player:AIPlayer,damage:uint,attacker:Player):AIPlayerAction
		{
			return AIPlayerAction.NULL
		}
		
		public function requestActionOnRespawn(player:AIPlayer):AIPlayerAction
		{
			return AIPlayerAction.NULL
		}
		
		public function requestActionOnMapTransfrom(player:AIPlayer):AIPlayerAction
		{
			return AIPlayerAction.NULL
		}
		
		public function requestActionOnPickupBonusBox(player:AIPlayer,box:BonusBox):AIPlayerAction
		{
			return AIPlayerAction.NULL
		}
	}
}