package batr.game.entity.entities.players 
{
	import batr.common.*;
	import batr.general.*;
	import batr.game.entity.*;
	import batr.game.entity.ai.*;
	import batr.game.entity.ai.programs.*;
	import batr.game.entity.entities.*;
	import batr.game.entity.entities.players.*;
	import batr.game.model.*;
	import batr.game.main.*;
	
	import flash.display.Graphics;
	
	public class AIPlayer extends Player
	{
		//============Static Variables============//
		public static const LINE_SIZE:Number=GlobalGameVariables.DEFAULT_SIZE/32;
		public static const DEFAULT_AI_RUN_SPEED:Number=12;
		
		//============Static Functions============//
		public static function getAIProgram():IAIProgram
		{
			switch(exMath.random(4))
			{
				case 1: return new AIProgram_Novice();
				case 2: return new AIProgram_Adventurer();
				case 3: return new AIProgram_Master();
				default: return new AIProgram_Dummy();
			}
		}
		
		/**
		 * The Function betweens beginFill and endFill.
		 * @param	AILabel	The Label that determine shape.
		 * @param	radius	The scale of decoration.
		 */
		public static function drawAIDecoration(graphics:Graphics,AILabel:String,radius:Number=SIZE/10):void
		{
			switch(AILabel)
			{
				case AIProgram_Dummy.LABEL:
					graphics.drawCircle(0,0,radius);
					break;
				case AIProgram_Novice.LABEL:
					graphics.drawRect(-radius,-radius,radius*2,radius*2);
					break;
				case AIProgram_Adventurer.LABEL:
					graphics.moveTo(-radius,-radius);
					graphics.lineTo(radius,0);
					graphics.lineTo(-radius,radius);
					graphics.lineTo(-radius,-radius);
					break;
				case AIProgram_Master.LABEL:
					graphics.moveTo(-radius,0);
					graphics.lineTo(0,radius);
					graphics.lineTo(radius,0);
					graphics.lineTo(0,-radius);
					graphics.lineTo(-radius,-0);
					break;
			}
		}
		
		//============Instance Variables============//
		protected var _AIProgram:IAIProgram
		
		protected var _AIRunDelay:uint
		protected var _AIRunMaxDelay:uint
		protected var _actionThread:Vector.<AIPlayerAction>=new Vector.<AIPlayerAction>
		
		//============Constructor Function============//
		public function AIPlayer(
		   host:Game,
		   x:Number,y:Number,
		   team:PlayerTeam,
		   isActive:Boolean=true,
		   program:IAIProgram=null,
		   fillColor:Number=NaN,
		   lineColor:Number=NaN):void
		{
			this._AIProgram=program==null?AIPlayer.getAIProgram():program;
			this.AIRunSpeed=this._AIProgram.referenceSpeed;//once getting
			super(host,x,y,team,0,isActive,fillColor,lineColor);
		}
		
		//============Destructor Function============//
		public override function deleteSelf():void
		{
			this._AIRunDelay=this._AIRunMaxDelay=0
			this._AIProgram=null
			super.deleteSelf()
		}
		
		//============Instance Getter And Setter============//
		public override function get type():EntityType
		{
			return EntityType.AI_PLAYER
		}
		
		public function get AIProgram():IAIProgram
		{
			return this._AIProgram;
		}
		
		public function get AIRunSpeed():Number
		{
			return GlobalGameVariables.TPS/(_AIRunDelay)
		}
		
		public function set AIRunSpeed(speed:Number):void
		{
			if(speed==this.AIRunSpeed) return
			if(isNaN(speed))
			{
				//NaN means randomly speed
				speed=DEFAULT_AI_RUN_SPEED;
			}
			else if(!isFinite(speed))
			{
				//Infinite means max speed
				speed=10*GlobalGameVariables.TPS;
			}
			this._AIRunMaxDelay=GlobalGameVariables.TPS/speed;
			this.initAITick();
		}
		
		public function get hasAction():Boolean
		{
			return this._actionThread!=null&&this._actionThread.length>0;
		}
		
		public function get AILabel():String
		{
			return this._AIProgram==null?null:this._AIProgram.label;
		}
		
		public function get ActionThread():Vector.<AIPlayerAction>
		{
			return this._actionThread;
		}
		
		//============Instance Functions============//
		public function initAITick():void
		{
			this._AIRunDelay=exMath.random(this._AIRunMaxDelay)
		}
		
		public function resetAITick():void
		{
			this._AIRunDelay=this._AIRunMaxDelay
		}
		
		//AI Shape
		protected override function drawShape(Alpha:Number=1):void
		{
			//Basic Body
			var realRadiusX:Number=(SIZE-LINE_SIZE)/2;
			var realRadiusY:Number=(SIZE-LINE_SIZE)/2;
			graphics.clear();
			graphics.lineStyle(LINE_SIZE,this._lineColor);
			graphics.beginFill(this._fillColor,Alpha);
			graphics.moveTo(-realRadiusX,-realRadiusY);
			graphics.lineTo(realRadiusX,0);
			graphics.lineTo(-realRadiusX,realRadiusY);
			graphics.lineTo(-realRadiusX,-realRadiusY);
			//Shape By AI
			AIPlayer.drawAIDecoration(this.graphics,this._AIProgram.label);
			graphics.endFill();
		}
		
		//AI Tick
		public override function tickFunction():void
		{
			if(!_isActive) return;
			super.tickFunction();
			if(this._AIRunDelay>0) this._AIRunDelay--;
			else
			{
				this._AIRunDelay=this._AIRunMaxDelay;
				AIContol();
			}
		}
		
		//AI Trigger
		protected override function onHurt(damage:uint,attacker:Player=null):void
		{
			var action:AIPlayerAction=this.AIProgram.requestActionOnHurt(this,damage,attacker)
			this.runAction(action)
			//super
			super.onHurt(damage,attacker);
		}
		
		protected override function onDeath(damage:uint,attacker:Player=null):void
		{
			var action:AIPlayerAction=this.AIProgram.requestActionOnDeath(this,damage,attacker)
			this.runAction(action)
			//super
			super.onDeath(damage,attacker);
		}
		
		protected override function onKillPlayer(victim:Player,damage:uint):void
		{
			var action:AIPlayerAction=this.AIProgram.requestActionOnKill(this,damage,victim)
			this.runAction(action)
			//super
			super.onKillPlayer(victim,damage);
		}
		
		public override function onPickupBonusBox(box:BonusBox):void
		{
			var action:AIPlayerAction=this.AIProgram.requestActionOnPickupBonusBox(this,box)
			this.runAction(action)
			//super
			super.onPickupBonusBox(box);
		}
		
		protected override function onRespawn():void
		{
			var action:AIPlayerAction=this.AIProgram.requestActionOnRespawn(this)
			this.runAction(action)
			//super
			super.onRespawn();
		}
		
		public override function onMapTransform():void
		{
			super.onMapTransform()
			var action:AIPlayerAction=this.AIProgram.requestActionOnMapTransfrom(this)
			this.runAction(action)
		}
		
		//========AI Contol:The main auto-contol of AI========//
		protected function AIContol():void
		{
			//Tick
			var action:AIPlayerAction
			action=this.AIProgram.requestActionOnTick(this)
			this.runAction(action)
			//Thread
			if(this.hasAction)
			{
				action=this._actionThread.shift()
				this.runAction(action)
			}
		}
		
		public function runAction(action:AIPlayerAction):void
		{
			if(this.isRespawning) return;
			switch(action)
			{
				case AIPlayerAction.MOVE_UP:
					this.moveUp()
				break;
				case AIPlayerAction.MOVE_DOWN:
					this.moveDown()
				break;
				case AIPlayerAction.MOVE_LEFT_ABS:
					this.moveLeft()
				break;
				case AIPlayerAction.MOVE_RIGHT_ABS:
					this.moveRight()
				break;
				case AIPlayerAction.MOVE_FORWARD:
					this.moveForward()
				break;
				case AIPlayerAction.MOVE_BACK:
					this.trunBack(),this.moveForward()
				break;
				case AIPlayerAction.MOVE_LEFT_REL:
					this.trunRelativeLeft(),this.moveForward()
				break;
				case AIPlayerAction.MOVE_RIGHT_REL:
					this.trunRelativeRight(),this.moveForward()
				break;
				case AIPlayerAction.TRUN_UP:
					this.trunUp()
				break;
				case AIPlayerAction.TRUN_DOWN:
					this.trunDown()
				break;
				case AIPlayerAction.TRUN_LEFT_ABS:
					this.trunAbsoluteLeft()
				break;
				case AIPlayerAction.TRUN_RIGHT_ABS:
					this.trunAbsoluteRight()
				break;
				case AIPlayerAction.TRUN_BACK:
					this.trunBack()
				break;
				case AIPlayerAction.TRUN_LEFT_REL:
					this.trunRelativeLeft()
				break;
				case AIPlayerAction.TRUN_RIGHT_REL:
					this.trunRelativeRight()
				break;
				case AIPlayerAction.USE_WEAPON:
					this.useWeapon()
				break;
				case AIPlayerAction.PRESS_KEY_UP:
					this.pressUp=true
				break;
				case AIPlayerAction.PRESS_KEY_DOWN:
					this.pressDown=true
				break;
				case AIPlayerAction.PRESS_KEY_LEFT:
					this.pressLeft=true
				break;
				case AIPlayerAction.PRESS_KEY_RIGHT:
					this.pressRight=true
				break;
				case AIPlayerAction.PRESS_KEY_USE:
					this.pressUse=true
				break;
				case AIPlayerAction.RELEASE_KEY_UP:
					this.pressUp=false
				break;
				case AIPlayerAction.RELEASE_KEY_DOWN:
					this.pressDown=false
				break;
				case AIPlayerAction.RELEASE_KEY_LEFT:
					this.pressLeft=false
				break;
				case AIPlayerAction.RELEASE_KEY_RIGHT:
					this.pressRight=false
				break;
				case AIPlayerAction.RELEASE_KEY_USE:
					this.pressUse=false
				break;
				case AIPlayerAction.DISABLE_CHARGE:
					this.onDisableCharge()
				break;
			}
		}
		
		public function runActions(actions:Vector.<AIPlayerAction>):void
		{
			for(var i:uint=0;i<actions.length;i++)
			{
				runAction(actions[i])
			}
		}
		
		public function runActions2(...actions):void
		{
			var runV:Vector.<AIPlayerAction>=new Vector.<AIPlayerAction>
			for(var i:uint=0;i<actions.length;i++)
			{
				if(actions[i] is AIPlayerAction)
				{
					runAction(actions[i] as AIPlayerAction)
				}
			}
		}
		
		public function addActionToThread(action:AIPlayerAction):void
		{
			this._actionThread.push(action)
		}
		
		public function addActionsToThread(actions:Vector.<AIPlayerAction>):void
		{
			this._actionThread=this._actionThread.concat(actions)
		}
		
		public function addActionToThreadAtFirst(action:AIPlayerAction):void
		{
			this._actionThread.unshift(action)
		}
		
		public function addActionsToThreadAtFirst(actions:Vector.<AIPlayerAction>):void
		{
			this._actionThread=actions.concat(this._actionThread)
		}
		
		public function shiftActionToThread():AIPlayerAction
		{
			return this._actionThread.shift()
		}
		
		public function popActionInThread():AIPlayerAction
		{
			return this._actionThread.pop()
		}
		
		public function reverseActionThread():void
		{
			this._actionThread=this._actionThread.reverse()
		}
		
		public function repeatActionThread(count:uint=1):void
		{
			//this._actionThread*=(count+1)
			if(count<1) return
			else if(count==1)
			{
				this._actionThread=this._actionThread.concat(this._actionThread)
			}
			else
			{
				var tempActions:Vector.<AIPlayerAction>=this._actionThread.concat()
				for(var i:uint=0;i<count;i++)
				{
					this._actionThread=this._actionThread.concat(tempActions)
				}
			}
		}
		
		public function clearActionThread():void
		{
			this._actionThread.splice(0,this._actionThread.length)
		}
		
		public function runAllActionsOfThreadImmediately():void
		{
			if(this._actionThread.length<1) return
			this.runActions(this._actionThread)
			this.clearActionThread()
		}
	}
}