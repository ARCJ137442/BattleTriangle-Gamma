package batr.game.entity.ai.programs 
{
	import batr.common.*;
	import batr.general.*;
	
	import batr.game.block.*;
	import batr.game.entity.ai.*;
	import batr.game.model.*;
	import batr.game.entity.*;
	import batr.game.entity.entities.*;
	import batr.game.entity.entities.players.*;
	import batr.game.main.*;
	import batr.game.map.*;
	
	import flash.utils.Dictionary;
	
	/**
	 * Advanced Advancer.
	 */
	public class AIProgram_Master implements IAIProgram 
	{
		//============Static Variables============//
		public static const LABEL:String="Master";
		public static const LABEL_SHORT:String="M";
		
		public static const DEBUG:Boolean=false;
		
		//============Static Functions============//
		protected static function initFGH(n:PathNode,host:Game,owner:Player,target:iPoint):PathNode
		{
			//Set Rot in mapDealNode
			n.G=getPathWeight(n,host,owner);
			n.H=target==null?0:n.getManhattanDistance(target)*10//exMath.intAbs((n.x-target.x)*(n.y-target.y))*10;//With Linear distance
			return n;
		}
		
		/**
		 * Equals The Variable G's coefficient
		 * @param	node	The node.
		 * @param	host	The host as Game.
		 * @param	player	The player.
		 * @return	A int will be multi with G.
		 */
		protected static function getPathWeight(node:PathNode,host:Game,player:Player):int
		{
			var damage:int=host.getBlockPlayerDamage(node.x,node.y);
			if(!host.testPlayerCanPass(player,node.x,node.y,true,false)) return 1000;
			if(damage>0) return damage*100;
			else if(damage<0) return 0;
			return 0;
		}
		
		//========Dynamic A* PathFind========//
		internal static function getDynamicNode(start:iPoint,target:iPoint,host:Game,owner:AIPlayer,remember:Vector.<Vector.<Boolean>>):PathNode
		{
			var nearbyNodes:Vector.<PathNode>=new <PathNode>[
				initDynamicNode(new PathNode(start.x+1,start.y).setFromRot(GlobalRot.RIGHT),host,owner,target),
				initDynamicNode(new PathNode(start.x-1,start.y).setFromRot(GlobalRot.LEFT),host,owner,target),
				initDynamicNode(new PathNode(start.x,start.y+1).setFromRot(GlobalRot.DOWN),host,owner,target),
				initDynamicNode(new PathNode(start.x,start.y-1).setFromRot(GlobalRot.UP),host,owner,target)
			];
			var _leastNode:PathNode=null;
			var _leastF:int=int.MAX_VALUE;
			for each(var node:PathNode in nearbyNodes)
			{
				if(node==null||AIProgram_Adventurer.pointInRemember(node,remember)||
					host.operateFinalPlayerHurtDamage(owner,node.x,node.y,host.getBlockPlayerDamage(node.x,node.y))>=owner.health) continue;
				if(node.F<_leastF)
				{
					_leastNode=node;
					_leastF=node.F;
				}
			}
			return _leastNode;
		}
		
		protected static function initDynamicNode(n:PathNode,host:Game,owner:AIPlayer,target:iPoint):PathNode
		{
			return initFGH(host.lockIPointInMap(n) as PathNode,host,owner,target);
		}
		
		//============Instance Variables============//
		/**
		 * This matrix contains point where it went.
		 */
		protected var _remember:Vector.<Vector.<Boolean>>;
		
		protected var _closeTarget:Dictionary;
		
		protected var _lastTarget:EntityCommon;
		
		//AI Judging about
		protected var _pickupWeight:int=exMath.random(50)*exMath.random1();
		
		//============Constructor Function============//
		public function AIProgram_Master():void
		{
			this._lastTarget=null;
			this._closeTarget=new Dictionary(true);
		}
		
		//============Destructor Function============//
		public function deleteSelf():void
		{
			this._lastTarget=null;
			this._closeTarget=null;
		}
		
		//============Instance Functions============//
		protected function initRemember(host:Game):void
		{
			this._remember=host.map.getMatrixBoolean();
		}
		
		protected function resetRemember():void
		{
			for each(var v:Vector.<Boolean> in this._remember)
			{
				for(var i:String in v)
				{
					v[i]=false;
				}
			}
			//trace("remember resetted!")
		}
		
		protected function changeTarget(owner:AIPlayer,target:EntityCommon):void
		{
			if(this._lastTarget==target) return;
			this._lastTarget=target;
			this.resetRemember();
			if(owner.isPress_Use) owner.addActionToThread(AIPlayerAction.RELEASE_KEY_USE);
		}
		
		protected function resetTarget():void
		{
			this._lastTarget=null;
			this.resetRemember();
		}
		
		protected function inCloseTarget(target:EntityCommon):Boolean
		{
			return Boolean(this._closeTarget[target]);
		}
		
		protected function addCloseTarget(target:EntityCommon):void
		{
			this._closeTarget[target]=true;
		}
		
		protected function resetCloseTarget():void
		{
			for(var i in this._closeTarget)
			{
				delete this._closeTarget[i];
			}
		}
		
		/*========AI Tools========*/
		public function getNearestBonusBox(ownerPoint:iPoint,host:Game):BonusBox
		{
			//getManhattanDistance
			var _nearestBox:BonusBox=null;
			var _nearestDistance:int=int.MAX_VALUE;
			var _tempDistance:int;
			for each(var box:BonusBox in host.entitySystem.bonusBoxes)
			{
				if(box==null||this.inCloseTarget(box)) continue;
				_tempDistance=exMath.intAbs(box.gridX-ownerPoint.x)+exMath.intAbs(box.gridY-ownerPoint.y);
				if(_tempDistance<_nearestDistance)
				{
					_nearestBox=box;
					_nearestDistance=_tempDistance;
				}
			}
			return _nearestBox;
		}
		
		public function getNearestEnemy(owner:Player,host:Game):Player
		{
			//getManhattanDistance
			var _nearestEnemy:Player=null;
			var _nearestDistance:int=int.MAX_VALUE;
			var _tempDistance:int;
			var players:Vector.<Player>=host.getAlivePlayers();
			for each(var player:Player in players)
			{
				if(player==owner||!owner.canUseWeaponHurtPlayer(player,owner.weapon)||
				player==null||this.inCloseTarget(player)) continue;
				_tempDistance=iPoint.getLineTargetDistance2(owner.gridX,owner.gridY,player.gridX,player.gridY);
				if(_tempDistance<_nearestDistance)
				{
					_nearestEnemy=player;
					_nearestDistance=_tempDistance;
				}
			}
			return _nearestEnemy;
		}
		
		/*====INTERFACE batr.Game.AI.IAIPlayerAI====*/
		/*========AI Getter And Setter========*/
		public function get label():String
		{
			return AIProgram_Master.LABEL;
		}
		
		public function get labelShort():String 
		{
			return AIProgram_Master.LABEL_SHORT;
		}
		
		public function get referenceSpeed():uint
		{
			return 20*(1+exMath.random(4));
		}
		
		protected function get pickBonusFirst():Boolean
		{
			return this._pickupWeight<0;
		}
		
		/*========AI Program Main========*/
		public function requestActionOnTick(player:AIPlayer):AIPlayerAction
		{
			if(player==null) return AIPlayerAction.NULL;
			//Set Variables
			var host:Game=player.host;
			var ownerPoint:iPoint=player.gridPoint;
			var lastTargetPlayer:Player=this._lastTarget as Player;
			var lastTargetPlayerPoint:iPoint=lastTargetPlayer==null?null:lastTargetPlayer.gridPoint;
			//Init remember
			if(this._remember==null)
			{
				this.initRemember(host);
			}
			//Act
			if(!player.hasAction)
			{
				//Clear Invalid Target
				if(this._lastTarget!=null&&!this._lastTarget.isActive||
					lastTargetPlayer!=null&&(!player.canUseWeaponHurtPlayer(lastTargetPlayer,player.weapon)||
					lastTargetPlayer!=null&&lastTargetPlayer.isRespawning))
				{
					this.resetTarget();
					AIProgram_Adventurer.traceLog(player,"Clear invalid target!");
				}
				/*//Change target when weak
				else if(lastTargetPlayer!=null&&player.health<lastTargetPlayer.health)
				{
					if((this._pickupWeight++)<0)
					{
						this.addCloseTarget(this._lastTarget);
						AIProgram_Adventurer.traceLog(player,"close target when wreak:"+getEntityName(this._lastTarget));
						this.resetTarget();
					}
				}*/
				//====Dynamic A*====//
				//If No Target,Get New Target
				if(this._lastTarget==null)
				{
					//========Find BonusBox========//
					var target:EntityCommon=null;
					//set Player as Target
					target=this.pickBonusFirst?getNearestBonusBox(ownerPoint,host):getNearestEnemy(player,host);
					//if cannot find box/player
					if(target==null)
					{
						if(!this.pickBonusFirst&&host.entitySystem.bonusBoxCount>0) target=getNearestBonusBox(ownerPoint,host);
						else target=getNearestEnemy(player,host);
					}
					if(target!=null)
					{
						this.changeTarget(player,target);
						AIProgram_Adventurer.traceLog(player,"trun target to "+AIProgram_Adventurer.getEntityName(this._lastTarget));
					}
					//If all avliable target closed
					else this.resetCloseTarget();
				}
				else
				{
					var tempRot:uint=GlobalRot.fromLinearDistance(this._lastTarget.entityX-player.entityX,this._lastTarget.entityY-player.entityY);
					//Attack Enemy
					if(GlobalRot.isValidRot(tempRot)&&
						AIProgram_Adventurer.detectCarryBlock(player)&&
						lastTargetPlayer!=null&&
						AIProgram_Adventurer.weaponUseTestWall(player,host,tempRot,ownerPoint.getManhattanDistance(lastTargetPlayerPoint))&&
						player.canUseWeaponHurtPlayer(lastTargetPlayer,player.weapon))
					{
						//Reset
						this.resetRemember();
						//Trun
						if(player.rot!=tempRot) player.addActionToThread(AIPlayerAction.getTrunActionFromEntityRot(tempRot));
						//Press Use
						if(!player.isPress_Use) return AIPlayerAction.PRESS_KEY_USE;
						AIProgram_Adventurer.traceLog(player,"attack target "+AIProgram_Adventurer.getEntityName(this._lastTarget))
					}
					//Carry Block
					else if(!AIProgram_Adventurer.detectCarryBlock(player)&&
							AIProgram_Adventurer.detectBlockCanCarry(player,host.getBlockAttributes(player.getFrontIntX(),player.getFrontIntY())))
					{
						//Press Use
						player.clearActionThread();
						if(!player.isPress_Use) return AIPlayerAction.PRESS_KEY_USE;
					}
					//Find Path
					else
					{
						//==Release Use==//
						if(player.isPress_Use) return AIPlayerAction.RELEASE_KEY_USE;;
						//==Decision==//
						//Find Path
						var finalNode:PathNode;
						//Attack player
						if(lastTargetPlayer!=null)
						{
							finalNode=getDynamicNode(
								ownerPoint,
								iPoint.getLineTargetPoint2(
									player.gridX,player.gridY,this._lastTarget.gridX,this._lastTarget.gridY,true
								),
								host,
								player,
								this._remember
							);
						}
						else//Default as Bonus
						{
							finalNode=host.lockIPointInMap(
								getDynamicNode(
									ownerPoint,
									this._lastTarget.gridPoint,
									host,player,this._remember
								)
							) as PathNode;
						}
						//==Execute==//
						//Find Failed
						if(finalNode==null)
						{
							this.addCloseTarget(this._lastTarget);
							this.resetTarget();
							AIProgram_Adventurer.traceLog(player,"finalNode==null,forget target");
						}
						//Find Success
						else
						{
							AIProgram_Adventurer.writeRememberPoint(this._remember,finalNode,true);
							AIProgram_Adventurer.writeRememberPoint(this._remember,ownerPoint,true);
							player.addActionToThread(
								AIPlayerAction.getMoveActionFromEntityRot(
									finalNode.fromRot
								)
							);
							AIProgram_Adventurer.traceLog(player,"findPath("+AIProgram_Adventurer.getEntityName(this._lastTarget)+") success!writeRememberAt:"+finalNode+","+ownerPoint);
						}
					}
				}
			}
			return AIPlayerAction.NULL;
		}
		
		public function requestActionOnCauseDamage(player:AIPlayer,damage:uint,victim:Player):AIPlayerAction
		{
			this._pickupWeight+=damage;
			return AIPlayerAction.NULL;
		}
		
		public function requestActionOnHurt(player:AIPlayer,damage:uint,attacker:Player):AIPlayerAction
		{
			if(player.healthPercent<0.5)
			{
				if(this._pickupWeight>0) this._pickupWeight=-this._pickupWeight;
				if(attacker!=null) this.addCloseTarget(attacker);
				this.resetTarget();
			}
			else if(attacker!=null&&attacker!=this._lastTarget&&
				player.canUseWeaponHurtPlayer(attacker,player.weapon))
			{
				this._pickupWeight-=damage;
				this.changeTarget(player,attacker);
			}
			return AIPlayerAction.NULL;
		}
		
		public function requestActionOnKill(player:AIPlayer,damage:uint,victim:Player):AIPlayerAction
		{
			this.resetTarget();
			this.resetCloseTarget();
			return AIPlayerAction.NULL;
		}
		
		public function requestActionOnDeath(player:AIPlayer,damage:uint,attacker:Player):AIPlayerAction
		{
			return AIPlayerAction.NULL;
		}
		
		public function requestActionOnRespawn(player:AIPlayer):AIPlayerAction
		{
			this.resetTarget();
			return AIPlayerAction.NULL;
		}
		
		public function requestActionOnMapTransfrom(player:AIPlayer):AIPlayerAction
		{
			this.resetTarget();
			return AIPlayerAction.NULL;
		}
		
		public function requestActionOnPickupBonusBox(player:AIPlayer,box:BonusBox):AIPlayerAction
		{
			this._pickupWeight-=5;
			return AIPlayerAction.NULL;
		}
	}
}