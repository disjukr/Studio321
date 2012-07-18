package kr.studio321.util
{
	/**
	 * 날짜 관련 메서드들이 들어있습니다.
	 * @author 0xABCDEF
	 */
	public class DateUtil
	{
		/**
		 * 디데이를 계산합니다.
		 * @param targetYear 목표년입니다.
		 * @param targetMonth 목표월입니다.
		 * @param targetDay 목표일입니다.
		 * @param startYear 오늘년입니다. 0을 집어넣으면 시스템 년을 기준으로 계산합니다.
		 * @param startMonth 오늘월입니다. 0을 집어넣으면 시스템 월을 기준으로 계산합니다.
		 * @param startDay 오늘일입니다. 0을 집어넣으면 시스템 일을 기준으로 계산합니다.
		 * @return 목표 날짜까지 남은 일수를 반환합니다. DateUtil.dDay( 2011, 11, 16, 2011, 11, 11 )는 5입니다.
		 */
		public static function dDay( targetYear:int,
										targetMonth:int,
										targetDay:int,
										startYear:int = 0,
										startMonth:int = 0,
										startDay:int = 0 ):int
		{
			var dDay:int;
			if( !startYear || !startMonth || !startDay ) var nowDate:Date = new Date;
			if( !startYear ) startYear = nowDate.fullYear;
			if( !startMonth ) startMonth = nowDate.month+1;
			if( !startDay ) startDay = nowDate.date;
			var targetDate:Date = new Date( targetYear, targetMonth-1, targetDay, 0, 0, 0, 0 );
			var startDate:Date = new Date( startYear, startMonth-1, startDay, 0, 0, 0, 0 );
			dDay = Math.floor( ( targetDate.time - startDate.time ) / ( 24*60*60*1000 ) );
			return dDay;
		}
		
		/**
		 * 간지를 계산합니다.
		 * @param year 목표년입니다.
		 * @return 2016을 집어넣으면 "병신년"을 반환합니다.
		 */
		public static function kanjiYear( year:uint ):String
		{
			const CHEON_GAN:Array = [ "갑", "을", "병", "정", "무", "기", "경", "신", "임", "계" ];
			const JI_JI:Array = [ "자", "축", "인", "묘", "진", "사", "오", "미", "신", "유", "술", "해" ];
			return String( CHEON_GAN[ ( year+6 )%10 ] + JI_JI[ ( year+8 )%12 ] + "년" );
		}
		
		/**
		 * 무슨 요일인지 알려줍니다.
		 * @param year 목표년입니다.
		 * @param month 목표월입니다.
		 * @param day 목표일입니다.
		 * @return 첼러의 공식을 수행한 값을 반환합니다. 0은 토요일 1은 일요일 2는 월요일... 6은 금요일입니다.
		 */
		public static function zellersFormula( year:uint, month:uint, day:uint ):int {
			if( month == 1 || month == 2 ){
				month += 12;
				--year;
			}
			return ( ( year+year/4-year/100+year/400+int( 2.6*month+2.6 )+day )%7+7 )%7;
			/*/
			0 = 토
			1 = 일
			2 = 월
			3 = 화
			4 = 수
			5 = 목
			6 = 금
			//*/
		}
		
		/**
		 * 윤년인지 아닌지 알려줍니다.
		 * @param year 목표년입니다.
		 * @return 윤년이면 true, 아니면 false를 반환합니다.
		 */
		public static function isLeapYear( year:uint ):Boolean
		{
			return ( year%400 == 0 )||( year%100 != 0 && year%4 == 0 );
		}
	}
}