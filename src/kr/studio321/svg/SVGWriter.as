package kr.studio321.svg
{
	import flash.display.CapsStyle;
	import flash.display.Graphics;
	import flash.geom.Point;
	
	import kr.studio321.util.MathUtil;

	/**
	 * SVG 파일을 AS3의 Graphics 클래스처럼 작성할 수 있게 해줍니다.
	 * <p>( 설명 쓰기 귀찮아서 레퍼런스에서 복사해온담에 약간 수정했습니다. )</p>
	 * @author 0xABCDEF
	 */
	public class SVGWriter
	{
		
		private var svg:XML;
		
		private var pencil:Point;
		
		private var fill_d:String;
		private var d:String;
		
		private var g:XML;
		
		private var f_fill:Boolean;
		private var f_color:uint;
		private var f_alpha:Number;
		
		private var l_thickness:Number;
		private var l_color:uint;
		private var l_alpha:Number;
		private var l_pixelHinting:Boolean; // 쓸모없음
		private var l_scaleMode:String; // 쓸모없음
		private var l_caps:String;
		private var l_joints:String;
		private var l_miterLimit:Number;
		
		/**
		 * 그림이 그려질 Graphics ( 디버그용 )객체입니다.
		 * @default 
		 */
		public var graphics:Graphics;
		
		
		/**
		 * SVGWriter 객체를 생성합니다.
		 * @param graphics 그림이 그려질 Graphics ( 디버그용 )객체입니다.
		 */
		public function SVGWriter( graphics:Graphics = null )
		{
			if( graphics ) this.graphics = graphics;
			else this.graphics = new Graphics;
			clear();
		}
		
		private function setStroke( element:XML ):void
		{
			element.@stroke = MathUtil.toHex( l_color );
			element.@[ "stroke-width" ] = String( l_thickness );
			if( l_caps == null || l_caps == CapsStyle.ROUND ) element.@[ "stroke-linecap" ] = "round";
			else if( l_caps == CapsStyle.NONE ) element.@[ "stroke-linecap" ] = "butt";
			else element.@[ "stroke-linecap" ] = "square";
			if( l_joints ) element.@[ "stroke-linejoin" ] = l_joints;
			else element.@[ "stroke-linejoin" ] = "round";
			element.@[ "stroke-miterlimit" ] = String( l_miterLimit );
			element.@[ "stroke-opacity" ] = String( l_alpha );
		}
		
		private function setFill( element:XML ):void
		{
			element.@fill = MathUtil.toHex( f_color );
			element.@[ "fill-opacity" ] = String( f_alpha );
		}
		
		private function init_d():void
		{
			d = "";
		}
		
		private function init_fill():void
		{
			fill_d = "";
			f_fill = false;
			f_color = 0;
			f_alpha = 1;
		}
		
		private function init_g():void
		{
			g = <g/>;
		}
		
		private function flush_d( svg:XML, g:XML ):void
		{
			if( d.length )
			{
				var path:XML = <path/>;
				path.@fill = "none";
				setStroke( path );
				path.@d = d;
				
				if( f_fill ) g.appendChild( path );
				else svg.appendChild( path );
			}
		}
		
		private function flush_fill( svg:XML ):void
		{
			if( f_fill )
			{
				var path:XML = <path/>;
				path.@stroke = "none";
				setFill( path );
				path.@d = fill_d;
				
				svg.appendChild( path );
			}
		}
		
		private function flush_g( svg:XML ):void
		{
			if( g.children().length() ) svg.appendChild( g );
		}
		
		/**
		 * 드로잉에 다른 Graphics 메서드(예: lineTo() 또는 drawCircle())에 대한 후속 호출을 사용하는 단순한 단색 채우기를 지정합니다.
		 * <p>채우기의 효과는 endFill() 메서드를 호출할 때까지 유지됩니다.</p>
		 * @param color 채우기 색상(0xRRGGBB)입니다.
		 * @param alpha 채우기의 알파 값(0.0 ~ 1.0)입니다.
		 */
		public function beginFill( color:uint, alpha:Number = 1.0 ):void
		{
			f_fill = true;
			f_color = color;
			f_alpha = alpha;
			
			graphics.beginFill( color, alpha );
		}
		
		/**
		 * 이 SVGWriter 객체에 그린 그래픽을 지우고 채우기 및 선 스타일을 다시 설정합니다.
		 */
		public function clear():void
		{
			svg = <svg version="1.2" baseProfile="tiny" xmlns="http://www.w3.org/2000/svg"/>;
			pencil = new Point;
			init_d();
			init_fill();
			init_g();
			lineStyle();
			
			graphics.clear();
		}
		
		/**
		 * 현재의 선 스타일을 사용하여 현재의 드로잉 위치에서 (anchorX, anchorY) 위치까지 곡선을 그립니다. 제어점으로는 (controlX, controlY) 위치를 사용합니다. 그러면 현재 드로잉 위치가 (anchorX, anchorY)로 설정됩니다. 그리고 있는 동영상 클립에 Flash 드로잉 도구로 만든 내용이 포함된 경우, 이 내용 아래에 curveTo() 메서드에 대한 호출이 그려집니다. moveTo() 메서드를 호출하기 전에 curveTo() 메서드를 호출할 경우, 현재 드로잉 위치의 기본값이 (0, 0)입니다. 매개 변수가 하나라도 없으면 이 메서드는 실패하고 현재 드로잉 위치는 변경되지 않습니다.
		 * <p>그려진 곡선은 2차원 베지어 곡선입니다. 2차원 베지어 곡선은 앵커 포인트 두 개와 제어점 한 개로 구성됩니다. 이 곡선은 앵커 포인트를 두 개 삽입하고 제어점 방향으로 구부러집니다.</p>
		 * @param controlX 제어점의 가로 위치를 지정하는 숫자입니다.
		 * @param controlY 제어점의 세로 위치를 지정하는 숫자입니다.
		 * @param anchorX 다음 앵커 포인트의 가로 위치를 지정하는 숫자입니다.
		 * @param anchorY 다음 앵커 포인트의 세로 위치를 지정하는 숫자입니다.
		 */
		public function curveTo( controlX:Number, controlY:Number, anchorX:Number, anchorY:Number ):void
		{
			var str:String = "Q"+controlX+","+controlY+" "+anchorX+","+anchorY+" ";
			d += str;
			fill_d += str;
			pencil.x = anchorX;
			pencil.y = anchorY;
			
			graphics.curveTo( controlX, controlY, anchorX, anchorY );
		}
		
		/**
		 * 현재 드로잉 위치에서 지정된 앵커 포인트까지 3차 베지어 곡선을 그립니다. 3차 베지어 곡선은 앵커 포인트 두 개와 제어점 두 개로 구성됩니다. 이 곡선은 앵커 포인트를 두 개 삽입하고 두 제어점 방향으로 구부러집니다.
		 * @param controlX1 부모 표시 객체의 등록 포인트를 기준으로 첫 번째 제어점의 가로 위치를 지정합니다.
		 * @param controlY1 부모 표시 객체의 등록 포인트를 기준으로 첫 번째 제어점의 세로 위치를 지정합니다.
		 * @param controlX2 부모 표시 객체의 등록 포인트를 기준으로 두 번째 제어점의 가로 위치를 지정합니다.
		 * @param controlY2 부모 표시 객체의 등록 포인트를 기준으로 두 번째 제어점의 세로 위치를 지정합니다.
		 * @param anchorX 부모 표시 객체의 등록 포인트를 기준으로 앵커 포인트의 가로 위치를 지정합니다.
		 * @param anchorY 부모 표시 객체의 등록 포인트를 기준으로 앵커 포인트의 세로 위치를 지정합니다.
		 */
		public function cubicCurveTo( controlX1:Number, controlY1:Number, controlX2:Number, controlY2:Number, anchorX:Number, anchorY:Number ):void
		{
			var str:String = "C"+controlX1+","+controlY1+" "+controlX2+","+controlY2+" "+anchorX+","+anchorY+" ";
			d += str;
			fill_d += str;
			pencil.x = anchorX;
			pencil.y = anchorY;
			
			graphics.cubicCurveTo( controlX1, controlY1, controlX2, controlY2, anchorX, anchorY );
		}
		
		/**
		 * 원을 그립니다. drawCircle() 메서드를 호출하기 전에 linestyle() 또는 beginFill() 메서드를 호출하여 선 스타일, 채우기 또는 두 가지 모두를 설정합니다.
		 * @param x 원 중심의 x 위치(픽셀 단위)입니다.
		 * @param y 원 중심의 y 위치(픽셀 단위)입니다.
		 * @param radius
		 */
		public function drawCircle( x:Number, y:Number, radius:Number ):void
		{
			var circle:XML = <circle/>;
			circle.@cx = String( x );
			circle.@cy = String( y );
			circle.@r = String( radius );
			setStroke( circle );
			if( f_fill )
			{
				setFill( circle );
				g.appendChild( circle );
			} else {
				circle.@fill = "none";
				svg.appendChild( circle );
			}
			moveTo( x+radius, y );
			
			graphics.drawCircle( x, y, radius );
		}
		
		/**
		 * beginFill() 메서드에 대한 마지막 호출 이후로 추가된 선과 곡선에 채우기를 적용합니다. Flash는 beginFill() 메서드를 이전에 호출할 때 지정한 채우기를 사용합니다. 현재 드로잉 위치가 moveTo() 메서드에 지정된 이전 드로잉 위치와 다르고 채우기가 정의되어 있는 경우, 이 경로를 선으로 닫은 다음 채웁니다.
		 * <p><b>참고:</b> SVGWriter에서 endFill()은 명시적으로 호출되어야만 합니다. 호출되지 않았을 때의 결과물은 Graphics 클래스에서의 결과물과 약간 다를 수 있습니다. 나름대로 해결해보려고 하긴 했는데 시간만 더럽게 잡아먹고 구현도 더러워져서 그냥 포기했습니다.</p>
		 */
		public function endFill():void
		{
			flush_fill( svg );
			init_fill();
			flush_g( svg );
			init_g();
			
			graphics.endFill();
		}
		
		/**
		 * 이후에 lineTo() 메서드 또는 drawCircle() 메서드 등의 SVGWriter 메서드를 호출할 때 사용되는 선 스타일을 지정합니다. 선 스타일의 효과는 다른 매개 변수를 사용하여 lineStyle() 메서드를 호출할 때까지 유지됩니다.
		 * <p>패스를 그리는 동안 lineStyle() 메서드를 호출하면 패스 내의 여러 선분에 대해 다른 스타일을 지정할 수 있습니다.</p>
		 * <p><b>참고:</b> clear() 메서드를 호출하면 선 스타일이 다시 undefined로 설정됩니다.</p>
		 * @param thickness 선의 두께를 포인트 단위로 나타내는 정수이며 유효한 값은 0-255입니다. 숫자를 지정하지 않았거나 매개 변수가 정의되지 않은 경우 선이 그려지지 않습니다. 0보다 작은 값이 전달될 경우 기본값은 0입니다. 값 0은 매우 가는 두께를 나타내며 최대 두께는 255입니다. 255보다 큰 값이 전달될 경우 기본값은 255입니다.
		 * @param color 선의 16진수 색상 값입니다. 예를 들어 빨강은 0xFF0000, 파랑은 0x0000FF 등입니다. 값이 지정되지 않은 경우 기본값은 0x000000(검정)입니다. 선택 사항입니다.
		 * @param alpha 선 색상의 알파 값을 나타내는 숫자로, 유효한 값은 0부터 1까지입니다. 값이 지정되지 않은 경우 기본값은 1(단색)입니다. 값이 0보다 작으면 기본값은 0입니다. 값이 1보다 큰 경우 기본값은 1입니다.
		 * @param pixelHinting 쓸데없는 값입니다. 무시하셔도 됩니다. Graphics 클래스랑 모양을 똑같이 만들려고 넣었을 뿐입니다.
		 * @param scaleMode 쓸데없는 값입니다. 무시하셔도 됩니다. Graphics 클래스랑 모양을 똑같이 만들려고 넣었을 뿐입니다.
		 * @param caps 선 끝의 유형을 지정하는 CapsStyle 클래스 값입니다. 유효 값은 CapsStyle.NONE, CapsStyle.ROUND 및 CapsStyle.SQUARE입니다. 값이 지정되지 않으면 Flash에서는 라운드 끝을 사용합니다.
		 * @param joints 각도에 사용된 연결점 모양의 유형을 지정하는 JointStyle 클래스 값입니다. 유효 값은 JointStyle.BEVEL, JointStyle.MITER 및 JointStyle.ROUND입니다. 값이 지정되지 않으면 Flash에서는 라운드 연결점을 사용합니다.
		 * @param miterLimit 이음이 잘리는 한계를 나타내는 숫자입니다. 유효한 값의 범위는 1에서 255 사이이며, 이 범위를 벗어나는 값은 1 또는 255로 수정됩니다. 이 값은 jointStyle이 "miter"로 설정된 경우에만 사용됩니다. miterLimit 값은 선이 만나 연결점을 형성하는 점을 이음이 벗어날 수 있는 길이를 나타냅니다. 이 값은 선 thickness의 인수를 나타냅니다. 예를 들어 miterLimit 인수가 2.5이고 thickness가 10픽셀인 경우 25픽셀에서 이음이 잘립니다.
		 */
		public function lineStyle( thickness:Number = NaN, color:uint = 0, alpha:Number = 1.0, pixelHinting:Boolean = false, scaleMode:String = "normal", caps:String = null, joints:String = null, miterLimit:Number = 3 ):void
		{
			flush_d( svg, g );
			init_d();
			moveTo( pencil.x, pencil.y );
			if( thickness ) l_thickness = thickness;
			else l_thickness = 0;
			l_color = color;
			l_alpha = alpha;
			l_pixelHinting = pixelHinting;
			l_scaleMode = scaleMode;
			l_caps = caps;
			l_joints = joints;
			l_miterLimit = Math.min( Math.max( miterLimit, 1 ), 255 );
			
			graphics.lineStyle( thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit );
		}
		
		/**
		 * 현재의 선 스타일을 사용하여 현재의 드로잉 위치에서 (x, y) 위치까지 선을 그립니다. 그런 다음 현재의 드로잉 위치를 (x, y)로 설정합니다. moveTo() 메서드를 호출하기 전에 lineTo()를 호출하면 현재 드로잉의 기본 위치는 (0, 0)입니다. 매개 변수가 하나라도 없으면 이 메서드는 실패하고 현재 드로잉 위치는 변경되지 않습니다.
		 * @param x 수평 위치를 나타내는 숫자입니다(픽셀 단위).
		 * @param y 수직 위치를 나타내는 숫자입니다(픽셀 단위).
		 */
		public function lineTo( x:Number, y:Number ):void
		{
			var str:String = "L"+x+","+y+" ";
			d += str;
			fill_d += str;
			pencil.x = x;
			pencil.y = y;
			
			graphics.lineTo( x, y );
		}
		
		/**
		 * 현재의 드로잉 위치를 (x, y)로 옮깁니다. 매개 변수가 하나라도 없으면 이 메서드는 실패하고 현재 드로잉 위치는 변경되지 않습니다.
		 * @param x 수평 위치를 나타내는 숫자입니다(픽셀 단위).
		 * @param y 수직 위치를 나타내는 숫자입니다(픽셀 단위).
		 */
		public function moveTo( x:Number, y:Number ):void
		{
			var str:String = "M"+x+","+y+" ";
			d += str;
			if( pencil.x != x || pencil.y != y ) fill_d += str;
			pencil.x = x;
			pencil.y = y;
			
			graphics.moveTo( x, y );
		}
		
		/**
		 * 지금까지 작성한 svg 문서를 문자열로 표현합니다.
		 * @return 그림에 대한 정보가 들어있는 svg 문서입니다.
		 */
		public function toSVGString():String
		{
			var svg:XML = this.svg.copy();
			var g:XML = this.g.copy();
			flush_d( svg, g );
			flush_fill( svg );
			flush_g( svg );
			
			return svg.toXMLString();
		}
		
		/**
		 * 문자열로 변환합니다.
		 * @return 변환된 문자열입니다.
		 */
		public function toString():String
		{
			var result:String = "pencil position : " + pencil.x + ", " + pencil.y + "\n";
			result += "status of fill : " + f_fill + "\n";
			result += "path buffer : " + d + "\n";
			result += "fill buffer : " + fill_d + "\n\n";
			result += "- fill style -\n";
			result += "color : " + MathUtil.toHex( f_color ) + "\n";
			result += "alpha : " + f_alpha + "\n\n";
			result += "- line style -\n";
			result += "thickness : " + l_thickness + "\n";
			result += "color : " + MathUtil.toHex( l_color ) + "\n";
			result += "alpha : " + l_alpha + "\n";
			result += "cap style : " + l_caps + "\n";
			result += "joint style : " + l_joints + "\n";
			result += "miter limit : " + l_miterLimit + "\n";
			return result;
		}
		
	}
}