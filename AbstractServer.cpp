#include "os/osmacros.h"
#include "AbstractServer.h"
/*
 * 	NOTICE: port must > 999
 */
bool AbstractServer::start(int port){
	LOG1p("create server socket from port %d", port);
	int server_socket = OSCreateUDPSocket();
    LOG("1");
	if (server_socket < 0){
		ERR2p("failed to create server stocket on port %d, error no. %d", port, server_socket);
		return false;
	}

    LOG("2");
    
    if (OSUDPBind(&server_socket, port, "*") < 0){
		ERR2p("failed to bind server stocket  on port %d, error no. %d", port, server_socket);
		return false;
    }
    
	LOG1p("=>create server socket, %d", server_socket);
	fprintf(stdout, ".\n====\n");
	stopped = false;

     printf("SERVER:UDP_PACKET_MAX_SIZE=%d\n", UDP_PACKET_MAX_SIZE);
	while (m_StopEvent.Wait(10) == LOCKEX_ERR_TIMEOUT)
	{
		//fprintf(stderr, ".");
        char *buf=NULL;
        char src_ip[16]="";
        long port;
        long size = 0;
        struct sockaddr_in addr;
        if (OSUDPRecvFrom(server_socket, buf, size, src_ip, port, addr, 1) <= 0)
            continue;
 
		
   		fprintf(stderr, "\nget data from %s:%d\n %s", src_ip, port, buf);
        SAFEFREE(buf);
        
        
        // acknowledge immediately
        char *ss = "welcome!";
        printf("sending to port %d...\n", port);
		//int r = OSUDPSendTo(server_socket, ss, strlen(ss), src_ip, port//);
		//int r = OSUDPSendTo(server_socket, ss, strlen(ss));
        int r = sendto(server_socket, ss, strlen(ss)+1, 0, (struct sockaddr *)&addr, (int) sizeof(addr));

        printf("sendto return %d\n", r);
	
    }
	CloseSocket(&server_socket);
	LOG0("udpserver exited");
    stopped = true;
}
int get_line(int sock, char *buf, int size)
{
 int i = 0;
 char c = '\0';
 int n;

 while ((i < size - 1) && (c != '\n'))
 {
  n = recv(sock, &c, 1, 0);
  /* DEBUG printf("%02X\n", c); */
  if (n > 0)
  {
   if (c == '\r')
   {
    n = recv(sock, &c, 1, MSG_PEEK);
    /* DEBUG printf("%02X\n", c); */
    if ((n > 0) && (c == '\n'))
     recv(sock, &c, 1, 0);
    else
     c = '\n';
   }
   buf[i] = c;
   i++;
  }
  else
   c = '\n';
 }
 buf[i] = '\0';
 
 return(i);
}