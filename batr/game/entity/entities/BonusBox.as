package batr.game.entity.entities 
{
	import batr.common.*;
	import batr.general.*;
	
	import batr.game.entity.*;
	import batr.game.entity.objects.*;
	import batr.game.entity.entities.players.*;
	import batr.game.model.*;
	import batr.game.main.*;
	
	public class BonusBox extends EntityCommon
	{
		//============Static Variables============//
		public static const LINE_COLOR:uint=0x777777
		public static const FILL_COLOR:uint=0xdddddd
		
		public static const BOX_SIZE:Number=GlobalGameVariables.DEFAULT_SIZE*0.8
		public static const LINE_SIZE:Number=GlobalGameVariables.DEFAULT_SIZE/20
		public static const BOX_ELLIPSE_SIZE:Number=GlobalGameVariables.DEFAULT_SIZE/16
		
		//============Static Functions============//
		
		//============Instance Variables============//
		protected var _bonusType:BonusType
		protected var _symbol:BonusBoxSymbol
		
		//============Constructor Function============//
		public function BonusBox(host:Game,x:int,y:int,type:BonusType=BonusType.NULL):void
		{
			super(host,x,y);
			this._bonusType=type;
			this._symbol=new BonusBoxSymbol(this._bonusType);
			this._symbol.x=this._symbol.y=GlobalGameVariables.DEFAULT_SIZE/2;
			this.addChild(this._symbol);
			this.drawShape();
		}
		
		//============Destructor Function============//
		public override function deleteSelf():void
		{
			this._bonusType=null;
			this._symbol.deleteSelf();
			this.removeChild(this._symbol);
			super.deleteSelf();
		}
		
		//============Instance Getters And Setters============//
		public override function get type():EntityType
		{
			return EntityType.BONUS_BOX;
		}
		
		public function get bonusType():BonusType
		{
			return this._bonusType;
		}
		
		public function set bonusType(value:BonusType):void
		{
			this._bonusType=value;
			this._symbol.drawShape();
		}
		
		protected function get borderSpace():Number
		{
			return (GlobalGameVariables.DEFAULT_SIZE-BOX_SIZE)/2;
		}
		
		protected function get boxRadius():Number
		{
			return BOX_SIZE/2;
		}
		
		//============Instance Functions============//
		public function drawShape():void
		{
			//Define
			//var radius:Number=GlobalGameVariables.DEFAULT_SIZE/2;
			//Line
			this.graphics.beginFill(LINE_COLOR);
			this.graphics.drawRoundRect(borderSpace,borderSpace,BOX_SIZE,BOX_SIZE,BOX_ELLIPSE_SIZE,BOX_ELLIPSE_SIZE);
			this.graphics.endFill();
			//Fill
			this.graphics.beginFill(FILL_COLOR);
			this.graphics.drawRoundRect(borderSpace+LINE_SIZE,borderSpace+LINE_SIZE,BOX_SIZE-2*LINE_SIZE,BOX_SIZE-2*LINE_SIZE,BOX_ELLIPSE_SIZE,BOX_ELLIPSE_SIZE);
			this.graphics.endFill();
			//Symbol
			this._symbol.type=this._bonusType;
		}
		
		public function onPlayerPickup(player:Player):void
		{
			if(player==null) return;
			//Disactive
			this.isActive=false;
			//Effect
			switch(this._bonusType)
			{
				//Health,Heal&Life
				case BonusType.ADD_HEALTH:
					player.addHealth(5*(1+exMath.random(10)));
					break;
				case BonusType.ADD_HEAL:
					player.heal+=5*(1+exMath.random(25));
					break;
				case BonusType.ADD_LIFE:
					if(player.infinityLife||player.isFullHealth) player.maxHealth+=5;
					else player.lifes++;
					break;
				//Weapon
				case BonusType.RANDOM_WEAPON:
					player.weapon=WeaponType.getRandomAvaliableWithout(player.weapon);
					break;
				//Attributes
				case BonusType.BUFF_DAMAGE:
					player.buffDamage++;
					break;
				case BonusType.BUFF_CD:
					player.buffCD++;
					break;
				case BonusType.BUFF_RESISTANCE:
					player.buffResistance++;
					break;
				case BonusType.BUFF_RADIUS:
					player.buffRadius++;
					break;
				case BonusType.ADD_EXPERIENCE:
					player.experience+=((player.level>>2)+1)<<2;
					break;
				//Team
				case BonusType.RANDOM_CHANGE_TEAM:
					this._host.randomizePlayerTeam(player);
					break;
				case BonusType.UNITE_AI:
					this._host.setATeamToAIPlayer();
					break;
				case BonusType.UNITE_PLAYER:
					this._host.setATeamToNotAIPlayer();
					break;
				//Other
				case BonusType.RANDOM_TELEPORT:
					this._host.spreadPlayer(player,false,true);
					break;
			}
			//Stats Operations
			player.stats.pickupBonusBoxCount++;
			//Remove
			this._host.entitySystem.removeBonusBox(this);
		}
	}
}
