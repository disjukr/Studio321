package kr.studio321.geom
{
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * 경로를 정의합니다.
	 * @author 0xABCDEF
	 */
	public class Path implements ISegment
	{
		/**
		 * 선분의 집합입니다.
		 * @default 
		 */
		public var segments:Vector.<ISegment>;
		
		/**
		 * 경로 객체를 생성합니다.
		 */
		public function Path()
		{
			segments = new Vector.<ISegment>;
		}
		
		/**
		 * 선분을 추가합니다.
		 * @param segment 추가할 선분입니다.
		 */
		public function addSegment( segment:ISegment ):void
		{
			segments.push( segment );
		}
		
		/**
		 * 모든 점들을 반환합니다.
		 * @return 선분을 이루는 점들의 집합입니다.
		 */
		public function getPoints():Vector.<Point>
		{
			var points:Vector.<Point> = new Vector.<Point>;
			for each( var segment:ISegment in segments )
			{
				points = points.concat( segment.getPoints() );
			}
			return points;
		}
		
		/**
		 * 접선벡터를 반환합니다.
		 * @param t 0~1 사이의 값입니다.
		 * @return t에 해당하는 접선벡터를 반환합니다.
		 */
		public function tangent( t:Number ):Point
		{
			if( t >= 1 ) return segments[ segments.length-1 ].tangent( 1 );
			var position:int = segments.length*t;
			return segments[ position ].tangent( t );
		}
		
		/**
		 * target에다가 t에 해당하는 값을 집어넣고 그 순간의 각도( 라디안 )를 반환합니다.
		 * @param target 값이 들어갈 점입니다.
		 * @param t 0~1 사이의 값입니다.
		 * @return t에 해당하는 각도( 라디안 )입니다.
		 */
		public function process( target:Point, t:Number ):Number
		{
			if( t >= 1 ) return segments[ segments.length-1 ].process( target, 1 );
			var position:int = segments.length*t;
			return segments[ position ].process( target, ( t-position/segments.length )*segments.length );
		}
		
		/**
		 * 이 선분의 구간을 반환합니다.
		 * @param start 시작할 시점( t )입니다.
		 * @param end 끝날 시점( t )입니다.
		 * @return 이 선분의 구간입니다.
		 */
		public function section( start:Number, end:Number ):ISegment
		{
			var startPos:int = segments.length*start;
			var endPos:int = segments.length*end;
			var section:Path = new Path;
			for( var i:int=start; i<=end; ++i )
			{
				if( i != startPos )if( i != endPos ) section.addSegment( segments[ i ] );
				else section.addSegment( segments[ i ].section( ( start-startPos/segments.length )*segments.length, ( end-endPos/segments.length )*segments.length ) );
			}
			return section;
		}
		
		/**
		 * target에다가 t에 해당하는 그림을 그립니다.
		 * @param target 그림이 그려질 대상입니다.
		 * @param t 0~1 사이의 값입니다.
		 */
		public function processOnGraphics( target:Graphics, t:Number ):void
		{
			var position:int = segments.length*t;
			if( t >= 1 ) position = segments.length -1;
			for( var i:int=0; i<=position; ++i )
			{
				if( i != position ) segments[ i ].drawOnGraphics( target );
				else segments[ i ].processOnGraphics( target, ( t-position/segments.length )*segments.length );
			}
		}
		
		/**
		 * 이 선분을 그립니다.
		 * @param target 그림이 그려질 대상입니다.
		 */
		public function drawOnGraphics( target:Graphics ):void
		{
			for each( var segment:ISegment in segments )
			{
				segment.drawOnGraphics( target );
			}
		}
		
		/**
		 * 이 선분의 구간을 그립니다.
		 * @param target 그림이 그려질 대상입니다.
		 * @param start 시작할 시점( t )입니다.
		 * @param end 끝날 시점( t )입니다.
		 */
		public function sectionOnGraphics( target:Graphics, start:Number, end:Number ):void
		{
			var startPos:int = segments.length*start;
			var endPos:int = segments.length*end;
			for( var i:int=start; i<=end; ++i )
			{
				if( i != startPos )if( i != endPos ) segments[ i ].drawOnGraphics( target );
				else segments[ i ].sectionOnGraphics( target, ( start-startPos/segments.length )*segments.length, ( end-endPos/segments.length )*segments.length );
			}
		}
		
		// TODO : weld 메서드( segment 벡터를 순회하면서 A의 시작점과 B의 끝점의 좌표가 같은 케이스의 선들을 이어줌 )
		
		/**
		 * 문자열로 변환합니다.
		 * @return 변환된 문자열입니다.
		 */
		public function toString():String
		{
			var result:String = "";
			for each( var segment:ISegment in segments )
			{
				var points:Vector.<Point> = segment.getPoints();
				result += getQualifiedClassName( segment ).split( "::" )[ 1 ] + " : ";
				for each( var point:Point in points )
				{
					result += "( "+point.x+", "+point.y+" )";
				}
				result += "\n";
			}
			result += "Number of segments : " + segments.length;
			return result;
		}
		
	}
}