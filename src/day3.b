SECTION "RUCKSACK"

GET "u/utils.b" //Try to figure out proper inclusion utils.h should inject this into global manifest

LET start() = VALOF
{	IF NOT set_infile("data/day3.data") DO
	{	writef("Bad file*n")
		RESULTIS 1
	}

	start_timer()
	total.misplaced()
	reset_infile()
	stinkin.badges()
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
			first%priority := TRUE
		}

		FOR i = ln%0/2+1 TO ln%0 DO
		{	LET c = ln%i
			AND priority = 0
			LET bitset = c&#X20
			priority := (c&#X1F) + (bitset~=0 -> 0, 26) - 1
			second%priority := TRUE 
		}

		FOR i = 0 TO 52
		IF first%i = TRUE%0 & second%i = TRUE%0 DO //TRUE is a manifest constant, we have to access it as a byte to prevent bit extension on the equivalency test
		{	total := total + i + 1
		}  
		freevec(ln)
	}	REPEATUNTIL eof = TRUE

	writef("Misplaced Total -> %d *n", total)

	freevec(first)
	freevec(second)
}

AND stinkin.badges() BE
{	LET total, eof = 0, FALSE
	LET badges1, badges2, badges3 = getvec(14), getvec(14), getvec(14)
	LET line = 1
	{	LET ln1, ln2, ln3 = fread_line(), fread_line(), fread_line()

		eof := result2
		IF ln1 = 0 BREAK

		FOR i = 0 TO 13 DO { badges1!i := 0; badges2!i := 0; badges3!i := 0 }

		get_priorities(ln1, badges1)
		get_priorities(ln2, badges2)
		get_priorities(ln3, badges3)

		FOR i = 0 TO 51 IF badges1%i = TRUE%0 & badges2%i = TRUE%0 & badges3%i = TRUE%0 DO
		{	total := total + i + 1
		}

		freevec(ln1)
		freevec(ln2)
		freevec(ln3)
		line := line + 3
	}	REPEATUNTIL eof = TRUE //this check has become redundant

	freevec(badges1)
	freevec(badges2)
	freevec(badges3)
	writef("Badge Total -> %d *n", total)
}

AND get_priorities(str, out) BE
FOR i = 1 TO str%0 DO
{	LET c, priority = str%i, 0
	LET bitset = c&#X20
	priority := (c&#X1F) + (bitset~=0 -> 0, 26) - 1
	out%priority := TRUE
}