
package tsql;

import haxe.ds.Option;
import haxe.ds.StringMap;
import tsql.Typed.SqlType;


// https://dev.mysql.com/doc/refman/5.0/en/expressions.html



enum Constant {
	CInt(x:String);
	CString(x:String);
	CFloat(x:String);
	CBool(b:Bool);
	CNull;
}


typedef ScalarSubQuery = {}

typedef SubQuery = {}

enum Literal {

}



enum Expr {
	ENamed(e:Expr, as:String);
	EAllColumns(table:Option<String>);
	EColumn(n:String, table:Option<String>);
	EIdent(n:String);
	EConst(c:Constant);
	EFunction(name:String, params:Array<Expr>);
	EBinop(op:Binop, e1:Expr, e2:Expr);
	EUnop(op:Unop, e:Expr);
	ETernop(e1:Expr, op:Ternop, e2:Expr, e3:Expr);
	ESubSelect(select:Select);
	EMultiple(terms:Array<Expr>);
	EParenthesis(e:Expr);
	EWildcard;


}



typedef Select = {
	selectExprs : Array<Expr>,
	from : Option<TableReferences>,
	where : Option<Expr>,
	limit : Option<Limit>,
	orderBy : Option<OrderBy>,
	groupBy : Option<GroupBy>,
	having : Option<Expr>,

}


typedef WhereCondition = Expr

enum Direction {
	Asc;
	Desc;
}

typedef OrderBy = Array<{ e:Expr, dir:Direction }>;
typedef GroupBy = {
	groups: Array<{ e:Expr, dir:Direction }>,
	withRollup : Bool
}

typedef Limit = { count:Int, offset:Option<Int> }


enum Create {
	CSchema(schema:TableSchema);
	CLike(table:String, likeTable:String);
}


enum Update {
	USimple(table:String, sets:Array<{ col : String, expr:Expr}>, where:Option<Expr>, orderBy:Option<OrderBy>, limit:Option<Int>);
}

enum Insert {
	UInsert(table:String, sets:Array<{ col : String, expr:Expr}>, where:Option<Expr>, orderBy:Option<OrderBy>, limit:Option<Int>);
}



enum Statement {
	StSelect(s:Select);
	StCreate(s:Create);
	StUpdate(u:Update);
	StInsert(x:Insert);
}



enum Binop {
	OpGt;
	OpGte;
	OpLte;
	OpLt;
	OpEq;
	OpNotEq;
	OpNotIn;
	OpLike;
	OpIn;
	OpBoolAnd;
	OpBoolOr;
	OpBoolXor;
	OpAdd;
	OpSub;
	OpMult;
	OpDiv;
	OpLeftShift;
	OpRightShift;
	OpOr;
	OpXor;
	OpAnd;
	OpMod;
}

enum Unop {
	OpIsNull;
	OpIsNotNull;
	OpExists;
	OpNotExists;
	OpNot;
	OpPlus;
	OpMinus;
}

enum Ternop {
	Between;
	NotBetween;
}










// From Table Syntax

enum JoinOp {
	JInner;
	JCross;
	JStraightJoin;
	JOuter;
	JNatural;
	JLeft;
	JRight;
	//JMul(joins:Array<JoinOp>);


}


typedef ContitionalExpr = {}

enum JoinCondition  {
	JcOn(e:Expr);
	JcUsing(ex:Array<Expr>);
}

//enum TableJoin {
//	TjInnerJoin(tf:TableFactor, cond:Option<JoinCondition>);
//	TjCrossJoin(tf:TableFactor, cond:Option<JoinCondition>);
//	TjStraightJoin(tf:TableFactor, cond:Option<ContitionalExpr>);
//	TjJoin(side:TableJoinSide, outer:Bool, tr:TableReference, cond:JoinCondition);
//	Natural(side:TableJoinSide, outer:Bool, tf:TableFactor);
//}

enum TableReference  {

	TrSimple(name:String);
	TrJoinTable(t1:TableReference, op:Array<JoinOp>, t2:TableReference, joinCondition:Option<JoinCondition>);

	TrNamed(t:TableReference, alias:String);
	//TrMulti(refs:Array<TableReference>);
	TrSubSelect(s:Select);

}


/*
enum TableFactor {
	TfSimple(name:String, alias:Option<String>, indexHint:Option<IndexHint>);
	TfSubQuery(q:TableSubQuery, alias:String);
	TfMulti(refs:TableReferences);
}
*/


// currently ignored
enum IndexHint { /* incomplete */
	IhUse;
	IhIgnore;
	IhForce;
}

typedef TableReferences = Array<TableReference>;


enum ReferenceOption {
	RoRestrict;
	RoCascade;
	RoSetNull;
	RoNoAction;
}



typedef TableColumnReference = {
	tableName : String,
	colName : String,
	onDelete : Option<ReferenceOption>,
	onUpdate : Option<ReferenceOption>
}

typedef TableColumn = {
	type : SqlType,
	name : String,
	defaultVal : Option<Expr>,
	autoIncrement : Bool,
	unique : Bool,
	key : Bool,
	primary : Bool,
	reference : Option<TableColumnReference>,



}

enum TableOption {
	ToCharacterSet(s:String, collate:Option<String>);
	ToEngine(engine : String);
	ToAutoIncrement(start:Int);
	
}

enum CreateDef {
	CDColumn(t:TableColumn);
	// constraints etc.
}

typedef TableSchema = {
	options: Array<TableOption>,
	columns : Map<String,TableColumn>
}