
package ;

import tsql.SqlLexer;

class Sample {

	static var x = false;

	public static function main () {
		
		x = true;

		var z = 2;
		var where = if (x) 'WHERE (name >= $z) or name > 2' else '';
		
		
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
		//parseAndShow("SELECT name from age");
		//parseAndShow("SELECT name from user as u, adress");
		//parseAndShow("SELECT name as n from age");
		//parseAndShow("SELECT name as n from age where id > 5");
		//parseAndShow("SELECT x.name as n from age as x where id > 5");
		//trace(parse("update name from age"));

	}

	public static function parseAndShow(sql:String) {
		trace(sql);
		trace(parse(sql));
	}

	public static function parse (sqlStatement:String) {
		var input = byte.ByteData.ofString(sqlStatement);
		
		var parser = new tsql.SqlParser(input, "sql");


		return parser.parse();
	}

}