package batr.game.effect.effects 
{
	import batr.general.*;
	
	import batr.game.effect.*;
	import batr.game.main.*;
	
	import flash.display.*;
	
	public class EffectTeleport extends EffectCommon
	{
		//============Static Variables============//
		public static const DEFAULT_COLOR:uint=0x44ff44
		public static const LINE_ALPHA:Number=0.6
		public static const FILL_ALPHA:Number=0.5
		public static const LINE_SIZE:Number=GlobalGameVariables.DEFAULT_SIZE/25
		public static const SIZE:uint=GlobalGameVariables.DEFAULT_SIZE*2
		public static const SCALE:Number=1
		
		//============Instance Variables============//
		protected var maxScale:Number
		protected var block1:Shape=new Shape()
		protected var block2:Shape=new Shape()
		
		//============Constructor Function============//
		public function EffectTeleport(host:Game,x:Number,y:Number,scale:Number=EffectTeleport.SCALE):void
		{
			super(host,x,y,GlobalGameVariables.TPS*1/2);
			this.drawShape();
			this.maxScale=scale;
			this.initScale(scale);
			this.addChilds();
		}
		
		protected function initScale(scale:Number):void
		{
			this.scale=maxScale;
		}
		
		//============Destructor Function============//
		public override function deleteSelf():void
		{
			this.maxScale=NaN;
			if(this.block1!=null)
			{
				this.removeChild(this.block1);
				this.block1.graphics.clear();
				this.block1=null;
			}
			if(this.block1!=null)
			{
				this.removeChild(this.block2);
				this.block2.graphics.clear();
				this.block2=null;
			}
			super.deleteSelf();
		}
		
		//============Instance Getter And Setter============//
		public override function get type():EffectType
		{
			return EffectType.TELEPORT;
		}
		
		protected function set scale(value:Number):void
		{
			this.scaleX=this.scaleY=value;
		}
		
		//============Instance Functions============//
		protected function addChilds():void
		{
			this.addChild(this.block1);
			this.addChild(this.block2);
		}
		
		public override function onEffectTick():void
		{
			this.scale=(life/LIFE)*maxScale;
			this.rotation=((LIFE-life)/LIFE)*360;
			dealLife();
		}
		
		public override function drawShape():void
		{
			drawBlocks(EffectTeleport.DEFAULT_COLOR,EffectTeleport.SIZE);
		}
		
		protected function drawBlocks(color:uint,size:uint):void
		{
			drawBlock(this.block1.graphics,color,size);
			drawBlock(this.block2.graphics,color,size);
			this.block2.rotation=45;
		}
		
		protected function drawBlock(graphics:Graphics,color:uint,size:uint):void
		{
			graphics.clear();
			graphics.lineStyle(LINE_SIZE,color,LINE_ALPHA);
			graphics.beginFill(color,FILL_ALPHA);
			graphics.drawRect(-size/2,-size/2,size,size);
			graphics.endFill();
		}
	}
}