package batr.game.entity.objects 
{
	import batr.general.*;
	
	import batr.game.main.*;
	import batr.game.effect.effects.*;
	import batr.game.model.*;
	
	import flash.display.Shape;
	
	public class BonusBoxSymbol extends Shape
	{
		//============Static Variables============//
		//General
		public static const GRID_SIZE:Number=GlobalGameVariables.DEFAULT_SIZE/5
		
		//HHL
		public static const HEALTH_COLOR:uint=PlayerGUI.HEALTH_COLOR
		
		//Weapon
		public static const WEAPON_COLOR:uint=0x555555
		public static const WEAPON_LINE_SIZE:uint=4
		
		//Attributes
		public static const ATTRIBUTES_LINE_SIZE:uint=4
		public static const ATTRIBUTES_FILL_ALPHA:Number=3/4
		
		public static const EXPERIENCE_COLOR:uint=0xcc88ff
		
		public static const BUFF_DAMAGE_COLOR:uint=0xff6666
		public static const BUFF_CD_COLOR:uint=0x6666ff
		public static const BUFF_RESISTANCE_COLOR:uint=0x66ff66
		public static const BUFF_RADIUS_COLOR:uint=0xffff66
		
		//Team
		public static const TEAM_LINE_SIZE:uint=4
		
		public static const RANDOM_CHANGE_TEAM_LINE_COLOR:uint=0x555555
		public static const UNITE_PLAYER_LINE_COLOR:uint=0x6666ff
		public static const UNITE_AI_LINE_COLOR:uint=0x66ff66
		
		//============Static Functions============//
		
		//============Instance Variables============//
		protected var _type:BonusType
		
		//============Constructor Function============//
		public function BonusBoxSymbol(type:BonusType=BonusType.NULL):void
		{
			super();
			this.drawShape();
		}
		
		//============Destructor Function============//
		public function deleteSelf():void
		{
			this._type=null;
			this.graphics.clear();
		}
		
		//============Instance Getters And Setters============//
		public function get type():BonusType
		{
			return this._type;
		}
		
		public function set type(value:BonusType):void
		{
			if(this._type==value) return;
			this._type=value;
			this.drawShape();
		}
		
		//============Instance Functions============//
		//========Symbol Shape========//
		public function drawShape():void
		{
			this.graphics.clear();
			switch(this._type)
			{
				case BonusType.NULL:return;
				//HHL(Health,Heal&Life)
				case BonusType.ADD_HEALTH:
					this.drawHealthSymbol();
				break;
				case BonusType.ADD_HEAL:
					this.drawHealSymbol();
				break;
				case BonusType.ADD_LIFE:
					this.drawLifeSymbol();
				break;
				//Weapon
				case BonusType.RANDOM_WEAPON:
					this.drawWeaponSymbol();
				break;
				//Attributes
				case BonusType.BUFF_DAMAGE:
					this.drawAttributesSymbol(BUFF_DAMAGE_COLOR);
				break;
				case BonusType.BUFF_CD:
					this.drawAttributesSymbol(BUFF_CD_COLOR);
				break;
				case BonusType.BUFF_RESISTANCE:
					this.drawAttributesSymbol(BUFF_RESISTANCE_COLOR);
				break;
				case BonusType.BUFF_RADIUS:
					this.drawAttributesSymbol(BUFF_RADIUS_COLOR);
				break;
				case BonusType.ADD_EXPERIENCE:
					this.drawAttributesSymbol(EXPERIENCE_COLOR);
				break;
				//Team
				case BonusType.RANDOM_CHANGE_TEAM:
					this.drawTeamSymbol(RANDOM_CHANGE_TEAM_LINE_COLOR);
				break;
				case BonusType.UNITE_PLAYER:
					this.drawTeamSymbol(UNITE_PLAYER_LINE_COLOR);
				break;
				case BonusType.UNITE_AI:
					this.drawTeamSymbol(UNITE_AI_LINE_COLOR);
				break;
				//Other
				case BonusType.RANDOM_TELEPORT:
					this.drawRandomTeleportSymbol();
				break;
			}
		}
		
		//====HHL====//
		protected function drawHealthSymbol():void
		{
			//V
			this.graphics.beginFill(HEALTH_COLOR);
			this.graphics.drawRect(-GRID_SIZE/2,-GRID_SIZE*1.5,GRID_SIZE,GRID_SIZE*3);
			this.graphics.endFill();
			//H
			this.graphics.beginFill(HEALTH_COLOR);
			this.graphics.drawRect(-GRID_SIZE*1.5,-GRID_SIZE/2,GRID_SIZE*3,GRID_SIZE);
			this.graphics.endFill();
		}
		
		protected function drawHealSymbol():void
		{
			//V
			this.graphics.beginFill(HEALTH_COLOR);
			this.graphics.drawRect(-GRID_SIZE/2,-GRID_SIZE*1.5,GRID_SIZE,GRID_SIZE*3);
			//H
			this.graphics.drawRect(-GRID_SIZE*1.5,-GRID_SIZE/2,GRID_SIZE*3,GRID_SIZE);
			this.graphics.endFill();
		}
		
		protected function drawLifeSymbol():void
		{
			//L
			this.graphics.beginFill(HEALTH_COLOR);
			this.graphics.drawRect(-GRID_SIZE*1.5,-GRID_SIZE*1.5,GRID_SIZE,GRID_SIZE*2);
			this.graphics.endFill();
			this.graphics.beginFill(HEALTH_COLOR);
			this.graphics.drawRect(-GRID_SIZE*1.5,GRID_SIZE/2,GRID_SIZE*3,GRID_SIZE);
			this.graphics.endFill();
		}
		
		//====Weapon====//
		protected function drawWeaponSymbol():void
		{
			//Circle
			this.graphics.lineStyle(WEAPON_LINE_SIZE,WEAPON_COLOR);
			this.graphics.drawCircle(0,0,GRID_SIZE);
		}
		
		//====Attributes====//
		protected function drawAttributesSymbol(color:uint):void
		{
			//Colored Rectangle
			/*this.graphics.lineStyle(ATTRIBUTES_LINE_SIZE,color);
			this.graphics.beginFill(color,ATTRIBUTES_FILL_ALPHA);
			this.graphics.drawRect(-GRID_SIZE*7/8,-GRID_SIZE*7/8,GRID_SIZE*7/4,GRID_SIZE*7/4);
			this.graphics.endFill();*/
			//Colored Arrow
			//Top
			this.graphics.lineStyle(ATTRIBUTES_LINE_SIZE,color);
			this.graphics.beginFill(color,ATTRIBUTES_FILL_ALPHA);
			this.graphics.moveTo(0,-GRID_SIZE*1.5);//T1
			this.graphics.lineTo(GRID_SIZE*1.5,0);//T2
			this.graphics.lineTo(GRID_SIZE/2,0)//B1
			this.graphics.lineTo(GRID_SIZE/2,GRID_SIZE*1.5)//B2
			this.graphics.lineTo(-GRID_SIZE/2,GRID_SIZE*1.5)//B3
			this.graphics.lineTo(-GRID_SIZE/2,0)//B4
			this.graphics.lineTo(-GRID_SIZE*1.5,0);//T3
			this.graphics.lineTo(0,-GRID_SIZE*1.5);//T1
			this.graphics.endFill();
			//Bottom
		}
		
		//====Team====//
		protected function drawTeamSymbol(color:uint):void
		{
			this.graphics.lineStyle(TEAM_LINE_SIZE,color);
			graphics.moveTo(-GRID_SIZE,-GRID_SIZE);
			graphics.lineTo(GRID_SIZE,0);
			graphics.lineTo(-GRID_SIZE,GRID_SIZE);
			graphics.lineTo(-GRID_SIZE,-GRID_SIZE);
		}
		
		//====Other====//
		protected function drawRandomTeleportSymbol():void
		{
			//Teleport Effect
			//1
			this.graphics.lineStyle(EffectTeleport.LINE_SIZE,EffectTeleport.DEFAULT_COLOR,EffectTeleport.LINE_ALPHA);
			this.graphics.beginFill(EffectTeleport.DEFAULT_COLOR,EffectTeleport.FILL_ALPHA);
			this.graphics.drawRect(-GRID_SIZE,-GRID_SIZE,GRID_SIZE*2,GRID_SIZE*2);
			this.graphics.endFill();
			//2
			this.graphics.lineStyle(EffectTeleport.LINE_SIZE,EffectTeleport.DEFAULT_COLOR,EffectTeleport.LINE_ALPHA);
			this.graphics.beginFill(EffectTeleport.DEFAULT_COLOR,EffectTeleport.FILL_ALPHA);
			graphics.moveTo(0,-GRID_SIZE*Math.SQRT2);
			graphics.lineTo(GRID_SIZE*Math.SQRT2,0);
			graphics.lineTo(0,GRID_SIZE*Math.SQRT2);
			graphics.lineTo(-GRID_SIZE*Math.SQRT2,0);
			graphics.lineTo(0,-GRID_SIZE*Math.SQRT2);
			this.graphics.endFill();
		}
	}
}