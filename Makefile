CC = gcc
CFLAGS = -I. -lbcm2835 -lrt
DEPS = 
OBJ = DHT.o

%.o: %.c $(DEPS)
	$(CC) -c -o $@ $< $(CFLAGS)

DHT.out: $(OBJ)
	gcc -o $@ $^ $(CFLAGS)

clean:
	rm *.o *.out