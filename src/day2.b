SECTION "ROCKPAPERSCISSORS"

GET "u/utils.b" //Try to figure out proper inclusion utils.h should inject this into global manifest

MANIFEST
{	rock = 0
	paper = 1
	scissors = 2
	X = 0
	Y = 1
	Z = 2
	loss = 0
	tie = 3
	win = 6
}

STATIC
{	s.score.table
	s.score.table2
}

LET start() = VALOF
{	IF NOT set_infile("data/day2.data") DO
	{	writef("Bad file*n")
		RESULTIS 1
	}

	start_timer()
	build.table()
	build.table2()
	rps.score()
	free.tables()
	stop_timer()
	cls_infile()
	writef("Execution Time: %d ms *n", get_time_taken_ms())
	RESULTIS 0
}

AND build.table() BE
{	s.score.table := getvec(3)
 
	(@s.score.table!rock)%rock := tie
	(@s.score.table!rock)%paper := loss
	(@s.score.table!rock)%scissors := win

	(@s.score.table!paper)%rock := win
	(@s.score.table!paper)%paper := tie
	(@s.score.table!paper)%scissors := loss

	(@s.score.table!scissors)%rock := loss
	(@s.score.table!scissors)%paper := win
	(@s.score.table!scissors)%scissors := tie
}

AND build.table2() BE
{	s.score.table2 := getvec(3)
 
	(@s.score.table2!X)%rock := scissors
	(@s.score.table2!X)%paper := rock
	(@s.score.table2!X)%scissors := paper

	(@s.score.table2!Y)%rock := rock
	(@s.score.table2!Y)%paper := paper
	(@s.score.table2!Y)%scissors := scissors

	(@s.score.table2!Z)%rock := paper
	(@s.score.table2!Z)%paper := scissors
	(@s.score.table2!Z)%scissors := rock
}

AND free.tables() BE freevec(s.score.table) <> freevec(s.score.table2)

AND rps.score() BE
{	LET score, score2, eof = 0, 0, FALSE
	{	LET ln = fread_line()
		AND p1, p2, v1, v2 = 0, 0, 0, 0
		eof := result2

		IF ln = 0 LOOP
		p2 := ln%3
		p1 := ln%1

		v1 := (p1&3) - 1
		v2 := p2&3

		score := score + (@s.score.table!v2)%v1 + (v2+1)
		score2 := score2 + (@s.score.table2!v2)%v1 + 1 + (v2 * 3)
		freevec(ln)
	} REPEATUNTIL eof = TRUE

	writef("Total Score -> %d *n", score)
	writef("Total Score2 -> %d *n", score2)
}