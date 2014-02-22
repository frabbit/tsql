
package tsql;

import tsql.Context;
import tsql.Typed;
import tsql.Ast;

import haxe.ds.Option;

using tsql.Typed.TypedExprs;
using tsql.Typed.SqlTypes;




class Typer {

	static function tableRefsToContext (tableRefs:Array<TableReference>, global:Context):Context {
		
		var tables = new Map();
		for (t in tableRefs) {
			function loop(t:TableReference):Table
			{
				return switch (t) {
					case TrSimple(t): switch global.getTable(t)
					{
						case Some(x): x;
						case None: throw ("assert table " + t + " does not exist");
					}
					case TrNamed(t, alias): 
						var t = loop(t);
						{ name : alias, fields : t.fields };
					case TrJoinTable(t1,op,t2,c):
						throw "not implemented";
					case TrSubSelect(s):
						throw "not implemented";
					
				}
			}
			var t = loop(t);
			tables.set(t.name, t);
		}

		return new Context(tables, None);

	}

	

	public static function typeSelect (s:Select, ctx:Context):TypedSelect {
		// create subcontext
		var ctx = switch (s.from) {
			case Some(x): tableRefsToContext(x, ctx);
			case None : ctx;
		}
		trace(ctx);

		var selExprs = s.selectExprs.map(typeExpr.bind(_, ctx));
		trace(selExprs);

		var whereExpr = switch s.where {
			case Some(e): Some(typeExpr(e, ctx));
			case None: None;
		}
		trace(whereExpr);
		return throw "not implemented";
	}

	public static function typeStatement (s:Statement, ctx:Context) {
		return switch (s) {
			case StSelect(s):
				typeSelect(s, ctx);
			case _ : throw "not implemented";
		}
	}

	/*
	public static function typeCreate (s:Create):TypedCreate {
		return throw "not implemented";
	}
	*/


	public static function typeExpr (e:tsql.Ast.Expr, ctx:Context):TypedExpr {
		return switch (e) {
			case EWildcard: TWildcard(STUnknown);
			case EConst(x = CInt(c)): TConst(x, STInt(ILInt(None,false)));
			case EConst(x = CFloat(c)): TConst(x, STFloat(FLFloat(None,None,false)));
			case EConst(x = CNull): TConst(x, STNull(STUnknown));
			case EConst(x = CString(c)) if (c.length <= 255): TConst(x, STString(SLVarChar(255)));
			case EBinop(OpEq, e1, e2):
				var e1 = typeExpr(e1,ctx);
				var e2 = typeExpr(e2,ctx);
				var unified = unify(e1.type(),e2.type());

				if (!unified.isUnknown()) {
					e1 = e1.replaceUntypedWildcard(unified);
					e2 = e2.replaceUntypedWildcard(unified);
				}

				var x = TBinop(OpEq, e1, e2, STBool);
				trace(x);
				x;
			case EColumn(name, None): 
				var f = ctx.getFieldType(name);
				switch f.length {
					case 0: throw "field " + name + " doesn't exist in any of the tables: " + [for (x in f) x.table.name].join(", ");
					case 1: TColumn(name, None, f[0].type);
					case _: 
						throw "ambigious field " + name + " exists in tables " + [for (x in f) x.table.name].join(" and ");
				}
			case EColumn(name, Some(x)): 
				switch ctx.getTable(x)
				{
					case None: throw "table " + x + " does not exist in query.";
					case Some(t):
						var f = t.fields.get(name);

						switch f {
							case null: throw "field " + name + " doesn't exist in table " + t.name;
							case t: TColumn(name, None, t);
							
						}
				}
				


			case _ : 
				trace(e);
				throw "typeExpr not implemented for " + e;

		}
	}

	/*
	public static function typeFunctionCall (name:String, params:Array<Expr>):TypedExpr {
		return switch (name.toLowerCase()) {
			case "greatest":

				if (params.length <= 0) throw params.length + " params for max given, but at least 1 expected";
				var typedExprs = [for (p in params) typeExpr(p)];


		}
			
	}


	static function inferSameTypes (p:Array<TypedExpr>, possibleTypes:Array<SqlType>):Array<TypedExpr> {
		var cur = None;
		for (t in p) {
			t.type();
		}
	}

	*/

	static function unify (t1:SqlType, t2:SqlType) {
		return switch [t1, t2] {
			case [STUnknown, x]: x;
			case [STInt(a), STInt(b)]: STInt(unifyInts(a,b));
			case [x, STUnknown]: x;
			case _ : throw "unify not implemented for " + t1 + " <-> " + t2;
			//case [STInt(a), STInt(b)]: 
		}
	}

	static function unifyInts (a:IntLike, b:IntLike) {
		return switch [a,b] {
			case [ILBit(_), ILBit(_)]: ILBit(None);
			case [ILBit(_), b]: b;
			case [a, ILBit(_)]: a;
			case [
				(ILTinyInt(_,a)|ILSmallInt(_,a)|ILInt(_,a)|ILMediumInt(_,a)|ILBigInt(_,a)),
				(ILTinyInt(_,b)|ILSmallInt(_,b)|ILInt(_,b)|ILMediumInt(_,b)|ILBigInt(_,b))
				 ] if (a != b) : throw "cannot unify signed and unsigned integer types";
			

			case [ILTinyInt(_,x), ILTinyInt(_,_)]: ILTinyInt(None,x);
			case [ILTinyInt(_,_), b]: b;
			case [a, ILTinyInt(_,_)]: a;
			case [ILSmallInt(_,x), ILSmallInt(_,_)]: ILSmallInt(None,x);
			case [ILSmallInt(_,_), b]: b;
			case [a, ILSmallInt(_,_)]: a;
			case [ILMediumInt(_,x), ILMediumInt(_,_)]: ILMediumInt(None,x);
			case [ILMediumInt(_,_), b]: b;
			case [a, ILMediumInt(_,_)]: a;
			case [ILInt(_,x), ILInt(_,_)]: ILInt(None,x);
			case [ILInt(_,_), b]: b;
			case [a, ILInt(_,_)]: a;
			case [ILBigInt(_,x), ILBigInt(_,_)]: ILBigInt(None, x);
			
			

		}
	}
	
}