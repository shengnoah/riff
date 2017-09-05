#include <pcap.h>  
#include <time.h>  
#include <stdlib.h>  
#include <stdio.h>  
#include <string.h>
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>
lua_State* L = NULL;

void getPacket(u_char * arg, const struct pcap_pkthdr * pkthdr, const u_char * packet)  
{ 

  L = lua_open();
      luaL_openlibs(L);

  if (luaL_loadfile(L, "buffer.lua") || lua_pcall(L, 0,0,0))
      printf("Cannot run configuration file:%s", lua_tostring(L, -1));


  lua_getglobal(L, "buffer");
  char *buffer = NULL;
  buffer = (u_char*)malloc(pkthdr->len);
  memcpy(buffer, packet, pkthdr->len);

  lua_newtable(L); 
  int idx = 0;
  for (idx=1; idx < pkthdr->len; idx++) {
      lua_pushnumber(L, idx);  
      lua_pushnumber(L, packet[idx]);  
      lua_settable(L, -3);  
  }
  lua_pcall(L, 1,0,0);

  int * id = (int *)arg;  
  printf("id: %d\n", ++(*id));  
  printf("Packet length: %d\n", pkthdr->len);  
  printf("Number of bytes: %d\n", pkthdr->caplen);  
  printf("Recieved time: %s", ctime((const time_t *)&pkthdr->ts.tv_sec));   
    
  int i;  
  for(i=0; i<pkthdr->len; ++i) {  
    //printf(" %02x", packet[i]);  
    if( (i + 1) % 16 == 0 ) {  
	//printf("\n");  
    }  
  }  

  printf("\n\n");  

  free(buffer);
  buffer = NULL;
}  
  
int main()  
{  
  char errBuf[PCAP_ERRBUF_SIZE], * devStr;  
    
  /* get a device */  
  //devStr = pcap_lookupdev(errBuf);  
  devStr = "eth1";
    
  if(devStr)  
  {  
    printf("success: device: %s\n", devStr);  
  }  
  else  
  {  
    printf("error: %s\n", errBuf);  
    exit(1);  
  }  
    
  /* open a device, wait until a packet arrives */  
  pcap_t * device = pcap_open_live(devStr, 65535, 1, 0, errBuf);  
    
  if(!device)  
  {  
    printf("error: pcap_open_live(): %s\n", errBuf);  
    exit(1);  
  }  
    
  /* construct a filter */  
  struct bpf_program filter;  
  pcap_compile(device, &filter, "src port 80", 1, 0);  
  //pcap_compile(device, &filter, "dst port 80", 1, 0);  
  pcap_setfilter(device, &filter);  
    
  /* wait loop forever */  
  int id = 0;  
  pcap_loop(device, -1, getPacket, (u_char*)&id);  
    
  pcap_close(device);  
  
  return 0;  
}  
