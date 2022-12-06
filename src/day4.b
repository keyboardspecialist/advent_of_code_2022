SECTION "CLEANINGDUTY"

GET "u/utils.b" //Try to figure out proper inclusion utils.h should inject this into global manifest

LET start() = VALOF
{	IF NOT set_infile("data/day4.data") DO
	{	writef("Bad file*n")
		RESULTIS 1
	}

	start_timer()
	camp.cleanup()
	stop_timer()
	cls_infile()
	writef("Execution Time: %d ms *n", get_time_taken_ms())
	RESULTIS 0
}

AND camp.cleanup() BE
{	LET total, total2, eof = 0, 0, FALSE
	{	LET ln = fread_line()
		LET rvals = VEC 4
		LET ns = VEC 4
		LET n, s = 0, 0

		eof := result2
		IF ln = 0 BREAK

		FOR i = 1 TO ln%0
			TEST isnumeric(ln%i) = TRUE 
			THEN { ns!s%(n+1) := ln%i; n +:= 1 } 
			ELSE { ns!s%0 := n; s +:= 1; n := 0 }
		
		ns!s%0 := n
		FOR i = 0 TO s DO
		{	string_to_number(ns!i)
			rvals!i := result2
		}

		IF rvals!0 >= rvals!2 & rvals!1 <= rvals!3 | 
		rvals!2 >= rvals!0 & rvals!3 <= rvals!1
		DO 
		total +:= 1

		IF rvals!0 <= rvals!3 & rvals!0 >= rvals!2 |
		rvals!1 >= rvals!2 & rvals!1 <= rvals!3 |
		rvals!0 >= rvals!2 & rvals!1 <= rvals!3 | 
		rvals!2 >= rvals!0 & rvals!3 <= rvals!1
		DO 
		total2 +:= 1 // <> writef("any overlap str:: %s *n", ln)

		freevec(ln)
	}	REPEATUNTIL eof = TRUE

	writef("Total complete overlaps %d *n", total)
	writef("Total any overlap %d *n", total2)
}
