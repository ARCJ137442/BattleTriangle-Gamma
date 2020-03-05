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
		/*========AI Criteria========*/
		public static function weaponUseTestWall(owner:Player,host:Game,rot:uint,distance:uint):Boolean
		{
			var vx:int=GlobalRot.towardXInt(rot,1);
			var vy:int=GlobalRot.towardYInt(rot,1);
			var cx:int,cy:int;
			var weapon:WeaponType=owner.weapon;
			for(var i:uint=1;i<distance;i++)
			{
				cx=owner.gridX+vx*i;
				cy=owner.gridY+vy*i;
				if(host.isIntOutOfMap(cx,cy)) continue;
				if(!host.testIntCanPass(
					cx,cy,weapon==WeaponType.MELEE,
					WeaponType.isBulletWeapon(weapon)||weapon==WeaponType.BLOCK_THROWER,
					WeaponType.isLaserWeapon(weapon),
					weaponNotThroughPlayer(weapon),false
					)
				) return false;
			}
			return true;
		}
		
		protected static function weaponNotThroughPlayer(weapon:WeaponType):Boolean
		{
			switch(weapon)
			{
				case WeaponType.BULLET:
				case WeaponType.NUKE:
				case WeaponType.BLOCK_THROWER:
				case WeaponType.MELEE:
				case WeaponType.LIGHTNING:
					return true;
			}
			return false;
		}
		
		protected static function weaponNeedCarryBlock(weapon:WeaponType):Boolean
		{
			return weapon==WeaponType.BLOCK_THROWER;
		}
		
		protected static function detectCarryBlock(player:Player):Boolean
		{
			if(weaponNeedCarryBlock(player.weapon)&&!player.isCarriedBlock) return false;
			return true;
		}
		
		protected static function detectBlockCanCarry(player:Player,blockAtt:BlockAttributes):Boolean
		{
			return !player.isCarriedBlock&&blockAtt.isCarryable&&player.host.testCarryableWithMap(blockAtt,player.host.map);
		}
		
		protected static function initFGH(n:PathNode,host:Game,owner:Player,target:iPoint):PathNode
		{
			//Set Rot in mapDealNode
			n.G=getPathWeight(n,host,owner);
			n.H=n.getManhattanDistance(target)*10//exMath.intAbs((n.x-target.x)*(n.y-target.y))*10;//With Linear distance
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
		public static function getDynamicNode(start:iPoint,target:iPoint,host:Game,owner:AIPlayer,remember:Vector.<Vector.<Boolean>>):PathNode
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
				if(node==null||pointInRemember(node,remember)||
					host.operateFinalPlayerHurtDamage(owner,node.x,node.y,host.getBlockPlayerDamage(node.x,node.y))>=owner.health) continue;
				if(node.F<_leastF)
				{
					_leastNode=node;
					_leastF=node.F;
				}
			}
			return _leastNode;
		}
		
		protected static function pointInRemember(p:iPoint,r:Vector.<Vector.<Boolean>>):Boolean
		{
			if(p==null||r==null||r.length<1) return false;
			return r[p.x][p.y];
		}
		
		protected static function writeRemember(remember:Vector.<Vector.<Boolean>>,x:uint,y:uint,value:Boolean):void
		{
			remember[x][y]=value;
		}
		
		protected static function writeRememberPoint(remember:Vector.<Vector.<Boolean>>,p:iPoint,value:Boolean):void
		{
			remember[p.x][p.y]=value;
		}
		
		protected static function initDynamicNode(n:PathNode,host:Game,owner:AIPlayer,target:iPoint):PathNode
		{
			return initFGH(host.lockIPointInMap(n) as PathNode,host,owner,target);
		}
		
		protected static function getEntityName(target:EntityCommon):String
		{
			if(target==null) return "null";
			if(target is Player) return (target as Player).customName;
			return target.toString();
		}
		
		/**
		 * Trace if DEBUG=true.
		 * @param	owner	the owner.
		 * @param	message	the text without AIPlayer name.
		 */
		protected static function traceLog(owner:Player,message:String):void
		{
			if(DEBUG) trace(owner.customName+":",message);
		}
		
		//============Instance Variables============//
		/**
		 * This matrix contains point where it went.
		 */
		protected var _remember:Vector.<Vector.<Boolean>>;
		
		protected var _closeTarget:Vector.<EntityCommon>;
		
		protected var _lastTarget:EntityCommon;
		
		//AI Judging about
		protected var _pickupWeight:int=exMath.random(50)*exMath.random1();
		
		//============Constructor Function============//
		public function AIProgram_Master():void
		{
			this._lastTarget=null;
			this._closeTarget=new Vector.<EntityCommon>();
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
			return this._closeTarget.indexOf(target)>=0;
		}
		
		protected function addCloseTarget(target:EntityCommon):void
		{
			if(!this.inCloseTarget(target)) this._closeTarget.push(target);
		}
		
		protected function resetCloseTarget():void
		{
			this._closeTarget.splice(0,this._closeTarget.length);
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
				}
				//Change target when wreak
				else if(lastTargetPlayer!=null&&player.health<lastTargetPlayer.health)
				{
					if((this._pickupWeight++)<0) this.resetTarget();
				}
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
						traceLog(player,"trun target to "+getEntityName(this._lastTarget));
					}
					//If all avliable target closed
					else this.resetCloseTarget();
				}
				else
				{
					var tempRot:uint=GlobalRot.fromLinearDistance(this._lastTarget.entityX-player.entityX,this._lastTarget.entityY-player.entityY);
					//Attack Enemy
					if(GlobalRot.isValidRot(tempRot)&&
						detectCarryBlock(player)&&
						lastTargetPlayer!=null&&
						weaponUseTestWall(player,host,tempRot,ownerPoint.getManhattanDistance(lastTargetPlayerPoint))&&
						player.canUseWeaponHurtPlayer(lastTargetPlayer,player.weapon))
					{
						//Reset
						this.resetRemember();
						//Trun
						if(player.rot!=tempRot) player.addActionToThread(AIPlayerAction.getTrunActionFromEntityRot(tempRot));
						//Press Use
						if(!player.isPress_Use) return AIPlayerAction.PRESS_KEY_USE;
						traceLog(player,"attack target "+getEntityName(this._lastTarget))
					}
					//Carry Block
					else if(!detectCarryBlock(player)&&
							detectBlockCanCarry(player,host.getBlockAttributes(player.getFrontIntX(),player.getFrontIntY())))
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
							traceLog(player,"finalNode==null,forget target");
						}
						//Find Success
						else
						{
							writeRememberPoint(this._remember,finalNode,true);
							writeRememberPoint(this._remember,ownerPoint,true);
							player.addActionToThread(
								AIPlayerAction.getMoveActionFromEntityRot(
									finalNode.fromRot
								)
							);
							traceLog(player,"findPath("+getEntityName(this._lastTarget)+") success!writeRememberAt:"+finalNode+","+ownerPoint);
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