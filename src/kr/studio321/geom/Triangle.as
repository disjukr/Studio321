package kr.studio321.geom
{
	import flash.geom.Point;

	/**
	 * 삼각형을 정의합니다.
	 * @author 0xABCDEF
	 */
	/**
	 * 
	 * @author 0xABCDEF
	 */
	public class Triangle
	{
		/**
		 * 삼각형을 이루는 정점입니다.
		 * @default 
		 */
		public var a:Point;
		/**
		 * 삼각형을 이루는 정점입니다.
		 * @default 
		 */
		public var b:Point;
		/**
		 * 삼각형을 이루는 정점입니다.
		 * @default 
		 */
		public var c:Point;
		
		/**
		 * 삼각형을 생성합니다.
		 * @param ax 정점의 x값입니다.
		 * @param ay 정점의 y값입니다.
		 * @param bx 정점의 x값입니다.
		 * @param by 정점의 y값입니다.
		 * @param cx 정점의 x값입니다.
		 * @param cy 정점의 y값입니다.
		 */
		public function Triangle( ax:Number, ay:Number, bx:Number, by:Number, cx:Number, cy:Number )
		{
			a = new Point( ax, ay );
			b = new Point( bx, by );
			c = new Point( cx, cy );
		}
		
		/**
		 * 삼각형이 해당 점을 포함하는지 여부를 반환합니다.
		 * @param point 알잖아요.
		 * @return 삼각형 안쪽에 점이 있으면 true를 반환합니다. 삼각형이 플래시의 화면좌표계 기준으로 CCW( 반시계 방향 )로 구성되어있다면 무조건 false가 반환됩니다.
		 */
		public function haveCW( point:Point ):Boolean
		{
			var Px:Number = point.x, Py:Number = point.y;
			var Ax:Number = a.x, Ay:Number = a.y;
			var Bx:Number = b.x, By:Number = b.y;
			var Cx:Number = c.x, Cy:Number = c.y;
			var ax:Number = Cx-Bx, ay:Number = Cy-By;
			var bx:Number = Ax-Cx, by:Number = Ay-Cy;
			var cx:Number = Bx-Ax, cy:Number = By-Ay;
			var apx:Number = Px-Ax, apy:Number = Py-Ay;
			var bpx:Number = Px-Bx, bpy:Number = Py-By;
			var cpx:Number = Px-Cx, cpy:Number = Py-Cy;
			var axb:Number = ax*bpy - ay*bpx;
			var bxc:Number = bx*cpy - by*cpx;
			var cxa:Number = cx*apy - cy*apx;
			return ( ( axb>=0 )&&( bxc>=0 )&&( cxa>=0 ) );
		}
		
		/**
		 * 삼각형이 해당 점을 포함하는지 여부를 반환합니다.
		 * @param point 알잖아요.
		 * @return 삼각형 안쪽에 점이 있으면 true를 반환합니다. 삼각형이 플래시의 화면좌표계 기준으로 CW( 시계 방향 )로 구성되어있다면 무조건 false가 반환됩니다.
		 */
		public function haveCCW( point:Point ):Boolean
		{
			var Px:Number = point.x, Py:Number = point.y;
			var Ax:Number = c.x, Ay:Number = c.y;
			var Bx:Number = b.x, By:Number = b.y;
			var Cx:Number = a.x, Cy:Number = a.y;
			var ax:Number = Cx-Bx, ay:Number = Cy-By;
			var bx:Number = Ax-Cx, by:Number = Ay-Cy;
			var cx:Number = Bx-Ax, cy:Number = By-Ay;
			var apx:Number = Px-Ax, apy:Number = Py-Ay;
			var bpx:Number = Px-Bx, bpy:Number = Py-By;
			var cpx:Number = Px-Cx, cpy:Number = Py-Cy;
			var axb:Number = ax*bpy - ay*bpx;
			var bxc:Number = bx*cpy - by*cpx;
			var cxa:Number = cx*apy - cy*apx;
			return ( ( axb>=0 )&&( bxc>=0 )&&( cxa>=0 ) );
		}
		
		/**
		 * 삼각형이 해당 점을 포함하는지 여부를 반환합니다.
		 * @param point 알잖아요.
		 * @return 삼각형 안쪽에 점이 있으면 true를 반환합니다.
		 */
		public function have( point:Point ):Boolean
		{
			return haveCW( point )||haveCCW( point );
		}
		
	}
}