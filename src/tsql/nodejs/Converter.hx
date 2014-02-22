
package tsql.nodejs;

import haxe.ds.Option;

using StringTools;

import tsql.Converter.FromSqlConverter;
import tsql.Converter.ToSqlConverter;

class NodeToSqlConverter implements ToSqlConverter {

	public function new () {}

	function leftPad (d:Dynamic, char:String, until:Int) 
	{
		return Std.string(d).lpad(char,until);
	}

	public function toSqlUnknown (d:Dynamic):String 
	{
		// we need runtime conversion here because
		// the type couldn't be inferred
		return throw "not implemented";
	}


	public function dateToSqlDate (d:Date):String 
	{
		return d.getFullYear() + "-" + leftPad(d.getMonth()+1, "0", 2) + "-" + leftPad(d.getDate(), "0", 2);
	}
	public function dateToSqlTime (d:Date):String 
	{
		return leftPad(d.getHours(), "0", 2) + ":" + leftPad(d.getMinutes(), "0", 2) + ":" + leftPad(d.getSeconds(), "0", 2);
	}


	public function dateToSqlTimestamp (d:Date):String 
	{
		//Std.string(Math.round(d.getTime()*1000));
		return dateToSqlDateTime(d);
	}

	public function dateToSqlDateTime (d:Date):String 
	{
		return dateToSqlDate(d) + " " + dateToSqlTime(d);
	}

	public function dateToSqlYear (d:Date):String 
	{
		return Std.string(d.getFullYear());
	}

	public function toSqlNull <X>(x:Option<X>, f:X->String):String
	{
		return switch (x) {
			case Some(x): f(x);
			case None : "NULL";
		}
	}

	public function stringToSqlVarChar (s:String, len:Int):String 
	{
		if (s.length > len) throw "String with length("+s.length+") to large for VarChar("+len+")";
		return s;
	}

	public function stringToSqlChar (s:String, len:Int):String 
	{
		if (s.length > len) throw "String with length("+s.length+") to large for Char("+len+")";
		return s;
	}



	public function stringToSqlText (s:String):String 
	{
		return s;
	}

	public function stringToSqlTinyText (s:String):String 
	{
		return s;
	}

	public function stringToSqlMediumText (s:String):String 
	{
		return s;
	}

	public function stringToSqlLongText (s:String):String 
	{
		return s;
	}

	public function intToSqlSmallInt (i:Int, unsigned:Bool):String 
	{
		if (!unsigned && i < 0) throw "cannot convert negative integer ("+i+") to signed small int";
		return Std.string(i);
	}

	public function intToSqlInt (i:Int, unsigned:Bool):String 
	{
		if (!unsigned && i < 0) throw "cannot convert negative integer ("+i+") to signed int";
		return Std.string(i);
	}

	public function intToSqlTinyInt (i:Int, unsigned:Bool):String 
	{
		if (!unsigned && i < 0) throw "cannot convert negative integer ("+i+") to signed tiny int";
		return Std.string(i);
	}

	public function intToSqlMediumInt (i:Int, unsigned:Bool):String 
	{
		if (!unsigned && i < 0) throw "cannot convert negative integer ("+i+") to signed medium int";
		return Std.string(i);
	}

	public function intToSqlBigInt (i:Int, unsigned:Bool):String 
	{
		if (!unsigned && i < 0) throw "cannot convert negative integer ("+i+") to signed big int";
		return Std.string(i);
	}

	public function floatToSqlDouble (f:Float, unsigned:Bool):String 
	{
		if (!unsigned && f < 0) throw "cannot convert negative float ("+f+") to signed double";
		return Std.string(f);
	}

	public function floatToSqlFloat (f:Float, unsigned:Bool):String 
	{
		if (!unsigned && f < 0) throw "cannot convert negative float ("+f+") to signed float";
		return Std.string(f);
	}

	public function floatToSqlReal (f:Float, unsigned:Bool):String 
	{
		if (!unsigned && f < 0) throw "cannot convert negative float ("+f+") to signed real";
		return Std.string(f);
	}

	public function boolToSqlBit (b:Bool):String 
	{
		return if (b) "1" else "0";
	}

}


class NodeFromSqlConverter implements FromSqlConverter{

	function leftPad (d:Dynamic, char:String, until:Int) 
	{
		return Std.string(d).lpad(char,until);
	}

	//public static function runtimeConvert (d:Dynamic):String 
	//{
	//	return throw "not implemented";
	//}


	public function sqlDateToDate (d:Dynamic):Date 
	{
		var s = Std.string(d);
		var parts = s.split("-");
		var year = Std.parseInt(parts[0]);
		var month = Std.parseInt(parts[1])-1;
		var date = Std.parseInt(parts[2]);
		return new Date(year, month, date,0,0,0);
	}

	public function sqlTimeToDate (d:Dynamic):Date 
	{
		var s = Std.string(d);
		var parts = s.split(":");
		var hour = Std.parseInt(parts[0]);
		var minutes = Std.parseInt(parts[1]);
		var secs = Std.parseInt(parts[2]);
		return new Date(0,0,0, hour, minutes, secs);
	}


	public function sqlTimestampToDate (d:Date):Date 
	{

		return sqlDateTimeToDate(d);
	}

	public function sqlDateTimeToDate (d:Dynamic):Date 
	{
		var s = Std.string(d);
		var parts = s.split(" ");
		var dateParts = parts[0].split("-");
		var timeParts = parts[1].split(":");

		var year = Std.parseInt(dateParts[0]);
		var month = Std.parseInt(dateParts[1])-1;
		var date = Std.parseInt(dateParts[2]);

		var hour = Std.parseInt(timeParts[0]);
		var minutes = Std.parseInt(timeParts[1]);

		var secParts = timeParts[2].split(".");

		var secs = Std.parseInt(secParts[0]);

		// micro seconds in 5.6.4 are allowed, how to deal with them

		//var micro = secParts.length > 1 ? Std.parseInt(secParts[1]) : 0;
		

		return new Date(year, month, date, hour, minutes, secs);
	}

	public function sqlYearToDate (d:Dynamic):Date 
	{
		var s = Std.string(d);
		var year = Std.parseInt(s);
		return new Date(year, 0,0,0,0,0);
	}

	public function sqlNullToX <X>(x:Dynamic, f:Dynamic->X):Option<X>
	{
		var s = Std.string(x);
		return if (s.toLowerCase() == "null") None else Some(f(x));
	}

	public function sqlVarCharToString (s:Dynamic):String 
	{
		return Std.string(s);
	}

	public function sqlCharToString (s:Dynamic):String 
	{
		return Std.string(s);
	}

	public function sqlTinyTextToString (s:Dynamic):String 
	{
		return Std.string(s);
	}

	public function sqlMediumTextToString (s:Dynamic):String 
	{
		return Std.string(s);
	}

	public function sqlTextToString (s:Dynamic):String 
	{
		return Std.string(s);
	}

	public function sqlLongTextToString (s:Dynamic):String 
	{
		return Std.string(s);
	}



	public function sqlSmallIntToInt (x:Dynamic):Int 
	{
		return Std.parseInt(Std.string(x));
	}

	public function sqlIntToInt (x:Dynamic):Int 
	{
		return Std.parseInt(Std.string(x));
	}

	public function sqlTinyIntToInt (x:Dynamic):Int 
	{
		return Std.parseInt(Std.string(x));
	}

	public function sqlMediumIntToInt (x:Dynamic):Int 
	{
		return Std.parseInt(Std.string(x));
	}

	public function sqlBigIntToInt (x:Dynamic):Int 
	{
		return throw "assert";
	}

	public function sqlDoubleToFloat (x:Dynamic):Float 
	{
		return Std.parseFloat(Std.string(x));
	}

	public function sqlFloatToFloat (x:Dynamic):Float 
	{
		return Std.parseFloat(Std.string(x));
	}

	public function sqlRealToFloat (x:Dynamic):Float 
	{
		return Std.parseFloat(Std.string(x));
	}

	public function sqlBitToBool (x:Dynamic):Bool 
	{
		var s = Std.string(x);
		return switch (s) {
			case "0": false;
			case "1": true;
			case _ : throw "assert";
		}
	}

}