#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include <time.h>
#include <unistd.h>
#include "nalla520nmxlib.h"
#include "520nmx_bist_bar0_mmap.h"

//#define ESRAM_TEST_CHANNEL0 = 0x10000
//#define ESRAM_TEST_CHANNEL7 = 0x12000
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
    hbar = NALLA_520nmx_Open(1,NALLA_OPEN_520nmx_BAR_CSR);
    if(hbar == NULL)
	{
		printf("Error opening card %d.\n", 1);
		return 1;
	}

    uint32_t *writebuffer;
    uint32_t *readbuffer;
   
    int buffer_size = ESRAM_CHANNEL7 - ESRAM_CHANNEL0;
    //int buffer_size = 0x12000 - 0x10000;
    int dword_buffer_size = buffer_size /4;
    writebuffer = (uint32_t*)calloc(dword_buffer_size, sizeof(uint32_t));
    readbuffer = (uint32_t*)calloc(dword_buffer_size, sizeof(uint32_t));
    // Set up count data
	for(i=0; i<dword_buffer_size; i++)
	{
		writebuffer[i] = i;
	}

    int numbyteswritten=0, numbytesread=0, numbytes=0;
    numbytes = buffer_size;
    clock_t begin_writing = clock();
    numbyteswritten = NALLA_520nmx_Write(hbar, writebuffer, ESRAM_CHANNEL0, numbytes, NALLA_MMAP_WRITE);
    if(numbyteswritten != numbytes)
    {
        printf("Mismatch: Number of bytes written %d, number of bytes requested %d\n",numbyteswritten, numbytes);
        free(writebuffer);
        free(readbuffer);
        return 1;
    }
    clock_t end_writing = clock();
    double time_spent_writing = (double)(end_writing - begin_writing) / CLOCKS_PER_SEC;
    printf("Time spent writing %d bytes of data %fs\n", numbyteswritten,time_spent_writing);

    clock_t begin_reading = clock();
    numbytesread = NALLA_520nmx_Read(hbar, readbuffer, ESRAM_CHANNEL0, numbytes, NALLA_MMAP_READ);
    if(numbytesread != numbytes)
    {
            printf("Mismatch: Number of bytes received %d, number of bytes requested %d\n",numbytesread, numbytes);
            free(writebuffer);
            free(readbuffer);
            return 1;
    }
    clock_t end_reading = clock();
    double time_spent_reading = (double)(end_reading - begin_reading) / CLOCKS_PER_SEC;
    printf("Time spent reading %d bytes of data %fs\n", numbytesread,time_spent_reading);

    

    // for(i=0; i<dword_buffer_size; i++)
	// {
    //     printf("The data in memory is %d\n", readbuffer[i]);
		
	// }
    

    if(hbar!=0)
	{
		NALLA_520nmx_Close(hbar);
	}

    return 0;
}
