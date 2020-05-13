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
	 * Moving uses A*(A Star) algorithm.
	 */
	public class AIProgram_Adventurer implements IAIProgram 
	{
		//============Static Variables============//
		public static const LABEL:String="Adventurer";
		public static const LABEL_SHORT:String="A";
		
		public static const DEBUG:Boolean=false;
		
		//============Static Functions============//
		/*========AI Criteria========*/
		internal static function weaponUseTestWall(owner:Player,host:Game,rot:uint,distance:uint):Boolean
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
		
		internal static function weaponNotThroughPlayer(weapon:WeaponType):Boolean
		{
			switch(weapon)
			{
				case WeaponType.BULLET:
				case WeaponType.NUKE:
				case WeaponType.SUB_BOMBER:
				case WeaponType.BLOCK_THROWER:
				case WeaponType.MELEE:
				case WeaponType.LIGHTNING:
					return true;
			}
			return false;
		}
		
		internal static function weaponNeedCarryBlock(weapon:WeaponType):Boolean
		{
			return weapon==WeaponType.BLOCK_THROWER;
		}
		
		internal static function detectCarryBlock(player:Player):Boolean
		{
			if(weaponNeedCarryBlock(player.weapon)&&!player.isCarriedBlock) return false;
			return true;
		}
		
		internal static function detectBlockCanCarry(player:Player,blockAtt:BlockAttributes):Boolean
		{
			return !player.isCarriedBlock&&blockAtt.isCarryable&&player.host.testCarryableWithMap(blockAtt,player.host.map);
		}
		
		/*========A Star Algorithm========*/
		/**
		 * Find the "best" path in a map with the owner.
		 * The startPos should be (owner.gridX,owner.gridY)
		 * 1. [OpenList],[CloseList]
		 * 2. [F=G+H]
		 * @return	The Path From Target To Start
		 */
		protected static function findPath(owner:Player,host:Game,startX:int,startY:int,endX:int,endY:int):Vector.<PathNode>
		{
			//trace("Name="+owner.customName)
			//Operation
			var openList:Vector.<PathNode>=new Vector.<PathNode>();
			var closeList:Vector.<PathNode>=new Vector.<PathNode>();
			
			var endNode:PathNode=new PathNode(endX,endY,null);
			var startNode:PathNode=initFGH(new PathNode(startX,startY,null),host,owner,endNode);
			var targetNode:PathNode=initFGH(new PathNode(endX,endY,null),host,owner,endNode);
			var _leastNearbyNode:PathNode;
			var _nearbyNodes:Vector.<PathNode>;
			var _tempNode:PathNode;
			
			openList.push(startNode)
			
			while(openList.length>0)
			{
				//Set
				_leastNearbyNode=getLeastFNode(openList);
				//trace("Set _leastNearbyNode="+_leastNearbyNode,"numO="+openList.length,"numC="+closeList.length)
				//Move
				removeNodeIn(_leastNearbyNode,openList);
				if(closeList.indexOf(_leastNearbyNode)<0) closeList.push(_leastNearbyNode);
				//Find
				_nearbyNodes=getNearbyNodesAndInitFGH(_leastNearbyNode,host,owner,targetNode);
				//Test And Add
				for each(_tempNode in _nearbyNodes)
				{
					//Touch End
					if(_tempNode.equals(targetNode)) break;
					//Add
					if(!containNode(_tempNode,closeList)&&!containNode(_tempNode,openList)) openList.push(_tempNode);
				}
			}
			//Now the _tempNode is the succeed Node.
			//Return
			return _tempNode==null?null:_tempNode.pathToRoot;
		}
		
		protected static function containNode(node:PathNode,nodes:Vector.<PathNode>):Boolean
		{
			if(nodes.indexOf(node)>=0) return true;
			for(var i:String in nodes)
			{
				if(node.equals(nodes[i])) return true;
			}
			return false;
		}
		
		protected static function removeNodeIn(node:PathNode,nodes:Vector.<PathNode>):Boolean
		{
			var i:int=nodes.indexOf(node);
			if(i>=0)
			{
				//trace("remove node"+node,"succeed!")
				nodes.splice(i,1);
				return true;
			}
			//trace("remove node"+node,"failed!")
			return false;
		}
		
		protected static function getNearbyNodesAndInitFGH(n:PathNode,host:Game,owner:Player,target:PathNode):Vector.<PathNode>
		{
			//Set Rot in mapDealNode
			return new <PathNode>[
				initFGH(mapDealNode(new PathNode(n.x+1,n.y,n),host,GlobalRot.RIGHT),host,owner,target),
				initFGH(mapDealNode(new PathNode(n.x-1,n.y,n),host,GlobalRot.LEFT),host,owner,target),
				initFGH(mapDealNode(new PathNode(n.x,n.y+1,n),host,GlobalRot.DOWN),host,owner,target),
				initFGH(mapDealNode(new PathNode(n.x,n.y-1,n),host,GlobalRot.UP),host,owner,target)
			];
		}
		
		protected static function getLeastFNode(nodes:Vector.<PathNode>):PathNode
		{
			if(nodes==null) return null;
			var _leastNode:PathNode=null;
			var _leastF:int=int.MAX_VALUE;
			for each(var node:PathNode in nodes)
			{
				if(node==null) continue;
				if(node.F<_leastF)
				{
					_leastNode=node;
					_leastF=node.F;
				}
			}
			return _leastNode;
		}
		
		protected static function initFGH(n:PathNode,host:Game,owner:Player,target:iPoint):PathNode
		{
			//Set Rot in mapDealNode
			n.G=getPathWeight(n,host,owner);
			n.H=n.getManhattanDistance(target)*10//exMath.intAbs((n.x-target.x)*(n.y-target.y))*10;//With Linear distance
			return n;
		}
		
		protected static function mapDealNode(n:PathNode,host:Game,fromRot:uint):PathNode
		{
			n.fromRot=fromRot;
			return host.lockIPointInMap(n) as PathNode;
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
				if(node==null||pointInRemember(node,remember)||
					host.isKillZone(node.x,node.y)) continue;
				if(node.F<_leastF)
				{
					_leastNode=node;
					_leastF=node.F;
				}
			}
			return _leastNode;
		}
		
		internal static function pointInRemember(p:iPoint,r:Vector.<Vector.<Boolean>>):Boolean
		{
			if(p==null||r==null||r.length<1) return false;
			return r[p.x][p.y];
		}
		
		internal static function writeRemember(remember:Vector.<Vector.<Boolean>>,x:uint,y:uint,value:Boolean):void
		{
			remember[x][y]=value;
		}
		
		internal static function writeRememberPoint(remember:Vector.<Vector.<Boolean>>,p:iPoint,value:Boolean):void
		{
			remember[p.x][p.y]=value;
		}
		
		internal static function getEntityName(target:EntityCommon):String
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
		internal static function traceLog(owner:Player,message:String):void
		{
			if(DEBUG) trace(owner.customName+":",message);
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
		
		protected var _closeTarget:Vector.<EntityCommon>;
		
		protected var _lastTarget:EntityCommon;
		
		//AI Judging about
		protected var _pickupFirst:Boolean=true;
		
		//============Constructor Function============//
		public function AIProgram_Adventurer():void
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
			return AIProgram_Adventurer.LABEL;
		}
		
		public function get labelShort():String 
		{
			return AIProgram_Adventurer.LABEL_SHORT;
		}
		
		public function get referenceSpeed():uint
		{
			return 10*(1+exMath.random(6));
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
				//Old
				/*{
					var pathNodes:Vector.<PathNode>=findPath(player,host,player.gridX,player.gridY,box.gridX,box.gridY);
					var node:PathNode;
					while(pathNodes.length>0)
					{
						node=pathNodes.pop();
						if(node.hasFromRot)
						{
							player.addActionToThread(AIPlayerAction.getTrunActionFromEntityRot(node.fromRot));
						}
					}
					player.addActionToThread(AIPlayerAction.PRESS_KEY_USE);
				}*/
				//====Dynamic A*====//
				//If No Target,Get New Target
				if(this._lastTarget==null)
				{
					//========Find BonusBox========//
					var target:EntityCommon=null;
					//set Player as Target
					target=this._pickupFirst?getNearestBonusBox(ownerPoint,host):getNearestEnemy(player,host);
					//if cannot find player
					if(target==null)
					{
						if(!this._pickupFirst&&host.entitySystem.bonusBoxCount>0) target=getNearestBonusBox(ownerPoint,host);
						else target=getNearestEnemy(player,host);
					}
					if(target!=null)
					{
						this.changeTarget(player,target);
						traceLog(player,"trun target to "+getEntityName(this._lastTarget));
					}
					//If all avliable target closed
					else
					{
						this.resetCloseTarget();
					}
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
						if(player.weaponReverseCharge)
						{
							if(player.chargingPercent>=1) return AIPlayerAction.PRESS_KEY_USE;
							else if(player.isPress_Use) return AIPlayerAction.RELEASE_KEY_USE;
						}
						else if(!player.isPress_Use) return AIPlayerAction.PRESS_KEY_USE;
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
			return AIPlayerAction.NULL;
		}
		
		public function requestActionOnHurt(player:AIPlayer,damage:uint,attacker:Player):AIPlayerAction
		{
			if(attacker!=null&&attacker!=this._lastTarget&&
				player.canUseWeaponHurtPlayer(attacker,player.weapon))
			{
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
			return AIPlayerAction.NULL;
		}
	}
}

import batr.common.*;
import batr.general.*;
import batr.game.map.*;

class PathNode extends iPoint
{
	public var parent:PathNode;
	
	/**
	 * From GlobalRot(U,D,L,R)
	 */
	public var fromRot:uint=GlobalRot.NULL;
	
	public var G:int=0;
	public var H:int=0;
	
	public function get F():int
	{
		return this.G+this.H;
	}
	
	public function get hasParent():Boolean
	{
		return this.parent!=null;
	}
	
	public function get hasFromRot():Boolean
	{
		return GlobalRot.isValidRot(this.fromRot);
	}
	
	public function get rootParent():PathNode
	{
		var p:PathNode=this.parent;
		while(p.parent!=null&&p.parent!=this)
		{
			p=p.parent;
		}
		return p;
	}
	
	/**
	 * Didn't include the root
	 */
	public function get pathToRoot():Vector.<PathNode>
	{
		var result:Vector.<PathNode>=new <PathNode>[this];
		var p:PathNode=this.parent;
		while(p!=this&&p.parent&&p.hasFromRot&&p.parent.hasFromRot)
		{
			p=p.parent;
			result.push(p);
		}
		return result;
	}
	
	//Constructor
	public function PathNode(x:int,y:int,parent:PathNode=null):void
	{
		super(x,y);
		this.parent=parent;
	}
	
	//Static Constructor
	public static function fromPoint(p:iPoint):PathNode
	{
		return new PathNode(p.x,p.y,null);
	}
	
	//Methods
	public function getFromRot(from:PathNode):uint
	{
		return GlobalRot.fromLinearDistance(this.x-from.x,this.y-from.y);
	}
	
	public function autoSetFromRot():void
	{
		if(this.hasParent)
		{
			this.fromRot=this.getFromRot(this.parent);
		}
	}
	
	/**
	 * @param	parent	A Point
	 * @return	This point
	 */
	public function setParentAndFromRot(parent:PathNode):PathNode
	{
		this.parent=parent;
		this.autoSetFromRot();
		return this;
	}
	
	public function setFromRot(rot:uint):PathNode
	{
		this.fromRot=rot;
		return this;
	}
	
	public override function toString():String 
	{
		return "[pos="+super.toString()+",F="+this.F+",G="+this.G+",H="+this.H+"]";
	}
}

import batr.general.GlobalRot;
import batr.game.map.IMap;

internal class NodeHeap extends Object
{
	/**
	 * @param	i	index start at 0
	 * @return	The index start at 0
	 */
	protected static function getLeftIndex(i:uint):uint
	{
		return ((i+1)<<1)-1;
	}
	
	/**
	 * @param	i	index start at 0
	 * @return	The index start at 0
	 */
	protected static function getRightIndex(i:uint):uint
	{
		return (i+1)<<1;
	}
	
	/**
	 * @param	i	index start at 0
	 * @return	The index start at 0
	 */
	protected static function getParentIndex(i:uint):uint
	{
		return ((i+1)>>1)-1;
	}
	
	protected const _list:Vector.<PathNode>=new Vector.<PathNode>();
	
	public function get length():uint
	{
		return this._list.length;
	}
	
	public function get leastF():PathNode
	{
		return this._list[0];
	}
	
	public function NodeHeap():void
	{
		
	}
	
	public function add(node:PathNode):void
	{
		if(node==null) return;
		this._list.push(node);
		var index:uint=this.length-1;
		while(index>0&&hasParent(index)&&this._list[getParentIndex(index)].F>node.F)
		{
			swapNode(index,getParentIndex(index));
			index=getParentIndex(index);
		}
	}
	
	public function remove():void
	{
		swapNode(0,this.length-1);
		this._list.length--;
		var index:uint=0;
		while(index>0&&hasNode(index)&&this._list[index].F>leastChildF(index))
		{
			swapNode(index,getParentIndex(index));
			index=getParentIndex(index);
		}
	}
	
	protected function getLastNode():PathNode
	{
		return this._list[this.length-1];
	}
	
	protected function setNode(n:PathNode,i:uint):void
	{
		if(n==null) return;
		if(this.length<i) this._list.length=i+1;
		this._list[i]=n;
	}
	
	protected function hasNode(i:uint):Boolean
	{
		return this.length>i&&this._list[i]!=null;
	}
	
	protected function hasParent(i:uint):Boolean
	{
		if(i==0) return false;
		return hasNode(getParentIndex(i));
	}
	
	protected function hasChild(i:uint):Boolean
	{
		return hasNode(getLeftIndex(i))&&hasNode(getRightIndex(i));
	}
	
	protected function getLeftChildF(i:uint):uint
	{
		return hasNode(getLeftIndex(i))?this._list[getLeftIndex(i)].F:0;
	}
	
	protected function getRightChildF(i:uint):uint
	{
		return hasNode(getRightIndex(i))?this._list[getRightIndex(i)].F:0;
	}
	
	protected function getChildF(i:uint):uint
	{
		return hasNode(i)?this._list[i].F:0;
	}
	
	protected function leastChildF(i:uint):uint
	{
		if(!this.hasChild(i)) return 0;
		return exMath.intMin(getChildF(getLeftIndex(i)),getChildF(getRightIndex(i)));
	}
	
	protected function swapNode(i1:uint,i2:uint):void
	{
		if(i1<this.length&&i2<this.length)
		{
			var temp:PathNode=this._list[i1];
			this._list[i1]=this._list[i2];
			this._list[i2]=temp;
		}
	}
}
