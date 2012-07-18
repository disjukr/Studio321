package kr.studio321.util
{
	/**
	 * 수학 관련 메서드들이 들어있습니다.
	 * @author 0xABCDEF
	 */
	public class MathUtil
	{
		/**
		 * 소숫점 자릿수를 셉니다.
		 * @param decimal 소수( 0보다 작은 값 )을 갖고있는 숫자입니다.
		 * @return 소수점 자릿수를 센 값을 반환합니다. 1.2345를 집어넣으면 4를 반환합니다.
		 */
		public static function downDecimalsCount( decimal:Number ):int
		{
			return String( decimal ).split( "." )[1].length;
		}
		
		/**
		 * 최대공약수를 계산합니다.
		 * @param a
		 * @param b
		 * @return a와 b의 최대공약수를 반환합니다.
		 */
		public static function gcd( a:int, b:int ):int
		{
			var c:int;
			while( true ){
				c = a%b;
				if( !c ){
					break;
				}
				a = b;
				b = c;
			}
			return b;
		}
		
		/**
		 * 최소공배수를 계산합니다.
		 * @param a
		 * @param b
		 * @return a와 b의 최소공배수를 반환합니다.
		 */
		public static function lcm( a:int, b:int ):int
		{
			return a*b/gcd( a, b );
		}
		
		/**
		 * 숫자를 분수로 표현합니다.
		 * @param decimal 소수( 0보다 작은 값 )을 갖고있는 숫자입니다.
		 * @return 인자로 받은 수를 분수로 표현한 값을 반환합니다. 0.5를 집어넣으면 "1/2"을 반환합니다.
		 */
		public static function fractionalExp( decimal:Number ):String
		{
			if( String( decimal ).split( "." )[1] ) {
				var decimalLength:int = MathUtil.downDecimalsCount( decimal );
				var multipleCount:int = Math.pow( 10, decimalLength );
				var value:int = decimal * multipleCount;
				var gcd:int = MathUtil.gcd( value, multipleCount );
				return String( ( value / gcd ) + "/" + ( multipleCount / gcd ) );
			} else {
				return String( decimal );
			}
		}
		
		/**
		 * 선형보간을 수행합니다.
		 * @param start 시작값입니다.
		 * @param end 끝값입니다.
		 * @param t 0~1 사이의 값을 넣어주면 됩니다. t의 값이 0일 때는 start가 반환되고 1일 때는 end가 반환됩니다.
		 * @return 선형보간한 값을 반환합니다.
		 */
		public static function linear( start:Number, end:Number, t:Number ):Number
		{
			return start + ( end-start )*t;
		}
		
		/**
		 * 베지어보간을 수행합니다.
		 * @param values 베지어 보간을 할 값들이 들어있는 배열입니다.
		 * @param t 0~1 사이의 값을 넣어주면 됩니다. t의 값이 0일 때는 values[ 0 ]이 반환되고 1일 때는 values[ values.length-1 ]이 반환됩니다.
		 * @return 주어진 값들을 베지어보간한 값이 반환됩니다.
		 */
		public static function bezier( values:Array, t:Number ):Number
		{
			if( values.length < 2 ) return NaN;
			if( values.length == 2 ) return MathUtil.linear( values[ 0 ], values[ 1 ], t );
			var i:int;
			while( values.length > 1 )
			{
				var resultValues:Array = [];
				var count:int = values.length-1;
				for ( i = 0; i<count; ++i )
				{
					resultValues.push( MathUtil.linear( values[ i ], values[ i+1 ], t ) );
				}
				values = resultValues;
			}
			return values[ 0 ];
		}
		
		/**
		 * 범위를 제한합니다.
		 * @param value 범위를 제한할 값입니다.
		 * @param min value가 min보다 작을 경우 min이 반환됩니다.
		 * @param max value가 max보다 클 경우 max가 반환됩니다.
		 * @return value의 범위를 제한한 값을 반환합니다.
		 */
		public static function restrict( value:Number, min:Number, max:Number ):Number
		{
			return value<min?min:value>max?max:value;
		}
		
		/**
		 * 원하는 단위를 기준으로 스냅시킨 값을 반환합니다.
		 * @param value 스냅시키고자 하는 값입니다.
		 * @param unit 스냅하고 싶은 단위입니다.
		 * @return 스냅시킨 값이 반환됩니다. unit가 90일 때, value가 50이면 90이 반환되고 40이면 0이 반환됩니다.
		 */
		public static function snap( value:Number, unit:Number ):Number
		{
			var adjust:Number;
			if( value > 0 ) adjust = value%unit;
			else if( value < 0 ) adjust = unit + value%unit;
			else return 0;
			if( adjust > unit/2 ) return value+unit-adjust;
			return value-adjust;
		}
		
		/**
		 * 16진수로 서식을 맞춰줍니다.
		 * <p>HTML 방식으로 색상을 표현하고자 할 때 유용합니다.</p>
		 * @param value 서식을 맞추고자 하는 값입니다.
		 * @param prefix 접두사입니다.
		 * @param count 표현하고자 하는 숫자의 최소길이입니다.
		 * @return 서식에 맞춘 값을 반환합니다.
		 */
		public static function toHex( value:uint, prefix:String = "#", count:uint = 6 ):String
		{
			var hex:String = value.toString( 16 ).toUpperCase();
			while( hex.length < count )
			{
				hex = "0"+hex;
			}
			return prefix + hex;
		}
		
	}
}