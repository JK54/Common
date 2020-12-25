#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

/*the main purpose : grep compound keyword,such as "else if"*/
int main(int argc,char **argv)
{
	if(argc == 1 || (argc == 2 && (strncmp(argv[1],"-",1) == 0)))
	{
		printf("grep keyword in current folder recursively,without bracket or quote(exclude \"/mnt\" when stay in root folder by default)\n");
		printf("usage1 : findall keyword\n");
		printf("usage2 : findall -d dir keyword\n");
		exit(1);
	}
	char buf[BUFSIZ];
	char directory[BUFSIZ] = ".";
	memset(buf,'\0',BUFSIZ);
	memset(directory,'\0',BUFSIZ);
	directory[0] = '.';
	int start = 1;
	if(strncmp(argv[1],"-d",2) == 0)
	{
		strncpy(directory,argv[2],BUFSIZ);
		start = 3;
	}
	for(int i = start;i < argc;i++)
	{
		strncat(buf,argv[i],strlen(buf) + strlen(argv[i]));
		if(i < argc - 1)
			strncat(buf," ",1 + strlen(buf));
	}
	execlp("grep","grep","-rn","--color=auto","--exclude-dir=/mnt",buf,directory,NULL);
}
