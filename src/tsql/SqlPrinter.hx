
package tsql;

import haxe.ds.Option;
import tsql.Ast;

class SqlPrinter {

	public function new () {

	}

	public function printStatement (s:Statement) {
		return switch (s) {
			case StSelect(x): printSelect(x);
			case StCreate(x): printCreate(x);
			case StUpdate(x): printUpdate(x);
			case StInsert(x): printInsert(x);
			case StAlterTable(x): printAlterTable(x);
		}
	}

	public function printOpt <X>(x:Option<X>, f:X->String, prefix = "", postfix = "") {
		return switch (x) 
		{
			case Some(x): prefix + f(x) + postfix;
			case None: "";
		}
	}	

	public function printCommaSeparatedList <X>(a:Array<X>, f:X->String) 
	{
		var first = true;
		var s = "";
		for (x in a) {
			var prefix = if (first) { first = false; ""; } else ",";
			s += prefix + f(x);
		}
		return s;
	}

	function printConstant(c:Constant) {
		return switch (c) {
			case CNull: "null";
			case CFloat(x): x;
			case CInt(x): x;
			case CString(x): "'" + x + "'";
			case CBool(true): "TRUE";
			case CBool(false): "FALSE";
		}
	}

	function printUnop (op:Unop) {
		return switch op {
			case OpIsNull: " IS NULL ";
			case OpIsNotNull: " IS NOT NULL ";
			case OpExists: " EXISTS ";
			case OpNotExists: " NOT EXISTS ";
			case OpNot: " NOT ";
			case OpPlus: "+";
			case OpMinus: "-";
		}
	}

	function printTernop (op:Ternop) {
		return switch op {
			case OpBetween: " BETWEEN ";
			case OpNotBetween: " NOT BETWEEN ";
		}
	}

	function printBinop (op:Binop) {
		return switch op {
			case OpGt: ">";
			case OpGte: ">=";
			case OpLte: "<=";
			case OpLt: "<";
			case OpEq: "=";
			case OpNotEq: "!=";
			case OpNotIn: " NOT IN ";
			case OpLike: " LIKE ";
			case OpIn: " IN ";
			case OpBoolAnd: " AND ";
			case OpBoolOr: " OR ";
			case OpBoolXor: " XOR ";
			case OpAdd: "+";
			case OpSub: "-";
			case OpMult: "*";
			case OpDiv: " DIV ";
			case OpLeftShift: "<<";
			case OpRightShift: ">>";
			case OpOr: "|";
			case OpXor: "^";
			case OpAnd: "&";
			case OpMod: "%";
		}
	}

	function printStr (s:String) return s;

	public function printExpr (e:Expr) 
	{
		return switch e 
		{
			case ENamed(e, as): printExpr(e) + " as " + "`" + as + "`";
			case EAllColumns(table): printOpt(table, printStr, "`", "`.") + "*"; 
			case EColumn(n, table): printOpt(table, printStr, "`", "`.") + "`" + n + "`"; 
			case EIdent(n): n;
			case EConst(c): printConstant(c);
			case EFunctionCall(name, params): 
				name + "(" + printCommaSeparatedList(params, printExpr) + ")";
			case EBinop(op, e1, e2): 
				printExpr(e1) + printBinop(op) + printExpr(e2);
			case EUnop(op, e): 
				printUnop(op) + printExpr(e);
			case ETernop(e1, op, e2, e3): 
				printExpr(e1) + printTernop(op) + printExpr(e2) + " AND " + printExpr(e2);
			case ESubSelect(select): printSelect(select); 
			case EMultiple(terms): throw "not implemented";
			case EParenthesis(e): "(" + printExpr(e) + ")";
			case EWildcard: "?";
		}
	}

	public function printSelect(x:Select) {
		return "SELECT "
			 + printCommaSeparatedList(x.selectExprs, printExpr);

	}

	public function printCreate(x:Create) {
		return throw "not implemented";
		
	}

	public function printUpdate(x:Update) {
		return throw "not implemented";
		
	}

	public function printInsert(x:Insert) {
		return throw "not implemented";
		//return 
		
	}

	public function printAlterTable(x:AlterTable) {
		//return "ALTER TABLE " + 
		return throw "not implemented";
		
	}



}