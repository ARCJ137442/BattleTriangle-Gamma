package batr.menu.objects 
{
	import flash.display.*;
	
	public class Title extends Sprite
	{
		//============Static Variables============//
		public static const WIDTH:Number=2048.75;
		public static const HEIGHT:Number=609.75;
		public static const X:Number=-23.1;
		public static const Y:Number=-23.1;
		
		//============Constructor Function============//
		public function Title():void
		{
			//AddBitMap
			var bitmap:Bitmap=new Bitmap(new TitleImg());//TitleImg.IMAGE_DATA
			bitmap.x=X;
			bitmap.y=Y;
			bitmap.width=WIDTH;
			bitmap.height=HEIGHT;
			this.addChild(bitmap);
		}
	}
}