package batr.game.entity.entities.projectiles 
{
	import batr.common.*;
	import batr.general.*;
	import batr.game.model.WeaponType;
	
	import batr.game.block.*;
	import batr.game.entity.entities.players.*;
	import batr.game.main.*;
	
	/**
	 * ...
	 * @author ARCJ137442
	 */
	public class Lightning extends ProjectileCommon
	{
		//============Static Variables============//
		public static const LIGHT_ALPHA:Number=0.5
		public static const LIGHT_BLOCK_WIDTH:Number=0.2
		public static const LIFE:uint=GlobalGameVariables.TPS/2
		
		//============Static Functions============//
		
		//============Instance Variables============//
		protected var _life:uint=LIFE;
		public var isDamaged:Boolean=false;
		
		protected var _energy:int;
		protected var _initialEnergy:int;
		
		protected var _wayPoints:Vector.<iPoint>=new Vector.<iPoint>();
		protected var _hurtPlayers:Vector.<Player>=new Vector.<Player>();
		protected var _hurtDefaultDamage:Vector.<uint>=new Vector.<uint>();
		
		//============Constructor Function============//
		public function Lightning(host:Game,x:Number,y:Number,rot:uint,owner:Player,energy:int):void
		{
			super(host,x,y,owner);
			this.rot=rot;
			this._initialEnergy=this._energy=energy;
			this._currentWeapon=WeaponType.LIGHTNING;
		}
		
		//============Destructor Function============//
		public override function deleteSelf():void
		{
			
		}
		
		//============Instance Getter And Setter============//
		public function get energyPercent():Number
		{
			return this._energy/this._initialEnergy;
		}
		
		//============Instance Functions============//
		public function dealTick():void
		{
			if(!this.isDamaged)
			{
				this.isDamaged=true;
				this.lightningWays();
				this.host.lightningHurtPlayers(this,this._hurtPlayers,this._hurtDefaultDamage);
			}
			this.alpha=this._life/Lightning.LIFE
			if(this._life>0) this._life--;
			else this._host.entitySystem.removeProjectile(this);
		}
		
		/**
		 * Init the way of lightning
		 */
		protected function lightningWays():void
		{
			//Draw in location in this
			var head:iPoint=new iPoint(this.gridX,this.gridY)
			var ownerWeapon:WeaponType=this.currentWeapon;
			var vx:int,vy:int;
			var cost:int=0;
			var player:Player=null;
			var tRot:uint=this.owner.rot;
			var nRot:uint=0;
			//Loop to run
			this._wayPoints.push(new iPoint(0,0));
			while(true)
			{
				//trace("initWay in "+head,nRot,tRot,cost);
				//Cost and hit
				cost=operateCost(head.x,head.y);
				if((this._energy-=cost)<0) break;
				player=this.host.getHitPlayerAt(head.x,head.y);
				if(player!=null&&this.owner.canUseWeaponHurtPlayer(player,ownerWeapon))
				{
					this._hurtPlayers.push(player);
					this._hurtDefaultDamage.push(ownerWeapon.defaultDamage*this.energyPercent);
				}
				//Update Rot
				nRot=this.getLeastWeightRot(head.x,head.y,tRot);
				if(GlobalRot.isValidRot(nRot))
				{
					tRot=nRot;
					this.addWayPoint(head.x,head.y);
				}
				vx=GlobalRot.towardXInt(tRot);
				vy=GlobalRot.towardYInt(tRot);
				//Move
				head.x+=vx;
				head.y+=vy;
			}
			this.addWayPoint(head.x,head.y);
			//Draw
			this.rot=0;
			this.drawLightning();
			//trace(this.entityX,this.entityY);
		}
		
		protected function addWayPoint(hostX:int,hostY:int):void
		{
			this._wayPoints.push(new iPoint(hostX-this.gridX,hostY-this.gridY));
		}
		
		protected function getLeastWeightRot(x:int,y:int,nowRot:uint):uint
		{
			var cx:int,cy:int;
			var leastCost:int=operateCost(x+GlobalRot.towardXInt(nowRot),y+GlobalRot.towardYInt(nowRot));
			var cost:int;
			var result:uint=GlobalRot.NULL;
			nowRot=GlobalRot.lockIntToStandard(nowRot+exMath.random1());
			for(var r:int=nowRot;r<nowRot+4;r+=2)
			{
				cx=x+GlobalRot.towardXInt(r);
				cy=y+GlobalRot.towardYInt(r);
				cost=operateCost(cx,cy);
				if(cost<leastCost)
				{
					leastCost=cost;
					result=GlobalRot.lockIntToStandard(r);
				}
			}
			return result;
		}
		
		protected function operateCost(x:int,y:int):int
		{
			if(this.host.isHitAnyPlayer(x,y)) return 5;//The electricResistance of player
			if(this.host.isIntOutOfMap(x,y)) return int.MAX_VALUE;//The electricResistance out of world
			var attributes:BlockAttributes=this.host.getBlockAttributes(x,y);
			if(attributes!=null) return attributes.electricResistance;
			return 0;
		}
		
		public override function onProjectileTick():void
		{
			this.dealTick();
		}
		
		public override function drawShape():void
		{
			
		}
		
		protected function drawLightning():void
		{
			//These points uses local grid,for example the initial point is (0,0)
			var point:iPoint=null,pointH:iPoint=null;
			//drawLines
			for(var i:uint=0;i<this._wayPoints.length;i++)
			{
				point=pointH;
				pointH=this._wayPoints[i];
				if(point!=null&&pointH!=null)//Head
				{
					this.graphics.beginFill(this.ownerColor,LIGHT_ALPHA);
					this.graphics.drawRect(
						GlobalGameVariables.DEFAULT_SIZE*(exMath.intMin(point.x,pointH.x)-LIGHT_BLOCK_WIDTH),
						GlobalGameVariables.DEFAULT_SIZE*(exMath.intMin(point.y,pointH.y)-LIGHT_BLOCK_WIDTH),
						GlobalGameVariables.DEFAULT_SIZE*(exMath.intAbs(point.x-pointH.x)+LIGHT_BLOCK_WIDTH*2),
						GlobalGameVariables.DEFAULT_SIZE*(exMath.intAbs(point.y-pointH.y)+LIGHT_BLOCK_WIDTH*2)
						);
					this.graphics.endFill();
					//trace("drawPoint at ",point,pointH);
				}
			}
			//drawPoints
			//this.
		}
	}
}