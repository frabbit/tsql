
package tsql;

import haxe.ds.Option;

import tsql.Data;
import tsql.Ast;

typedef SqT = SqlType;


enum IntLike {
	ILBit(len:Option<Int>);
	ILSmallInt(len:Option<Int>, unsigned:Bool);
	ILTinyInt(len:Option<Int>, unsigned:Bool);
	ILMediumInt(len:Option<Int>, unsigned:Bool);
	ILInt(len:Option<Int>, unsigned:Bool);
	ILBigInt(len:Option<Int>, unsigned:Bool);
}

enum FloatLike {
	FLDouble(len:Option<Int>, decimals:Option<Int>, unsigned:Bool);
	FLFloat(len:Option<Int>, decimals:Option<Int>,unsigned:Bool);
	FLReal(len:Option<Int>, decimals:Option<Int>, unsigned:Bool);
}

enum StringLike {
	SLChar(len:Int);
	SLVarChar(len:Int);
	SLTinyText(binary:Bool);
	SLMediumText(binary:Bool);
	SLText(binary:Bool);
	SLLongText(binary:Bool);
}

enum DateOrTime {
	DTDate;
	DTTime;
	DTTimestamp;
	DTDateTime;
	DTYear;
}
enum BlobLike {
	BLBinary(len:Int);
	BLVarBinary(len:Int);
	BLTinyBlob;
	BLBlob;
	BLMediumBlob;
	BLLongBlob;
}

enum SqlType {
	STUnknown;

	STBool;

	STInt(x:IntLike);
	STFloat(x:FloatLike);
	STString(x:StringLike);

	STDateOrTime(x:DateOrTime);
	STBlob(b:BlobLike);
	
	STNull(t:SqlType);
	
	STEnum(values:Array<String>);
	
	STSet(values:Array<String>);
	
	// table or subselects as table refs
	
	STObject(fields:Array<{ name : String, t:SqlType}>);
	//STTuple(t:Array<SqlType>);
}

class SqlTypes {
	public static function isUnknown (t:SqlType) {
		return t.match(STUnknown);
	}
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

class TypedExprs {
	public static function isWildcard (t:TypedExpr) {
		return t.match(TWildcard(_));
	}

	public static function replaceWildcardType (t:TypedExpr, st:SqlType):TypedExpr {
		return switch t {
			case TWildcard(_): TWildcard(st);
			case _ : t;
		}
	}

	public static function replaceUntypedWildcard (t:TypedExpr, st:SqlType):TypedExpr {
		return switch t {
			case TWildcard(STUnknown): TWildcard(st);
			case _ : t;
		}
	}
	
	public static function type (t:TypedExpr) {
		return switch t {
			case TNamed(_, _, t): t;
			case TAllColumns(_,t): t;
			case TColumn(_,_,t): t;
			case TIdent(_,t): t;
			case TConst(_,t): t;
			case TFunction(_,_,t): t;
			case TBinop(_,_,_,t): t;
			case TUnop(_,_,t): t;
			case TTernop(_,_,_,_,t): t;
			case TSubSelect(_,t): t;
			case TMultiple(_,t): t;
			case TParenthesis(_,t): t;
			case TWildcard(t): t;
		}
	}
}

enum TypedStatement {
	TStSelect(s:TypedSelect);
	TStCreate(s:TypedCreate);
	TStUpdate(u:TypedUpdate);
	TStInsert(x:TypedInsert);
}


typedef TypedOrderBy = Array<{ e:TypedExpr, dir:Direction }>;

typedef TypedGroupBy = {
	groups: Array<{ e:TypedExpr, dir:Direction }>,
	withRollup : Bool
}

typedef TypedSelect = {
	selectExprs : Array<TypedExpr>,
	from : Option<TableReferences>,
	where : Option<TypedExpr>,
	limit : Option<Limit>,
	orderBy : Option<TypedOrderBy>,
	groupBy : Option<TypedGroupBy>,
	having : Option<TypedExpr>,
	type : SqlType,

}

enum TypedCreate {
	TCSchema(schema:TableSchema);
	TCLike(table:String, likeTable:String);
}

enum TypedUpdate {
	TUpdate(tables:TableReferences, sets:Array<{ col : String, expr:ExprOrDefault}>, where:Option<Expr>, orderBy:Option<OrderBy>, limit:Option<Int>);
}

enum TypedInsert {
	TInsertWithSets(table:String, sets:Array<{ col : String, expr:ExprOrDefault}>, duplicateKeyUpdate:Option<Array<{col:String, expr:Expr}>>);
	TInsertWithSelect(table:String, cols:Array<String>, s:Select, duplicateKeyUpdate:Option<Array<{col:String, expr:Expr}>>);
}