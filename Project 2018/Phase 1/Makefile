CC = gcc

EXEC = al

default: $(EXEC)

$(EXEC): al.c lib/al.h
	$(CC) -o $(EXEC) $^

al.c: al.l
	lex --outfile=al.c $^

.PHONY: clean

clean:
	$(RM) $(EXEC)
	$(RM) *.o
	$(RM) *.c
