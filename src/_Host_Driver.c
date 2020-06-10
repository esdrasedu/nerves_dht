#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include "erl_comm.c"
#include "erl_interface.h"
#include "ei.h"

typedef unsigned char byte;

int main(int argc, char *argv[]) {

  if (argc != 3) {
    fprintf(stderr, "Usage: %s [GPIO_Pin] [DHT] \n", argv[0]);
    exit(EXIT_FAILURE);
  }

  int pin = atoi(argv[1]);
  int sensor = atoi(argv[2]);

  for(;;){
    sleep(3);

    if (1){

      float humidity = (float)rand()/(float)(RAND_MAX/50);
      float temperature = (float)rand()/(float)(RAND_MAX/30);

      write_success(pin, sensor, humidity, temperature);

    } else {

      write_error(-1);
    }

  }

}
