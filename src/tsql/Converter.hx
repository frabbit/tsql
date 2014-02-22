
package tsql;

import haxe.ds.Option;


interface ToSqlConverter {


	public function toSqlUnknown (d:Dynamic):String;

	public function dateToSqlDate (d:Date):String;
	public function dateToSqlTime (d:Date):String;
	public function dateToSqlTimestamp (d:Date):String;
	public function dateToSqlDateTime (d:Date):String;
	public function dateToSqlYear (d:Date):String;

	public function toSqlNull <X>(x:Option<X>, f:X->String):String;

	public function stringToSqlVarChar (s:String, len:Int):String;
	public function stringToSqlChar (s:String, len:Int):String;
	public function stringToSqlText (s:String):String;
	public function stringToSqlTinyText (s:String):String;
	public function stringToSqlMediumText (s:String):String;
	public function stringToSqlLongText (s:String):String;


	public function intToSqlSmallInt (i:Int, unsigned:Bool):String;
	public function intToSqlInt (i:Int, unsigned:Bool):String;
	public function intToSqlTinyInt (i:Int, unsigned:Bool):String;
	public function intToSqlMediumInt (i:Int, unsigned:Bool):String;
	public function intToSqlBigInt (i:Int, unsigned:Bool):String;

	public function floatToSqlDouble (f:Float, unsigned:Bool):String;
	public function floatToSqlFloat (f:Float, unsigned:Bool):String;
	public function floatToSqlReal (f:Float, unsigned:Bool):String;

	public function boolToSqlBit (b:Bool):String;

}


interface FromSqlConverter {

	
	public function sqlDateToDate (d:Dynamic):Date;

	public function sqlTimeToDate (d:Dynamic):Date;


	public function sqlTimestampToDate (d:Date):Date;

	public function sqlDateTimeToDate (d:Dynamic):Date;

	public function sqlYearToDate (d:Dynamic):Date;

	public function sqlNullToX <X>(x:Dynamic, f:Dynamic->X):Option<X>;
	public function sqlVarCharToString (s:Dynamic):String;
	public function sqlCharToString (s:Dynamic):String;

	public function sqlTinyTextToString (s:Dynamic):String;

	public function sqlMediumTextToString (s:Dynamic):String;

	public function sqlTextToString (s:Dynamic):String;
	public function sqlLongTextToString (s:Dynamic):String;



	public function sqlSmallIntToInt (x:Dynamic):Int;

	public function sqlIntToInt (x:Dynamic):Int;

	public function sqlTinyIntToInt (x:Dynamic):Int;

	public function sqlMediumIntToInt (x:Dynamic):Int;

	public function sqlBigIntToInt (x:Dynamic):Int;

	public function sqlDoubleToFloat (x:Dynamic):Float;

	public function sqlFloatToFloat (x:Dynamic):Float;

	public function sqlRealToFloat (x:Dynamic):Float;

	public function sqlBitToBool (x:Dynamic):Bool;

}