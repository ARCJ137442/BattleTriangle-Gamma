package batr.game.effect 
{
	import batr.common.*;
	
	import batr.game.effect.*;
	import batr.game.main.*;
	
	/* The class is use for game that deal with effects
	 * The class have some functions about game effect
	 */
	public class EffectSystem
	{
		//============Static Variables============//
		
		//============Static Functions============//
		
		//============Instance Variables============//
		protected var _host:Game
		
		protected var _effects:Vector.<EffectCommon>=new Vector.<EffectCommon>
		
		//============Constructor Function============//
		public function EffectSystem(host:Game):void
		{
			this._host=host
		}
		
		//============Destructor Function============//
		public function deleteSelf():void
		{
			this.removeAllEffect()
			this._effects=null
			this._host=null
		}
		
		//============Instance Getters And Setters============//
		public function get host():Game
		{
			return this._host;
		}
		
		public function get effects():Vector.<EffectCommon>
		{
			return this._effects;
		}
		
		public function get effectCount():uint
		{
			if(this._effects==null) return 0;
			return this._effects.length;
		}
		
		//============Instance Functions============//
		public function GC():void
		{
			if(this._effects==null) return;
			//Effect
			while(this._effects.indexOf(null)>=0)
			{
				this._effects.splice(this._effects.indexOf(null),1);
			}
		}
		
		//Register,Cencell and Remove
		public function isRegisteredEffect(effect:EffectCommon):Boolean
		{
			return this._effects.some(
			function(e2:EffectCommon,i:uint,v:Vector.<EffectCommon>)
			{
				return e2==effect
			})
		}
		
		public function registerEffect(effect:EffectCommon):Boolean
		{
			if(effect==null||isRegisteredEffect(effect)) return false
			this._effects.push(effect)
			return true
		}
		
		public function cencellEffect(effect:EffectCommon):Boolean
		{
			if(effect==null||!isRegisteredEffect(effect)) return false
			this._effects.splice(this._effects.indexOf(effect),1)
			return true
		}
		
		public function addEffect(effect:EffectCommon):void
		{
			this.registerEffect(effect)
			this._host.addEffectChild(effect)
		}
		
		public function removeEffect(effect:EffectCommon):void
		{
			if(effect==null) return
			effect.deleteSelf()
			cencellEffect(effect)
			UsefulTools.removeChildIfContains(this._host.effectContainerBottom,effect)
			UsefulTools.removeChildIfContains(this._host.effectContainerTop,effect)
		}
		
		public function removeAllEffect():void
		{
			while(this._effects.length>0)
			{
				this.removeEffect(this._effects[0])
			}
		}
	}
}