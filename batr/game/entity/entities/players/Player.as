package batr.game.entity.entities.players {

	import batr.common.*;
	import batr.general.*;
	import batr.game.stat.*;
	import batr.game.entity.model.IPlayerProfile;

	import batr.game.block.*;
	import batr.game.entity.entities.*;
	import batr.game.entity.entities.players.*;
	import batr.game.entity.*;
	import batr.game.entity.objects.*;
	import batr.game.model.*;
	import batr.game.main.*;

	import flash.display.*;
	import flash.geom.*;

	public class Player extends EntityCommon implements IPlayerProfile {
		//============Static Variables============//
		public static const SIZE:Number = 1 * GlobalGameVariables.DEFAULT_SIZE;
		public static const LINE_SIZE:Number = GlobalGameVariables.DEFAULT_SIZE / 96;
		public static const CARRIED_BLOCK_ALPHA:Number = 1 / 4;

		public static const DEFAULT_MAX_HEALTH:int = 100;
		public static const DEFAULT_HEALTH:int = DEFAULT_MAX_HEALTH;
		public static const MAX_DAMAGE_DELAY:uint = 0.5 * GlobalGameVariables.FIXED_TPS;
		public static function isAI(player:Player):Boolean {
			return player is AIPlayer;
		}

		public static function getUplevelExperience(level:uint):uint {
			return (level + 1) * 5 + (level >> 1);
		}

		//============Instance Variables============//
		protected var _team:PlayerTeam;

		protected var _customName:String;

		protected var _weapon:WeaponType;

		protected var _droneWeapon:WeaponType = GameRule.DEFAULT_DRONE_WEAPON;

		//====Graphics Variables====//
		protected var _lineColor:uint = 0x888888;
		protected var _fillColor:uint = 0xffffff;
		protected var _fillColor2:uint = 0xcccccc;

		protected var _GUI:PlayerGUI;

		protected var _carriedBlock:BlockCommon;

		//====Contol Variables====//
		// ContolDelay
		public var contolDelay_Move:uint = GlobalGameVariables.FIXED_TPS * 0.5;

		// public var contolDelay_Use:uint=GlobalGameVariables.TPS/4
		// public var contolDelay_Select:uint=GlobalGameVariables.TPS/5

		// ContolLoop
		public var contolLoop_Move:uint = GlobalGameVariables.FIXED_TPS * 0.05;

		// public var contolLoop_Use:uint=GlobalGameVariables.TPS/25
		// public var contolLoop_Select:uint=GlobalGameVariables.TPS/40

		// ContolKey
		public var contolKey_Up:uint;
		public var contolKey_Down:uint;
		public var contolKey_Left:uint;
		public var contolKey_Right:uint;
		public var contolKey_Use:uint;
		// public var ContolKey_Select_Left:uint;
		// public var ContolKey_Select_Right:uint;

		// isPress
		public var isPress_Up:Boolean;
		public var isPress_Down:Boolean;
		public var isPress_Left:Boolean;
		public var isPress_Right:Boolean;
		public var isPress_Use:Boolean;
		// public var isPress_Select_Left:Boolean;
		// public var isPress_Select_Right:Boolean;

		// KeyDelay
		public var keyDelay_Move:int;
		// public var keyDelay_Use:int;
		// public var keyDelay_Select:int;

		//========Custom Variables========//
		// Health
		protected var _health:uint = DEFAULT_HEALTH;

		protected var _maxHealth:uint = DEFAULT_MAX_HEALTH;

		protected var _heal:uint = 0;

		protected var _lifes:uint = 10;

		protected var _infinityLife:Boolean = true;

		// Weapon
		protected var _weaponUsingCD:uint = 0;

		protected var _weaponChargeTime:int = -1;

		protected var _weaponChargeMaxTime:uint = 0;

		// Respawn
		public var respawnTick:int = -1;

		// negative number means isn't respawning

		// Gameplay
		protected var _lastHurtbyPlayer:Player = null;

		protected var _stats:PlayerStats;

		protected var _damageDelay:int = 0;

		protected var _healDelay:uint = 0;

		//========Attributes========//
		public var moveDistence:uint = 1;

		public var invulnerable:Boolean = false;

		//====Experience====//
		protected var _experience:uint = 0;

		public function get experience():uint {
			return this._experience;
		}

		public function set experience(value:uint):void {
			while (value > this.uplevelExperience) {
				value -= this.uplevelExperience;
				this.level++;
				this.onLevelup();
			}
			this._experience = value;
			if (this._GUI != null)
				this._GUI.updateExperience();

		}

		/**
		 * If the experience up to uplevelExperience,level++
		 */
		protected var _level:uint = 0;

		public function get level():uint {
			return this._level;
		}

		public function set level(value:uint):void {
			this._level = value;
		}

		public function get uplevelExperience():uint {
			return Player.getUplevelExperience(this._level);
		}

		public function get experiencePercent():Number {
			return this._experience / this.uplevelExperience;
		}

		//====Buff====//

		/**
		 * The EXTRA power of Damage
		 * #TotalDamage=WeaponDamage+buff*WeaponCoefficient
		 */
		protected var _buffDamage:uint = 0;

		public function get buffDamage():uint {
			return this._buffDamage;
		}

		public function set buffDamage(value:uint):void {
			this._buffDamage = value;
		}

		/**
		 * The EXTRA power of Weapon Usage CD
		 * #TotalCD=WeaponCD/(1+buff/10)
		 */
		protected var _buffCD:uint = 0;

		public function get buffCD():uint {
			return this._buffCD;
		}

		public function set buffCD(value:uint):void {
			this._buffCD = value;
		}

		/**
		 * The EXTRA power of Resistance
		 * #FinalDamage=TotalDamage-buff*WeaponCoefficient>0
		 */
		protected var _buffResistance:uint = 0;

		public function get buffResistance():uint {
			return this._buffResistance;
		}

		public function set buffResistance(value:uint):void {
			this._buffResistance = value;
		}

		/**
		 * The EXTRA power of Radius
		 * #FinalRadius=DefaultRadius*(1+buff/10)
		 */
		protected var _buffRadius:uint = 0;

		public function get buffRadius():uint {
			return this._buffRadius;
		}

		public function set buffRadius(value:uint):void {
			this._buffRadius = value;
		}

		//============Constructor Function============//
		public function Player(
				host:Game,
				x:Number,
				y:Number,
				team:PlayerTeam,
				contolKeyId:uint,
				isActive:Boolean = true,
				fillColor:Number = NaN,
				lineColor:Number = NaN):void {
			super(host, x, y, isActive);
			// Set Team
			this._team = team;
			// Set Stats
			this._stats = new PlayerStats(this);
			// Set Shape
			this.initColors(fillColor, lineColor);
			this.drawShape();
			// Set GUI And Effects
			this._GUI = new PlayerGUI(this);

			this.addChilds();

			// Set Contol Key
			this.initContolKey(contolKeyId);
			this.updateKeyDelay();
		}

		//============Destructor Function============//
		public override function deleteSelf():void {
			// Reset Key
			this.turnAllKeyUp();
			this.clearContolKeys();
			// Remove Display Object
			UsefulTools.removeChildIfContains(this._host.playerGUIContainer, this._GUI);
			// Remove Variables
			// Primitive
			this._customName = null;
			this._weaponUsingCD = 0;
			this._team = null;
			// Complex
			this._stats.deleteSelf();
			this._stats = null;
			this._lastHurtbyPlayer = null;
			this._weapon = null;
			this._GUI.deleteSelf();
			this._GUI = null;
			// Call Super Class
			super.deleteSelf();
		}

		//============Instance Getter And Setter============//
		public function get gui():PlayerGUI {
			return this._GUI;
		}

		/**
		 * Cannot using INT to return!
		 * Because it's on the center of block!
		 */
		public function get frontX():Number {
			return this.getFrontIntX(this.moveDistence);
		}

		/**
		 * Cannot using INT to return!
		 * Because it's on the center of block!
		 */
		public function get frontY():Number {
			return this.getFrontIntY(this.moveDistence);
		}

		public function get team():PlayerTeam {
			return this._team;
		}

		public function set team(value:PlayerTeam):void {
			if (value == this._team)
				return;
			this._team = value;
			this.initColors();
			this.drawShape();
			this._GUI.updateTeam();
			this._host.updateProjectilesColor();
		}

		public function get teamColor():uint {
			return this.team.defaultColor;
		}

		public function get stats():PlayerStats {
			return this._stats;
		}

		public function get weapon():WeaponType {
			return this._weapon;
		}

		/**
		 * This weapon is used by drones created from another weapon
		 */
		public function get droneWeapon():WeaponType {
			return this._droneWeapon;
		}

		public function set droneWeapon(value:WeaponType):void {
			this._droneWeapon = value;
		}

		/**
		 * Also Reset CD&Charge
		 */
		public function set weapon(value:WeaponType):void {
			if (value == this._weapon)
				return;
			this.resetCD();
			this.resetCharge(true, false);
			this.onWeaponChange(this._weapon, value);
			this._weapon = value;
		}

		public function get weaponUsingCD():uint {
			return this._weaponUsingCD;

		}

		public function set weaponUsingCD(value:uint):void {
			if (value == this._weaponUsingCD)
				return;

			this._weaponUsingCD = value;

			this._GUI.updateCD();

		}

		public function get weaponChargeTime():int {
			return this._weaponChargeTime;

		}

		public function set weaponChargeTime(value:int):void {
			if (value == this._weaponChargeTime)
				return;

			this._weaponChargeTime = value;

			this._GUI.updateCharge();

		}

		public function get weaponChargeMaxTime():uint {
			return this._weaponChargeMaxTime;

		}

		public function set weaponChargeMaxTime(value:uint):void {
			if (value == this._weaponChargeMaxTime)
				return;

			this._weaponChargeMaxTime = value;

			this._GUI.updateCharge();

		}

		public function get weaponNeedsCD():Boolean {
			if (this._weapon == null)
				return false;

			return this.weaponMaxCD > 0;

		}

		public function get weaponMaxCD():Number {
			return this._host.rule.weaponsNoCD ? GlobalGameVariables.WEAPON_MIN_CD : this._weapon.getBuffedCD(this.buffCD);
		}

		public function get weaponReverseCharge():Boolean {
			return this._weapon.reverseCharge;
		}

		public function get weaponCDPercent():Number {
			if (!this.weaponNeedsCD)
				return 1;

			return this._weaponUsingCD / this.weaponMaxCD;

		}

		public function get weaponNeedsCharge():Boolean {
			if (this._weapon == null)
				return false;

			return this._weapon.defaultChargeTime > 0;

		}

		public function get isCharging():Boolean {
			if (!this.weaponNeedsCharge)
				return false;

			return this._weaponChargeTime >= 0;

		}

		public function get chargingPercent():Number  { // 0~1
			if (!this.weaponNeedsCharge)
				return 1;

			if (!this.isCharging)
				return 0;

			return this._weaponChargeTime / this._weaponChargeMaxTime;

		}

		// Color
		public function get lineColor():uint {
			return this._lineColor;

		}

		public function get fillColor():uint {
			return this._fillColor;

		}

		// Health,MaxHealth,Life&Respawn
		public function get health():uint {
			return this._health;

		}

		public function set health(value:uint):void {
			if (value == this._health)
				return;

			this._health = Math.min(value, this._maxHealth);

			if (this._GUI != null)
				this._GUI.updateHealth();

		}

		public function get maxHealth():uint {
			return this._maxHealth;

		}

		public function set maxHealth(value:uint):void {
			if (value == this._maxHealth)
				return;

			this._maxHealth = value;

			if (value < this._health)
				this._health = value;

			this._GUI.updateHealth();

		}

		public function get isFullHealth():Boolean {
			return this._health >= this._maxHealth;

		}

		public function get heal():uint {
			return this._heal;

		}

		public function set heal(value:uint):void {
			if (value == this._heal)
				return;

			this._heal = value;

			this._GUI.updateHealth();

		}

		public function get lifes():uint {
			return this._lifes;

		}

		public function set lifes(value:uint):void {
			if (value == this._lifes)
				return;

			this._lifes = value;

			this._GUI.updateHealth();

		}

		public function get infinityLife():Boolean {
			return this._infinityLife;

		}

		public function set infinityLife(value:Boolean):void {
			if (value == this._infinityLife)
				return;

			this._infinityLife = value;

			this._GUI.updateHealth();

		}

		public function get isRespawning():Boolean {
			return this.respawnTick >= 0;

		}

		public function get healthPercent():Number {
			return this.health / this.maxHealth;

		}

		public function get isCertainlyOut():Boolean {
			return this.lifes == 0 && this.health == 0 && !this.isActive;
		}

		// Display for GUI
		public function get healthText():String {
			var healthText:String = this._health + "/" + this._maxHealth;

			var healText:String = this._heal > 0 ? "<" + this._heal + ">" : "";

			var lifeText:String = this._infinityLife ? "" : "[" + this._lifes + "]";

			return healthText + healText + lifeText;

		}

		public function get customName():String {
			return this._customName;

		}

		public function set customName(value:String):void {
			if (value == this._customName)
				return;

			this._customName = value;

			this._GUI.updateName();

		}

		// Other
		public function get lastHurtbyPlayer():Player {
			return this._lastHurtbyPlayer;

		}

		// Key&Control
		public function get someKeyDown():Boolean {
			return (this.isPress_Up ||
					this.isPress_Down ||
					this.isPress_Left ||
					this.isPress_Right ||
					this.isPress_Use /*||
					this.isPress_Select_Left||
					this.isPress_Selec_Right*/);

		}

		public function get someMoveKeyDown():Boolean {
			return (this.isPress_Up ||
					this.isPress_Down ||
					this.isPress_Left ||
					this.isPress_Right);

		}
		/*
		public function get someSelectKeyDown():Boolean {
			return (this.isPress_Select_Left||this.isPress_Selec_Right)
		}*/

		public function set pressLeft(turn:Boolean):void {
			this.isPress_Left = turn;

		}

		public function set pressRight(turn:Boolean):void {
			this.isPress_Right = turn;

		}

		public function set pressUp(turn:Boolean):void {
			this.isPress_Up = turn;

		}

		public function set pressDown(turn:Boolean):void {
			this.isPress_Down = turn;

		}

		public function set pressUse(turn:Boolean):void {
			if (this.isPress_Use && !turn) {
				this.isPress_Use = turn;

				if (isCharging)
					this.onDisableCharge();

				return;

			}
			this.isPress_Use = turn;

		}

		/*public function set pressLeftSelect(turn:Boolean):void {
			this.isPress_Select_Left=turn
		}
		
		public function set pressRightSelect(turn:Boolean):void {
			this.isPress_Select_Right=turn
		}*/

		// Entity Type
		public override function get type():EntityType {
			return EntityType.PLAYER;

		}

		//============Instance Functions============//
		//====Functions About Rule====//

		/**
		 * This function init the variables without update when this Player has been created.
		 * @param	weaponID	invaild number means random.
		 * @param	uniformWeapon	The uniform weapon
		 */
		public function initVariablesByRule(weaponID:int, uniformWeapon:WeaponType = null):void {
			// Health&Life
			this._maxHealth = this._host.rule.defaultMaxHealth;

			this._health = this._host.rule.defaultHealth;

			this.setLifeByInt(this is AIPlayer ? this._host.rule.remainLifesAI : this._host.rule.remainLifesPlayer);

			// Weapon
			if (weaponID < -1)
				this._weapon = this.host.rule.randomWeaponEnable;
			else if (!WeaponType.isValidAvailableWeaponID(weaponID) && uniformWeapon != null)
				this._weapon = uniformWeapon;
			else
				this._weapon = WeaponType.fromWeaponID(weaponID);

		}

		//====Functions About Health====//
		public function addHealth(value:uint, healer:Player = null):void {
			this.health += value;

			this.onHeal(value, healer);

		}

		public function removeHealth(value:uint, attacker:Player = null):void {
			if (invulnerable)
				return;
			this._lastHurtbyPlayer = attacker;
			if (health > value) {
				this.health -= value;
				this.onHurt(value, attacker);
			}
			else {
				this.health = 0;
				this.onDeath(health, attacker);
			}
		}

		public function setLifeByInt(lifes:Number):void {
			this._infinityLife = (lifes < 0);
			if (this._lifes >= 0)
				this._lifes = lifes;
		}

		//====Functions About Hook====//
		protected function onHeal(amount:uint, healer:Player = null):void {

		}

		protected function onHurt(damage:uint, attacker:Player = null):void {
			// this._hurtOverlay.playAnimation();
			this._host.addPlayerHurtEffect(this);
			this._host.onPlayerHurt(attacker, this, damage);
		}

		protected function onDeath(damage:uint, attacker:Player = null):void {
			this._host.onPlayerDeath(attacker, this, damage);
			if (attacker != null)
				attacker.onKillPlayer(this, damage);
		}

		protected function onKillPlayer(victim:Player, damage:uint):void {
			if (victim != this && !this.isRespawning)
				this.experience++;
		}

		protected function onRespawn():void {

		}

		public function onMapTransform():void {
			this.resetCD();
			this.resetCharge(false);
		}

		public function onPickupBonusBox(box:BonusBox):void {

		}

		public override function preLocationUpdate(oldX:Number, oldY:Number):void {
			this._host.prePlayerLocationChange(this, oldX, oldY);
			super.preLocationUpdate(oldX, oldY);
		}

		public override function onLocationUpdate(newX:Number, newY:Number):void {
			if (this._GUI != null) {
				this._GUI.entityX = this.entityX;
				this._GUI.entityY = this.entityY;
			}
			this._host.onPlayerLocationChange(this, newX, newY);
			super.onLocationUpdate(newX, newY);
		}

		public function onLevelup():void {
			this._host.onPlayerLevelup(this);
		}

		//====Functions About Gameplay====//

		/**
		 * @param	player	The target palyer.
		 * @param	weapon	The weapon.
		 * @return	If player can hurt target with this weapon.
		 */
		public function canUseWeaponHurtPlayer(player:Player, weapon:WeaponType):Boolean {
			return (isEnemy(player) && weapon.weaponCanHurtEnemy ||
					isSelf(player) && weapon.weaponCanHurtSelf ||
					isAlly(player) && weapon.weaponCanHurtAlly);

		}

		public function filterPlayersThisCanHurt(players:Vector.<Player>, weapon:WeaponType):Vector.<Player> {
			return players.filter(
					function(player:Player, index:int, vector:Vector.<Player>) {
						return this.canUseWeaponHurtPlayer(player, weapon);
					}, this
				);
		}

		public function isEnemy(player:Player):Boolean {
			return (!isAlly(player, true));

		}

		public function isSelf(player:Player):Boolean {
			return player === this;

		}

		public function isAlly(player:Player, includeSelf:Boolean = false):Boolean {
			return player != null && ((includeSelf || !isSelf(player)) &&
					this.team === player.team);

		}

		public function get carriedBlock():BlockCommon {
			return this._carriedBlock;

		}

		public function get isCarriedBlock():Boolean {
			return this._carriedBlock != null && this._carriedBlock.visible;

		}

		public function dealMoveInTestOnLocationChange(x:Number, y:Number, ignoreDelay:Boolean = false, isLocationChange:Boolean = false):void {
			this.dealMoveInTest(x, y, ignoreDelay, isLocationChange);

		}

		public function dealMoveInTest(x:Number, y:Number, ignoreDelay:Boolean = false, isLocationChange:Boolean = false):void {
			if (ignoreDelay) {
				this._host.moveInTestPlayer(this, isLocationChange);
				this._damageDelay = MAX_DAMAGE_DELAY;
			}
			else if (this._damageDelay > 0) {
				this._damageDelay--;
			}
			else if (this._damageDelay == 0 && this._host.moveInTestPlayer(this, isLocationChange)) {
				this._damageDelay = MAX_DAMAGE_DELAY;
			}
			else if (this._damageDelay > -1) {
				this._damageDelay = -1;
			}
		}

		public function dealHeal():void {
			if (this._heal < 1)
				return;
			if (this._healDelay > GlobalGameVariables.TPS * (0.1 + this.healthPercent * 0.15)) {
				if (this.isFullHealth)
					return;
				this._healDelay = 0;
				this._heal--;
				this.health++;
			}
			else {
				this._healDelay++;
			}
		}

		//====Functions About Respawn====//
		public function dealRespawn():void {
			if (this.respawnTick > 0)
				this.respawnTick--;

			else {
				this.respawnTick = -1;
				if (!this._infinityLife && this._lifes > 0)
					this._lifes--;
				this._host.onPlayerRespawn(this);
				this.onRespawn();
			}
		}

		//====Functions About Weapon====//
		protected function onWeaponChange(oldType:WeaponType, newType:WeaponType):void {
			this.initWeaponCharge();
			this.resetCharge(false);
			// Change Drone Weapon
			if (WeaponType.isDroneWeapon(newType)) {
				if (WeaponType.isBulletWeapon(oldType))
					this._droneWeapon = WeaponType.BULLET;
				else if (!WeaponType.isAvailableDroneNotUse(oldType))
					this._droneWeapon = oldType;
				else
					this._droneWeapon = GameRule.DEFAULT_DRONE_WEAPON;
			}
			// If The Block is still carring,then throw without charge(WIP,maybe?)
		}

		protected function dealUsingCD():void {
			// trace(this.weapon.name,this._weaponChargeTime,this._weaponChargeMaxTime)
			if (this._weaponUsingCD > 0) {
				this._weaponUsingCD--;
				this._GUI.updateCD();
			}
			else {
				if (!this.weaponNeedsCharge) {
					if (this.isPress_Use)
						this.useWeapon();
				}
				else if (this._weaponChargeTime < 0) {
					this.initWeaponCharge();
				}
				else {
					if (this.weaponReverseCharge) {
						this.dealWeaponReverseCharge();
					}
					else if (this.isPress_Use) {
						this.dealWeaponCharge();
					}
				}
			}
		}

		protected function dealWeaponCharge():void {
			if (this._weaponChargeTime >= this._weaponChargeMaxTime) {
				this.useWeapon();
				this.resetCharge(false, false);
			}
			else
				this._weaponChargeTime++;
			this._GUI.updateCharge();
		}

		protected function dealWeaponReverseCharge():void {
			if (this.weaponChargeTime < this.weaponChargeMaxTime) {
				this._weaponChargeTime++;
			}
			if (this.isPress_Use) {
				this.useWeapon();
				this.resetCharge(false, false);
			}
			this._GUI.updateCharge();
		}

		protected function onDisableCharge():void {
			if (!this.weaponNeedsCharge || this._weaponUsingCD > 0 || !this.isActive || this.isRespawning)
				return;
			this.useWeapon();
			this.resetCharge();
		}

		public function initWeaponCharge():void {
			this._weaponChargeTime = 0;
			this._weaponChargeMaxTime = this._weapon.defaultChargeTime;
		}

		public function resetCharge(includeMaxTime:Boolean = true, updateGUI:Boolean = true):void {
			this._weaponChargeTime = -1;
			if (includeMaxTime)
				this._weaponChargeMaxTime = 0;
			if (updateGUI)
				this._GUI.updateCharge();
		}

		public function resetCD():void {
			this._weaponUsingCD = 0;
			this._GUI.updateCD();
		}

		//====Functions About Attributes====//

		/**
		 * The Function returns the final damage with THIS PLAYER.
		 * FinalDamage=DefaultDamage+
		 * attacker.buffDamage*WeaponCoefficient-
		 * this.buffResistance*WeaponCoefficient>=0.
		 * @param	attacker	The attacker.
		 * @param	attackerWeapon	The attacker's weapon(null=attacker.weapon).
		 * @param	defaultDamage	The original damage by attacker.
		 * @return	The Final Damage.
		 */
		public final function computeFinalDamage(attacker:Player, attackerWeapon:WeaponType, defaultDamage:uint):uint {
			if (attacker == null)
				return attackerWeapon == null ? 0 : attackerWeapon.defaultDamage;
			if (attackerWeapon == null)
				attackerWeapon = attacker.weapon;
			if (attackerWeapon != null)
				return attackerWeapon.getBuffedDamage(defaultDamage, attacker.buffDamage, this.buffResistance);
			return 0;
		}

		public final function finalRemoveHealth(attacker:Player, attackerWeapon:WeaponType, defaultDamage:uint):void {
			this.removeHealth(this.computeFinalDamage(attacker, attackerWeapon, defaultDamage), attacker);
		}

		public final function computeFinalCD(weapon:WeaponType):uint {
			return weapon.getBuffedCD(this.buffCD);
		}

		public final function computeFinalRadius(defaultRadius:Number):Number {
			return defaultRadius * (1 + Math.min(this.buffRadius / 16, 3));
		}

		public final function computeFinalLightningEnergy(defaultEnergy:uint):int {
			return defaultEnergy * (1 + this._buffDamage / 20 + this._buffRadius / 10);

		}

		//====Functions About Graphics====//
		protected function drawShape(Alpha:Number = 1):void {
			var realRadiusX:Number = (SIZE - LINE_SIZE) / 2;
			var realRadiusY:Number = (SIZE - LINE_SIZE) / 2;
			graphics.clear();
			graphics.lineStyle(LINE_SIZE, this._lineColor);
			// graphics.beginFill(this._fillColor,Alpha);
			var m:Matrix = new Matrix();
			m.createGradientBox(GlobalGameVariables.DEFAULT_SIZE,
					GlobalGameVariables.DEFAULT_SIZE, 0, -realRadiusX, -realRadiusX);
			graphics.beginGradientFill(GradientType.LINEAR,
					[this._fillColor, this._fillColor2],
					[Alpha, Alpha],
					[63, 255],
					m,
					SpreadMethod.PAD,
					InterpolationMethod.RGB,
					1);
			graphics.moveTo(-realRadiusX, -realRadiusY);
			graphics.lineTo(realRadiusX, 0);
			graphics.lineTo(-realRadiusX, realRadiusY);
			graphics.lineTo(-realRadiusX, -realRadiusY);
			// graphics.drawCircle(0,0,10);
			graphics.endFill();
		}

		protected function initColors(fillColor:Number = NaN, lineColor:Number = NaN):void {
			// Deal fillColor
			if (isNaN(fillColor))
				this._fillColor = this._team.defaultColor;
			else
				this._fillColor = uint(fillColor);
			// Deal lineColor
			var HSV:Vector.<Number> = Color.HEXtoHSV(this._fillColor);
			this._fillColor2 = Color.HSVtoHEX(HSV[0], HSV[1], HSV[2] / 1.5);
			if (isNaN(lineColor)) {
				this._lineColor = Color.HSVtoHEX(HSV[0], HSV[1], HSV[2] / 2);
			}
			else
				this._lineColor = uint(lineColor);
		}

		public function setCarriedBlock(block:BlockCommon, copyBlock:Boolean = true):void {
			if (block == null) {
				this._carriedBlock.visible = false;
			}
			else {
				if (this._carriedBlock != null && this.contains(this._carriedBlock))
					this.removeChild(this._carriedBlock);
				this._carriedBlock = copyBlock ? block.clone() : block;
				this._carriedBlock.x = GlobalGameVariables.DEFAULT_SIZE / 2;
				this._carriedBlock.y = -GlobalGameVariables.DEFAULT_SIZE / 2;
				this._carriedBlock.alpha = CARRIED_BLOCK_ALPHA;
				this.addChild(this._carriedBlock);
			}
		}

		protected function addChilds():void {
			this._host.playerGUIContainer.addChild(this._GUI);
		}

		//====Tick Run Function====//
		public override function tickFunction():void {
			this.dealUsingCD();
			this.updateKeyDelay();
			this.dealKeyContol();
			this.dealMoveInTest(this.entityX, this.entityY, false, false);
			this.dealHeal();
			super.tickFunction();
		}

		//====Contol Functions====//
		public function initContolKey(id:uint):void {
			switch (id) {
				// AI
				case 0:
					return;
					break;
					// P1
				case 1:
					contolKey_Up = KeyCode.W; // Up:W
					contolKey_Down = KeyCode.S; // Down:S
					contolKey_Left = KeyCode.A; // Left:A
					contolKey_Right = KeyCode.D; // Right:D
					contolKey_Use = KeyCode.SPACE; // Use:Space
					break;
					// P2
				case 2:
					contolKey_Up = KeyCode.UP; // Up:Key_UP
					contolKey_Down = KeyCode.DOWN; // Down:Key_DOWN
					contolKey_Left = KeyCode.LEFT; // Left:Key_Left
					contolKey_Right = KeyCode.RIGHT; // Right:Key_RIGHT
					contolKey_Use = KeyCode.NUMPAD_0; // Use:"0"
					break;
					// P3
				case 3:
					contolKey_Up = KeyCode.U; // Up:U
					contolKey_Down = KeyCode.J; // Down:J
					contolKey_Left = KeyCode.H; // Left:H
					contolKey_Right = KeyCode.K; // Right:K
					contolKey_Use = KeyCode.RIGHT_BRACKET; // Use:"]"
					break;
					// P4
				case 4:
					contolKey_Up = KeyCode.NUMPAD_8; // Up:Num 5
					contolKey_Down = KeyCode.NUMPAD_5; // Down:Num 2
					contolKey_Left = KeyCode.NUMPAD_4; // Left:Num 1
					contolKey_Right = KeyCode.NUMPAD_6; // Right:Num 3
					contolKey_Use = KeyCode.NUMPAD_ADD; // Use:Num +
					break;
			}
		}

		public function isOwnContolKey(code:uint):Boolean {
			return (code == this.contolKey_Up ||
					code == this.contolKey_Down ||
					code == this.contolKey_Left ||
					code == this.contolKey_Right ||
					code == this.contolKey_Use /*||
					code==this.contolKey_Select_Left||
					code==this.contolKey_Selec_Right*/);
		}

		public function isOwnKeyDown(code:uint):Boolean {
			return (code == this.contolKey_Up && this.isPress_Up ||
					code == this.contolKey_Down && this.isPress_Down ||
					code == this.contolKey_Left && this.isPress_Left ||
					code == this.contolKey_Right && this.isPress_Right ||
					code == this.contolKey_Use && this.isPress_Use /*||
					code==this.contolKey_Select_Left||
					code==this.contolKey_Selec_Right*/);
		}

		public function clearContolKeys():void {
			contolKey_Up = KeyCode.EMPTY;
			contolKey_Down = KeyCode.EMPTY;
			contolKey_Left = KeyCode.EMPTY;
			contolKey_Right = KeyCode.EMPTY;
			contolKey_Use = KeyCode.EMPTY;
		}

		public function turnAllKeyUp():void {
			this.isPress_Up = false;
			this.isPress_Down = false;
			this.isPress_Left = false;
			this.isPress_Right = false;
			this.isPress_Use = false;
			// this.isPress_Select_Left=false;
			// this.isPress_Select_Right=false;
			this.keyDelay_Move = 0;
			this.contolDelay_Move = GlobalGameVariables.FIXED_TPS * 0.5;
			// this.contolDelay_Select=GlobalGameVariables.TPS/5;
			this.contolLoop_Move = GlobalGameVariables.FIXED_TPS * 0.05;
			// this.contolLoop_Select=GlobalGameVariables.TPS/40;
		}

		public function updateKeyDelay():void {
			// trace(this.keyDelay_Move,this.contolDelay_Move,this.contolLoop_Move);
			//==Set==//
			// Move
			if (this.someMoveKeyDown) {
				this.keyDelay_Move++;
				if (this.keyDelay_Move >= this.contolLoop_Move) {
					this.keyDelay_Move = 0;
				}
			}
			else {
				this.keyDelay_Move = -contolDelay_Move;
			}
		}

		public function runActionByKeyCode(code:uint):void {
			if (!this.isActive || this.isRespawning)
				return;
			switch (code) {
				case this.contolKey_Up:
					this.moveUp();
					break;
				case this.contolKey_Down:
					this.moveDown();
					break;
				case this.contolKey_Left:
					this.moveLeft();
					break;
				case this.contolKey_Right:
					this.moveRight();
					break;
				case this.contolKey_Use:
					if (!this.weaponReverseCharge)
						this.useWeapon();
					break;
					/*case this.contolKey_Select_Left:
					this.moveSelect_Left();
				break;
				case this.contolKey_Select_Right:
					this.moveSelect_Right();
				break;*/
			}
		}

		public function dealKeyContol():void {
			if (!this.isActive || this.isRespawning)
				return;
			if (this.someKeyDown) {
				// Move
				if (this.keyDelay_Move == 0) {
					// Up
					if (this.isPress_Up) {
						this.moveUp();
					}
					// Down
					else if (this.isPress_Down) {
						this.moveDown();
					}
					// Left
					else if (this.isPress_Left) {
						this.moveLeft();
					}
					// Right
					else if (this.isPress_Right) {
						this.moveRight();
					}
				} /*
				//Select_Left
				if(this.keyDelay_Select==0) {
					//Select_Right
					if(this.isPress_Select_Right) {
						this.SelectRight();
					}
					else if(this.isPress_Select_Left) {
						this.SelectLeft();
					}
				}*/
			}
		}

		public override function moveForward(distance:Number = 1):void {
			if (this.isRespawning)
				return;
			switch (this.rot) {
				case GlobalRot.RIGHT:
					moveRight();
					break;

				case GlobalRot.LEFT:
					moveLeft();
					break;

				case GlobalRot.UP:
					moveUp();
					break;

				case GlobalRot.DOWN:
					moveDown();
					break;

			}
		}

		public override function moveIntForward(distance:Number = 1):void {
			moveForward(distance);
		}

		public function moveLeft():void {
			this._host.movePlayer(this, GlobalRot.LEFT, this.moveDistence);
		}

		public function moveRight():void {
			this._host.movePlayer(this, GlobalRot.RIGHT, this.moveDistence);
		}

		public function moveUp():void {
			this._host.movePlayer(this, GlobalRot.UP, this.moveDistence);
		}

		public function moveDown():void {
			this._host.movePlayer(this, GlobalRot.DOWN, this.moveDistence);
		}

		public function turnUp():void {
			this.rot = GlobalRot.UP;
		}

		public function turnDown():void {
			this.rot = GlobalRot.DOWN;
		}

		public function turnAbsoluteLeft():void {
			this.rot = GlobalRot.LEFT;
		}

		public function turnAbsoluteRight():void {
			this.rot = GlobalRot.RIGHT;
		}

		public function turnBack():void {
			this.rot += 2;
		}

		public function turnRelativeLeft():void {
			this.rot += 3;
		}

		public function turnRelativeRight():void {
			this.rot += 1;
		}

		public function useWeapon():void {
			if (!this.weaponNeedsCharge || this.chargingPercent > 0) {
				this._host.playerUseWeapon(this, this.rot, this.chargingPercent);
			}
			if (this.weaponNeedsCharge)
				this._GUI.updateCharge();
		}
	}
}
