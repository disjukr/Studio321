package kr.studio321.control
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * Point 객체를 쉽게 컨트롤하기 위한 컨트롤러입니다.
	 * @author 0xABCDEF
	 */
	public class PointControl extends Sprite
	{
		/**
		 * 드래그 가능한 PointControl이 포인터 위치의 가운데에 잠기는지(true) 아니면 사용자가 PointControl을 처음으로 클릭한 위치에 잠기는지(false)를 지정합니다.
		 * @default 
		 */
		public var lockCenter:Boolean;
		/**
		 * PointControl의 제한 영역을 지정하는 PointControl의 부모의 좌표와 관련된 값입니다.
		 * @default 
		 */
		public var bounds:Rectangle;
		/**
		 * 연결시킬 Point 객체입니다. 실제로 연결( Bind )되는 것은 아니고 updatePoint()와 updateControl() 메서드로 서로 연결되어있는 것처럼 보이게 할 수 있습니다.
		 * @default 
		 */
		public var point:Point;
		
		/**
		 * PointControl 객체를 생성합니다.
		 * @param point 연결시킬 Point 객체입니다. 실제로 연결( Bind )되는 것은 아니고 updatePoint()와 updateControl() 메서드로 서로 연결되어있는 것처럼 보이게 할 수 있습니다.
		 * @param drawMethod 이 컨트롤을 그릴, Graphics인자 하나를 받는 메서드입니다.
		 * @param lockCenter 드래그 가능한 PointControl이 포인터 위치의 가운데에 잠기는지(true) 아니면 사용자가 PointControl을 처음으로 클릭한 위치에 잠기는지(false)를 지정합니다.
		 * @param bounds PointControl의 제한 영역을 지정하는 PointControl의 부모의 좌표와 관련된 값입니다.
		 */
		public function PointControl( point:Point = null, drawMethod:Function = null, lockCenter:Boolean = false, bounds:Rectangle = null )
		{
			this.lockCenter = lockCenter;
			this.bounds = bounds;
			this.point = point?point:new Point;
			updateControl();
			drawMethod = Boolean( drawMethod )?drawMethod:defaultDrawMethod;
			drawMethod( graphics );
			addEventListener( MouseEvent.MOUSE_DOWN, MOUSE_DOWN );
			addEventListener( MouseEvent.MOUSE_UP, MOUSE_UP );
			super();
		}
		
		private function defaultDrawMethod( graphics:Graphics ):void
		{
			graphics.clear();
			graphics.beginFill( 0xDDDDDD, 0.7 );
			graphics.lineStyle( 1, 0x555555 );
			graphics.drawCircle( 0, 0, 4 );
			graphics.endFill();
		}
		
		private function MOUSE_DOWN( e:MouseEvent ):void
		{
			startDrag( lockCenter, bounds );
		}
		
		private function MOUSE_UP( e:MouseEvent ):void
		{
			stopDrag();
		}
		
		/**
		 * 연결된 Point 객체를 갱신시킵니다. PointControl의 좌표를 변경했을 때 사용합니다.
		 */
		public function updatePoint():void
		{
			point.x = x;
			point.y = y;
		}
		
		/**
		 * PointControl의 좌표를 갱신합니다. 연결된 Point 객체의 속성이 수정되었을 때 사용합니다.
		 */
		public function updateControl():void
		{
			x = point.x;
			y = point.y;
		}
		
		/**
		 * 이 PointControl 객체를 제거하기 위한 작업을 합니다. 이 메서드를 호출하면 이 객체의 부모로부터 removeChild 되며, 기본등록된 이벤트리스너가 제거됩니다. 
		 */
		public function destroy():void
		{
			graphics.clear();
			parent.removeChild( this );
			removeEventListener( MouseEvent.MOUSE_DOWN, MOUSE_DOWN );
			removeEventListener( MouseEvent.MOUSE_UP, MOUSE_UP );
		}
		
	}
}