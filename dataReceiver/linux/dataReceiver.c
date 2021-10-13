/*
 * Filename             : streamer.cpp
 * Description          : Provides functions to test USB data transfer performance.
 * gcc "dataReceiver.c" -O2 -g `pkg-config libusb-1.0 --libs --cflags`  -lpthread -o "dataReceiver"
 * License: GPLv2
 */




#define __maybe_unused __attribute__((unused))
#define __force	__attribute__((force))
#define __ACCESS_ONCE(x) ({ \
	 __maybe_unused typeof(x) __var = (__force typeof(x)) 0; \
	(volatile typeof(x) *)&(x); })
#define ACCESS_ONCE(x) (*__ACCESS_ONCE(x))
#define TIMEOUT_XFER 500
#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <stdlib.h>
#include <termios.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <fcntl.h>
#include <pthread.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <fcntl.h>
#include <libusb-1.0/libusb.h>
typedef enum {false, true} bool;


typedef struct data_header_struct_in
{
	uint16_t step     :16;
	uint8_t  t_L	     :8;
	uint8_t scan_enable     :1;
	uint8_t line_enable     :1;
	uint8_t pixel_enable    :1;
	uint8_t valid_tdc_L     :1;
	uint8_t  id		     :4; // must be in value 0
	
} data_header_struct_in;

typedef struct data_payload_struct_in
{
	int8_t  t_C     :8;
	int8_t  t_B     :8;
	int8_t  t_A     :8;
	uint8_t  useless	 : 1;
	uint8_t  valid_tdc_C :1;
	uint8_t  valid_tdc_B :1;
	uint8_t  valid_tdc_A :1;
	uint8_t  id		 :4;   // must be in value >0
	
} data_payload_struct_in;


typedef struct data_header_struct_out
{
	uint32_t event;
	uint16_t step     ;
	uint8_t  t_L	  ;
	uint8_t scan_enable     ;
	
	uint8_t line_enable     ;
	uint8_t pixel_enable    ;
	uint8_t valid_tdc_L     ;
	uint8_t  id		     ; // must be in value 0
	
} data_header_struct_out;

typedef struct data_payload_struct_out
{
	uint32_t event;
	uint8_t  t_C     ;
	uint8_t  t_B     ;
	uint8_t  t_A     ;
	
	uint8_t  useless	 ;
	uint8_t  valid_tdc_C ;
	uint8_t  valid_tdc_B ;
	uint8_t  valid_tdc_A ;
	
	uint8_t  id		 ;   // must be in value >0
	
} data_payload_struct_out;


typedef struct userDataStruct
{
	uint32_t event;
	uint8_t  t_C     ;
	uint8_t  t_B     ;
	uint8_t  t_A     ;
	
	uint8_t  useless	 ;
	uint8_t  valid_tdc_C ;
	uint8_t  valid_tdc_B ;
	uint8_t  valid_tdc_A ;
	
	uint8_t  id		 ;   // must be in value >0
	
} userDataStruct;


#define RATIOPKT 256
//Ratio between the pktsize/ptksize_out

// Variables storing the user provided application configuration.
static unsigned int	endpoint   = 0x81;		// Endpoint to be tested
static unsigned int	reqsize    = 1;	// Request size in number of packets
//static unsigned int	reqsize    = 2;	// Request size in number of packets
static unsigned int	queuedepth = 255;	// Number of requests to queue
//static unsigned int	queuedepth = 8;	// Number of requests to queue
static unsigned char eptype = LIBUSB_TRANSFER_TYPE_BULK;			// Type of endpoint (transfer type)
static unsigned int	pktsize=16384;		    // Maximum packet size for the endpoint
static unsigned int	pktsize_out=16384*3;		// Size of a packet after parsing

static volatile unsigned long long	successUSB_count = 0;	// Number of successful transfers
static volatile unsigned long long	successDATA_count = 0;	// Number of successful transfers
static volatile unsigned long long	failure_count = 0;	// Number of failed transfers
static volatile unsigned long long	transfer_size = 0;	// Size of data transfers performed so far
static volatile unsigned long long	transfer_index = 0;	// Write index into the transfer_size array
static volatile unsigned long long	transfer_perf = 0;	// Performance in MBps
static volatile bool	stop_transfers = false;	// Request to stop data transfers
static volatile int	rqts_in_flight = 0;	// Number of transfers that are in progress
static volatile bool	app_running = false;	// Whether the streamer application is running
static pthread_t	strm_thread;		// Thread used for the streamer operation

static struct timeval	start_ts;		// Data transfer start time stamp.
static struct timeval	end_ts;			// Data transfer stop time stamp.

static volatile bool	saving_data_flag = true;	// Whether the streamer application is running
static volatile bool	streamOut_flag = false;	// Whether the streamer application is running
static volatile bool	parse_flag = true;	// Whether the streamer application is running
static volatile bool  	verbose_flag = 0;

//static volatile unsigned long long GLOBAL_BYTES_GOOD=0;
//static volatile unsigned long long GLOBAL_BYTES_BAD=0;
//static volatile unsigned long long GLOBAL_BYTES_RECEIVED=0;





#define NUMBER_OF_WORDS 8




struct timeval tnow;

struct timeval time_call;


char filename[1024];
static FILE *fptr;

static int parseUSBpacket(void *buf, int len, void *bufOut){
	gettimeofday (&time_call, NULL);
	

	static int prevval = 0;
	size_t bufOutSize=0;
	size_t bufGoodDataInSize=0;
	

	data_header_struct_in *dataIN_as_header;
	data_payload_struct_in *dataIN_as_payload;

	data_header_struct_out *dataOUT_as_header;
	data_payload_struct_out *dataOUT_as_payload;
	dataOUT_as_header=bufOut;
	dataOUT_as_payload=bufOut;
	uint32_t val;
	uint32_t time_call_int;
	time_call_int = time_call.tv_sec * 1000 + time_call.tv_usec / 1000;
	int i;
	
	size_t good_packet_count=0;
	size_t bad_packet_count=0;
	
	//fprintf(stderr,"%d/%d\n",len,len/sizeof(dataOUT_as_header));
	//fprintf(stderr, "Chunk Total in byte: %d, = %d words\n", len, len/4);
	//fprintf(stderr, "Total in byte: %d, = %d words\n",  READ_ONCE(ACCESS_ONCE ( GLOBAL_BYTES_RECEIVED )),  READ_ONCE(ACCESS_ONCE ( GLOBAL_BYTES_RECEIVED ))/4);
	int nword=0;
	int i_out=0;
	int header_position;	
	int first_header_position;
	int last_footer_position;	
	int expected_ID=0;
	bool last_data_group_was_OK=false;
	bool looking_for_next_header=true;
	int ordering_OK=0;
	good_packet_count=0;
	bad_packet_count=0;
	int output_pos=0;
	dataIN_as_header= buf;
	dataIN_as_payload= buf;
	

	// len is in sizeof unit (1= 8bits)
	expected_ID=0;
    if (len>0){
					for (i = 0; i < (len / sizeof(uint32_t)); i++) {
						last_data_group_was_OK=false;
				
						val = ((uint32_t*)buf)[i];
						expected_ID=expected_ID % NUMBER_OF_WORDS;
						
						//Only for verbose_flag
						if (verbose_flag==1){
									
									fprintf(stderr, "@%08ld: \t",i*sizeof(uint32_t));
									
										if (dataIN_as_header[i].id==0) 
											{

											if (verbose_flag==1) fprintf(stderr, "0x%08x \t Header s:%8d \tid:%d \t %d \t %d \t %d %d %d ", 
																			val,
																			dataIN_as_header[i].step,
																			dataIN_as_header[i].id,
																			dataIN_as_header[i].t_L,
																			dataIN_as_header[i].valid_tdc_L,
																			dataIN_as_header[i].pixel_enable,
																			dataIN_as_header[i].line_enable,
																			dataIN_as_header[i].scan_enable);
											}
											else
											{
											 if (verbose_flag==1) fprintf(stderr, "0x%08x \t Payload \t\tid:%d \t %d %d %d \t %d \t %d %d %d ", 
																			val,
																			dataIN_as_payload[i].id,
																			dataIN_as_payload[i].t_C,
																			dataIN_as_payload[i].t_B,
																			dataIN_as_payload[i].t_A,
																			dataIN_as_payload[i].useless,
																			dataIN_as_payload[i].valid_tdc_C,
																			dataIN_as_payload[i].valid_tdc_B,
																			dataIN_as_payload[i].valid_tdc_A);
											 
											}
									  }
						if (verbose_flag==1) fprintf(stderr, " Exp.ID %d ", expected_ID);
						
						if (dataIN_as_header[i].id!=expected_ID){
											if (verbose_flag==1) {fprintf(stderr," WRONG!");}
											if (verbose_flag==1) {fprintf(stderr, " Now looking for header ");}
											
											bad_packet_count++;
											expected_ID=0;   
						}			
						
						if (dataIN_as_header[i].id==expected_ID){
									if (verbose_flag==1) {fprintf(stderr, " OK ");}
									expected_ID++;

									if (expected_ID==NUMBER_OF_WORDS){	
										last_data_group_was_OK=true;
										expected_ID=0;
										if (verbose_flag==1) {fprintf(stderr, " LAST. PCK OK - Started @%d",header_position);}
									}
									
									if (dataIN_as_header[i].id==0){
										header_position=i;

									}
									
							}
						if (last_data_group_was_OK==true){
								
								output_pos=good_packet_count*NUMBER_OF_WORDS;
								good_packet_count++;
								
								if (verbose_flag==1) {
									fprintf(stderr,"%d %d \n",nword,header_position);
									}
								
										
								for (nword=0; nword<NUMBER_OF_WORDS; nword++)
									{
										if (nword==0) {
											dataOUT_as_header[output_pos].event = time_call_int; //good_packet_count;
											dataOUT_as_header[output_pos].step = dataIN_as_header[header_position].step;
											dataOUT_as_header[output_pos].t_L  = dataIN_as_header[header_position].t_L;
											dataOUT_as_header[output_pos].scan_enable = dataIN_as_header[header_position].scan_enable;
											dataOUT_as_header[output_pos].line_enable = dataIN_as_header[header_position].line_enable;
											dataOUT_as_header[output_pos].pixel_enable = dataIN_as_header[header_position].pixel_enable;
											dataOUT_as_header[output_pos].valid_tdc_L = dataIN_as_header[header_position].valid_tdc_L;
											dataOUT_as_header[output_pos].id = dataIN_as_header[header_position].id;
											dataOUT_as_header[output_pos].step = dataIN_as_header[header_position].step;
										}
										else {
											dataOUT_as_payload[output_pos+nword].event = time_call_int; //good_packet_count;
											dataOUT_as_payload[output_pos+nword].t_C = dataIN_as_payload[header_position+nword].t_C;
											dataOUT_as_payload[output_pos+nword].t_B = dataIN_as_payload[header_position+nword].t_B;
											dataOUT_as_payload[output_pos+nword].t_A = dataIN_as_payload[header_position+nword].t_A;
											dataOUT_as_payload[output_pos+nword].useless = dataIN_as_payload[header_position+nword].useless;
											dataOUT_as_payload[output_pos+nword].valid_tdc_C = dataIN_as_payload[header_position+nword].valid_tdc_C;
											dataOUT_as_payload[output_pos+nword].valid_tdc_B = dataIN_as_payload[header_position+nword].valid_tdc_B;
											dataOUT_as_payload[output_pos+nword].valid_tdc_A = dataIN_as_payload[header_position+nword].valid_tdc_A;
											dataOUT_as_payload[output_pos+nword].id = dataIN_as_payload[header_position+nword].id;
										}
														
									}
									
								//size_t pckbufOutSize=(good_packet_count)*(sizeof(data_header_struct_out) + sizeof(data_payload_struct_out)*(NUMBER_OF_WORDS-1));
								//NOTE THIS IS with data_header_struct_in as it is consider as 
								
								bufOutSize=(good_packet_count)*(sizeof(data_header_struct_out) + sizeof(data_payload_struct_out)*(NUMBER_OF_WORDS-1));
								bufGoodDataInSize=(good_packet_count)*(sizeof(data_header_struct_in) + sizeof(data_payload_struct_in)*(NUMBER_OF_WORDS-1));
								//
								//fprintf(stderr,"%ld + %ld\t%ld + %ld\n", output_pos, nword,header_position,nword);

										

							}
						
						if (verbose_flag==1) { 
									fprintf(stderr,"last dataOUT_as_payload_index %d %d ",output_pos,output_pos+nword);
									fprintf(stderr,"STORED: %ld",good_packet_count);
									fprintf(stderr,"\n");
									}
						
						 last_data_group_was_OK=false;
								
								
								
								if (verbose_flag==1) { 
									fprintf(stderr,"\n");
								}				 
						
					}
		
				
		

		if (verbose_flag==1){
			 fprintf(stderr, "Good: %ld / %ld \n ",good_packet_count*NUMBER_OF_WORDS, len/sizeof(uint32_t));

		}

		if (streamOut_flag){
					//fprintf(stderr,"%p size:%ld\n", bufOut,bufOutSize);
					//fprintf(fptr,"%p size:%ld\n", bufOut,bufOutSize);
					//~ if( fwrite(bufOut, 1, bufOutSize, fptr) !=  bufOutSize) {
					   //~ fprintf( stderr,"Error stdout\n");
					//~ }
				}
		 if (saving_data_flag){
			 gettimeofday (&tnow, NULL);
	
			 //fprintf(stderr,"%s",filename);
					//fprintf(stderr,"%p  %ld\n ", bufOut, bufOutSize);
					if( fwrite(bufOut, 1, bufOutSize, fptr) !=  bufOutSize) {
					   fprintf( stderr,"Error fwrite(...,fptr)\n");
					}									
	
		  }				

  	    //ACCESS_ONCE(GLOBAL_BYTES_GOOD)  = ACCESS_ONCE(GLOBAL_BYTES_GOOD) + (good_packet_count-1)*(sizeof(data_header_struct_in) + sizeof(data_payload_struct_in)*(NUMBER_OF_WORDS-1));
		//ACCESS_ONCE(GLOBAL_BYTES_BAD) = bad_packet_count;

	}
		
	successDATA_count += bufGoodDataInSize;
	
	return good_packet_count;
}



// Function: streamer_stop_xfer
// Requests the streamer operation to be stopped.
void
streamer_stop_xfer (
		void)
{
	stop_transfers = true;
}

// Function: streamer_is_running
// Checks whether the streamer operation is running.
bool
streamer_is_running (
		void)
{
	return app_running;
}

// Function: streamer_update_results
// Gets the streamer test results on an ongoing basis
static void
streamer_update_results (
		void)
{
	char buffer[64];

	// Print the transfer statistics into the character strings and update UI.
	fprintf (stderr, "USB data    Total: %10lld MB\t rate: %10lld Mbps\n", successUSB_count /1024/1024, transfer_perf);
	fprintf (stderr, "          Payload: %10lld MB\t \n", successDATA_count /1024/1024); // , transfer_perf * successDATA_count / successUSB_count);
	fprintf (stderr, "          No-Data: %10lld MB\t \n", (successUSB_count-successDATA_count) /1024/1024); //, transfer_perf- (transfer_perf * successDATA_count / successUSB_count));

	//mainwin->streamer_out_passcnt->setText (buffer);

	fprintf (stderr, "Failure count: %lld\n", failure_count);
	//mainwin->streamer_out_failcnt->setText (buffer);

}

// Function: xfer_callback
// This is the call back function called by libusb upon completion of a queued data transfer.
static void
xfer_callback (
		struct libusb_transfer *transfer)
{
	unsigned int elapsed_time;
	double       performance;
	int          size = 0;

	// Check if the transfer has succeeded.
	if (transfer->status != LIBUSB_TRANSFER_COMPLETED) {
		//fprintf(stderr,"status: %d\n", transfer->status);
		failure_count++;
		fprintf(stderr,".");

	} else {

		if (eptype == LIBUSB_TRANSFER_TYPE_ISOCHRONOUS) {

			// Loop through all the packets and check the status of each packet transfer
			for (unsigned int i = 0; i < reqsize; ++i) {

				// Calculate the actual size of data transferred in each micro-frame.
				if (transfer->iso_packet_desc[i].status == LIBUSB_TRANSFER_COMPLETED) {
					size += transfer->iso_packet_desc[i].actual_length;
				}
			}

		} else {
			//size = reqsize * pktsize;
			size = transfer->actual_length;    //Modify by MD for ZLP
		}

		//successUSB_count++;
		successUSB_count += transfer->actual_length;
	}

	// Update the actual transfer size for this request.
	transfer_size += size;

	// Print the transfer statistics when queuedepth transfers are completed.
	transfer_index++;
	if (transfer_index == queuedepth) {
	
		gettimeofday (&end_ts, NULL);
		elapsed_time = ((end_ts.tv_sec - start_ts.tv_sec) * 1000000 +
			(end_ts.tv_usec - start_ts.tv_usec));

		// Calculate the performance in MBps.
		performance    = (((double)transfer_size * 8.0F / 1024.0F / 1024.0F) / ((double)elapsed_time / 1000000));
		transfer_perf  = (unsigned int)performance;

		transfer_index = 0;
		transfer_size  = 0;
		start_ts = end_ts;
	}

	// Reduce the number of requests in flight.
	rqts_in_flight--;
	
	
	
	

			
	 if (parse_flag){
		 parseUSBpacket(transfer->buffer, transfer->actual_length, transfer->user_data);		 
		}
	 else
	 {	
		 if (saving_data_flag){
			 //gettimeofday (&tnow, NULL);
			 //sprintf(filename, "/dev/shm/data/data-%ld.%06ld", tnow.tv_sec,tnow.tv_usec);
			 //fprintf(stderr,"%s",filename);
			
			 //fptr = fopen(filename,"w");
			 // parseUSBpacket(transfer->buffer, transfer->actual_length, transfer->user_data);		 

			 fwrite(transfer->buffer,1, transfer->actual_length, fptr);
			 //fclose(fptr);
		  }		 
		if (streamOut_flag){
			 fwrite(transfer->buffer,1, transfer->actual_length, stdout);
		 }	
		 		
     }		
      
		
	// Prepare and re-submit the read request.
	if (!stop_transfers) {

		// We do not expect a transfer queue attempt to fail in the general case.
		// However, if it does fail; we just ignore the error.
		switch (eptype) {
			case LIBUSB_TRANSFER_TYPE_BULK:
				if (libusb_submit_transfer (transfer) == 0)
					rqts_in_flight++;
				break;

			case LIBUSB_TRANSFER_TYPE_INTERRUPT:
				if (libusb_submit_transfer (transfer) == 0)
					rqts_in_flight++;
				break;

			case LIBUSB_TRANSFER_TYPE_ISOCHRONOUS:
				libusb_set_iso_packet_lengths (transfer, pktsize);
				if (libusb_submit_transfer (transfer) == 0)
					rqts_in_flight++;
				break;

			default:
				break;
		}
	}
}

// Function to free data buffers and transfer structures
static void
free_transfer_buffers (
		unsigned char          **databuffers,
		unsigned char          **databuffers_out,		
		struct libusb_transfer **transfers)
{
	// Free up any allocated transfer structures
	if (transfers != NULL) {
		for (unsigned int i = 0; i < queuedepth; i++) {
			if (transfers[i] != NULL) {
				libusb_free_transfer (transfers[i]);
			}
			transfers[i] = NULL;
		}
		free (transfers);
	}

	// Free up any allocated data buffers
	if (databuffers != NULL) {
		for (unsigned int i = 0; i < queuedepth; i++) {
			if (databuffers[i] != NULL) {
				free (databuffers[i]);
			}
			databuffers[i] = NULL;
		}
		free (databuffers);
	}
	
// Free up any allocated data buffers_out
	if (databuffers_out != NULL) {
		for (unsigned int i = 0; i < queuedepth; i++) {
			if (databuffers_out[i] != NULL) {
				free (databuffers_out[i]);
			}
			databuffers_out[i] = NULL;
		}
		free (databuffers_out);
	}	
}

// Function: streamer_thread_func
// Function that implements the main streamer functionality. This will run on a dedicated thread
// created for the streamer operation.
static void *
streamer_thread_func (
		void *arg)
{
	libusb_device_handle *dev_handle = (libusb_device_handle *)arg;
	struct libusb_transfer **transfers = NULL;		// List of transfer structures.
	unsigned char **databuffers = NULL;			    // List of data buffers.
	unsigned char **databuffers_out = NULL;			// List of data buffers.
	int  rStatus;

	// Check for validity of the device handle
	if (dev_handle == NULL) {
		fprintf(stderr,"Failed to get CyUSB device handle\n");
		pthread_exit (NULL);
	}

	// The endpoint is already found and its properties are known.
	fprintf(stderr,"Starting test with the following parameters\n");
	fprintf(stderr,"\tEndpoint to test : 0x%x\n", endpoint);
	fprintf(stderr,"\tEndpoint type    : 0x%x\n", eptype);
	fprintf(stderr,"\tMax packet size  : 0x%x\n", pktsize);
	fprintf(stderr,"\tRequest size     : 0x%x\n", reqsize);
	fprintf(stderr,"\tQueue depth      : 0x%x\n", queuedepth);
	fprintf(stderr,"\n");

	// Allocate buffers and transfer structures
	bool allocfail = false;

	databuffers = (unsigned char **)calloc (queuedepth, sizeof (unsigned char *));
	databuffers_out = (unsigned char **)calloc (queuedepth, sizeof (unsigned char *));
	
	transfers   = (struct libusb_transfer **)calloc (queuedepth, sizeof (struct libusb_transfer *));

	if ((databuffers != NULL) && (databuffers_out != NULL) && (transfers != NULL)) {

		for (unsigned int i = 0; i < queuedepth; i++) {

			databuffers[i]     = (unsigned char *)malloc (reqsize * pktsize);
			databuffers_out[i] = (unsigned char *)malloc (reqsize * pktsize_out);
			transfers[i]   = libusb_alloc_transfer (
					(eptype == LIBUSB_TRANSFER_TYPE_ISOCHRONOUS) ? reqsize : 0);

			if ((databuffers[i] == NULL) || (transfers[i] == NULL) || (databuffers_out[i] == NULL)) {
				allocfail = true;
				break;
			}
		}

	} else {

		allocfail = true;

	}

	// Check if all memory allocations have succeeded
	if (allocfail) {
		fprintf(stderr,"Failed to allocate buffers and transfer structures\n");
		free_transfer_buffers (databuffers, databuffers_out, transfers);
		pthread_exit (NULL);
	}

	// Take the transfer start timestamp
	gettimeofday (&start_ts, NULL);

	// Launch all the transfers till queue depth is complete
	for (unsigned int i = 0; i < queuedepth; i++) {
		//fprintf(stderr,"%d: %p\n",i, databuffers_out[i]);
		switch (eptype) {
			case LIBUSB_TRANSFER_TYPE_BULK:
		
				libusb_fill_bulk_transfer (transfers[i],		//    struct libusb_transfer* transfer,
										   dev_handle,			//    libusb_device_handle* dev_handle,
										   endpoint,  			//    unsigned char endpoint,
										   databuffers[i],		//    unsigned char* buffer,
										   reqsize * pktsize,	//    int length,
										   xfer_callback,		//    libusb_transfer_cb_fn callback,
										   databuffers_out[i],	//    void* user_data,
										   TIMEOUT_XFER);				//    unsigned int timeout

				rStatus = libusb_submit_transfer (transfers[i]);
				if (rStatus == 0)
					rqts_in_flight++;
				else 				
									//enum libusb_error {
										//LIBUSB_SUCCESS             = 0,
										//LIBUSB_ERROR_IO            = -1,
										//LIBUSB_ERROR_INVALID_PARAM = -2,
										//LIBUSB_ERROR_ACCESS        = -3,
										//LIBUSB_ERROR_NO_DEVICE     = -4,
										//LIBUSB_ERROR_NOT_FOUND     = -5,
										//LIBUSB_ERROR_BUSY          = -6,
										//LIBUSB_ERROR_TIMEOUT       = -7,
										//LIBUSB_ERROR_OVERFLOW      = -8,
										//LIBUSB_ERROR_PIPE          = -9,
										//LIBUSB_ERROR_INTERRUPTED   = -10,
										//LIBUSB_ERROR_NO_MEM        = -11,
										//LIBUSB_ERROR_NOT_SUPPORTED = -12,
										//LIBUSB_ERROR_OTHER         = -99,
											//}
					fprintf(stderr,"Queued %d Error: %d\n", i, rStatus);
				break;

			case LIBUSB_TRANSFER_TYPE_INTERRUPT:
				libusb_fill_interrupt_transfer (transfers[i], dev_handle, endpoint,
						databuffers[i], reqsize * pktsize, xfer_callback, databuffers_out[i], TIMEOUT_XFER);
				rStatus = libusb_submit_transfer (transfers[i]);
				if (rStatus == 0)
					rqts_in_flight++;
				break;

			case LIBUSB_TRANSFER_TYPE_ISOCHRONOUS:
				libusb_fill_iso_transfer (transfers[i], dev_handle, endpoint, databuffers[i],
						reqsize * pktsize, reqsize, xfer_callback, databuffers_out[i], TIMEOUT_XFER);
				libusb_set_iso_packet_lengths (transfers[i], pktsize);
				rStatus = libusb_submit_transfer (transfers[i]);
				if (rStatus == 0)
					rqts_in_flight++;
				break;

			default:
				break;
		}
	}

	fprintf(stderr,"Queued %d requests\n", rqts_in_flight);

	struct timeval t1, t2, tout;
	gettimeofday (&t1, NULL);

	// Use a 1 second timeout for the libusb_handle_events_timeout call
	tout.tv_sec  = 1;
	tout.tv_usec = 0;

	// Keep handling events until transfer stop is requested.
	do {
		libusb_handle_events_timeout (NULL, &tout);

		// Refresh the performance statistics about once in 0.5 seconds.
		gettimeofday (&t2, NULL);
		if (t2.tv_sec > t1.tv_sec) {
			streamer_update_results ();
			t1 = t2;
		}

	} while (!stop_transfers);

	fprintf(stderr,"Stopping streamer app\n");
	while (rqts_in_flight != 0) {
		fprintf(stderr,"%d requests are pending\n", rqts_in_flight);
		libusb_handle_events_timeout (NULL, &tout);
		sleep (1);
	}

	free_transfer_buffers (databuffers, databuffers_out, transfers);
	app_running = false;

	fprintf(stderr,"Streamer test completed \n Press 'q' to exit \n\n");
	pthread_exit (NULL);
}

// Function: streamer_start_xfer
// Function to start the streamer operation. This creates a new thread which runs the
// data transfers.
int
streamer_start_xfer (
		void)
{
    int r,e,i,found,cnt;
	struct libusb_device **devs;
	struct libusb_device_handle *handle = NULL;
	struct libusb_device *dev;
	struct libusb_device_descriptor desc;
	
	if (app_running)
		{
		return -EBUSY;
		}








		r = libusb_init(NULL);
		if(r < 0) {
			fprintf( stderr,"\nfailed to initialise libusb\n");
			return 1;
		}

		cnt = libusb_get_device_list(NULL, &devs);
		if (cnt < 0) {
			fprintf( stderr,"\nThere are no USB devices on bus\n");
			return -1;
		}

		for (i = 0; i < cnt; i++) {
			dev = devs[i];
			r = libusb_get_device_descriptor(dev, &desc);
			if (r < 0) {
				fprintf( stderr,"failed to get device descriptor\n");
				libusb_free_device_list(devs,1);
				libusb_close(handle);
				break;
			}

			if (desc.idVendor == 0x04b4 && desc.idProduct == 0x00f1) {
				found = 1;
				break;
			}
		}

		if (found) {
			e = libusb_open(dev, &handle);
			if (e < 0) {
				fprintf( stderr,"error opening device\n");
				libusb_free_device_list(devs,1);
				libusb_close(handle);
			}
			fprintf( stderr,"\nDevice found\n");
		} else {
			fprintf( stderr,"\nDevice NOT found\n");
			libusb_free_device_list(devs,1);
			libusb_close(handle);
			return 1;
		}

		libusb_free_device_list(devs, 1);
		
		fprintf( stderr,"\nResetting Interface");
		
		e = libusb_reset_device(handle);
		if (e < 0) {
			fprintf( stderr,"\nCannot Reset Interface");
			libusb_free_device_list(devs,1);
			libusb_close(handle);
			return -1;
		}

		fprintf( stderr,"\nClaming Interface");

		e = libusb_claim_interface(handle, 0);
		if (e < 0) {
			fprintf( stderr,"\nCannot Claim Interface");
			libusb_free_device_list(devs,1);
			libusb_close(handle);
			return -1;
		}

	pktsize_out =((pktsize / (sizeof(data_header_struct_in) + sizeof(data_payload_struct_in)*(NUMBER_OF_WORDS-1)))) * (sizeof(data_header_struct_out) + sizeof(data_payload_struct_out)*(NUMBER_OF_WORDS-1));
	fprintf(stderr, "pktsize_out = %d\n",pktsize_out);


	// Default initialization for variables
	successUSB_count  = 0;
	successDATA_count  = 0;
	failure_count  = 0;
	transfer_index = 0;
	transfer_size  = 0;
	transfer_perf  = 0;
	rqts_in_flight = 0;
	stop_transfers = false;

	// Mark application running
	app_running    = true;
	if (pthread_create (&strm_thread, NULL, streamer_thread_func, (void *)handle) != 0) {
		app_running = false;
		return -ENOMEM;
	}

	return 0;
}




int main(int argc, char *argv[]) 
{

    struct termios t;
    tcgetattr(0, &t);
    t.c_lflag &= ~ICANON;
    tcsetattr(0, TCSANOW, &t);

    fcntl(0, F_SETFL, fcntl(0, F_GETFL) | O_NONBLOCK);
    
    
	//~ fptr = fopen("dataAppended","ab+");   
	//~ if (fptr==NULL){
		 //~ fprintf(stderr,"FileBroken\n");
		//~ }
	//~ else
	//~ {
		 //~ fprintf(stderr,"File: dataAppended\n");
	//~ }
    if (argc > 1) {
		double mytimeout;		
		//sscanf(argv[1], "%llu", &mysize);
		//fprintf( stderr,"Found mysize: %llu \n", mysize);
		fprintf( stderr,"Automatic mode:\n");


		sscanf(argv[1], "%lf", &mytimeout);
		fprintf( stderr,"Timeout set to: %e \n", mytimeout);
		
		if (argc > 2) {
			
			if (strcmp(argv[2], "RAW") == 0) {
				parse_flag=false;
				fprintf( stderr,"RAW flag, Parser disactivated");
			}
			
		}
		//mysize=floor(mysize/8+1)*8;
		//fprintf( stderr,"Using mysize: %llu \n", mysize);

			if (saving_data_flag) {
					gettimeofday (&tnow, NULL);
					//sprintf(filename, "/dev/shm/data/data-%ld.%06ld", tnow.tv_sec,tnow.tv_usec);        
					if (parse_flag){
						sprintf(filename, "data/data-%ld.%06ld.ttp", tnow.tv_sec,tnow.tv_usec);        
					}
					else
					{
						sprintf(filename, "data/data-%ld.%06ld.ttr", tnow.tv_sec,tnow.tv_usec);        
					}
					fprintf(stderr,"Filename: %s\n",filename);          
					fptr = fopen(filename,"ab+");
				}
            streamer_start_xfer();


		
				struct timeval timeForTimeoutStart;
				struct timeval timeForTimeoutNow;
				unsigned int timeDeltaForTimeout;
		
			
				gettimeofday (&timeForTimeoutStart, NULL);
				gettimeofday (&timeForTimeoutNow, NULL);
				do
				{
					timeDeltaForTimeout = ( (timeForTimeoutNow.tv_sec - timeForTimeoutStart.tv_sec) * 1000 + 
											(timeForTimeoutNow.tv_usec - timeForTimeoutStart.tv_usec) / 1000);
					gettimeofday (&timeForTimeoutNow, NULL);
					//fprintf( stderr,"time: %d \n", timeDeltaForTimeout);		
				}while (timeDeltaForTimeout<mytimeout);
			
			
            streamer_stop_xfer();
			fprintf(stderr,"Wait for thread stopping...\n");
			while(app_running==true)
			{
			}
			fprintf(stderr,"\n");
			streamer_update_results();
			
			
			if (fptr!=NULL) {
				 fprintf(stderr,"File closed\n");
				 fclose(fptr);	
			 }
						
         
            
						
            fprintf(stderr,"Filename: %s\n", filename);

			exit(0);


		
		return 0;

	}		
		
    fprintf(stderr,"Press 0 to STOP\n Press 1 to START,\n 'p' to toggle the parseUSBpacket, \n 's' to stream to stdout, 'k' to save packet to /dev/shm/data-*, 'q' to quit\n");
            
            if (saving_data_flag){
				fprintf(stderr,"Saving data ON\n");          
			} 
			else
			{
				fprintf(stderr,"Saving data OFF\n");           			
			}
			
            if (streamOut_flag){
				fprintf(stderr,"Stream to stdout ON\n");          
			} 
			else
			{
				fprintf(stderr,"Stream to stdout OFF\n");           			
			}
            
            
            if (parse_flag){
				fprintf(stderr,"Parser on-fly ON\n");          
			} 
			else
			{
				fprintf(stderr,"Parser on-fly OFF\n");           			
			}            
            
            
    for (int i = 0; ; i++) {
        char c = 0;
        ssize_t ttt;
        ttt=read (0, &c, 1);
		
		if(c!=0) fprintf(stderr,"\n");
        
        switch (c) {
        case '1':
			if (saving_data_flag) {
					gettimeofday (&tnow, NULL);
					//sprintf(filename, "/dev/shm/data/data-%ld.%06ld", tnow.tv_sec,tnow.tv_usec);        
					if (parse_flag){
						sprintf(filename, "data/data-%ld.%06ld.ttp", tnow.tv_sec,tnow.tv_usec);        
					}
					else
					{
						sprintf(filename, "data/data-%ld.%06ld.ttr", tnow.tv_sec,tnow.tv_usec);        
					}
					fprintf(stderr,"Filename: %s\n",filename);          
					fptr = fopen(filename,"ab+");
				}
            streamer_start_xfer();
            break;

        case '0':
            streamer_stop_xfer();
            break;
 
        case 'k':		
            saving_data_flag=!saving_data_flag;
            if (saving_data_flag){
				fprintf(stderr,"Saving data ON\n");          
			} 
			else
			{
				fprintf(stderr,"Saving data OFF\n");           			
			}
            break;
            
        case 's':
            streamOut_flag=!streamOut_flag;            
            if (streamOut_flag){
				fprintf(stderr,"Stream to stdout ON\n");          
			} 
			else
			{
				fprintf(stderr,"Stream to stdout OFF\n");           			
			}
            break;
            
        case 'p':
            parse_flag=!parse_flag;                    
            if (parse_flag){
				fprintf(stderr,"Parser on-fly ON\n");          
			} 
			else
			{
				fprintf(stderr,"Parser on-fly OFF\n");           			
			}                     
            break;
        
        case 'v':
			if (verbose_flag==1){
				verbose_flag=0;
			}
			else
			{
				verbose_flag=1;
			}
            
            if (verbose_flag==1){
			
				fprintf(stderr,"Verbose on-fly ON\n");          
			} 
			else
			{
				fprintf(stderr,"Verbose on-fly OFF\n");           			
			}                     
            break;            
                                        
        case 'q':
            streamer_stop_xfer();
			fprintf(stderr,"Wait for thread stopping...\n");
			while(app_running==true)
			{
			}
			fprintf(stderr,"\n");
			streamer_update_results();
			//fprintf(stderr, "Received data: %f MB\n", (double) successUSB_count / 1024.0 / 1024.0 );
			
			
			if (fptr!=NULL) {
				 fprintf(stderr,"File closed\n");
				 fclose(fptr);	
			 }
						
            fprintf(stderr,"Filename: %s\n", filename);

            exit(0);
        }
    }

    return 0; 
}
/*[]*/

