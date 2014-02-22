
package ;

#if !macro
import tsql.Context;
import tsql.SqlLexer;
import tsql.Typer;
#end

class Sample {

	#if !macro

	static var x = false;



	public static function main () {
		
		x = true;

		var z = 2;
		var where = if (x) 'WHERE (name >= $z) or name > 2' else '';
		
		/*
		parseAndShow('
			SELECT MAX((name + ?) * 3), age.* 
			FROM age as a, users as u LEFT Join Persons On u.id = Persons.id
			$where
			GROUP BY name DESC 
			HAVING name > -2 ORDER BY name ASC, age DESC limit 4,2'
			);

		parseAndShow('
			CREATE TABLE user (	
				name TINYINT(2) Not Null Default 2 AUTO_INCREMENT UNIQUE KEY,
				first VARCHAR(255) Null PRIMARY KEY
			) ENGINE=innodb AUTO_INCREMENT=1');
		parseAndShow('
			Update user set name = 5, age = 10 Where id = 17'
		);
		parseAndShow('
			Update user, persons set name = 5, age = 10 Where id = 17 and persons.id == user.id'
		);
		parseAndShow('
			Update user, persons set name = 5, age = 10 Where id = 17 and persons.id == user.id'
		);
		parseAndShow('
			INSERT user set name = 5, age = 10'
		);
		parseAndShow('
			INSERT INTO user set name = 5, age = 10'
		);
		parseAndShow('
			INSERT user (name, age) VALUES ("foo", 5)'
		);
		parseAndShow('
			INSERT user (name, age) SELECT a,b from persons ON DUPLICATE KEY UPDATE age=age+1'
		);
		*/
		/*
		parseAndPrint('select password from t');

		parseAndShow('SELECT MAX(?, 3)');

		parseAndPrint("SELECT t.a as x, u.x as y FROM u, t");
	*/

		var cr = parse("
			CREATE TABLE user (	
				name TINYINT(2) Not Null Default 2 AUTO_INCREMENT UNIQUE KEY,
				first VARCHAR(255) Not Null PRIMARY KEY
			) ENGINE=innodb AUTO_INCREMENT=1
		");
		var cr2 = parse("
			CREATE TABLE persons (	
				name INT Not Null Default 2 AUTO_INCREMENT UNIQUE KEY,
				second VARCHAR(255) Not Null PRIMARY KEY,
				body TINYTEXT Null
			) ENGINE=innodb AUTO_INCREMENT=1
		");

		var ctx = tsql.ContextBuilder.build([cr, cr2]);
		trace(ctx);

		parseTypeAndShow('SELECT u.name from user as u, persons as p where u.name = ?', ctx);

		//parseAndShow("SELECT name from age");
		//parseAndShow("SELECT name from user as u, adress");
		//parseAndShow("SELECT name as n from age");
		//parseAndShow("SELECT name as n from age where id > 5");
		//parseAndShow("SELECT x.name as n from age as x where id > 5");
		//trace(parse("update name from age"));

		var f = test();
		trace(f(true, Date.now(), Date.now(), None));
	}

	public static function parseAndShow(sql:String) {
		trace(sql);
		trace(Std.string(parse(sql)));
	}

	public static function parseTypeAndShow(sql:String, ctx:Context) {
		var st = parse(sql);
		var t = Typer.typeStatement(st, ctx);

		//trace(Std.string(t));
	}

	public static function parseAndPrint(sql:String) {
		trace(sql);
		trace(new tsql.SqlPrinter().printStatement(parse(sql)));
	}

	public static function parse (sqlStatement:String) {
		var input = byte.ByteData.ofString(sqlStatement);
		
		var parser = new tsql.SqlParser(input, "sql");


		return parser.parse();
	}

	#end

	macro public static function test () {
		var c = tsql.MacroTools.sqlTypeToConversion;
		var conv = macro new tsql.nodejs.Converter.NodeToSqlConverter();
		var types = [
			c(STInt(ILBit(None)),conv),
			c(STDateOrTime(DTDate),conv),
			c(STDateOrTime(DTTimestamp),conv),
			c(STNull(STString(SLVarChar(255))),conv)

		];
		trace(types);
		return macro function (a,b,c,d) {
			var a = ${types[0]}(a);
			var b = ${types[1]}(b);
			var c = ${types[2]}(c);
			var d = ${types[3]}(d);

			return a + " | " + b + " | " + c + " | " + d;

		}
	}

}