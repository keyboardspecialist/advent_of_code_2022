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
	writef("CODE [%c %c %c %c] POSITION %d *n", m%0, m%1, m%2, m%3, i)
}

AND msg.sniffer() BE 
{	

}