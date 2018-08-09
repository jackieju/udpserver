#ifndef ABSSERVER_H
#define ABSSERVER_H
#include "memory.h"
#include "os/socket.h"
#include "log.h"
#include "os/CSS_LOCKEX.h"
#include "clib.h"

#define SERVER_SELECT_FREQ 1000000 
#define SERVER_READ_FREQ   100000
int get_line(int sock, char *buf, int size);


class AbstractServer{
public:
	AbstractServer(){
		if (m_StopEvent.Create(NULL, true, false, NULL) != LOCKEX_ERR_OK)
	    	throw new clib::CExp(0, "create stop event failed");

		stopped = true;
	}
	virtual ~AbstractServer(){
		stop();
		while(!stopped){
			JUJU::sleep(100);
		}
		m_StopEvent.Destroy();
	}
	
	bool start(int port);


	    CSS_EVENT	m_StopEvent;	// event to stop server

private:
	
	int stopped;
	bool stop(){
			m_StopEvent.Set();
	}

	

}



;
#endif
