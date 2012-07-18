package kr.studio321.air.util
{
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;

	/**
	 * NativeMenu 관련 메서드들이 들어있습니다.
	 * @author 0xABCDEF
	 */
	public class NativeMenuUtil
	{
		
		/**
		 * NativeMenu의 생성을 도와줍니다.
		 * @param array 메뉴 구성을 다차원 배열( 항목은 String, 구분선은 Array, 서브메뉴는 Object[ label:서브메뉴의 레이블<String>, items:서브메뉴의 구성<Array> ] )로 받습니다.
		 * @param references 메뉴의 모든 항목의 참조를 담을 빈 배열입니다.
		 * @return 생성된 NativeMenu 객체입니다.
		 */
		public static function create( array:Array, references:Array=null ):NativeMenu
		{
			var menu:NativeMenu = new NativeMenu;
			var container:Object;
			for each( var item:Object in array )
			{
				if( item is String ) // item
				{
					container = menu.addItem( new NativeMenuItem( item as String ) );
					if( references ) references.push( container );
				} else if( item is Array ) { // separator
					container = menu.addItem( new NativeMenuItem( "", true ) );
					if( references ) references.push( container );
				} else { // submenu
					container = [];
					if( references ) references.push( container );
					menu.addSubmenu( create( item.items, container as Array ), item.label );
				}
			}
			return menu;
		}
		
	}
}