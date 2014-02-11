
package tsql;

import haxe.ds.Option;

import tsql.Data;
import tsql.Ast;

typedef SqT = SqlType;



enum SqlType {
	STUnknown;
	STBit(len:Option<Int>);
	STSmallInt(len:Option<Int>, unsigned:Bool);
	STTinyInt(len:Option<Int>, unsigned:Bool);
	STMediumInt(len:Option<Int>, unsigned:Bool);
	STInt(len:Option<Int>, unsigned:Bool);
	STBigInt(len:Option<Int>, unsigned:Bool);
	STDouble(len:Option<Int>, decimals:Option<Int>, unsigned:Bool);
	STFloat(len:Option<Int>, decimals:Option<Int>,unsigned:Bool);
	STReal(len:Option<Int>, decimals:Option<Int>, unsigned:Bool);
	STDate;
	STTime;
	STTimestamp;
	STDateTime;
	STYear;
	STChar(len:Int);
	STVarChar(len:Int);
	STBinary(len:Int);
	STVarBinary(len:Int);
	STTinyBlob;
	STBlob;
	STMediumBlob;
	STLongBlob;
	STTinyText(binary:Bool);
	STMediumText(binary:Bool);
	STText(binary:Bool);
	STNull(t:SqlType);
	STEnum(values:Array<String>);
	STSet(values:Array<String>);
	// table or subselects as table refs
	STObject(fields:Array<{ name : String, t:SqlType}>);
	//STTuple(t:Array<SqlType>);
		

}

enum TypedExpr {
	TNamed(e:TypedExpr, as:String, t:SqlType);
	TAllColumns(table:Option<String>, t:SqlType);
	TColumn(n:String, table:Option<String>, t:SqlType);
	TIdent(n:String, t:SqlType);
	TConst(c:Constant, t:SqlType);
	TFunction(name:String, params:Array<TypedExpr>, t:SqlType);
	TBinop(op:Binop, e1:TypedExpr, e2:TypedExpr, t:SqlType);
	TUnop(op:Unop, e:TypedExpr, t:SqlType);
	TTernop(e1:TypedExpr, op:Ternop, e2:TypedExpr, e3:TypedExpr, t:SqlType);
	TSubSelect(select:Select, t:SqlType);
	TMultiple(terms:Array<TypedExpr>, t:SqlType);
	TParenthesis(e:TypedExpr, t:SqlType);
	TWildcard(t:SqlType);


}