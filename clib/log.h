#ifndef JUJU_LOG_H
#define JUJU_LOG_H
#include "options.h"
#include <string>
#ifdef WIN32
#include <hash_map>
#else
#include <ext/hash_map>
#endif
#include "macros.h"
#ifdef ENABLE_LOG_CACHE
#include "thread.h"
#endif

#include <stdio.h>
  #include   <time.h>   
  #include   <stdlib.h>  

#define LOG_DEFAULT_LVL 100

#if !defined(_WIN32)
using   namespace   __gnu_cxx;
#endif
//static std::hash_map<char*, CLog*> log_list;


namespace JUJU{
void _log(std::string  msg, char* file, long line, int l, char* type, char* filename="");
void _log(char*  msg, char* file, long li, int l, char* type,char* filename="");


#ifdef ENABLE_LOG_CACHE
void log_thread(void* p);
class thread{

public:
	unsigned char heart_beat;
	thread(void* param){
		this->param = param;
		thread_create_real(log_thread, (void*)this, "log_daemon");
		stop_event = 0;
	}
	
	~thread(){

	}

	void stop(){
		stop_event = 1;
	}

	int stop_event;

	void* param;

};
#endif
/*struct   str_hash  
  {  
                  size_t   operator()(const  std::string&   str)   const  
                  {  
                                  return   __stl_hash_string(str.c_str());  
                  }  
  }; */  
class CLog{



	
public:
#ifdef WIN32
	static stdext::hash_map<char*, CLog*> log_list;
#else
	static hash_map<char*, CLog*> log_list;
#endif

	void _log(char *msg,char* file, long line, int l, char *type);
	static void debug2(char* fmt, char* file, int line, ...);
	static void Log(char* msg, char* file, long line, int l, char* type, char* category, ...);


	
	static CLog* getInst(char* cat){
			if (cat == NULL || strlen(cat) == 0)
				return getDefInst();
		CLog* p = log_list[cat];
		if (p == NULL){
			p = new CLog(cat);
			log_list[cat] = p;
		}
		return p;

	}
	static CLog* getDefInst(){
		if (pInst == NULL)
		{
			pInst = new CLog();
			pInst->Init();
		}
		return pInst;
	}

	void Init(){

	}

	~CLog();
	static void setFile(char* file){
		strncpy(logFileName, file, 255);
	}
	static void enableStdOut(bool t){
		bStdOut = t;
	}
	static std::string genFileName(char* cat=""){
	//	if (strlen(logFileName) == 0)
	//		return "";
			
 		char fileName[256] = ""; // generated full filename
      
        // get current time
        time_t t;
        struct tm *ptm;
        time(&t);
#if LOG_TIMESTAMP_GMTTIME
        tm = localtime(t);
#else
        ptm = gmtime(&t);
#endif
        
        // generate actual file name
        snprintf(fileName, 255, "%s%s%04d%02d%02d.log",logFileName, cat, ptm->tm_year + 1900, ptm->tm_mon + 1, ptm->tm_mday);

		return std::string(fileName);

	}

	void real_log(char *s);
	void flush(){
       
		if (cache.length() == 0)
			return;

		real_log((char *)cache.c_str());
		
		cache = "";
	}

	void writeFirstLog(){
		char msg[300] = "";
		sprintf(msg, "log started, category=%s", this->category);

		this->_log(msg, __FILE__, __LINE__, 0, "EVENT");

		flush();
	}

	static void setCache(bool useCache){
		bUseCache = useCache;
	}
protected:
	CLog(char* n ){
		strcpy(category, n);
		writeFirstLog();
#ifdef ENABLE_LOG_CACHE
		pth = new thread(this);
#endif
		//bUseCache = true;
		level = LOG_DEFAULT_LVL;
	};
	
	CLog(){
		strcpy(category, "");
		writeFirstLog();
#ifdef ENABLE_LOG_CACHE
		pth = new thread(this);
#endif
		//bUseCache = true;
		level = LOG_DEFAULT_LVL;
	};

public:
	static bool isDebug(){
		return bDebug;
	}
private:
	static CLog *pInst;
	static char logFileName[256];
	char category[256];
	std::string cache;
#ifdef ENABLE_LOG_CACHE
	thread* pth;
#endif
	static bool bUseCache;
	static bool bStdOut;
	static bool bDebug;
	int level;
public:
	static void debug(char* fmt, ...);
};


}


void debug(char* fmt, ...);
// simple and stable log, no cache, write file directly, for emergency use
#define cLOG(m) JUJU::_log(m, __FILE__, __LINE__, 10, "LOG")

// cached log
#define LOG(m) JUJU::CLog::Log(m, __FILE__, __LINE__, 10, "LOG", "")
#define LOGc(m, category)  JUJU::CLog::Log(m, __FILE__, __LINE__, 10, "LOG", category)
#define nLOG(m, n)  JUJU::CLog::Log(m, __FILE__, __LINE__, n, "LOG", "")
#define LOG0(m) JUJU::CLog::Log(m, __FILE__, __LINE__, 10, "LOG", "")
#define LOG1p(m, p1) JUJU::CLog::Log(m, __FILE__, __LINE__, 10, "LOG", "", p1)
#define LOG2p(m, p1, p2) JUJU::CLog::Log(m, __FILE__, __LINE__, 10, "LOG", "", p1, p2)
#define ERR(m) JUJU::CLog::Log(m, __FILE__, __LINE__, 10, "ERR", "")
#define ERRc(m, category) JUJU::CLog::Log(m, __FILE__, __LINE__, 10, "ERR", category)
#define ERR0(m) JUJU::CLog::Log(m, __FILE__, __LINE__, 10, "ERR", "")
#define ERR1p(m, p1) JUJU::CLog::Log(m, __FILE__, __LINE__, 10, "ERR", "", p1)
#define ERR2p(m, p1, p2) JUJU::CLog::Log(m, __FILE__, __LINE__, 10, "ERR", "", p1, p2)
#define ERR2(m, c) JUJU::CLog::Log(m, __FILE__, __LINE__, 10, "ERR", c)

#define nTRACE(m, n) JUJU::CLog::Log(m, __FILE__, __LINE__, n, "TRC", "")
//#ifdef TRACE
//#undef TRACE
//#endif
//#define TRACE(m)  JUJU::CLog::Log(m, __FILE__, __LINE__, 10, "TRC")
#define TRACE1(m, category)  JUJU::CLog::Log(m, __FILE__, __LINE__, 10, "TRC", category)
#define DEBUGc(m, category)  JUJU::CLog::Log(m, __FILE__, __LINE__, 10, "DBG", category)
#define DEBUG0(m)  JUJU::CLog::Log(m, __FILE__, __LINE__, 10, "DBG", "")
#define DEBUG1p(m, p1)  JUJU::CLog::Log(m, __FILE__, __LINE__, 10, "DBG", "", p1)
#define DEBUG2p(m, p1, p2)  JUJU::CLog::Log(m, __FILE__, __LINE__, 10, "DBG", "", p1, p2)
#define DEBUG3p(m, p1, p2, p3)  JUJU::CLog::Log(m, __FILE__, __LINE__, 10, "DBG", "", p1, p2, p3)
#define DEBUG4p(m, p1, p2, p3, p4)  JUJU::CLog::Log(m, __FILE__, __LINE__, 10, "DBG", "", p1, p2, p3, p4)
#define DEBUG5p(m, p1, p2, p3, p4, p5)  JUJU::CLog::Log(m, __FILE__, __LINE__, 10, "DBG", "", p1, p2, p3, p4,p5)
#define DEBUG6p(m, p1, p2, p3, p4, p5, p6)  JUJU::CLog::Log(m, __FILE__, __LINE__, 10, "DBG", "", p1, p2, p3, p4,p5,p6)
#define DEBUG(m)  JUJU::CLog::Log(m, __FILE__, __LINE__, 10, "DBG", "")
using namespace JUJU;
#endif
