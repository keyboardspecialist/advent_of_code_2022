SECTION "SUPPLYSTACKS"

GET "u/utils.b" //Try to figure out proper inclusion utils.h should inject this into global manifest

MANIFEST
{	mark = 0
	next
	crateupb
}

STATIC
{	s.stacks
	s.stacksz
}

LET start() = VALOF
{	IF NOT set_infile("data/day5.data") DO
	{	writef("Bad file*n")
		RESULTIS 1
	}

	start_timer()
	init.stacks()
	dump.stacks()
	move.stacks()
	stop_timer()
	cls_infile()
	cleanup()
	writef("Execution Time: %d ms *n", get_time_taken_ms())
	RESULTIS 0
}

AND make.crate() = VALOF
{	LET crate = ?
	crate := getvec(crateupb)
	crate!mark := '?'
	crate!next := 0
	RESULTIS crate
}

AND del.crate(crate) BE	freevec(crate)

AND del.stack(stack) BE
{	LET c = ?
	{	c := pop.crate(stack)
		del.crate(c)
	}	REPEATUNTIL !stack = 0
}

AND cleanup() BE
{	FOR i = 0 TO s.stacksz-1 DO del.stack(s.stacks!i)
	freevec(s.stacks)
}

AND pop.crate(head) = VALOF
{	LET tmp = ?
	IF !head = 0 DO RESULTIS 0
	tmp := !head
	!head := (!head)!next
	RESULTIS tmp
}

AND push.crate(head, crate) BE
{	IF !head = 0 DO 
	{	!head := crate
		RETURN
	}

	crate!next := !head
	!head := crate
}

AND init.stacks() BE
{	LET lns = VEC 9
	FOR i = 0 TO 8 DO lns!i := fread_line()
	s.stacksz := lns!8%(lns!8%0 - 1) - '0'
	s.stacks := getvec(s.stacksz)
	FOR i = 0 TO s.stacksz DO s.stacks!i := 0
	FOR i = 1 TO lns!8%0 DO
	{	IF isnumeric(lns!8%i) DO
		{	LET idx, col = lns!8%i - '0' - 1, 8
			LET lc = ?
			{	LET tc = ?
				col -:= 1
				IF col = -1 BREAK
				lc := lns!col%i
				IF lc = ' ' LOOP
				tc := make.crate()
				tc!mark := lc
				push.crate(@s.stacks!idx, tc)
			}	REPEAT
		}
	}
}

AND move.stacks() BE
{

}

AND dump.stacks() BE
	FOR i = 0 TO s.stacksz-1 DO
	{	LET h = s.stacks!i
		writef("STACK %d *n", i)
		UNTIL h = 0 DO
		{	writef("[%c] *n", h!mark)
			h := h!next
		}
	}

