package battle.model
{
	import battle.events.MoveFadeEvent;
	
	import flash.events.EventDispatcher;
	
	import mx.core.UIComponent;
	import mx.effects.Fade;
	import mx.effects.Move;
	import mx.events.EffectEvent;
	
	public class MoveFade extends EventDispatcher
	{
		private var _target:UIComponent = null; 
		
		private var _duration:int = 2000;
		
		private var isMoveEnd:Boolean = false;
		private var isFadeEnd:Boolean = false;
		
		public function MoveFade(target:UIComponent = null, time:int = 2000)
		{
			_target = target;
			_duration = time;
		}
		
		public function play(target:UIComponent = null):void
		{
			if (target != null)
				_target = target;
				
			var fade:Fade = new Fade();
			fade.target = _target;
			fade.alphaFrom = 1;
			fade.alphaTo = 0;
			fade.duration = _duration;
			fade.addEventListener(EffectEvent.EFFECT_END, fadeEnd);
			fade.play();
			
			var move:Move = new Move();
			move.target = _target;
			move.xFrom = _target.x;
			move.yFrom = _target.y;
			move.xTo = _target.x;
			move.yTo = _target.y - 30;
			move.duration = _duration;
			move.addEventListener(EffectEvent.EFFECT_END, moveEnd);
			move.play();
		}
		
		private function moveEnd(evt:EffectEvent):void
		{
			isMoveEnd = true;
			if (evt.target is Move)
			{
				var move:Move = evt.target as Move;
				if (move != null)
				{
					move.removeEventListener(EffectEvent.EFFECT_END, moveEnd);
					move.target = null;
					move = null;
				}
			}
			
			if (isMoveEnd && isFadeEnd)
			{
				end();
			}
		}
		
		private function fadeEnd(evt:EffectEvent):void
		{
			isFadeEnd = true;
			if (evt.target is Fade)
			{
				var fade:Fade = evt.target as Fade;
				if (fade != null)
				{
					fade.removeEventListener(EffectEvent.EFFECT_END, fadeEnd);
					fade.target = null;
					fade = null;
				}
			}
			
			if (isMoveEnd && isFadeEnd)
			{
				end();
			}
		}
		
		private function end():void
		{
			if (_target.parent)
			{
				_target.parent.removeChild(_target);
				_target = null;
			}
			
			var evt:MoveFadeEvent = new MoveFadeEvent(MoveFadeEvent.MOVE_FADE_END);
			this.dispatchEvent(evt);
		}
		
		public function set target(param:UIComponent):void
		{
			_target = param;
		}
		
		public function set duration(param:int):void
		{
			_duration = param;
		}

	}
}