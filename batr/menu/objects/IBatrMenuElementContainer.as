package batr.menu.objects 
{
	import batr.common.*;
	import batr.general.*;
	
	import batr.menu.events.*;
	import batr.menu.objects.*;
	
	import flash.display.*;
	
	public interface IBatrMenuElementContainer extends IBatrMenuElement
	{
		function appendDirectElement(element:IBatrMenuElement):IBatrMenuElement
		function appendDirectElements(...elements):IBatrMenuElement
		function addChildPerDirectElements():void
		
		function getElementAt(index:int):IBatrMenuElement
		function getElementByName(name:String):BatrMenuGUI
	}
}