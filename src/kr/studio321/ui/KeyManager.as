package kr.studio321.ui
{
	import flash.display.InteractiveObject;
	import flash.events.KeyboardEvent;
	import flash.utils.ByteArray;

	/**
	 * 키를 관리합니다.
	 * @author 0xABCDEF
	 */
	public class KeyManager
	{
		private var _target:InteractiveObject;
		private var _table:ByteArray;
		private var _recentEvent:KeyboardEvent;
		
		/**
		 * 키가 눌릴 때에 호출될 콜백함수입니다.
		 * @default 
		 */
		public var onKeyDown:Function;
		/**
		 * 키가 떼어졌을 때에 호출될 콜백함수입니다.
		 * @default 
		 */
		public var onKeyUp:Function;
		
		/**
		 * 키매니저를 생성합니다.
		 * @param target 포커스가 주어진 대상입니다. 
		 */
		public function KeyManager( target:InteractiveObject )
		{
			this.target = target;
			_table = new ByteArray;
		}
		
		public function get target():InteractiveObject
		{
			return _target;
		}
		
		/**
		 * 키매니저를 GC에 맡기기 전에 target에 null을 박으면 이벤트리스너를 뜯어줍니다.
		 * @param value
		 */
		public function set target( value:InteractiveObject ):void
		{
			if( _target )
			{
				_target.removeEventListener( KeyboardEvent.KEY_DOWN, KEY_DOWN );
				_target.removeEventListener( KeyboardEvent.KEY_UP, KEY_UP );
			}
			if( value )
			{
				_target = value;
				_target.addEventListener( KeyboardEvent.KEY_DOWN, KEY_DOWN );
				_target.addEventListener( KeyboardEvent.KEY_UP, KEY_UP );
			}
		}
		
		/**
		 * 가장 최근 갱신된 키보드이벤트를 반환합니다. keyCode 외의 속성들이 필요할 때 사용합니다.
		 * @return 키보드이벤트입니다. 
		 */
		public function get recentEvent():KeyboardEvent
		{
			return _recentEvent;
		}
		
		/**
		 * 키가 눌려있는지 여부를 반환합니다.
		 * @param keyCode 확인하고 싶은 키 코드입니다.
		 * @return 
		 */
		public function isDown( keyCode:int ):Boolean
		{
			return _table[ keyCode ];
		}
		
		private function KEY_DOWN( e:KeyboardEvent ):void
		{
			_recentEvent = e;
			if( !_table[ e.keyCode ] )
			{
				_table[ e.keyCode ] = true;
				if( onKeyDown is Function ) onKeyDown();
			}
		}
		
		private function KEY_UP( e:KeyboardEvent ):void
		{
			_recentEvent = e;
			_table[ e.keyCode ] = false;
			if( onKeyUp is Function ) onKeyUp();
		}
		
	}
}