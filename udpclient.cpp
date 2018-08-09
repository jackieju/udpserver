#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>

#define PORT 3001
#define MAXDATASIZE 100

int main(int argc, char *argv[])
{
    int sockfd, num;
    char buf[MAXDATASIZE];

    struct hostent *he;
    struct sockaddr_in server,peer;

    if (argc !=3)
    {
    printf("Usage: %s <IP Address><message>\n",argv[0]);
    exit(1);
    }

    if ((he=gethostbyname(argv[1]))==NULL)
    {
    printf("gethostbyname()error\n");
    exit(1);
    }

    if ((sockfd=socket(AF_INET, SOCK_DGRAM,0))==-1)
    {
    printf("socket() error\n");
    exit(1);
    }

    bzero(&server,sizeof(server));
    server.sin_family = AF_INET;
    server.sin_port = htons(PORT);
    server.sin_addr= *((struct in_addr *)he->h_addr);
    sendto(sockfd, argv[2],strlen(argv[2]),0,(struct sockaddr *)&server,sizeof(server));
    printf("\nclient:sent\n");
    socklen_t  addrlen;
    addrlen=sizeof(server);
    while (1)
    {
        printf("client:recvfrom...\n");
        if((num=recvfrom(sockfd,buf,MAXDATASIZE,0,(struct sockaddr *)&peer,&addrlen))== -1)
        {
            printf("recvfrom() error\n");
            exit(1);
        }
            printf("client:2\n");
        
        if (addrlen != sizeof(server) ||memcmp((const void *)&server, (const void *)&peer,addrlen) != 0)
        {
            printf("Receive message from otherserver.\n");
            continue;
        }
 printf("client:3\n");
        buf[num]='\0';
        printf("Get Server Message:%s\n",buf);
        break;
    }

    close(sockfd);
}