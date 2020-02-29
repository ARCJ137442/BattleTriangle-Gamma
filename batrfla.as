package
{
	import batr.common.*;
	import batr.general.*;
	import batr.main.*;
	
	import flash.events.*;
	import flash.display.MovieClip;
	
	public class batrFla extends MovieClip
	{
		var sub:BatrSubject=new BatrSubject()
		
		public function batrFla()
		{
			this.addChild(sub);
			sub.trunToMenu();
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
			 * <Enter>:Game Ticking
			 */
			switch(code)
			{
				case KeyCode.M:
					sub.trunToMenu();
				break;
				case KeyCode.G:
					sub.trunToGame();
				break;
				case KeyCode.X:
					if(shift) sub.trunTranslations();
					else sub.menuObj.trunSheet();
				break;
			}
			if(!sub.gameObj.isLoaded) return;
			switch(code)
			{
				case KeyCode.R:
					if(ctrl||ctrl&&shift) sub.gameObj.setATeamToAIPlayer();
					else if(shift) sub.gameObj.setATeamToNotAIPlayer();
					else sub.gameObj.randomizeAllPlayerTeam();
					break;
				case KeyCode.T:
					if(shift) sub.gameObj.transformMap();
					else sub.gameObj.spreadAllPlayer();
					break;
				case KeyCode.C:
					if(shift) sub.gameObj.effectSystem.removeAllEffect();
					else sub.gameObj.entitySystem.removeAllProjectile();
					break;
				case KeyCode.V:
					if(shift) sub.gameObj.changeAllPlayerWeapon();
					else sub.gameObj.changeAllPlayerWeaponRandomly();
					break;
				case KeyCode.B:
					if(shift) sub.gameObj.entitySystem.removeAllBonusBox();
					else sub.gameObj.randomAddRandomBonusBox();
					break;
				case KeyCode.ENTER:
					sub.gameObj.dealGameTick();
					break;
				case KeyCode.BACK_QUOTES:
					if(shift) sub.gameObj.speed--;
					else sub.gameObj.speed++;
					break;
				case KeyCode.L:
					if(shift)
						trace("List of Effect UUIDs:",sub.gameObj.effectSystem.getAllUUID());
					else trace("List of Entity UUIDs:",sub.gameObj.entitySystem.getAllUUID());
					break;
			}
		}
	}
}
