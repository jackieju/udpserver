# Project: se


#headers = $(shell echo ./*.h os/*.h)
#srcs = $(shell echo ./*.cpp os/*.cpp)
#objs = $(srcs:.cpp=.o)

CC   = g++ 

CLIB_OBJ = clib/array.o clib/exp.o clib/thread.o clib/log.o clib/utility.o os/os.o os/LogCache.o os/ostime.o os/socket.o os/str.o os/thread-pthread.o os/osutils.o os/log.o os/CSS_LOCKEX.o os/ConfigFile.o os/protected.o os/mutex.o os/LogLevel.o 
OBJ = $(CLIB_OBJ) AbstractServer.o UdpServer.o 
EXEC_OBJ  =  $(OBJ)  main.o 
CGI_OBJ = $(OBJ) cgi-bin/cs_cgi.o
TEST = main
TEST_CLIENT = udpclient
#OBJ  = $(objs) $(RES)
#OBJ  = $(objs)
pp = cocoR1/cp.cpp
BIN_EXEC = server
CGI = cgi-bin/cs.cgi
BIN  = libnanohttp.so.1.0
SOBIN=$(BIN:.so.1.0=.so)
CFLAGS = -D__SUPPORT_OBJ -g -fPIC  -D_VMMANAGER -O2 -fomit-frame-pointer -w -W -Wall -Iclib -Ios -I./ -D_64 -pthread
# -Wfatal-errors
LINK=g++ 
LFLAGS=-g -pthread

.PHONY: all all-before all-after clean clean-custom

all: all-before $(BIN_EXEC) $(BIN) all-after

lib: all-before $(BIN) all-after
    
test: all-before $(TEST) $(TEST_CLIENT) all-after
    
test_client: all-before $(TEST_CLIENT) all-after
    
#parser: $(pp)
clean: clean-custom
	rm -f $(OBJ) $(BIN)
	rm -f main.o
	rm -f cgi-bin/cs_cgi.o
DLLWRAP=g++

UdpServer.o: UdpServer.cpp
	$(CC) -c UdpServer.cpp -o UdpServer.o $(CFLAGS)
    
udpclient.o: udpclient.cpp
	$(CC) -c udpclient.cpp -o udpclient.o $(CFLAGS)

main.o: main.cpp
	$(CC) -c main.cpp -o main.o $(CFLAGS)

AbstractServer.o: AbstractServer.cpp AbstractServer.h
	$(CC) -c AbstractServer.cpp -o AbstractServer.o $(CFLAGS)
	

linuxlib/IsWanted.o:linuxlib/IsWanted.cpp
	$(CC) -c linuxlib/IsWanted.cpp -o linuxlib/IsWanted.o $(CFLAGS)

os/os.o: os/os.cpp
	$(CC) -c os/os.cpp -o os/os.o $(CFLAGS)

os/ostime.o: os/ostime.cpp
	$(CC) -c os/ostime.cpp -o os/ostime.o $(CFLAGS)

os/socket.o: os/socket.cpp
	$(CC) -c os/socket.cpp -o os/socket.o $(CFLAGS)

os/ConfigFile.o: os/ConfigFile.cpp
	$(CC) -c os/ConfigFile.cpp -o os/ConfigFile.o $(CFLAGS)

os/log.o: os/log.cpp
	$(CC) -c os/log.cpp -o os/log.o $(CFLAGS)

os/protected.o: os/protected.cpp
	$(CC) -c os/protected.cpp -o os/protected.o $(CFLAGS)

os/thread-pthread.o: os/thread-pthread.cpp
	$(CC) -c os/thread-pthread.cpp -o os/thread-pthread.o $(CFLAGS)

os/LogLevel.o: os/LogLevel.cpp
	$(CC) -c os/LogLevel.cpp -o os/LogLevel.o $(CFLAGS)

os/CSS_LOCKEX.o: os/CSS_LOCKEX.cpp
	$(CC) -c os/CSS_LOCKEX.cpp -o os/CSS_LOCKEX.o $(CFLAGS)

os/mutex.o: os/mutex.cpp
	$(CC) -c os/mutex.cpp -o os/mutex.o $(CFLAGS)

os/LogCache.o: os/LogCache.cpp
	$(CC) -c os/LogCache.cpp -o os/LogCache.o $(CFLAGS)

os/osutils.o: os/osutils.cpp
	$(CC) -c os/osutils.cpp -o os/osutils.o $(CFLAGS)

os/str.o: os/str.cpp
	$(CC) -c os/str.cpp -o os/str.o $(CFLAGS)

os/LogLevel.o: os/LogLevel.cpp
	$(CC) -c os/LogLevel.cpp -o os/LogLevel.o $(CFLAGS)	
	
clib/log.o: clib/log.cpp
	$(CC) -c clib/log.cpp -o clib/log.o $(CFLAGS)
	
clib/utility.o: clib/utility.cpp
	$(CC) -c clib/utility.cpp -o clib/utility.o $(CFLAGS)
	
clib/thread.o: clib/thread.cpp
	$(CC) -c clib/thread.cpp -o clib/thread.o $(CFLAGS)

clib/exp.o: clib/exp.cpp
	$(CC) -c clib/exp.cpp -o clib/exp.o $(CFLAGS)

clib/array.o: clib/array.cpp
	$(CC) -c clib/array.cpp -o clib/array.o $(CFLAGS)

$(BIN_EXEC): $(EXEC_OBJ)
	$(LINK) $(EXEC_OBJ) -o bin/$(BIN_EXEC) $(LFLAGS)

$(BIN): $(OBJ)
	$(DLLWRAP) -g -shared -Wl -soname=$(SOBIN)  $(OBJ)  -o ./bin/$(BIN) -lc -lcs -L../cs/bin

$(TEST): $(EXEC_OBJ)
	$(LINK) $(EXEC_OBJ) -o $(TEST) $(LFLAGS)
    
$(TEST_CLIENT): udpclient.cpp
	$(CC) udpclient.cpp -o $(TEST_CLIENT)
   
install:
	cp -fr bin/libnanohttp.so.1.0 /usr/lib
