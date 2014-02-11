package tsql;

import tsql.Ast;





/*
ABS()	Return the absolute value
ACOS()	Return the arc cosine
ADDDATE()	Add time values (intervals) to a date value
ADDTIME()	Add time
AES_DECRYPT()	Decrypt using AES
AES_ENCRYPT()	Encrypt using AES
AND, &&	Logical AND
ASCII()	Return numeric value of left-most character
ASIN()	Return the arc sine
=	Assign a value (as part of a SET statement, or as part of the SET clause in an UPDATE statement)
:=	Assign a value
ATAN2(), ATAN()	Return the arc tangent of the two arguments
ATAN()	Return the arc tangent
AVG()	Return the average value of the argument
BENCHMARK()	Repeatedly execute an expression
BETWEEN ... AND ...	Check whether a value is within a range of values
BIN()	Return a string containing binary representation of a number
BINARY	Cast a string to a binary string
BIT_AND()	Return bitwise and
BIT_COUNT()	Return the number of bits that are set
BIT_LENGTH()	Return length of argument in bits
BIT_OR()	Return bitwise or
BIT_XOR()	Return bitwise xor
&	Bitwise AND
~	Invert bits
|	Bitwise OR
^	Bitwise XOR
CASE	Case operator
CAST()	Cast a value as a certain type
CEIL()	Return the smallest integer value not less than the argument
CEILING()	Return the smallest integer value not less than the argument
CHAR_LENGTH()	Return number of characters in argument
CHAR()	Return the character for each integer passed
CHARACTER_LENGTH()	Synonym for CHAR_LENGTH()
CHARSET()	Return the character set of the argument
COALESCE()	Return the first non-NULL argument
COERCIBILITY()	Return the collation coercibility value of the string argument
COLLATION()	Return the collation of the string argument
COMPRESS()	Return result as a binary string
CONCAT_WS()	Return concatenate with separator
CONCAT()	Return concatenated string
CONNECTION_ID()	Return the connection ID (thread ID) for the connection
CONV()	Convert numbers between different number bases
CONVERT_TZ()	Convert from one timezone to another
CONVERT()	Cast a value as a certain type
COS()	Return the cosine
COT()	Return the cotangent
COUNT(DISTINCT)	Return the count of a number of different values
COUNT()	Return a count of the number of rows returned
CRC32()	Compute a cyclic redundancy check value
CURDATE()	Return the current date
CURRENT_DATE(), CURRENT_DATE	Synonyms for CURDATE()
CURRENT_TIME(), CURRENT_TIME	Synonyms for CURTIME()
CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP	Synonyms for NOW()
CURRENT_USER(), CURRENT_USER	The authenticated user name and host name
CURTIME()	Return the current time
DATABASE()	Return the default (current) database name
DATE_ADD()	Add time values (intervals) to a date value
DATE_FORMAT()	Format date as specified
DATE_SUB()	Subtract a time value (interval) from a date
DATE()	Extract the date part of a date or datetime expression
DATEDIFF()	Subtract two dates
DAY()	Synonym for DAYOFMONTH()
DAYNAME()	Return the name of the weekday
DAYOFMONTH()	Return the day of the month (0-31)
DAYOFWEEK()	Return the weekday index of the argument
DAYOFYEAR()	Return the day of the year (1-366)
DECODE()	Decodes a string encrypted using ENCODE()
DEFAULT()	Return the default value for a table column
DEGREES()	Convert radians to degrees
DES_DECRYPT()	Decrypt a string
DES_ENCRYPT()	Encrypt a string
DIV	Integer division
/	Division operator
ELT()	Return string at index number
ENCODE()	Encode a string
ENCRYPT()	Encrypt a string
<=>	NULL-safe equal to operator
=	Equal operator
EXP()	Raise to the power of
EXPORT_SET()	Return a string such that for every bit set in the value bits, you get an on string and for every unset bit, you get an off string
EXTRACT()	Extract part of a date
FIELD()	Return the index (position) of the first argument in the subsequent arguments
FIND_IN_SET()	Return the index position of the first argument within the second argument
FLOOR()	Return the largest integer value not greater than the argument
FORMAT()	Return a number formatted to specified number of decimal places
FOUND_ROWS()	For a SELECT with a LIMIT clause, the number of rows that would be returned were there no LIMIT clause
FROM_DAYS()	Convert a day number to a date
FROM_UNIXTIME()	Format UNIX timestamp as a date
GET_FORMAT()	Return a date format string
GET_LOCK()	Get a named lock
>=	Greater than or equal operator
>	Greater than operator
GREATEST()	Return the largest argument
GROUP_CONCAT()	Return a concatenated string
HEX()	Return a hexadecimal representation of a decimal or string value
HOUR()	Extract the hour
IF()	If/else construct
IFNULL()	Null if/else construct
IN()	Check whether a value is within a set of values
INET_ATON()	Return the numeric value of an IP address
INET_NTOA()	Return the IP address from a numeric value
INSERT()	Insert a substring at the specified position up to the specified number of characters
INSTR()	Return the index of the first occurrence of substring
INTERVAL()	Return the index of the argument that is less than the first argument
IS_FREE_LOCK()	Checks whether the named lock is free
IS NOT NULL	NOT NULL value test
IS NOT	Test a value against a boolean
IS NULL	NULL value test
IS_USED_LOCK()	Checks whether the named lock is in use. Return connection identifier if true.
IS	Test a value against a boolean
ISNULL()	Test whether the argument is NULL
LAST_DAY	Return the last day of the month for the argument
LAST_INSERT_ID()	Value of the AUTOINCREMENT column for the last INSERT
LCASE()	Synonym for LOWER()
LEAST()	Return the smallest argument
<<	Left shift
LEFT()	Return the leftmost number of characters as specified
LENGTH()	Return the length of a string in bytes
<=	Less than or equal operator
<	Less than operator
LIKE	Simple pattern matching
LN()	Return the natural logarithm of the argument
LOAD_FILE()	Load the named file
LOCALTIME(), LOCALTIME	Synonym for NOW()
LOCALTIMESTAMP, LOCALTIMESTAMP()	Synonym for NOW()
LOCATE()	Return the position of the first occurrence of substring
LOG10()	Return the base-10 logarithm of the argument
LOG2()	Return the base-2 logarithm of the argument
LOG()	Return the natural logarithm of the first argument
LOWER()	Return the argument in lowercase
LPAD()	Return the string argument, left-padded with the specified string
LTRIM()	Remove leading spaces
MAKE_SET()	Return a set of comma-separated strings that have the corresponding bit in bits set
MAKEDATE()	Create a date from the year and day of year
MAKETIME()	Create time from hour, minute, second
MASTER_POS_WAIT()	Block until the slave has read and applied all updates up to the specified position
MATCH	Perform full-text search
MAX()	Return the maximum value
MD5()	Calculate MD5 checksum
MICROSECOND()	Return the microseconds from argument
MID()	Return a substring starting from the specified position
MIN()	Return the minimum value
-	Minus operator
MINUTE()	Return the minute from the argument
MOD()	Return the remainder
% or MOD	Modulo operator
MONTH()	Return the month from the date passed
MONTHNAME()	Return the name of the month
NAME_CONST()	Causes the column to have the given name
NOT BETWEEN ... AND ...	Check whether a value is not within a range of values
!=, <>	Not equal operator
NOT IN()	Check whether a value is not within a set of values
NOT LIKE	Negation of simple pattern matching
NOT REGEXP	Negation of REGEXP
NOT, !	Negates value
NOW()	Return the current date and time
NULLIF()	Return NULL if expr1 = expr2
OCT()	Return a string containing octal representation of a number
OCTET_LENGTH()	Synonym for LENGTH()
OLD_PASSWORD()	Return the value of the pre-4.1 implementation of PASSWORD
||, OR	Logical OR
ORD()	Return character code for leftmost character of the argument
PASSWORD()	Calculate and return a password string
PERIOD_ADD()	Add a period to a year-month
PERIOD_DIFF()	Return the number of months between periods
PI()	Return the value of pi
+	Addition operator
POSITION()	Synonym for LOCATE()
POW()	Return the argument raised to the specified power
POWER()	Return the argument raised to the specified power
PROCEDURE ANALYSE()	Analyze the results of a query
QUARTER()	Return the quarter from a date argument
QUOTE()	Escape the argument for use in an SQL statement
RADIANS()	Return argument converted to radians
RAND()	Return a random floating-point value
REGEXP	Pattern matching using regular expressions
RELEASE_LOCK()	Releases the named lock
REPEAT()	Repeat a string the specified number of times
REPLACE()	Replace occurrences of a specified string
REVERSE()	Reverse the characters in a string
>>	Right shift
RIGHT()	Return the specified rightmost number of characters
RLIKE	Synonym for REGEXP
ROUND()	Round the argument
ROW_COUNT()	The number of rows updated
RPAD()	Append string the specified number of times
RTRIM()	Remove trailing spaces
SCHEMA()	Synonym for DATABASE()
SEC_TO_TIME()	Converts seconds to 'HH:MM:SS' format
SECOND()	Return the second (0-59)
SESSION_USER()	Synonym for USER()
SHA1(), SHA()	Calculate an SHA-1 160-bit checksum
SIGN()	Return the sign of the argument
SIN()	Return the sine of the argument
SLEEP()	Sleep for a number of seconds
SOUNDEX()	Return a soundex string
SOUNDS LIKE	Compare sounds
SPACE()	Return a string of the specified number of spaces
SQRT()	Return the square root of the argument
STD()	Return the population standard deviation
STDDEV_POP()	Return the population standard deviation
STDDEV_SAMP()	Return the sample standard deviation
STDDEV()	Return the population standard deviation
STR_TO_DATE()	Convert a string to a date
STRCMP()	Compare two strings
SUBDATE()	Synonym for DATE_SUB() when invoked with three arguments
SUBSTR()	Return the substring as specified
SUBSTRING_INDEX()	Return a substring from a string before the specified number of occurrences of the delimiter
SUBSTRING()	Return the substring as specified
SUBTIME()	Subtract times
SUM()	Return the sum
SYSDATE()	Return the time at which the function executes
SYSTEM_USER()	Synonym for USER()
TAN()	Return the tangent of the argument
TIME_FORMAT()	Format as time
TIME_TO_SEC()	Return the argument converted to seconds
TIME()	Extract the time portion of the expression passed
TIMEDIFF()	Subtract time
*	Multiplication operator
TIMESTAMP()	With a single argument, this function returns the date or datetime expression; with two arguments, the sum of the arguments
TIMESTAMPADD()	Add an interval to a datetime expression
TIMESTAMPDIFF()	Subtract an interval from a datetime expression
TO_DAYS()	Return the date argument converted to days
TRIM()	Remove leading and trailing spaces
TRUNCATE()	Truncate to specified number of decimal places
UCASE()	Synonym for UPPER()
-	Change the sign of the argument
UNCOMPRESS()	Uncompress a string compressed
UNCOMPRESSED_LENGTH()	Return the length of a string before compression
UNHEX()	Return a string containing hex representation of a number
UNIX_TIMESTAMP()	Return a UNIX timestamp
UPPER()	Convert to uppercase
USER()	The user name and host name provided by the client
UTC_DATE()	Return the current UTC date
UTC_TIME()	Return the current UTC time
UTC_TIMESTAMP()	Return the current UTC date and time
UUID()	Return a Universal Unique Identifier (UUID)
VALUES()	Defines the values to be used during an INSERT
VAR_POP()	Return the population standard variance
VAR_SAMP()	Return the sample variance
VARIANCE()	Return the population standard variance
VERSION()	Returns a string that indicates the MySQL server version
WEEK()	Return the week number
WEEKDAY()	Return the weekday index
WEEKOFYEAR()	Return the calendar week of the date (0-53)
XOR	Logical XOR
YEAR()	Return the year
YEARWEEK()	Return the year and week
*/


enum Keyword {
	// KwdSelect;
	// KwdFrom;
	// KwdWhere;
	// KwdGroup;
	// KwdUpdate;
	// KwdDelete;
	// KwdAsc;
	// KwdDesc;
	// KwdOrder;
	// KwdLimit;
	// KwdAs;
	// KwdInner;
	// KwdCross;
	// KwdJoin;
	// KwdLeft;
	// KwdRight;
	// KwdOuter;
	// KwdOn;
	// KwdAnd;
	// KwdOr;
	// KwdNot;
	// KwdHaving;
	// KwdOffset;
	// KwdInto;
	// KwdBy;
	// KwdDisctinct;
	// KwdFor;
	// KwdCreate;
	// KwdRollup;
	// KwdWith;
	// KwdMax;
	// KwdTrue;
	// KwdFalse;
	// KwdNull;
	// KwdUsing;
	// KwdVarchar;
	// KwdTinyint;
	// KwdSmallint;
	// KwdMediumint;
	// KwdInt;
	// KwdBigint;
	// KwdDouble;
	// KwdFloat;
	// KwdDecimal;
	// KwdNumeric;
	// KwdDate;
	// KwdDatetime;
	// KwdTime;
	// KwdTimestamp;
	// KwdYear;
	// KwdChar;
	// KwdTinyblob;
	// KwdTinytext;
	// KwdMediumtext;
	// KwdLongtext;
	// KwdReal;
	// KwdTable;
	// KwdTemporary;
	// KwdAuto_increment;
	// KwdUnique;
	// KwdPrimary;
	// KwdDefault;
	// KwdKey;
	// KwdBit;
	KwdAdd;
	KwdAll;
	KwdAlter;
	KwdAnalyze;
	KwdAnd;
	KwdAs;
	KwdAsc;
	KwdAsensitive;
	KwdBefore;
	KwdBetween;
	KwdBigint;
	KwdBinary;
	KwdBlob;
	KwdBoth;
	KwdBy;
	KwdCall;
	KwdCascade;
	KwdCase;
	KwdChange;
	KwdChar;
	KwdCharacter;
	KwdCheck;
	KwdCollate;
	KwdColumn;
	KwdCondition;
	KwdConnection;
	KwdConstraint;
	KwdContinue;
	KwdConvert;
	KwdCreate;
	KwdCross;
	KwdCurrent_date;
	KwdCurrent_time;
	KwdCurrent_timestamp;
	KwdCurrent_user;
	KwdCursor;
	KwdDatabase;
	KwdDatabases;
	KwdDay_hour;
	KwdDay_microsecond;
	KwdDay_minute;
	KwdDay_second;
	KwdDec;
	KwdDecimal;
	KwdDeclare;
	KwdDefault;
	KwdDelayed;
	KwdDelete;
	KwdDesc;
	KwdDescribe;
	KwdDeterministic;
	KwdDistinct;
	KwdDistinctrow;
	KwdDiv;
	KwdDouble;
	KwdDrop;
	KwdDual;
	KwdEach;
	KwdElse;
	KwdElseif;
	KwdEnclosed;
	KwdEscaped;
	KwdExists;
	KwdExit;
	KwdExplain;
	KwdFalse;
	KwdFetch;
	KwdFloat;
	KwdFloat4;
	KwdFloat8;
	KwdFor;
	KwdForce;
	KwdForeign;
	KwdFrom;
	KwdFulltext;
	KwdGoto;
	KwdGrant	;
	KwdGroup;
	KwdHaving;
	KwdHigh_priority;
	KwdHour_microsecond;
	KwdHour_minute;
	KwdHour_second;
	KwdIf;
	KwdIgnore;
	KwdIn;
	KwdIndex;
	KwdInfile;
	KwdInner;
	KwdInout;
	KwdInsensitive;
	KwdInsert;
	KwdInt;
	KwdInt1;
	KwdInt2;
	KwdInt3;
	KwdInt4;
	KwdInt8;
	KwdInteger;
	KwdInterval;
	KwdInto;
	KwdIs;
	KwdIterate;
	KwdJoin;
	KwdKey;
	KwdKeys;
	KwdKill;
	KwdLabel;
	KwdLeading;
	KwdLeave;
	KwdLeft;
	KwdLike;
	KwdLimit;
	KwdLines;
	KwdLoad;
	KwdLocaltime;
	KwdLocaltimestamp;
	KwdLock;
	KwdLong;
	KwdLongblob;
	KwdLongtext;
	KwdLoop;
	KwdLow_priority;
	KwdMatch;
	KwdMediumblob;
	KwdMediumint;
	KwdMediumtext;
	KwdMiddleint;
	KwdMinute_microsecond;
	KwdMinute_second;
	KwdMod;
	KwdModifies;
	KwdNatural;
	KwdNot;
	KwdNo_write_to_binlog;
	KwdNull;
	KwdNumeric;
	KwdOn;
	KwdOptimize;
	KwdOption;
	KwdOptionally;
	KwdOr;
	KwdOrder;
	KwdOut;
	KwdOuter;
	KwdOutfile;
	KwdPrecision;
	KwdPrimary;
	KwdProcedure;
	KwdPurge;
	KwdRead;
	KwdReads;
	KwdReal;
	KwdReferences;
	KwdRegexp;
	KwdRelease;
	KwdRename;
	KwdRepeat;
	KwdReplace;
	KwdRequire;
	KwdRestrict;
	KwdReturn;
	KwdRevoke;
	KwdRight;
	KwdRlike;
	KwdSchema;
	KwdSchemas;
	KwdSecond_microsecond;
	KwdSelect;
	KwdSensitive;
	KwdSeparator;
	KwdSet;
	KwdShow;
	KwdSmallint;
	KwdSoname;
	KwdSpatial;
	KwdSpecific;
	KwdSql;
	KwdSqlexception;
	KwdSqlstate;
	KwdSqlwarning;
	KwdSql_big_result;
	KwdSql_calc_found_rows;
	KwdSql_small_result;
	KwdSsl;
	KwdStarting;
	KwdStraight_join;
	KwdTable;
	KwdTerminated;
	KwdThen;
	KwdTinyblob;
	KwdTinyint;
	KwdTinytext;
	KwdTo;
	KwdTrailing;
	KwdTrigger;
	KwdTrue;
	KwdUndo;
	KwdUnion;
	KwdUnique;
	KwdUnlock;
	KwdUnsigned;
	KwdUpdate;
	KwdUpgrade;
	KwdUsage;
	KwdUse;
	KwdUsing;
	KwdUtc_date;
	KwdUtc_time;
	KwdUtc_timestamp;
	KwdValues;
	KwdVarbinary;
	KwdVarchar;
	KwdVarcharacter;
	KwdVarying;
	KwdWhen;
	KwdWhere;
	KwdWhile;
	KwdWith;
	KwdWrite;
	KwdXor;
	KwdYear_month;
	KwdZerofill;
}

enum TokenDef {
	Kwd(k:Keyword);
	Const(c:Constant);
	Ident(id:String);
	Binop(op:Binop);
	Unop(op:Unop);
	//Comment(s:String);
	//CommentLine(s:String);
	//IntInterval(s:String);
	Semicolon;
	Dot;
	//DblDot;
	Comma;
	//BkOpen;
	//BkClose;
	//BrOpen;
	//BrClose;
	
	POpen;
	PClose;
	Question;
	//At;
	Eof;
}



//enum Unop {}


class Token {
	public var tok: TokenDef;
	public var pos: haxe.macro.Expr.Position;
	
	public function new(tok, pos) {
		this.tok = tok;
		this.pos = pos;
	}
}
