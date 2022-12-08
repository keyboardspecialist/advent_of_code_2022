SECTION "SUPPLYSTACKS"

GET "u/utils.b" //Try to figure out proper inclusion utils.h should inject this into global manifest

MANIFEST
{	mark = 0
	next
	crateupb
}

STATIC
{	s.stacksp1
	s.stacksp2
	s.stacksz
}

LET start() = VALOF
{	IF NOT set_infile("data/day5.data") DO
	{	writef("Bad file*n")
		RESULTIS 1
	}

	start_timer()
	init.stacks()
	writef("init done*n")
	move.stacks()
	writef("Part1 Solution*n")
	dump.heads(s.stacksp1)
	writef("Part2 Solution*n")
	dump.heads(s.stacksp2)
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
{	FOR i = 0 TO s.stacksz-1 DO 
	{	del.stack(@s.stacksp1!i)
		del.stack(@s.stacksp2!i)
	}
	freevec(s.stacksp1)
	freevec(s.stacksp2)
}

AND pop.crate(head) = VALOF
{	LET tmp = ?
	IF !head = 0 RESULTIS 0
	tmp := !head
	!head := (!head)!next
	tmp!next := 0
	RESULTIS tmp
}

AND pop.ncrates(head, n) = VALOF
{	LET tmp, p = ?, ?

	IF !head = 0 RESULTIS 0
	IF n = 1 RESULTIS pop.crate(head)

	p := !head
	tmp := p
	FOR i = 0 TO n-1 IF p DO p := p!next
	!head := p
	p := tmp
	FOR i = 0 TO n-2 IF p DO p := p!next
	p!next := 0
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

AND push.ncrates(head, cstack) BE
{	LET p, h = !cstack, !cstack

	UNLESS !head = 0 DO
	{	WHILE p!next DO p := p!next
		p!next := !head
	}
	!head := h
}

AND init.stacks() BE
{	LET lns = VEC 9
	FOR i = 0 TO 8 DO lns!i := fread_line()
	freevec(fread_line()) //toss blank
	s.stacksz := lns!8%(lns!8%0 - 1) - '0'
	s.stacksp1 := getvec(s.stacksz)
	s.stacksp2 := getvec(s.stacksz)
	FOR i = 0 TO s.stacksz DO { s.stacksp1!i := 0; s.stacksp2!i := 0 }
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
				push.crate(@s.stacksp1!idx, tc)
				tc := make.crate()
				tc!mark := lc
				push.crate(@s.stacksp2!idx, tc)
			}	REPEAT
		}
	}
	FOR i = 0 TO 8 DO freevec(lns!i)
}

AND move.stacks() BE
{	LET ln = fread_line()
	LET ns = VEC 2
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
	//part1
	FOR step = 0 TO cmds!0-1 DO
	{	LET tc = ?
		LET from = cmds!1 - 1
		LET to = cmds!2 - 1
		tc := pop.crate(@s.stacksp1!from)
		UNLESS tc = 0 DO push.crate(@s.stacksp1!to, tc)
	}

	//part2
	{	LET tc = ?
		LET from = cmds!1 - 1
		LET to = cmds!2 - 1
		tc := pop.ncrates(@s.stacksp2!from, cmds!0)
		UNLESS tc = 0 DO push.ncrates(@s.stacksp2!to, @tc)
	}
	//This clobbers my nodes??
//	freevec(ln)
}	REPEAT

AND dump.heads(stacks) BE FOR i = 0 TO s.stacksz-1 DO writef("HEAD [%c] *n", stacks!i!mark)

AND dump.stacks(stacks) BE
	FOR i = 0 TO s.stacksz-1 DO
	{	LET h = stacks!i
		writef("STACK %d *n", i+1)
		UNTIL h = 0 | h = h!next DO
		{	writef("[%c] ", h!mark)
			h := h!next
		}
		writef("*n")
	}

AND dump.stack(s) BE
{	writef("PARTIAL STACK -> ")
	WHILE s DO { writef("[%c] ", s!mark); s := s!next }
	writef("*n")
}
