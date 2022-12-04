SECTION "RUCKSACK"

GET "u/utils.b" //Try to figure out proper inclusion utils.h should inject this into global manifest

LET start() = VALOF
{	IF NOT set_infile("data/day3.data") DO
	{	writef("Bad file*n")
		RESULTIS 1
	}

	start_timer()
	total.misplaced()
	stop_timer()
	cls_infile()
	writef("Execution Time: %d ms *n", get_time_taken_ms())
	RESULTIS 0
}

AND total.misplaced() BE
{	LET total, eof= 0, FALSE
	LET first, second = ?, ?
	first := getvec(14)
	second := getvec(14)
	{	LET ln = fread_line()
		eof := result2

		IF ln = 0 BREAK
		FOR i = 0 TO 13 DO { first!i := 0; second!i := 0 }

		FOR i = 1 TO ln%0/2 DO
		{	LET c = ln%i
			AND priority = 0
			LET bitset = c&#X20
			priority := (c&#X1F) + (bitset~=0 -> 0, 26) - 1
			first%priority := 1 
		}

		FOR i = ln%0/2+1 TO ln%0 DO
		{	LET c = ln%i
			AND priority = 0
			LET bitset = c&#X20
			priority := (c&#X1F) + (bitset~=0 -> 0, 26) - 1
			second%priority := 1 
		}

		FOR i = 0 TO 52
		IF first%i = 1 & second%i  = 1 DO
		{	total := total + i + 1
		}  
		freevec(ln)
	}	REPEATUNTIL eof = TRUE

	writef("Total -> %d *n", total)

	freevec(first)
	freevec(second)
}