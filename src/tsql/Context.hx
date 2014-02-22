
package tsql;

import tsql.Ast.TableSchema;
import tsql.Typed;

import haxe.ds.Option;



typedef Table = {
	name : String,
	fields : Map<String, SqlType>
}


class Context
{

	var tables:Map<String, Table>;

	var parent : Option<Context>;

	public function new (tables:Map<String, Table>, parent:Option<Context>) 
	{
		this.parent = parent;
		this.tables = tables;
	}

	public function hasTable (t:String) 
	{
		return tables.exists(t) || switch (parent) {
			case Some(x): x.hasTable(t);
			case None : false;
		}
	}

	public function getFieldType (f:String):Array<{ table : Table, type : SqlType}> 
	{
		var res = [];
		for (k in tables.keys()) 
		{
			var t = tables[k];
			var type = t.fields.get(f);
			if (type != null) res.push({ table : t, type : type});
		}
		
		return switch (parent) 
		{
			case Some(x): res.concat(x.getFieldType(f));
			case None: res;
		}
		
	}

	public function getTable (t:String):Option<Table>
	{
		var x = tables.get(t);
		return if (x != null) Some(x) else switch (parent) {
			case Some(x): x.getTable(t);
			case None: None;
		}
	}

	public function toString () {
		return 
			
			"{ tables : " + tables.toString() + ", parent : " + 
			(switch (parent) { 
				case Some(x): "Some("+x.toString()+")"; 
				case None: "None";
			})
			+ " }";
	}
}






