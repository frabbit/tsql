
package tsql;

import haxe.ds.StringMap;
import tsql.Data;
import tsql.Ast;

import haxe.macro.Expr.Position;
import haxe.ds.Option;
import tsql.Typed.SqlType;

using Lambda;

enum ParserErrorMsg {
	MissingSemicolon;
	MissingType;
	DuplicateDefault;
	Custom(s:String);
}

typedef ParserError = {
	msg: ParserErrorMsg,
	pos: hxparse.Position
}

class SqlParser extends hxparse.Parser<SqlLexer, Token> implements hxparse.ParserBuilder {

	var doResume = false;
	
	
	
	public function new(input:byte.ByteData, sourceName:String) {
		super(new SqlLexer(input, sourceName), SqlLexer.tok);
	}

	//public function parse() {
	//	return parseFile();
	//}

	public function parse() {
		return parseStatement();
	}
	
	override function peek(n) {
		return if (n == 0)
			switch(super.peek(0)) {
				//case {tok:CommentLine(_) | Sharp("end" | "else" | "elseif" | "if" | "error" | "line")}:
				//	junk();
				//	peek(0);
				case t: t;
			}
		else
			super.peek(n);
	}

	static function punion(p1:Position, p2:Position) {
		return {
			file: p1.file,
			min: p1.min < p2.min ? p1.min : p2.min,
			max: p1.max > p2.max ? p1.max : p2.max,
		};
	}

	static function quoteIdent(s:String) {
		// TODO
		return s;
	}

	static function isLowerIdent(s:String) {
		function loop(p) {
			var c = s.charCodeAt(p);
			return if (c >= 'a'.code && c <= 'z'.code)
				true
			else if (c == '_'.code) {
				if (p + 1 < s.length)
					loop(p + 1);
				else
					true;
			} else
				false;
		}
		return loop(0);
	}
	/*
	static function precedence(op:Binop) {
		var left = true;
		var right = false;
		return switch(op) {
			case OpMod : {p: 0, left: left};
			case OpMult | OpDiv : {p: 0, left: left};
			case OpAdd | OpSub : {p: 0, left: left};
			case OpShl | OpShr | OpUShr : {p: 0, left: left};
			case OpOr | OpAnd | OpXor : {p: 0, left: left};
			case OpEq | OpNotEq | OpGt | OpLt | OpGte | OpLte : {p: 0, left: left};
			case OpInterval : {p: 0, left: left};
			case OpBoolAnd : {p: 0, left: left};
			case OpBoolOr : {p: 0, left: left};
			case OpArrow : {p: 0, left: left};
			case OpAssign | OpAssignOp(_) : {p:10, left:right};
		}
	}
	*/

	/*

	static function swap(op1:Binop, op2:Binop) {
		var i1 = precedence(op1);
		var i2 = precedence(op2);
		return i1.left && i1.p < i2.p;
	}
	*/

	/*
	static function makeBinop(op:Binop, e:Expr, e2:Expr) {
		return switch (e2.expr) {
			case EBinop(_op,_e,_e2) if (swap(op,_op)):
				var _e = makeBinop(op,e,_e);
				{expr: EBinop(_op,_e,_e2), pos:punion(_e.pos,_e2.pos)};
			case ETernary(e1,e2,e3) if (isNotAssign(op)):
				var e = makeBinop(op,e,e1);
				{expr:ETernary(e,e2,e3), pos:punion(e.pos, e3.pos)};
			case _:
				{ expr: EBinop(op,e,e2), pos:punion(e.pos, e2.pos)};
		}
	}
	*/

	/*
	static function makeUnop(op:Unop, e:Expr, p1:Position) {
		return switch(e.expr) {
			case EBinop(bop,e,e2):
				{ expr: EBinop(bop, makeUnop(op,e,p1), e2), pos: punion(p1,e.pos)};
			case ETernary(e1,e2,e3):
				{ expr: ETernary(makeUnop(op,e1,p1), e2, e3), pos:punion(p1,e.pos)};
			case _:
				{ expr: EUnop(op,false,e), pos:punion(p1,e.pos)};
		}
	}
	*/


	static function aadd<T>(a:Array<T>, t:T) {
		a.push(t);
		return a;
	}

	function psep<T>(sep:TokenDef, f:Void->T):Array<T> {
		var acc = [];
		while(true) {
			try {
				acc.push(f());
				switch stream {
					case [{tok: sep2} && sep2 == sep]:
				}
			} catch(e:hxparse.NoMatch<Dynamic>) {
				break;
			}
		}
		return acc;
	}

	function popt<T>(f:Void->T):Option<T> {
		return switch stream {
			case [v = f()]: Some(v);
			case _: None;
		}
	}

	function plist<T>(f:Void->T):Array<T> {
		var acc = [];
		try {
			while(true) {
				acc.push(f());
			}
		} catch(e:hxparse.NoMatch<Dynamic>) {}
		return acc;
	}

	


	//function comma() {
	//	return switch stream {
	//		case [{tok:Comma}]:
	//	}
	//}

	function semicolon() {
		return /*if (last.tok == BrClose) {
			switch stream {
				case [{tok: Semicolon, pos:p}]: p;
				case _: last.pos;
			}
		} else*/ switch stream {
			case [{tok: Semicolon, pos:p}]: p;
			case _:
				var pos = last.pos;
				if (doResume)
					pos
				else
					throw {
						msg: MissingSemicolon,
						pos: pos
					}
		}
	}


	function secureExpr () {
		return parseExpr();
	}

	function parseExpr () {

		return switch stream {
			case [{ tok : Question}]:
				exprNext(EWildcard);
			case [{ tok : Kwd(KwdTrue)}]:
				exprNext(EConst(CBool(true)));
			case [{ tok : Kwd(KwdFalse)}]:
				exprNext(EConst(CBool(false)));
			case [{ tok : Kwd(KwdNull)}]:
				exprNext(EConst(CNull));
			case [{ tok : Binop(OpMult)}]:
				// star operator
				EAllColumns(None);

			case [{ tok : Binop(OpSub)}, e = secureExpr()]:

				exprNext(EUnop(OpMinus, e));
			case [{ tok : Ident(x)}]:
				exprNext(EIdent(x));
			case [{ tok : Const(c)}]:
				exprNext(EConst(c));
			case [{ tok : Kwd(kwd)}, { tok : POpen}, exprs = parseExprs(), {tok:PClose}]:
				// keyword function
				// check if valid function
				var ident = kwd.getName().substr(3).toLowerCase();
				exprNext(EFunction(ident, exprs));
				
			case [{ tok : POpen}, e = secureExpr(), { tok : PClose}]:
				exprNext(EParenthesis(e));
			
		}
	}

	function exprNext(e1:Expr):Expr {
		return switch stream {
			case [{ tok:Dot }]:
				switch stream {
					case [{ tok : Ident(x)}]:
						switch (e1) {
							case EIdent(t):
								exprNext(EColumn(x, Some(t)));
							case _ : unexpected();
						}
					case [{ tok : Binop(OpMult)}]:
						switch (e1) {
							case EIdent(t):
								exprNext(EAllColumns(Some(t)));
							case _ : unexpected();
						}
					case _ : 
						unexpected();
				
				}
			// this can only be a user defined function or the keyword is missing
			case [{ tok:POpen }] if (e1.match(EIdent(_))):
				var name = switch (e1) { case EIdent(n): n; case _ : unexpected();};
				switch stream {
					case [exprs = parseExprs(), {tok:PClose}]:
						exprNext(EFunction(name, exprs));
					case _ : unexpected();
				}


			case [{ tok:Binop(op) }]:
				exprNext(EBinop(op, e1, secureExpr()));
			case [{ tok:Kwd(KwdAnd)}]:
				exprNext(EBinop(OpBoolAnd, e1, secureExpr()));
			case [{ tok:Kwd(KwdOr)}]:
				exprNext(EBinop(OpBoolOr, e1, secureExpr()));
			case _ : e1;
		}
	}

	function parseNamedExpr () {
		
		return switch stream {
			case [e = parseExpr()]:
				switch stream {
					case [{tok:Kwd(KwdAs)}, {tok:Ident(id)}]:
						ENamed(e, id);
					case _ :
						e;
				}
				
		}
	}

	function parseExprs () 
	{
		return parseCommaSeparatedList(parseExpr);
	}

	function parseNamedExprs () 
	{
		return parseCommaSeparatedList(parseNamedExpr);
	}

	function parseJoinCondition() 
	{
		return switch stream 
		{
			case [{ tok : Kwd(KwdOn)}, e = parseExpr()]:
				JcOn(e);
			case [{ tok : Kwd(KwdUsing)}, {tok:POpen}, exprs = parseExprs(), {tok:PClose}]:
				JcUsing(exprs);
		}
	}


	function parseTableReferenceNext (t1:TableReference) 
	{
		return switch stream 
		{
			case [{tok:Kwd(KwdAs)}, {tok:Ident(x)}]:
				parseTableReferenceNext(TrNamed(t1, x));
			
			case [{tok:Kwd(KwdInner)}, {tok:Kwd(KwdJoin)}, t2 = parseTableReference(), c = popt(parseJoinCondition)]:
				parseTableReferenceNext(TrJoinTable(t1, [JInner], t2, c));
			
			case [{tok:Kwd(x = KwdLeft|KwdRight)}]:
				var joinOp = switch(x) {
					case KwdLeft: JLeft;
					case KwdRight: JRight;
					case _ : throw "assert";
				}
				trace(joinOp);

				var r = switch stream {
					case [{tok:Kwd(KwdOuter)}, {tok:Kwd(KwdJoin)}, t2 = parseTableReference(), c = parseJoinCondition()]:
						trace("join1");
						parseTableReferenceNext(TrJoinTable(t1, [joinOp, JOuter], t2, Some(c)));
					case [{tok:Kwd(KwdJoin)}, t2 = parseTableReference(), c = parseJoinCondition() ]:
						trace("join2");
						parseTableReferenceNext(TrJoinTable(t1, [joinOp], t2, Some(c) ));

					
						
						
				}
				trace("after");
				r;
			case _ : 
				t1;
		}
	}

	function parseTableReference () 
	{
		return switch stream 
		{
			case [{tok:Ident(x)}]:
				
				var x = parseTableReferenceNext(TrSimple(x));

				x;

		}
			
		
	}

	function parseTableReferences ()
	{
		return parseCommaSeparatedList(parseTableReference);
	}


	function parseWhere () 
	{
		return switch stream {
			case [{tok:Kwd(KwdWhere)}, cond = parseExpr()]:
				cond;
		}		
	}

	function parseDirection () 
	{
		return switch stream 
		{
			case [{tok:Kwd(KwdAsc)}]: Asc;
			case [{tok:Kwd(KwdDesc)}]: Desc;
		}
	}

	function parseExprWithDirection () 
	{
		return switch stream 
		{
			case [e = parseExpr(), dir = parseDirection()]:
				{ e : e, dir : dir};
		}
	}

	function parseOrderBy () 
	{
		return switch stream 
		{
			case [{tok:Kwd(KwdOrder)}, {tok:Kwd(KwdBy)}]:
				parseCommaSeparatedList(parseExprWithDirection);
		}
	}

	function parseNonEmptyCommaSeparatedList <T>(f:Void->T):Array<T> 
	{
		return parseCommaSeparatedList(f, true);
	}

	function parseCommaSeparatedList <T>(f:Void->T, nonEmpty = false):Array<T>
	{
		var r = [];
		var br = false;
		try {
			
		
		while (!br) {
			switch stream {
				case [e = f()]:
					r.push(e);
					switch stream {
						case [{tok: Comma}]:
						case _: 
							br = true;
					}
			}
		}
		} catch(e:hxparse.NoMatch<Dynamic>) {
			if (r.length == 0 && !nonEmpty) {} else unexpected();
		}
		return r;
	}

	function customError (msg:String, pos:Position) 
	{
		return { err : Custom(msg), pos : pos};
	}

	function parseUnseparatedList <T>(f:Void->T, until:TokenDef->Bool, nonEmpty = false):Array<T>
	{
		var r = [];
		
		try {
			
			while (true) {
				
				switch stream {
					case [e = f()]:
						trace(e);
						r.push(e);
				}
			}
		} catch(e:hxparse.NoMatch<Dynamic>) {
			var token:Token = e.token;

			if (!until(token.tok)) throw e;

			if (r.length == 0 && nonEmpty) throw customError("list should be non empty", token.pos);
		} catch(e:hxparse.Unexpected<Dynamic>) {
			var token:Token = e.token;
			if (!until(token.tok)) throw e;
		}
		return r;
	}


	function parseLimit() 
	{
		var p = function (x, p) 
		{
			var r = Std.parseInt(x);
			if (r == null || r < 0) throw customError("limit and offset must be non negative integers", p);
			return r;
		}
		return switch stream 
		{
			case [{tok:Kwd(KwdLimit)}, {tok:Const(CInt( x )), pos:p1}]:
				switch stream {
					case [{tok:Comma}, {tok:Const(CInt(y)), pos:p2}]:
						{ offset : Some(p(x,p1)), count : p(y,p2) };
					case [_ = ident("offset"), {tok:Const(CInt(y)), pos:p2}]:
						{ offset : Some(p(y,p2)), count : p(x,p1)};
					case _ : 
						{ offset : None, count : p(x,p1)};
				}
		}		
	}

	function parseHaving () 
	{
		return switch stream 
		{
			case [{tok:Kwd(KwdHaving)}, cond = parseExpr()]:
				cond;
		}		
	}

	function ident (i:String) {
		return switch stream {
			case [{tok:Ident(x)} && x.toLowerCase() == i.toLowerCase()]:
				x;
		}
	}

	function parseFrom () 
	{
		return switch stream 
		{
			case [{tok:Kwd(KwdFrom)}]:
				switch stream 
				{
					case [refs = parseTableReferences()]:
						trace(refs);
						Some(refs);
					case _ : throw "error";
				}
				
			case _ : None;
		}		
	}

	function parseGroupBy () 
	{

		return switch stream 
		{
			case [{tok:Kwd(KwdGroup)}, {tok:Kwd(KwdBy)}]:

				var list = parseNonEmptyCommaSeparatedList(parseExprWithDirection);

				var rollup = switch stream {
					case [{tok:Kwd(KwdWith)}, _ = ident("rollup")]: true;
					case _ : false;
				};
				{ groups : list, withRollup : rollup };
		}		
	}

	function parseSelect ():Select 
	{
		
		return switch stream 
		{
			case [
				se = parseNamedExprs(), 
				from = parseFrom(),
				where = popt(parseWhere), 
				groupBy = popt(parseGroupBy), 
				having = popt(parseHaving), 
				orderBy = popt(parseOrderBy),
				limit = popt(parseLimit) 

				]:
				{
					selectExprs : se,
					from : from,
					where : where,
					limit : limit,
					groupBy : groupBy,
					having: having,
					orderBy : orderBy,

				}
			case _ : unexpected();
		}
		
	}

	function optKwd (k:Data.Keyword) {

		return switch stream {
			case [{tok:Kwd(x)} && x == k]: true;
			case _ : false;
		}

	}

	function kwd (k:Data.Keyword) {
		return switch stream {
			case [{tok:Kwd(x)} && x == k]: x;
		}
	}



	function parseSqlType () {

		function parseLen () {
			return switch stream {
				case [{tok:POpen}, {tok:Const(CInt(x))}, {tok:PClose}]:
					var l = Std.parseInt(x);
					if (l == null || l <= 0) unexpected();
					l;
			}
		}

		function parseUnsigned () {
			return switch stream {
				case [{tok:Kwd(KwdUnsigned)}]: true;
				case _ : false;
			}
		}

		return switch stream {
			case [{tok:Kwd(KwdTinyint)}, len = popt(parseLen), u = parseUnsigned()]:
				STTinyInt(len, u);
			case [{tok:Kwd(KwdSmallint)}, len = popt(parseLen), u = parseUnsigned()]:
				STSmallInt(len,u);
			case [{tok:Kwd(KwdMediumint)}, len = popt(parseLen), u = parseUnsigned()]:
				STMediumInt(len,u);
			case [{tok:Kwd(KwdInt)}, len = popt(parseLen), u = parseUnsigned()]:
				STInt(len, u);
			case [{tok:Kwd(KwdVarchar)}, len = parseLen()]:
				STVarChar(len);
			case [_ = ident("date")]:
				STDate;
			case [_ = ident("datetime")]:
				STDateTime;
			case [_ = ident("time")]:
				STTime;
			case [_ = ident("timestamp")]:
				STTimestamp;
		}
	}

	function parseTableDef () {
		return switch stream {
			case [{tok:Ident(x)}, t = parseSqlType()]:
				var nullable = switch stream {
					case [{tok:Kwd(KwdNull)}]: true;
					case [{tok:Kwd(KwdNot)}, {tok:Kwd(KwdNull)}] : true;
					case _ : false;
				}
				var defaultVal = switch stream {
					case [{tok:Kwd(KwdDefault)}, e = parseExpr()]:
						Some(e);
					case _ : None;
				}
				var autoIncrement = switch stream {
					case [_ = ident("auto_increment")]: true;
					case _ : false;
				}

				var unique = false;
				var primary = false;
				var key = false;

				switch stream {
					case [{tok:Kwd(KwdUnique)}, k = optKwd(KwdKey) ]: 
						unique = true;
						key = k;
					case [{tok:Kwd(KwdPrimary)}, k = optKwd(KwdKey) ]: 
						primary = true;
						unique = true;
						key = true;
					case [{tok:Kwd(KwdKey)}]: true;
						key = true;
					case _ : false;
				}

				CDColumn({
					type : t,
					name : x,
					defaultVal : defaultVal,
					autoIncrement : autoIncrement,
					unique : unique,
					primary : primary,
					key : key,
					reference : None
				});

		}
	}

	function parseCollate () {
		return switch stream {
			case [{tok:Kwd(KwdCollate)}, {tok:Ident(x)}]: x;
		}
	}

	function parseCreateOption () {
		return switch stream {
			case [_ = ident("engine"), {tok:Binop(OpEq)}, {tok:Ident(x)}]:
				ToEngine(x);
			
			case [_ = kwd(KwdDefault), {tok:Kwd(KwdCharacter)}, {tok:Kwd(KwdSet)}, {tok:Ident(x)}, collate = popt(parseCollate)]:
				ToCharacterSet(x, collate);
			case [{tok:Kwd(KwdCharacter)}, {tok:Kwd(KwdSet)}, {tok:Ident(x)}, collate = popt(parseCollate)]:
				ToCharacterSet(x, collate);
			case [_ = ident("auto_increment"), {tok:Binop(OpEq)}, {tok:Const(CInt(x1)), pos:p}]:
				var x = Std.parseInt(x1);
				if (x != null && x >= 0) {
					ToAutoIncrement(x);	
				} else {
					throw {
						err : Custom("Invalid value " + x1 + " for AUTO_INCREMENT, positive Integer expected"),
						pos : p
					}
				}
			
				

		}
	}

	function parseTableSchema() 
	{

		function endOfOptionList(x:TokenDef) {
			return x.match(Eof | Semicolon);
		}
		return switch stream 
		{
			case [{tok:POpen}, defs = parseCommaSeparatedList(parseTableDef), {tok:PClose}, options = parseUnseparatedList(parseCreateOption, endOfOptionList)]:
				var columns = [
					for (d in defs) if (d.match(CDColumn(_))) 
					switch (d) { 
						case CDColumn(c):c; 
						case _ : throw "assert";
					}
				];
				var columnsMap:Map<String,TableColumn> = [for (c in columns) c.name => c];
				{ columns : columnsMap, options : options };
		}
	}

	function parseCreate ():Create 
	{
		return switch stream {
			case [{tok:Kwd(KwdTable)}, {tok:Ident(x)}, s = parseTableSchema()]:
				CSchema(s);
		}
	}

	function parseStatement():Statement 
	{
		return switch stream 
		{
			case [{tok:Kwd(KwdSelect)}, s = parseSelect()]:
				StSelect(s);
			case [{tok:Kwd(KwdCreate)}, s = parseCreate()]:
				StCreate(s);
		}
	}

	//function parseFile() {
	//	return switch stream {
	//		case [{tok:Kwd(KwdPackage)}, p = parsePackage(), _ = semicolon(), l = parseTypeDecls(p,[]), {tok:Eof}]:
	//			{ pack: p, decls: l };
	//		case [l = parseTypeDecls([],[]), {tok:Eof}]:
	//			{ pack: [], decls: l };
	//	}
	//}

}
