package batr.game.effect.effects 
{
	import batr.common.*;
	import batr.general.*;
	
	import batr.game.effect.*;
	import batr.game.main.*;
	
	import flash.display.*;
	
	public class EffectSpawn extends EffectTeleport
	{
		//============Static Variables============//
		public static const DEFAULT_COLOR:uint=0x6666ff
		public static const LINE_ALPHA:Number=0.6
		public static const FILL_ALPHA:Number=0.5
		public static const LINE_SIZE:Number=GlobalGameVariables.DEFAULT_SIZE/25
		public static const SIZE:uint=GlobalGameVariables.DEFAULT_SIZE*1.6
		public static const MAX_LIFE:uint=GlobalGameVariables.FIXED_TPS*0.5
		public static const SCALE:Number=1
		public static const STAGE_1_START_TIME:uint=MAX_LIFE*3/4
		public static const STAGE_2_START_TIME:uint=MAX_LIFE/4
		public static const ROTATE_ANGLE:uint=45
		
		//============Instance Variables============//
		protected var _animationStage:uint
		protected var _tempLife:uint
		
		//============Constructor Function============//
		public function EffectSpawn(host:Game,x:Number,y:Number,scale:Number=SCALE):void
		{
			super(host,x,y,scale);
			this._animationStage=0;
		}
		
		protected override function initScale(scale:Number):void
		{
			this.scale=0;
		}
		
		//============Destructor Function============//
		public override function deleteSelf():void
		{
			this._animationStage=0;
			this._tempLife=0;
			super.deleteSelf();
		}
		
		//============Instance Getter And Setter============//
		public override function get type():EffectType
		{
			return EffectType.SPAWN;
		}
		
		//============Instance Functions============//
		public override function drawShape():void
		{
			drawBlocks(EffectSpawn.DEFAULT_COLOR,EffectSpawn.SIZE)
		}
		
		public override function onEffectTick():void
		{
			dealLife()
			if(this.life<=STAGE_2_START_TIME)
			{
				this._animationStage=2;
			}
			else if(this.life<=STAGE_1_START_TIME)
			{
				this._animationStage=1;
			}
			else
			{
				this._animationStage=0;
			}
			if(_animationStage==0)
			{
				this._tempLife=LIFE-life;
				this.scale=(_tempLife/(LIFE-STAGE_1_START_TIME))*this.maxScale;
			}
			else if(_animationStage==1)
			{
				this._tempLife=LIFE-life-STAGE_2_START_TIME;
				this.block1.rotation=-(_tempLife/(STAGE_1_START_TIME-STAGE_2_START_TIME))*ROTATE_ANGLE;
				this.block2.rotation=45+(_tempLife/(STAGE_1_START_TIME-STAGE_2_START_TIME))*ROTATE_ANGLE;
			}
			else if(_animationStage==2)
			{
				this._tempLife=life;
				this.scale=_tempLife/STAGE_2_START_TIME*this.maxScale;
			}
		}
	}
}