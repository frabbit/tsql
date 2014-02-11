package tsql;
import tsql.Data;
import hxparse.Lexer;

enum LexerErrorMsg {
	UnterminatedString;
	UnclosedComment;
}

class LexerError {
	public var msg:LexerErrorMsg;
	public var pos:haxe.macro.Expr.Position;
	public function new(msg, pos) {
		this.msg = msg;
		this.pos = pos;
	}
}

class SqlLexer extends Lexer implements hxparse.RuleBuilder {

	static function mkPos(p:hxparse.Position) {
		return {
			file: p.psource,
			min: p.pmin,
			max: p.pmax
		};
	}
	
	static function mk(lexer:Lexer, td) {
		return new Token(td, mkPos(lexer.curPos()));
	}
	
	// @:mapping generates a map with lowercase enum constructor names as keys
	// and the constructor itself as value
	static var keywords = @:mapping(3) Data.Keyword;
	
	static var buf = new StringBuf();
	
	static var ident = "_*[a-zA-Z][a-zA-Z0-9_]*|_+|_+[0-9][_a-zA-Z0-9]*";
	//static var idtype = "_*[A-Z][a-zA-Z0-9_]*";
	
	// @:rule wraps the expression to the right of => with function(lexer) return
	public static var tok = @:rule [
		"" => mk(lexer, Eof),
		"[\r\n\t ]" => lexer.token(tok),
		"0x[0-9a-fA-F]+" => mk(lexer, Const(CInt(lexer.current))),
		"[0-9]+" => mk(lexer, Const(CInt(lexer.current))),
		"[0-9]+.[0-9]+" => mk(lexer, Const(CFloat(lexer.current))),
		".[0-9]+" => mk(lexer, Const(CFloat(lexer.current))),
		//"[0-9]+[eE][\\+\\-]?[0-9]+" => mk(lexer,Const(CFloat(lexer.current))),
		//"[0-9]+.[0-9]*[eE][\\+\\-]?[0-9]+" => mk(lexer,Const(CFloat(lexer.current))),
		
		//"//[^\n\r]*" => mk(lexer, CommentLine(lexer.current.substr(2))),
		
		
		"!=" => mk(lexer,Binop(OpNotEq)),
		"<=" => mk(lexer,Binop(OpLte)),
		">=" => mk(lexer,Binop(OpGte)),
		"&&" => mk(lexer,Binop(OpBoolAnd)),
		//"|\\|" => mk(lexer,Binop(OpBoolOr)),
		
		//"->" => mk(lexer,Arrow),
		
		"!" => mk(lexer,Unop(OpNot)),
		
		"<" => mk(lexer,Binop(OpLt)),
		">" => mk(lexer,Binop(OpGt)),
		";" => mk(lexer, Semicolon),
		//":" => mk(lexer, DblDot),
		"," => mk(lexer, Comma),
		"." => mk(lexer, Dot),
		//"%" => mk(lexer,Binop(OpMod)),
		"&" => mk(lexer,Binop(OpAnd)),
		"|" => mk(lexer,Binop(OpOr)),
		"^" => mk(lexer,Binop(OpXor)),
		"+" => mk(lexer,Binop(OpAdd)),
		"*" => mk(lexer,Binop(OpMult)),
		"/" => mk(lexer,Binop(OpDiv)),
		"-" => mk(lexer,Binop(OpSub)),
		"=" => mk(lexer,Binop(OpEq)),
		//"[" => mk(lexer, BkOpen),
		//"]" => mk(lexer, BkClose),
		//"{" => mk(lexer, BrOpen),
		//"}" => mk(lexer, BrClose),
		"\\(" => mk(lexer, POpen),
		"\\)" => mk(lexer, PClose),
		"?"   => mk(lexer, Question),
		//"@" => mk(lexer, At),
		
		'"' => {
			buf = new StringBuf();
			var pmin = lexer.curPos();
			var pmax = try lexer.token(string) catch (e:haxe.io.Eof) throw new LexerError(UnterminatedString, mkPos(pmin));
			mk(lexer, Const(CString(buf.toString())));
		},
		"'" => {
			buf = new StringBuf();
			var pmin = lexer.curPos();
			var pmax = try lexer.token(string2) catch (e:haxe.io.Eof) throw new LexerError(UnterminatedString, mkPos(pmin));
			mk(lexer, Const(CString(buf.toString())));
		},
		//'/\\*' => {
		//	buf = new StringBuf();
		//	var pmin = lexer.curPos();
		//	var pmax = try lexer.token(comment) catch (e:haxe.io.Eof) throw new LexerError(UnclosedComment, mkPos(pmin));
		//	mk(lexer, Comment(buf.toString()));
		//},
		//"#" + ident => mk(lexer, Sharp(lexer.current.substr(1))),
		//"$" + ident => mk(lexer, Dollar(lexer.current.substr(1))),
		"`" + ident + "`" => {
			mk(lexer, Ident(lexer.current));
		},
		ident => {
			// sql keywords are case insensitive
			var kwd = keywords.get(lexer.current.toLowerCase());
			if (kwd != null) 
				mk(lexer, Kwd(kwd));
			else
				mk(lexer, Ident(lexer.current));
		},
		//idtype => mk(lexer, Const(CIdent(lexer.current))),
	];
	
	public static var string = @:rule [
		"\\\\\\\\" => {
			buf.add("\\");
			lexer.token(string);
		},
		"\\\\n" => {
			buf.add("\n");
			lexer.token(string);
		},
		"\\\\r" => {
			buf.add("\r");
			lexer.token(string);
		},
		"\\\\t" => {
			buf.add("\t");
			lexer.token(string);
		},
		"\\\\\"" => {
			buf.add('"');
			lexer.token(string);
		},
		'"' => lexer.curPos().pmax,
		"[^\\\\\"]+" => {
			buf.add(lexer.current);
			lexer.token(string);
		}
	];
	
	public static var string2 = @:rule [
		"\\\\\\\\" => {
			buf.add("\\");
			lexer.token(string2);
		},
		"\\\\n" =>  {
			buf.add("\n");
			lexer.token(string2);
		},
		"\\\\r" => {
			buf.add("\r");
			lexer.token(string2);
		},
		"\\\\t" => {
			buf.add("\t");
			lexer.token(string2);
		},
		'\\\\\'' => {
			buf.add('"');
			lexer.token(string2);
		},
		"'" => lexer.curPos().pmax,
		'[^\\\\\']+' => {
			buf.add(lexer.current);
			lexer.token(string2);
		}
	];
	
	public static var comment = @:rule [
		"*/" => lexer.curPos().pmax,
		"*" => {
			buf.add("*");
			lexer.token(comment);
		},
		"[^\\*]" => {
			buf.add(lexer.current);
			lexer.token(comment);
		}
	];
}