package kr.studio321.util
{
	/**
	 * 배열 관련 메서드들이 들어있습니다.
	 * @author 0xABCDEF
	 */
	public class ArrayUtil
	{
		/**
		 * 배열을 분할합니다.
		 * @param target 분할을 수행할 배열입니다.
		 * @param count 분할을 수행할 단위입니다.
		 * @return 배열을 일정 간격을 기준으로 분할한 배열을 반환합니다. 원본은 수정되지 않습니다.
		 */
		public static function divide( target:Array, count:int ):Array
		{
			if( count <= 0 ) return target;
			var cnt:int = 0;
			var dummyArray:Array = [];
			var result:Array = [];
			function flush():void
			{
				result.push( dummyArray );
				dummyArray = [];
				cnt = 0;
			}
			for( var i:int=0; i<target.length; ++i )
			{
				++cnt;
				dummyArray.push( target[ i ] );
				if( cnt == count ) flush();
			}
			if( dummyArray.length ) flush();
			return result;
		}
		
	}
}