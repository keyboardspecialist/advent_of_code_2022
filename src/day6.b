SECTION "TUNINGTROUBLE"

GET "u/utils.b" //Try to figure out proper inclusion utils.h should inject this into global manifest

LET start() = VALOF
{	IF NOT set_infile("data/day6.data") DO
	{	writef("Bad file*n")
		RESULTIS 1
	}

	start_timer()
	packet.sniffer()
	msg.sniffer()
	stop_timer()
	cls_infile()
	writef("Execution Time: %i ms *n", get_time_taken_ms())
	RESULTIS 0
}

AND packet.sniffer() BE
{	LET i = 4
	LET m = VEC 1
	m%0 := rdch()
	m%1 := rdch()
	m%2 := rdch()
	m%3 := rdch()
	{	LET c = 0
		IF m%0 ~= m%1 & m%0 ~= m%2 & m%0 ~= m%3 &
		m%1 ~= m%2 & m%1 ~= m%3 &
		m%2 ~= m%3 BREAK
		c := rdch()
		i +:= 1
		IF c = endstreamch BREAK
		m!0 >>:= 8; m%3 := c 
	}	REPEAT
	writef("CODE [%c %c %c %c] POSITION %i *n", m%0, m%1, m%2, m%3, i)
}

AND msg.sniffer() BE 
{	LET i, j = 0, 13
	LET strm = slurp()
	LET len = result2

	{	LET done = TRUE
		FOR k = 0 TO 13 DO
		FOR l = 0 TO 13 DO
		{	IF l = k LOOP
			IF strm%(i+k) = strm%(i+l) DO { done := FALSE}
		}
		IF done = TRUE BREAK
		i +:= 1
		j +:= 1
	} REPEATUNTIL j = len
	freevec(strm)
	writef("SOLUTION [")
	FOR k = 0 TO 13 DO writef("%c ", strm%(i+k))
	writef("], POSITION %i *n", j+1)
}


AND slurp() = VALOF
{	LET blob = ?
	LET sz = 0
	{	LET c = rdch()
		IF c = endstreamch BREAK
		sz +:= 1
	}	REPEAT

	blob := getvec(sz/bytesperword + 1)
	reset_infile()
	FOR i = 0 TO sz-1 DO blob%i := rdch()
	result2 := sz
	RESULTIS blob
}