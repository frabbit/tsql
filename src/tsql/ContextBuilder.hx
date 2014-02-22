
package tsql;

import tsql.Ast.Statement;

class ContextBuilder {

	public static function build (statements:Array<Statement>) {
		var tables = new Map();
		for (s in statements) {
			switch (s) {
				case StCreate(CSchema(s)):



					tables.set(s.name, { name : s.name, fields : [for (c in s.columns) c.name => c.type]});
				case _ : throw "not implemented";
			}
		}
		return new Context(tables, None);
	}


}