BISON?=bison
FLEX?=flex
GCC?=cc

BISON_VERSION=$(shell $(BISON) --version | head -n 1 | grep -o '[0-9]\.[0-9]\+')
BISON_VERSION_SUPPORTED=$(shell echo $(BISON_VERSION) \>= 3.0 | bc)
ifneq ($(BISON_VERSION_SUPPORTED), 1)
$(error Bison version $(BISON_VERSION) not supported. If you are using OS X, `bison` uses the system default instead of the brew version. Run BISON=/usr/local/opt/bison/bin/bison make)
endif

FLEX_VERSION=$(shell $(FLEX) --version | head -n 1 | grep -o '[0-9]\.[0-9]\+')
FLEX_VERSION_SUPPORTED=$(shell echo $(FLEX_VERSION) \>= 2.6 | bc)
ifneq ($(FLEX_VERSION_SUPPORTED), 1)
$(error Flex version $(FLEX_VERSION) not supported. If you are using OS X, `flex` uses the system default instead of the brew version. Run FLEX=/usr/local/opt/flex/bin/flex make)
endif

all: parser.cpp scanner.cpp

parser.cpp: parser.y
	$(BISON) parser.y --output=parser.c --defines=parser.h --verbose

scanner.cpp: scanner.l
	$(FLEX) -o scanner.c --header-file=scanner.h scanner.l

clean:
	rm -f scanner.lo scanner.c scanner.h parser.lo parser.c parser.h *.output
