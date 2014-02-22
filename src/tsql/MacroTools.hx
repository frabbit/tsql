package tsql;


import tsql.Typed.SqlType;

import haxe.macro.Type;
import haxe.macro.Expr;

private typedef MExpr = haxe.macro.Expr;

class MacroTools {

	public static function sqlTypeToConversion (t:SqlType, converter:Expr):MExpr
	{
		var c = converter;
		return switch (t) 
		{
			case STUnknown:        		    macro $c.runTimeConvert;
			case STBool,STInt(ILBit(_)):           macro $c.boolToSqlBit;
			case STInt(ILSmallInt(l,u)):    macro $c.intToSqlSmallInt.bind(_, $v{u});
			case STInt(ILTinyInt(l,u)):     macro $c.intToSqlTinyInt.bind(_, $v{u});
			case STInt(ILMediumInt(l,u)):   macro $c.intToSqlMediumInt.bind(_, $v{u});
			case STInt(ILInt(l,u)):         macro $c.intToSqlInt.bind(_, $v{u});
			case STInt(ILBigInt(l,u)):      macro $c.intToSqlBigInt.bind(_, $v{u});
			case STFloat(FLDouble(_,_,u)):  macro $c.floatToSqlDouble.bind(_, $v{u});
			case STFloat(FLFloat(_,_,u)):   macro $c.floatToSqlFloat.bind(_, $v{u});
			case STFloat(FLReal(_,_,u)):    macro $c.floatToSqlReal.bind(_, $v{u});
			case STString(SLChar(len)):     macro $c.stringToSqlChar.bind(_, $v{len});
			case STString(SLVarChar(len)):  macro $c.stringToSqlVarChar.bind(_, $v{len});
			case STString(SLTinyText(_)):   macro $c.stringToSqlTinyText;
			case STString(SLMediumText(_)): macro $c.stringToSqlMediumText;
			case STString(SLText(_)):       macro $c.stringToSqlText;
			case STString(SLLongText(_)):   macro $c.stringToSqlLongText;
			case STDateOrTime(DTDate):      macro $c.dateToSqlDate;
			case STDateOrTime(DTTime):      macro $c.dateToSqlTime;
			case STDateOrTime(DTTimestamp): macro $c.dateToSqlTimestamp;
			case STDateOrTime(DTDateTime):  macro $c.dateToSqlDateTime;
			case STDateOrTime(DTYear):      macro $c.dateToSqlYear;
			case STBlob(b):        throw "assert";
			case STNull(t):    
				var f = sqlTypeToConversion(t, c);
				macro $c.toSqlNull.bind(_, $f);
			case STEnum(values):   throw "assert";
			case STSet(values):    throw "assert";
			case STObject(fields): throw "assert";
		}
	}

	/*
	typedef TypePath = {
	var pack : Array<String>;
	var name : String;
	@:optional var params : Array<TypeParam>;
	@:optional var sub : Null<String>;
}*/	

	/*enum ComplexType {
		TPath( p : TypePath );
		TFunction( args : Array<ComplexType>, ret : ComplexType );
		TAnonymous( fields : Array<Field> );
		TParent( t : ComplexType );
		TExtend( p : Array<TypePath>, fields : Array<Field> );
		TOptional( t : ComplexType );
	}*/

	public static function sqlTypeToComplexType (t:SqlType):ComplexType {
		return switch (t) {
			case STUnknown:        TPath({ name : "Dynamic", pack : []});
			case STBool: 	       TPath({ name : "Bool", pack : [] });
			case STInt(x):         TPath({ name : "Int", pack : [] });
			case STFloat(x):       TPath({ name : "Float", pack : [] });
			case STString(x):      TPath({ name : "String", pack : [] });
			case STDateOrTime(x):  TPath({ name : "Date", pack : [] });
			case STBlob(b):        throw "assert";
			case STNull(t):        TPath({ name : "Null", pack : [], params : [TPType(sqlTypeToComplexType(t))] });
			case STEnum(values):   throw "assert";
			case STSet(values):    throw "assert";
			case STObject(fields): throw "assert";	
		}
	}
	



}