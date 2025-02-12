#include <stdio.h>
#include <stdlib.h>
#include "nalla520nmxlib.h"
#include "520nmx_bist_bar0_mmap.h"

/*
#define NALLA_OPEN_520nmx_MAINTENANCE      (0x00000001)
#define NALLA_OPEN_520nmx_MONITOR          (0x00000002)
#define NALLA_OPEN_520nmx_CONTROL_STATUS   (0x00000004)
#define NALLA_OPEN_520nmx_EGRESS_CH0       (0x00000008)
#define NALLA_OPEN_520nmx_INGRESS_CH0      (0x00000010)
#define NALLA_OPEN_520nmx_BAR_CSR          (0x00000020)
#define NALLA_OPEN_520nmx_BAR_SDRAM        (0x00000040)
#define NALLA_OPEN_520nmx_BAR_SRAM         (0x00000080)
#define NALLA_OPEN_520nmx_BUFFER_ALLOC     (0x00000100)
*/

NALLA_HANDLE hbar;



int main(int argc, char* argv[])
{
    int i;
    hbar = NALLA_520nmx_Open(0,NALLA_OPEN_520nmx_INGRESS_CH0);
    uint32_t *writebuffer;
    //uint32_t *readbuffer;
    int buffer_size = 4;
    int dword_buffer_size = buffer_size /4;
    writebuffer = (uint32_t*)calloc(dword_buffer_size, sizeof(uint32_t));
    // Set up count data
	for(i=0; i<dword_buffer_size; i++)
	{
		writebuffer[i] = i;
	}
    int numbytes = 4,numbyteswritten=0;
    numbyteswritten = NALLA_520nmx_Write(hbar, writebuffer, ESRAM_CHANNEL0, numbytes, NALLA_MMAP_WRITE);
    printf("%d", numbyteswritten);
    NALLA_520nmx_Close(hbar);
    return 0;
}
