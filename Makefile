# Project: se


#headers = $(shell echo ./*.h os/*.h)
#srcs = $(shell echo ./*.cpp os/*.cpp)
#objs = $(srcs:.cpp=.o)

CC   = g++ 

CLIB_OBJ = clib/array.o clib/exp.o clib/thread.o clib/log.o clib/utility.o os/os.o os/LogCache.o os/ostime.o os/socket.o os/str.o os/thread-pthread.o os/osutils.o os/log.o os/CSS_LOCKEX.o os/ConfigFile.o os/protected.o os/mutex.o os/LogLevel.o 
OBJ = $(CLIB_OBJ) AbstractServer.o interface.o HttpServer.o
EXEC_OBJ  =  $(OBJ)  main.o
CGI_OBJ = $(OBJ) cgi-bin/cs_cgi.o
#OBJ  = $(objs) $(RES)
#OBJ  = $(objs)
pp = cocoR1/cp.cpp
BIN_EXEC = server
CGI = cgi-bin/cs.cgi
BIN  = libnanohttp.so.1.0
SOBIN=$(BIN:.so.1.0=.so)
CFLAGS = -D__SUPPORT_OBJ -g -fPIC  -D_VMMANAGER -O2 -fomit-frame-pointer -w -W -Wall -Iclib -Ios -D_MACOS -I./ -D_64
# -Wfatal-errors
LINK=g++ 
LFLAGS=-g

.PHONY: all all-before all-after clean clean-custom

all: all-before $(BIN_EXEC) $(BIN) all-after

lib: all-before $(BIN) all-after

#parser: $(pp)
clean: clean-custom
	rm -f $(OBJ) $(BIN)
	rm -f main.o
	rm -f cgi-bin/cs_cgi.o
DLLWRAP=g++

HttpServer.o: HttpServer.cpp
	$(CC) -c HttpServer.cpp -o HttpServer.o $(CFLAGS)

interface.o: interface.cpp
	$(CC) -c interface.cpp -o interface.o $(CFLAGS)
	
main.o: main.cpp
	$(CC) -c main.cpp -o main.o $(CFLAGS)

AbstractServer.o: AbstractServer.cpp AbstractServer.h
	$(CC) -c AbstractServer.cpp -o AbstractServer.o $(CFLAGS)
	
cscript.o: cscript.cpp
	$(CC) -c cscript.cpp -o cscript.o $(CFLAGS)
	
cgi-bin/cs_cgi.o: cgi-bin/cs_cgi.cpp
	$(CC) -c cgi-bin/cs_cgi.cpp -o cgi-bin/cs_cgi.o $(CFLAGS)
	
Configure.o: Configure.cpp
	$(CC) -c Configure.cpp -o Configure.o $(CFLAGS)

cocoR1/cp.cpp: cocoR/cs.atg cocoR/PARSER_C.FRM cocoR/PARSER_H.FRM
	cd cocoR && ./cocor -A -F -X -S -G -C -L -D cs.atg && perl grep.pl > syntax
	
ObjectInst.o: ObjectInst.cpp
	$(CC) -c ObjectInst.cpp -o ObjectInst.o $(CFLAGS)
		
ObjTable.o: ObjTable.cpp
	$(CC) -c ObjTable.cpp -o ObjTable.o $(CFLAGS)
	
ClassDesTable.o: ClassDesTable.cpp
	$(CC) -c ClassDesTable.cpp -o ClassDesTable.o $(CFLAGS)
	
Class.o: Class.cpp
	$(CC) -c Class.cpp -o Class.o $(CFLAGS)
	
CCompiler.o: CCompiler.cpp
	$(CC) -c CCompiler.cpp -o CCompiler.o $(CFLAGS)

cp.o: cocoR/cp.cpp
	$(CC) -c cocoR/cp.cpp -o cp.o $(CFLAGS)

CR_ABS.o: cocoR/CR_ABS.cpp
	$(CC) -c cocoR/CR_ABS.cpp -o CR_ABS.o $(CFLAGS)

CR_ERROR.o: cocoR/CR_ERROR.cpp
	$(CC) -c cocoR/CR_ERROR.cpp -o CR_ERROR.o $(CFLAGS)

CR_PARSE.o: cocoR/CR_PARSE.cpp
	$(CC) -c cocoR/CR_PARSE.cpp -o CR_PARSE.o $(CFLAGS)

CR_SCAN.o: cocoR/CR_SCAN.cpp
	$(CC) -c cocoR/CR_SCAN.cpp -o CR_SCAN.o $(CFLAGS)

cs.o: cocoR/cs.cpp
	$(CC) -c cocoR/cs.cpp -o cs.o $(CFLAGS)

Function.o: Function.cpp
	$(CC) -c Function.cpp -o Function.o $(CFLAGS)

LoopTree.o: LoopTree.cpp
	$(CC) -c LoopTree.cpp -o LoopTree.o $(CFLAGS)

ObjDes.o: ObjDes.cpp
	$(CC) -c ObjDes.cpp -o ObjDes.o $(CFLAGS)

ClassDes.o: ClassDes.cpp
	$(CC) -c ClassDes.cpp -o ClassDes.o $(CFLAGS)

PubFuncTable.o: PubFuncTable.cpp
	$(CC) -c PubFuncTable.cpp -o PubFuncTable.o $(CFLAGS)

Request.o: Request.cpp
	$(CC) -c Request.cpp -o Request.o $(CFLAGS)
	
Exp.o: Exp.cpp
	$(CC) -c Exp.cpp -o Exp.o $(CFLAGS)

ScriptFuncTable.o: ScriptFuncTable.cpp
	$(CC) -c ScriptFuncTable.cpp -o ScriptFuncTable.o $(CFLAGS)

#StdAfx.o: StdAfx.cpp
#	$(CC) -c StdAfx.cpp -o StdAfx.o $(CFLAGS)

SymbolTable.o: SymbolTable.cpp
	$(CC) -c SymbolTable.cpp -o SymbolTable.o $(CFLAGS)

utility.o: utility.cpp
	$(CC) -c utility.cpp -o utility.o $(CFLAGS)

VirtualMachine.o: VirtualMachine.cpp
	$(CC) -c VirtualMachine.cpp -o VirtualMachine.o $(CFLAGS)

VMException.o: VMException.cpp
	$(CC) -c VMException.cpp -o VMException.o $(CFLAGS)

compiler.o: compiler.cpp
	$(CC) -c compiler.cpp -o compiler.o $(CFLAGS)

VMManager.o: VMManager.cpp
	$(CC) -c VMManager.cpp -o VMManager.o $(CFLAGS)

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

install:
	cp -fr bin/libnanohttp.so.1.0 /usr/lib
