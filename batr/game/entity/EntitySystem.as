package batr.game.entity {

	import batr.common.*;

	import batr.game.entity.*;
	import batr.game.entity.entities.*;
	import batr.game.entity.entities.players.*;
	import batr.game.entity.entities.projectiles.*;
	import batr.game.main.*;

	import flash.utils.Dictionary;

	/**
	 * Use for manage entities in game.
	 */
	public class EntitySystem {
		//============Static Variables============//

		//============Instance Variables============//
		protected var _host:Game;

		// UUID

		/**
		 * The UUID Process to system.
		 * getEntityByUUID(this._headUUID) usual equals null.
		 */
		private var _headUUID:uint = 1;
		private var _uuidDic:Dictionary = new Dictionary(true);

		protected var _entities:Vector.<EntityCommon> = new Vector.<EntityCommon>;
		protected var _players:Vector.<Player> = new Vector.<Player>;
		protected var _projectiles:Vector.<ProjectileCommon> = new Vector.<ProjectileCommon>;
		protected var _bonusBoxes:Vector.<BonusBox> = new Vector.<BonusBox>;

		//============Constructor Function============//
		public function EntitySystem(host:Game):void {
			this._host = host;

		}

		//============Destructor Function============//
		public function deleteSelf():void {
			this.removeAllEntity();
			this._entities = null;

			this._players = null;

			this._projectiles = null;

			this._bonusBoxes = null;

			this._host = null;

		}

		//============Instance Getters And Setters============//
		public function get host():Game {
			return this._host;
		}

		public function get entities():Vector.<EntityCommon> {
			return this._entities;
		}

		public function get players():Vector.<Player> {
			return this._players;
		}

		public function get projectiles():Vector.<ProjectileCommon> {
			return this._projectiles;
		}

		public function get bonusBoxes():Vector.<BonusBox> {
			return this._bonusBoxes;
		}

		public function get entityCount():uint {
			if (this._entities == null)
				return 0;
			return this._entities.length;
		}

		public function get playerCount():uint {
			if (this._players == null)
				return 0;
			return this._players.length;
		}

		public function get AICount():uint {
			if (this._players == null)
				return 0;
			var rU:uint;
			for each (var player:Player in this._players) {
				if (Player.isAI(player))
					rU++;
			}
			return rU;
		}

		public function get projectileCount():uint {
			if (this._projectiles == null)
				return 0;
			return this._projectiles.length;
		}

		public function get bonusBoxCount():uint {
			if (this._bonusBoxes == null)
				return 0;
			return this._bonusBoxes.length;
		}

		//============Instance Functions============//
		// UUID About

		/**
		 * Find next empty UUID,let getEntityByUUID(this._headUUID)==null
		 * @return
		 */
		public function nextUUID():uint {
			while (getEntityByUUID(++this._headUUID) == null && isValidUUID(this._headUUID)) {
				return this._headUUID;
			}
			return 0;
		}

		public function getEntityByUUID(uuid:uint):EntityCommon {
			return (this._uuidDic[uuid] as EntityCommon);
		}

		public function getUUIDByEntity(entity:EntityCommon):uint {
			return uint(this._uuidDic[entity]);
		}

		/**
		 * Use for loop to register UUID for entity.
		 * @param	uuid	needed UUID
		 * @return	if uuid!=0
		 */
		public function isValidUUID(uuid:uint):Boolean {
			return uuid > 0;
		}

		public function hasValidEntity(uuid:uint):Boolean {
			return this.isValidUUID(uuid) && this.getEntityByUUID(uuid) != null;
		}

		public function hasValidUUID(entity:EntityCommon):Boolean {
			return entity != null && this.isValidUUID(this.getUUIDByEntity(entity));
		}

		public function getAllEntity():Vector.<EntityCommon> {
			var result:Vector.<EntityCommon> = new Vector.<EntityCommon>();
			for each (var obj:Object in this._uuidDic) {
				if (obj != null && obj is EntityCommon)
					result.push(obj as EntityCommon);
			}
			return result;
		}

		public function getAllUUID():Vector.<uint> {
			var result:Vector.<uint> = new Vector.<uint>();
			for each (var obj:Object in this._uuidDic) {
				if (obj != null && obj is uint && isValidUUID(obj as uint))
					result.push(obj as uint);
			}
			return result;
		}

		public function registerEntityforUUID(entity:EntityCommon):Boolean {
			if (entity == null)
				return false;
			var uuid:uint = this.nextUUID();
			if (this.isValidUUID(uuid)) {
				this._uuidDic[entity] = uuid;
				this._uuidDic[uuid] = entity;
				return true;
			}
			return false;
		}

		public function cencellEntityforUUID(entity:EntityCommon):Boolean {
			var uuid:uint = this.getUUIDByEntity(entity);
			if (this.isValidUUID(uuid)) {
				this._uuidDic[entity] = 0;
				this._uuidDic[uuid] = null;
				return true;
			}
			return false;
		}

		// Ealier System Functions
		public function GC():void {
			if (this._entities == null)
				return;
			// Entity
			while (this._entities.indexOf(null) >= 0) {
				this._entities.splice(this._entities.indexOf(null), 1);
			}
			// Player
			while (this._players.indexOf(null) >= 0) {
				this._players.splice(this._players.indexOf(null), 1);
			}
			// Projectiles
			while (this._projectiles.indexOf(null) >= 0) {
				this._projectiles.splice(this._projectiles.indexOf(null), 1);
			}
			// BonusBox
			while (this._bonusBoxes.indexOf(null) >= 0) {
				this._bonusBoxes.splice(this._bonusBoxes.indexOf(null), 1);
			}
		}

		// Register,Cencell and Remove
		public function isRegisteredEntity(entity:EntityCommon):Boolean {
			// List
			/*return this._entities.some(
			function(e2:EntityCommon,i:uint,v:Vector.<EntityCommon>) {
				return e2==entity
			})*/
			// UUIDMap
			return this.hasValidUUID(entity);

		}

		public function registerEntity(entity:EntityCommon):Boolean {
			if (entity == null || isRegisteredEntity(entity))
				return false;

			// List
			this._entities.push(entity);

			// UUIDMap
			if (!this.hasValidUUID(entity))
				this.registerEntityforUUID(entity);
			return true;

		}

		public function cencellEntity(entity:EntityCommon):Boolean {
			if (entity == null || !isRegisteredEntity(entity))
				return false;

			// List
			this._entities.splice(this._entities.indexOf(entity), 1);

			// UUIDMap
			if (this.hasValidUUID(entity))
				this.cencellEntityforUUID(entity);
			return true;

		}

		public function removeEntity(entity:EntityCommon):void {
			if (entity == null)
				return;
			entity.deleteSelf();
			this.cencellEntity(entity);
			if (entity is Player)
				this.cencellPlayer(entity as Player);
			if (entity is ProjectileCommon)
				this.cencellProjectile(entity as ProjectileCommon);
			if (entity is BonusBox)
				this.cencellBonusBox(entity as BonusBox);
			UsefulTools.removeChildIfContains(this._host.playerContainer, entity);
			UsefulTools.removeChildIfContains(this._host.projectileContainer, entity);
			UsefulTools.removeChildIfContains(this._host.bonusBoxContainer, entity);
		}

		/**
		 * Remove All Entity!
		 */
		public function removeAllEntity():void {
			while (this._entities.length > 0) {
				this.removeEntity(this._entities[0]);

			}
			// Reset UUID Head
			this._headUUID = 0;
			// this._uuidDic=new Dictionary(true);
		}

		public function isRegisteredPlayer(player:Player):Boolean {
			// List
			return this._players.some(
					function(p2:Player, i:uint, v:Vector.<Player>) {
						return p2 == player;

					});

		}

		public function registerPlayer(player:Player):Boolean {
			if (player == null || isRegisteredEntity(player))
				return false;

			registerEntity(player);

			this._players.push(player);

			return true;

		}

		public function cencellPlayer(player:Player):Boolean {
			if (player == null || !isRegisteredPlayer(player))
				return false;

			this._players.splice(this._players.indexOf(player), 1);

			this.cencellEntity(player);

			return true;

		}

		public function removePlayer(player:Player):void {
			this.cencellPlayer(player);

			this.removeEntity(player);

		}

		public function removeAllPlayer():void {
			while (this._players.length > 0) {
				this.removePlayer(this._players[0]);

			}
		}

		public function isRegisteredProjectile(projectile:ProjectileCommon):Boolean {
			// List
			return this._projectiles.some(
					function(p2:ProjectileCommon, i:uint, v:Vector.<ProjectileCommon>) {
						return p2 == projectile;

					});

		}

		public function registerProjectile(projectile:ProjectileCommon):Boolean {
			if (projectile == null || isRegisteredEntity(projectile))
				return false;

			this.registerEntity(projectile);

			this._projectiles.push(projectile);

			return true;

		}

		public function cencellProjectile(projectile:ProjectileCommon):Boolean {
			if (projectile == null || !isRegisteredProjectile(projectile))
				return false;

			this._projectiles.splice(this._projectiles.indexOf(projectile), 1);

			cencellEntity(projectile);

			return true;

		}

		public function removeProjectile(projectile:ProjectileCommon):void {
			this.cencellProjectile(projectile);

			this.removeEntity(projectile);

		}

		public function removeAllProjectile():void {
			while (this._projectiles.length > 0) {
				this.removeProjectile(this._projectiles[0]);

			}
		}

		public function isRegisteredBonusBox(bonusBox:BonusBox):Boolean {
			// List
			return this._bonusBoxes.some(
					function(p2:BonusBox, i:uint, v:Vector.<BonusBox>) {
						return p2 == bonusBox;

					});

		}

		public function registerBonusBox(bonusBox:BonusBox):Boolean {
			if (bonusBox == null || isRegisteredBonusBox(bonusBox))
				return false;

			this.registerEntity(bonusBox);

			this._bonusBoxes.push(bonusBox);

			return true;

		}

		public function cencellBonusBox(bonusBox:BonusBox):Boolean {
			if (bonusBox == null || !isRegisteredBonusBox(bonusBox))
				return false;

			this._bonusBoxes.splice(this._bonusBoxes.indexOf(bonusBox), 1);

			this.cencellEntity(bonusBox);

			return true;

		}

		public function removeBonusBox(bonusBox:BonusBox):void {
			this.cencellBonusBox(bonusBox);

			this.removeEntity(bonusBox);

		}

		public function removeAllBonusBox():void {
			while (this._bonusBoxes.length > 0) {
				this.removeBonusBox(this._bonusBoxes[0]);

			}
		}
	}
}