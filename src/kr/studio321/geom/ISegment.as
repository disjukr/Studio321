package kr.studio321.geom
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Point;

	/**
	 * 선분을 정의합니다.
	 * @author 0xABCDEF
	 */
	public interface ISegment
	{
		
		/**
		 * 모든 점들을 반환합니다.
		 * @return 선분을 이루는 점들의 집합입니다.
		 */
		function getPoints():Vector.<Point>;
		
		/**
		 * 접선벡터를 반환합니다.
		 * @param t 0~1 사이의 값입니다.
		 * @return t에 해당하는 접선벡터를 반환합니다.
		 */
		function tangent( t:Number ):Point;
		
		/**
		 * target에다가 t에 해당하는 값을 집어넣고 그 순간의 각도( 라디안 )를 반환합니다.
		 * @param target 값이 들어갈 점입니다.
		 * @param t 0~1 사이의 값입니다.
		 * @return t에 해당하는 각도( 라디안 )입니다.
		 */
		function process( target:Point, t:Number ):Number;
		
		/**
		 * 이 선분의 구간을 반환합니다.
		 * @param start 시작할 시점( t )입니다.
		 * @param end 끝날 시점( t )입니다.
		 * @return 이 선분의 구간입니다.
		 */
		function section( start:Number, end:Number ):ISegment;
		
		/**
		 * target에다가 t에 해당하는 그림을 그립니다.
		 * @param target 그림이 그려질 대상입니다.
		 * @param t 0~1 사이의 값입니다.
		 */
		function processOnGraphics( target:Graphics, t:Number ):void;
		
		/**
		 * 이 선분을 그립니다.
		 * @param target 그림이 그려질 대상입니다.
		 */
		function drawOnGraphics( target:Graphics ):void;
		
		/**
		 * 이 선분의 구간을 그립니다.
		 * @param target 그림이 그려질 대상입니다.
		 * @param start 시작할 시점( t )입니다.
		 * @param end 끝날 시점( t )입니다.
		 */
		function sectionOnGraphics( target:Graphics, start:Number, end:Number ):void;
		
	}
}