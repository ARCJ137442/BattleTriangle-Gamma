package batr.menu.objects 
{
	import flash.display.*;
	
	public class Title extends Bitmap
	{
		//============Static Variables============//
		public static const WIDTH:Number=2048.75;
		public static const HEIGHT:Number=609.75;
		public static const X:Number=-23.1;
		public static const Y:Number=-23.1;
		
		//============Constructor Function============//
		public function Title():void
		{
			super(new TitleImg());//TitleImg.IMAGE_DATA
			//AddBitMap
			//var bitmap:Bitmap=new Bitmap();
			this.x=X;
			this.y=Y;
			this.width=WIDTH;
			this.height=HEIGHT;
		}
	}
}