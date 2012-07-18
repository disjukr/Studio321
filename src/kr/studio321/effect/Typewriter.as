package kr.studio321.effect
{
	/**
	 * 키보드로 한글을 직접 타이핑하는 듯한 애니메이션을 만들 때 사용합니다.
	 * @author 0xABCDEF
	 */
	public class Typewriter
	{
		private var _script:String;
		private var _current:String;
		private var _cash:Array;
		private var _index:int;
		
		/**
		 * 타이프라이터를 생성합니다.
		 * @param script 애니메이션할 문자열입니다.
		 */
		public function Typewriter( script:String="" )
		{
			this.script = script;
		}
		
		public function get script():String
		{
			return _script;
		}
		
		public function set script( value:String ):void
		{
			_script = value;
			_current = "";
			_cash = [];
			_index = 0;
		}
		
		/**
		 * 애니메이션되는 다음 문자열을 반환합니다. 더 이상 반환할 게 없으면 null을 반환합니다. 
		 * @return ㄵㅀㄺㅢㅟㅚ등등 처럼 두 글자가 합쳐진 자모에 대해서는 그냥 한 글자로 취급해서 처리합니다. 필요하면 직접 고쳐쓰십셔.
		 */
		public function next():String
		{
			if( _index == _script.length )if( !_cash.length ) return null;
			if( _cash.length )
			{
				if( _cash.length == 1 ) return _current += _cash.pop();
				return _current + _cash.pop();
			} else {
				_cash = divideChar( _script.charAt( _index++ ) );
				return next();
			}
		}
		
		private function divideChar( char:String ):Array
		{
			var charCode:int = char.charCodeAt()-44032;
			if( charCode < 0 || charCode > 11171 ) return [ char ];
			var initial:int = Math.floor( charCode/588 );
			var vowel:int = Math.floor( charCode%588/28 );
			var under:int = charCode%588%28;
			var initialChar:String = String.fromCharCode( 4352 + initial );
			var vowelChar:String = String.fromCharCode( 44032 + initial*588 + vowel*28 );
			if( initialChar == vowelChar ) return [ initialChar ];
			else if( initialChar != vowelChar )if( vowelChar == char || under == 0 ) return [ vowelChar, initialChar ];
			else return [ char, vowelChar, initialChar ];
			return null;
		}
		
	}
}