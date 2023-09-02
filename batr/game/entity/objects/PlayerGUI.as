package batr.game.entity.objects {

	import batr.game.entity.entities.players.*;
	import batr.general.*;

	import flash.display.*;
	import flash.text.*;
	/*
	 * It's A GUI Attach to Player(x=0,y=0)
	 * */
	public class PlayerGUI extends Sprite {
		//============Static Variables============//
		// Display Color
		public static const HEALTH_COLOR:uint = 0xff0000;
		public static const HEALTH_BAR_FRAME_COLOR:uint = 0xbbbbbb;
		public static const CHARGE_COLOR:uint = 0x88ffff;
		public static const CHARGE_BAR_FRAME_COLOR:uint = 0xaadddd;
		public static const CD_COLOR:uint = 0x88ff88;
		public static const CD_BAR_FRAME_COLOR:uint = 0xaaddaa;
		public static const EXPERIENCE_COLOR:uint = 0xcc88ff;
		public static const EXPERIENCE_BAR_FRAME_COLOR:uint = 0xbbaadd;
		public static const LEVEL_COLOR:uint = 0x8800ff;

		// Display Graphics
		public static const HEALTH_BAR_HEIGHT:Number = GlobalGameVariables.DEFAULT_SIZE / 10;
		public static const BAR_FRAME_SIZE:Number = GlobalGameVariables.DEFAULT_SIZE / 320;
		public static const UNDER_BAR_HEIGHT:Number = GlobalGameVariables.DEFAULT_SIZE / 16;
		public static const UNDER_BAR_Y_0:Number = 0.5 * GlobalGameVariables.DEFAULT_SIZE;
		public static const UNDER_BAR_Y_1:Number = UNDER_BAR_Y_0 + UNDER_BAR_HEIGHT;
		public static const UNDER_BAR_Y_2:Number = UNDER_BAR_Y_1 + UNDER_BAR_HEIGHT;

		// Display Texts
		public static const EXPERIENCE_FORMAT:TextFormat = new TextFormat(
				GlobalGameVariables.MAIN_FONT.fontName,
				0.4 * GlobalGameVariables.DEFAULT_SIZE,
				LEVEL_COLOR, true,
				null, null, null, null,
				TextFormatAlign.CENTER
			);
		public static const LEVEL_TEXT_HEAD:String = "Lv.";

		//============Instance Functions============//
		public static function getUnderBarY(barNum:uint = 0):Number {
			var result:Number = UNDER_BAR_Y_0;
			while (barNum > 0) {
				result += UNDER_BAR_HEIGHT;
				barNum--;
			}
			return result;
		}

		//============Instance Variables============//
		protected var _owner:Player;

		// Texts
		protected var _healthBarFormat:TextFormat = new TextFormat();
		protected var _nameTagFormat:TextFormat = new TextFormat();

		// Graphics
		protected var _pointerTriangle:Shape = new Shape();
		protected var _healthBarHealth:Shape = new Shape();
		protected var _healthBarFrame:Shape = new Shape();
		protected var _chargeBarCharge:Shape = new Shape();
		protected var _chargeBarFrame:Shape = new Shape();
		protected var _CDBarCD:Shape = new Shape();
		protected var _CDBarFrame:Shape = new Shape();
		protected var _experienceBarExperience:Shape = new Shape();
		protected var _experienceBarFrame:Shape = new Shape();

		protected var _healthBarText:TextField = new TextField();
		protected var _nameTagText:TextField = new TextField();
		protected var _levelText:TextField = new TextField();

		//============Constructor Function============//
		public function PlayerGUI(owner:Player):void {
			// Set Owner
			this._owner = owner;
			// Set Graphics
			this.setFormats();
			this.drawShape();
			this.setFromatsToFields();
			this.update();
			this.addChilds();
		}

		//============Instance Getter And Setter============//
		public function get owner():Player {
			return this._owner;
		}

		public function get entityX():Number {
			return PosTransform.realPosToLocalPos(this.x);
		}

		public function get entityY():Number {
			return PosTransform.realPosToLocalPos(this.y);
		}

		public function set entityX(value:Number):void {
			if (value == this.entityX)
				return;
			this.x = PosTransform.localPosToRealPos(value);
		}

		public function set entityY(value:Number):void {
			if (value == this.entityY)
				return;
			this.y = PosTransform.localPosToRealPos(value);
		}

		public function getVisibleCD(player:Boolean = true):Boolean {
			if (player)
				return this._owner.weaponNeedsCD && this._owner.weaponCDPercent > 0;
			return this._CDBarFrame.visible;
		}

		public function getVisibleCharge(player:Boolean = true):Boolean {
			if (player)
				return this._owner.isCharging;
			return this._chargeBarFrame.visible;
		}

		public function getVisibleExperience(player:Boolean = true):Boolean {
			if (player)
				return true;
			return this._experienceBarFrame.visible;
		}

		//============Instance Functions============//
		public function update():void {
			this.updateHealth();
			this.updateCD(false);
			this.updateCharge(false);
			this.updateExperience(false);
			this.sortUnderBars();
			this.updateName();
			this.updateTeam();
		}

		public function updateName():void {
			if (this._owner == null)
				return;
			this._nameTagText.text = this._owner.customName == null ? "" : this._owner.customName;
		}

		public function updateTeam():void {
			if (this._owner == null)
				return;
			this.drawPointerTriangle(this._pointerTriangle.graphics);
			this._nameTagText.textColor = this._owner.lineColor;
		}

		public function updateHealth():void {
			if (this._owner == null)
				return;
			this._healthBarHealth.scaleX = this._owner.healthPercent;
			this._healthBarText.text = this._owner.healthText == null ? "" : this._owner.healthText;
		}

		public function updateCharge(sort:Boolean = true):void {
			if (this._owner == null)
				return;
			this._chargeBarCharge.visible = this._chargeBarFrame.visible = this.getVisibleCharge();
			if (sort)
				sortUnderBars();
			this._chargeBarCharge.scaleX = this._owner.chargingPercent;
		}

		public function updateCD(sort:Boolean = true):void {
			if (this._owner == null)
				return;
			this._CDBarCD.visible = this._CDBarFrame.visible = this.getVisibleCD();
			if (sort)
				sortUnderBars();
			this._CDBarCD.scaleX = this._owner.weaponCDPercent;
		}

		public function updateExperience(sort:Boolean = true):void {
			if (this._owner == null)
				return;
			this._experienceBarExperience.visible = this._experienceBarFrame.visible = this.getVisibleExperience();
			/*if(sort) sortUnderBars()*/
			this._experienceBarExperience.scaleX = this._owner.experiencePercent;
			this._levelText.text = LEVEL_TEXT_HEAD + this._owner.level;
		}

		protected function sortUnderBars():void {
			var sortCD:uint = 0, sortCharge:uint = 0; /*,sortExperience:uint=0*/
			/*if(this.getVisibleExperience(false)) {
				sortCD++;
				sortCharge++;
			}*/
			if (this.getVisibleCD(false))
				sortCharge++;
			this._CDBarCD.y = this._CDBarFrame.y = getUnderBarY(sortCD);
			this._chargeBarCharge.y = this._chargeBarFrame.y = getUnderBarY(sortCharge);
			// this._experienceBarExperience.y=this._experienceBarFrame.y=getUnderBarY(sortExperience);
		}

		protected function setFormats():void {
			// Health Bar
			this._healthBarFormat.font = GlobalGameVariables.MAIN_FONT.fontName;
			this._healthBarFormat.align = TextFormatAlign.CENTER;
			this._healthBarFormat.bold = true;
			this._healthBarFormat.color = HEALTH_COLOR;
			this._healthBarFormat.size = 0.3 * GlobalGameVariables.DEFAULT_SIZE;
			// NameTag
			this._nameTagFormat.font = GlobalGameVariables.MAIN_FONT.fontName;
			this._nameTagFormat.align = TextFormatAlign.CENTER;
			this._nameTagFormat.bold = true;
			// this._nameTagFormat.color=this._owner.fillColor;
			this._nameTagFormat.size = 0.5 * GlobalGameVariables.DEFAULT_SIZE;
		}

		protected function setFromatsToFields():void {
			this._healthBarText.defaultTextFormat = this._healthBarFormat;
			this._nameTagText.defaultTextFormat = this._nameTagFormat;
			this._levelText.defaultTextFormat = EXPERIENCE_FORMAT;
			this._healthBarText.selectable = this._nameTagText.selectable = this._levelText.selectable = false;
			this._healthBarText.multiline = this._nameTagText.multiline = this._levelText.multiline = false;
			this._healthBarText.embedFonts = this._nameTagText.embedFonts = this._levelText.embedFonts = true;
			this._healthBarText.autoSize = this._nameTagText.autoSize = this._levelText.autoSize = TextFieldAutoSize.CENTER;
			// this._healthBarText.border=this._nameTagText.border=true;
		}

		protected function drawShape():void {
			// Pointer Triangle
			this._pointerTriangle.x = 0;
			this._pointerTriangle.y = -1.2 * GlobalGameVariables.DEFAULT_SIZE;
			// Name Tag
			this._nameTagText.x = -1.875 * GlobalGameVariables.DEFAULT_SIZE;
			this._nameTagText.y = -2.5 * GlobalGameVariables.DEFAULT_SIZE;
			this._nameTagText.width = 3.75 * GlobalGameVariables.DEFAULT_SIZE;
			this._nameTagText.height = 0.625 * GlobalGameVariables.DEFAULT_SIZE;
			// Level Text
			this._levelText.x = -1.875 * GlobalGameVariables.DEFAULT_SIZE;
			this._levelText.y = -1.9375 * GlobalGameVariables.DEFAULT_SIZE;
			this._levelText.width = 3.75 * GlobalGameVariables.DEFAULT_SIZE;
			this._levelText.height = 0.6 * GlobalGameVariables.DEFAULT_SIZE;
			// Health Bar
			drawHealthBar();
			this._healthBarFrame.x = this._healthBarHealth.x = -0.46875 * GlobalGameVariables.DEFAULT_SIZE;
			this._healthBarFrame.y = this._healthBarHealth.y = -0.725 * GlobalGameVariables.DEFAULT_SIZE;
			this._healthBarText.x = -1.5625 * GlobalGameVariables.DEFAULT_SIZE;
			this._healthBarText.y = -1.1 * GlobalGameVariables.DEFAULT_SIZE;
			this._healthBarText.width = 3.125 * GlobalGameVariables.DEFAULT_SIZE;
			this._healthBarText.height = 0.375 * GlobalGameVariables.DEFAULT_SIZE;
			// CD Bar
			drawCDBar();
			this._CDBarFrame.x = this._CDBarCD.x = -0.5 * GlobalGameVariables.DEFAULT_SIZE;
			this._CDBarFrame.y = this._CDBarCD.y = UNDER_BAR_Y_1;
			// Charge Bar
			drawChargeBar();

			this._chargeBarFrame.x = this._chargeBarCharge.x = -0.5 * GlobalGameVariables.DEFAULT_SIZE;
			this._chargeBarFrame.y = this._chargeBarCharge.y = UNDER_BAR_Y_2;
			// Experience Bar
			drawExperienceBar();

			this._experienceBarFrame.x = this._experienceBarExperience.x = -0.5 * GlobalGameVariables.DEFAULT_SIZE;
			this._experienceBarFrame.y = this._experienceBarExperience.y = -0.6 * GlobalGameVariables.DEFAULT_SIZE;
		}

		protected function drawPointerTriangle(graphics:Graphics):void {
			var realRadiusX:Number = 0.1875 * GlobalGameVariables.DEFAULT_SIZE;
			var realRadiusY:Number = 0.1875 * GlobalGameVariables.DEFAULT_SIZE;
			graphics.clear();
			graphics.beginFill(this._owner.fillColor);
			graphics.moveTo(-realRadiusX, -realRadiusY);
			graphics.lineTo(0, realRadiusY);
			graphics.lineTo(realRadiusX, -realRadiusY);
			graphics.lineTo(-realRadiusX, -realRadiusY);
			graphics.endFill();
		}

		protected function drawHealthBar():void {
			this._healthBarFrame.graphics.lineStyle(GlobalGameVariables.DEFAULT_SIZE / 200, HEALTH_BAR_FRAME_COLOR);
			this._healthBarFrame.graphics.drawRect(0, 0,
					0.9375 * GlobalGameVariables.DEFAULT_SIZE,
					HEALTH_BAR_HEIGHT);
			this._healthBarFrame.graphics.endFill();
			this._healthBarHealth.graphics.beginFill(HEALTH_COLOR);
			this._healthBarHealth.graphics.drawRect(0, 0,
					0.9375 * GlobalGameVariables.DEFAULT_SIZE,
					HEALTH_BAR_HEIGHT);
			this._healthBarFrame.graphics.endFill();

		}

		protected function drawCDBar():void {
			this._CDBarFrame.graphics.lineStyle(BAR_FRAME_SIZE, CD_BAR_FRAME_COLOR);
			this._CDBarFrame.graphics.drawRect(0, 0,
					GlobalGameVariables.DEFAULT_SIZE,
					UNDER_BAR_HEIGHT);
			this._CDBarFrame.graphics.endFill();
			this._CDBarCD.graphics.beginFill(CD_COLOR);
			this._CDBarCD.graphics.drawRect(0, 0,
					GlobalGameVariables.DEFAULT_SIZE,
					UNDER_BAR_HEIGHT);
			this._CDBarCD.graphics.endFill();
		}

		protected function drawChargeBar():void {
			this._chargeBarFrame.graphics.lineStyle(BAR_FRAME_SIZE, CHARGE_BAR_FRAME_COLOR);
			this._chargeBarFrame.graphics.drawRect(0, 0,
					GlobalGameVariables.DEFAULT_SIZE,
					UNDER_BAR_HEIGHT);
			this._chargeBarFrame.graphics.endFill();
			this._chargeBarCharge.graphics.beginFill(CHARGE_COLOR);
			this._chargeBarCharge.graphics.drawRect(0, 0,
					GlobalGameVariables.DEFAULT_SIZE,
					UNDER_BAR_HEIGHT);
			this._chargeBarCharge.graphics.endFill();
		}

		protected function drawExperienceBar():void {
			this._experienceBarFrame.graphics.lineStyle(BAR_FRAME_SIZE, EXPERIENCE_BAR_FRAME_COLOR);
			this._experienceBarFrame.graphics.drawRect(0, 0,
					GlobalGameVariables.DEFAULT_SIZE,
					UNDER_BAR_HEIGHT);
			this._experienceBarFrame.graphics.endFill();
			this._experienceBarExperience.graphics.beginFill(EXPERIENCE_COLOR);
			this._experienceBarExperience.graphics.drawRect(0, 0,
					GlobalGameVariables.DEFAULT_SIZE,
					UNDER_BAR_HEIGHT);
			this._experienceBarExperience.graphics.endFill();
		}

		protected function addChilds():void {
			this.addChild(this._healthBarHealth);
			this.addChild(this._healthBarFrame);
			this.addChild(this._healthBarText);
			this.addChild(this._CDBarCD);
			this.addChild(this._CDBarFrame);
			this.addChild(this._chargeBarCharge);
			this.addChild(this._chargeBarFrame);
			this.addChild(this._experienceBarExperience);
			this.addChild(this._experienceBarFrame);
			this.addChild(this._levelText);
			this.addChild(this._nameTagText);
			this.addChild(this._pointerTriangle);
		}

		protected function removeChilds():void {
			this.removeChild(this._healthBarHealth);
			this.removeChild(this._healthBarFrame);
			this.removeChild(this._healthBarText);
			this.removeChild(this._CDBarCD);
			this.removeChild(this._CDBarFrame);
			this.removeChild(this._chargeBarCharge);
			this.removeChild(this._chargeBarFrame);
			this.removeChild(this._experienceBarExperience);
			this.removeChild(this._experienceBarFrame);
			this.removeChild(this._levelText);
			this.removeChild(this._nameTagText);
			this.removeChild(this._pointerTriangle);
		}

		public function deleteSelf():void {
			this.removeChilds();
			this._healthBarHealth = null;
			this._healthBarFrame = null;
			this._healthBarText = null;
			this._CDBarCD = null;
			this._CDBarFrame = null;
			this._chargeBarCharge = null;
			this._chargeBarFrame = null;
			this._experienceBarExperience = null;
			this._experienceBarFrame = null;
			this._levelText = null;
			this._nameTagText = null;
			this._pointerTriangle = null;
			this._healthBarFormat = null;
			this._nameTagFormat = null;
			this._owner = null;
		}
	}
}