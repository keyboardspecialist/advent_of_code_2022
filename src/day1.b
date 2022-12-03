SECTION "ELFSNACKS"

GET "u/utils.b"

LET start() = VALOF
{	IF NOT set_infile("data/day1.data") DO
	{	writef("Bad file*n")
		RESULTIS 1
	}
	start_timer()
	count.cals()
	stop_timer()
	cls_infile()

	writef("Execution Time: %d ms *n", get_time_taken_ms())
	RESULTIS 0
}

AND count.cals() BE
{	LET acc, eof, total = 0, ?, ?
	AND big = VEC 3
	big!0 := 0
	big!1 := 0
	big!2 := 0
	{	LET ln = fread_line()
		eof := result2
		IF ln = 0 DO 
		{	IF acc > big!0 DO { big!0 := acc; GOTO reset }
			IF acc > big!1 DO { big!1 := acc; GOTO reset }
			IF acc > big!2 DO { big!2 := acc; GOTO reset }

			reset:
			acc := 0
			LOOP
		}
		IF NOT string_to_number(ln) LOOP
		acc := acc + result2
		freevec(ln)
	}	REPEATUNTIL eof = TRUE

	total := big!0 + big!1 + big!2

	writef("MAXIMAL ELF -> %d *n", big!0)
	writef("TOP 3 -> %d :: %d :: %d :: TOTAL %d *n", big!0, big!1, big!2, total)
}
