HEADER_FILES=src/*.h
SRC_FILES=src/*.c
TEST = test/xsalsa20
TEST_SRC = test/xsalsa20.c
CFLAGS = -std=c99 -Wall -W -O -Isrc -I/usr/local/include
LDFLAGS = -L/usr/local/lib -lsodium
RM = rm -f

all: $(TEST)

$(TEST): $(HEADER_FILES) $(SRC_FILES) $(COMBINED) $(TEST_SRC) Makefile
	$(CC) $(CFLAGS) -o $(TEST) $(TEST_SRC) $(SRC_FILES) $(COMBINED) $(LDFLAGS)

clean:
	$(RM) $(TEST)
