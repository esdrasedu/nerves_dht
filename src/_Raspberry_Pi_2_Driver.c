#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include "erl_comm.c"

#include "Raspberry_Pi_2/pi_2_dht_read.h"

typedef unsigned char byte;

int main(int argc, char *argv[]) {

  if (argc != 3) {
    fprintf(stderr, "Usage: %s [GPIO_Pin] [DHT] \n", argv[0]);
    exit(EXIT_FAILURE);
  }

  int pin = atoi(argv[1]);
  int sensor = atoi(argv[2]);

  for(;;){

    float humidity = 0, temperature = 0;
    int result = pi_2_dht_read(sensor, pin, &humidity, &temperature);

    if(result == DHT_SUCCESS){
      write_success(pin, sensor, humidity, temperature);
    } else {
      write_error(result);
    }

  }

  return 1;
}
