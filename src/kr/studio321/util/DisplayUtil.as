package kr.studio321.util
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.geom.Rectangle;
	
	/**
	 * 화면 표시관련 메서드들이 들어있습니다.
	 * @author 0xABCDEF
	 */
	public class DisplayUtil
	{
		/**
		 * 스크린 래핑을 수행합니다.
		 * @param target 대상 표시객체입니다.
		 * @param screen 대상은 이 스크린 안에서만 활동이 가능합니다. 대상이 스크린을 넘어가면 넘어간 반대편에서 나오게됩니다.
		 */
		public static function screenWrap( target:DisplayObject, screen:Rectangle ):void
		{
			target.x = ( target.x-screen.x+screen.width )%screen.width+screen.x;
			target.y = ( target.y-screen.y+screen.height )%screen.height+screen.y;
		}
		
		/**
		 * 심도 정렬을 수행합니다.
		 * @param target 대상 표시객체 컨테이너입니다.
		 * @param fieldName 정렬기준입니다. "y"를 집어넣으면 객체의 y값을 기준으로 정렬합니다.
		 */
		public static function childIndexSort( target:DisplayObjectContainer, fieldName:Object ):void
		{
			var childArray:Array = new Array;
			for( var i:int = 0; i<target.numChildren; ++i )
			{
				childArray.push( target.getChildAt( i ) );
			}
			childArray.sortOn( fieldName, Array.NUMERIC );
			for( i=0; i<childArray.length; ++i )
			{
				target.setChildIndex( childArray[ i ], i );
			}
		}
		
		/**
		 * 대상을 스테이지의 가운데로 옮깁니다.
		 * @param target 가운데로 옮길 표시객체입니다.
		 */
		public static function goCenterToStage( target:DisplayObject ):void
		{
			var stage:Stage = target.stage;
			target.x = ( stage.stageWidth>>1 )-target.width/2;
			target.y = ( stage.stageHeight>>1 )-target.height/2;
		}
		
	}
}