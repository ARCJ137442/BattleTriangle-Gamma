package batr.game.entity.ai.programs 
{
	import batr.common.*;
	import batr.general.*;
	
	import batr.game.entity.ai.*;
	import batr.game.entity.entities.*;
	import batr.game.entity.entities.players.*;
	
	/**
	 * Running as a State Machine.
	 */
	public class AIProgram_Novice implements IAIProgram 
	{
		//============Static Variables============//
		public static const LABEL:String="Novice";
		public static const LABEL_SHORT:String="N";
		
		//============Static Functions============//
		protected static function getLineEnemyPlayer(owner:AIPlayer):Player
		{
			if(owner==null) return null;
			var mapPlayers:Vector.<Player>=owner.host.getInMapPlayers();
			for each(var player:Player in mapPlayers)
			{
				if(player==owner) continue;
				if(player.gridX==owner.gridX||player.gridY==owner.gridY)
				{
					if(owner.canUseWeaponHurtPlayer(player,owner.weapon)) return player;
				}
			}
			return null;
		}
		
		protected static function getLineBonusBox(owner:AIPlayer):BonusBox
		{
			if(owner==null) return null;
			var boxes:Vector.<BonusBox>=owner.host.allAvaliableBonusBox;
			for each(var box:BonusBox in boxes)
			{
				if(box==null) continue;
				if(box.gridX==owner.gridX||box.gridY==owner.gridY)
				{
					return box;
				}
			}
			return null;
		}
		
		//============Instance Variables============//
		protected var _moveSum:uint
		protected var _moveMaxSum:uint=8
		protected var _tempRot:uint
		
		protected var _waitTime:int=0
		protected var _maxWaitTime:uint=40
		
		//============Constructor Function============//
		public function AIProgram_Novice() 
		{
			
		}
		
		//============Destructor Function============//
		public function deleteSelf():void 
		{
			this._moveSum=0;
			this._moveMaxSum=0;
			this._tempRot=0;
		}
		
		//============Instance Functions============//
		
		/*====INTERFACE batr.Game.AI.IAIPlayerAI====*/
		/*========AI Getter And Setter========*/
		public function get label():String 
		{
			return AIProgram_Novice.LABEL;
		}
		
		public function get labelShort():String 
		{
			return AIProgram_Novice.LABEL_SHORT;
		}
		
		/**
		 * Returns use for AIRunSpeed
		 */
		public function get referenceSpeed():uint
		{
			return 15+exMath.random(5)*5;
		}
		
		/*========AI Program Main========*/
		public function requestActionOnTick(player:AIPlayer):AIPlayerAction
		{
			if(player==null) return AIPlayerAction.NULL
			//Refresh Wait
			if(this._waitTime>=this._maxWaitTime)
			{
				this._waitTime=-this._moveMaxSum;
			}
			var target:Player=AIProgram_Novice.getLineEnemyPlayer(player);
			var lineBonus:BonusBox=AIProgram_Novice.getLineBonusBox(player);
			//Auto Pickup BonusBox
			if(lineBonus!=null&&this._waitTime>=0&&this._waitTime<this._maxWaitTime)
			{
				//Trun
				player.clearActionThread();
				this._moveSum=this._moveMaxSum;
				this._tempRot=GlobalRot.fromLinearDistance(lineBonus.entityX-player.gridX,lineBonus.entityY-player.gridY);
				//Act
				if(player.rot!=this._tempRot)
				{
					player.addActionToThreadAtFirst(AIPlayerAction.getTrunActionFromEntityRot(this._tempRot));
				}
				player.addActionToThreadAtFirst(AIPlayerAction.MOVE_FORWARD);
				this._waitTime++;
				return null;
			}
			//Auto Attack Target
			else if(target!=null&&this._waitTime>=0&&this._waitTime<this._maxWaitTime)
			{
				//Trun
				player.clearActionThread();
				this._moveSum=this._moveMaxSum;
				this._tempRot=GlobalRot.fromLinearDistance(target.entityX-player.entityX,target.entityY-player.entityY);
				//Act
				if(player.rot!=this._tempRot)
				{
					player.addActionToThread(AIPlayerAction.getTrunActionFromEntityRot(this._tempRot));
				}
				if(!player.isPress_Use) return AIPlayerAction.PRESS_KEY_USE;
				this._waitTime++;
				return AIPlayerAction.NULL
			}
			//Dummy Behavior(Calm)
			else
			{
				if(player.isPress_Use) return AIPlayerAction.RELEASE_KEY_USE;
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
					return AIPlayerAction.getTrunActionFromEntityRot(this._tempRot)
				}
				this._moveSum++
			}
			if(this._waitTime<0) this._waitTime++;
			return AIPlayerAction.MOVE_FORWARD
		}
		
		public function requestActionOnCauseDamage(player:AIPlayer,damage:uint,victim:Player):AIPlayerAction
		{
			this._waitTime=0;
			return AIPlayerAction.NULL
		}
		
		public function requestActionOnHurt(player:AIPlayer,damage:uint,attacker:Player):AIPlayerAction
		{
			this._waitTime-=damage;
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
			this._waitTime=0;
			return AIPlayerAction.NULL
		}
	}
}