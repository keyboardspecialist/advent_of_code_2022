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
	move.stacks()
	dump.heads()
	//dump.stacks()
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
{	FOR i = 0 TO s.stacksz-1 DO del.stack(@s.stacks!i)
	freevec(s.stacks)
}

AND pop.crate(head) = VALOF
{	LET tmp = ?
	IF !head = 0 DO RESULTIS 0
	tmp := !head
	!head := (!head)!next
	tmp!next := 0
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
	freevec(fread_line()) //toss blank
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
	FOR i = 0 TO 8 DO freevec(lns!i)
}

AND move.stacks() BE
{	LET ln = fread_line()
	LET ns = VEC 1
	LET cmds = VEC 3
	LET i, ci = 1, 0

	UNLESS ln BREAK

	{	LET c = ln%i
		IF c = ' ' DO
		{	LET j = 1
			i +:= 1
			c := ln%i
			WHILE isnumeric(c) DO
			{	ns%j := c
				j +:= 1
				IF ln%0 = i+1 BREAK
				
				i +:= 1
				c := ln%i
			}
			ns%0 := j-1
			string_to_number(ns)
			cmds!ci := result2
			ci +:= 1
		}
		i +:= 1
	}	REPEATUNTIL i > ln%0

	ci := 0
	//writef(" move %d from %d to %d *n", cmds!0, cmds!1, cmds!2)
	
	FOR step = 0 TO cmds!0-1 DO
	{	LET tc = ?
		LET from = cmds!1 - 1
		LET to = cmds!2 - 1
		tc := pop.crate(@s.stacks!from)
		UNLESS tc = 0 DO push.crate(@s.stacks!to, tc)
	//	writef("MOVING [%c] from %d to %d *n", tc!mark, from, to)
	}

}	REPEAT

AND dump.heads() BE FOR i = 0 TO s.stacksz-1 DO writef("HEAD [%c] *n", s.stacks!i!mark)

AND dump.stacks() BE
	FOR i = 0 TO s.stacksz-1 DO
	{	LET h = s.stacks!i
		writef("STACK %d *n", i)
		UNTIL h = 0 | h = h!next DO
		{	writef("[%c] *n", h!mark)
			h := h!next
		}
	}

