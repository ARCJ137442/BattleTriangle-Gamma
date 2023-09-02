package
{
	import batr.common.*;
	import batr.general.*;
	import batr.main.*;
	import batr.game.main.Game;
	
	import flash.events.*;
	import flash.display.MovieClip;
	
	public class batrFla extends MovieClip
	{
		var sub:BatrSubject=new BatrSubject();
		var fixed_mapID:uint=0;
		var temp_JSON:String;
		
		public function batrFla()
		{
			this.addChild(sub);
			sub.turnToMenu();
			sub.gameRule.playerCount=4;
			sub.gameRule.AICount=6;
			//sub.gameRule.defaultWeaponID=WeaponType.RANDOM_AVAILABLE_ID;
			//sub.gameRule.weaponsNoCD=false
			stage.addEventListener(KeyboardEvent.KEY_DOWN,onKD);
		}
		
		public function onKD(E:KeyboardEvent):void
		{
			var code:uint=E.keyCode;
			var ctrl:Boolean=E.ctrlKey
			var alt:Boolean=E.altKey
			var shift:Boolean=E.shiftKey
			/* Debug Functions:
			 * M:Menu
			 * G:Game
			 * R:Team(Color)
			 * T:Pos/Map
			 * C:Projectile/Effect
			 * V:Weapon
			 * X:Sheet/Translations
			 * L:Game UUID List
			 * <`~>:Game Speed
			 * N:Append Player
			 * <Enter>:Game Ticking
			 */
			switch(code)
			{
				case KeyCode.M:
					sub.turnToMenu();
				break;
				case KeyCode.G:
					sub.turnToGame();
				break;
				case KeyCode.X:
					if(shift) sub.turnTranslations();
					else sub.menuObj.turnSheet();
				break;
			}
			if(!sub.gameObj.isLoaded) return;
			switch(code)
			{
				// R: change teams
				case KeyCode.R:
					if(ctrl||ctrl&&shift) sub.gameObj.setATeamToAIPlayer();
					else if(shift) sub.gameObj.setATeamToNotAIPlayer();
					else sub.gameObj.randomizeAllPlayerTeam();
					break;
				// T: change position/map
				case KeyCode.T:
					if(ctrl)
					{
						if(shift) sub.gameObj.transformMap(Game.ALL_MAPS[fixed_mapID=exMath.intMod(fixed_mapID-1,Game.VALID_MAP_COUNT)]);
						else sub.gameObj.transformMap(Game.ALL_MAPS[fixed_mapID=exMath.intMod(fixed_mapID+1,Game.VALID_MAP_COUNT)]);
						trace("Now transform map to:",sub.gameObj.map.name);
					}
					else if(shift) sub.gameObj.transformMap();
					else sub.gameObj.spreadAllPlayer();
					break;
				// C: remove all projectiles/effects
				case KeyCode.C:
					if(shift) sub.gameObj.effectSystem.removeAllEffect();
					else sub.gameObj.entitySystem.removeAllProjectile();
					break;
				// V: change weapons
				case KeyCode.V:
					if(shift) sub.gameObj.changeAllPlayerWeapon();
					else sub.gameObj.changeAllPlayerWeaponRandomly();
					break;
				// B: control bonus boxes
				case KeyCode.B:
					if(ctrl) sub.gameObj.fillBonusBox();
					else if(shift) sub.gameObj.entitySystem.removeAllBonusBox();
					else sub.gameObj.randomAddRandomBonusBox();
					break;
				// ENTER: deal game tick
				case KeyCode.ENTER:
					sub.gameObj.dealGameTick();
					break;
				// BACK_QUOTES: manipulate speed
				case KeyCode.BACK_QUOTES:
					if(ctrl&&shift) sub.gameObj.speed=1; // Reset speed
					else if(shift) sub.gameObj.speed/=2;
					else if(ctrl) sub.gameObj.speed+=1;
					else sub.gameObj.speed*=2;
					break;
				//L: List UUIDs
				case KeyCode.L:
					if(shift)
						trace("List of Effect UUIDs:",sub.gameObj.effectSystem.getAllUUID());
					else trace("List of Entity UUIDs:",sub.gameObj.entitySystem.getAllUUID());
					break;
				//E: Test game end
				case KeyCode.E:
					sub.gameObj.testGameEnd(shift);
					break;
				//N: Create
				case KeyCode.N:
					if(ctrl)
						if(shift) // Append a "SuperAI" 
						{
							var p=sub.gameObj.appendAI();
							p.AIRunSpeed = alt?Infinity:1000;
						}
						else sub.gameObj.appendAI();
					
					else sub.gameObj.appendPlayer();
					break;
			}
		}
	}
}
