NALLALIB = nalla520nmxlib

# Comment/uncomment to enable/disable debugging code
DEBUG = 1
ifeq ($(DEBUG),1)
	DEBFLAGS = -g -O0 -D_DEBUG 
else
	DEBFLAGS = -O3
endif

# Source files
SOURCEDIR = src
CSRCS = $(wildcard $(SOURCEDIR)/*.c)


# Flags
SVNDEF := -D'SVN_REV="$(shell svnversion -n .)"'
CFLAGS =  -DLINUX $(DEBFLAGS) -Wall -fPIC -c $(SVNDEF)

LFLAGS += -lpthread #thread support

LFLAGS += -l$(NALLALIB)

# To generate this library do 'make static' in nalla510tlib directory
# STATIC_LIB = $(NALLASERIALSRCDIR)/libnalla_serial.a

ifndef TARGET_CPU
	TARGET_CPU=$(shell uname -m | sed 's/i.86/i386/' | sed 's/ppc/PPC/' | sed 's/ia64/IA64/')
endif

# Object files
BUILDDIR=./build
SOURCEDIR=./src
COBJS=$(patsubst $(SOURCEDIR)/%.c,$(BUILDDIR)/%.o,$(CSRCS))

# Compiler
CC=$(CROSS_COMPILE)g++

# Put exe into appropriate directory

# List of executables we produce with this Makefile.
EXE = $(BUILDDIR)/deepsouth_interface

# Rules
all: $(EXE)

$(EXE): $(COBJS)
	$(CC) -g -o$(EXE) $(COBJS) $(STATIC_LIB) $(LFLAGS) 

$(COBJS): $(BUILDDIR)/%.o : $(SOURCEDIR)/%.c
	$(CC) $(CFLAGS) $< -o $@

clean:
	rm -f core $(EXE) $(COBJS)

depend:
	mkdep $(CFLAGS) $(CSRCS) 
