#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include "erl_comm.c"
#include "erl_interface.h"
#include "ei.h"

#include "Raspberry_Pi_2/pi_2_dht_read.h"

typedef unsigned char byte;

int main(int argc, char *argv[]) {

  if (argc != 3) {
    fprintf(stderr, "Usage: %s [DHT] [GPIO_Pin] \n", argv[0]);
    exit(EXIT_FAILURE);
  }

  int sensor = atoi(argv[1]);
  int pin = atoi(argv[2]);

  ETERM * arr[5], *tuple;
  unsigned char buf[BUFSIZ];

  erl_init(NULL, 0);

  for(;;){

    float humidity = 0, temperature = 0;
    int result = pi_2_dht_read(22, pin, &humidity, &temperature);

    if(result == DHT_SUCCESS){

      arr[0] = erl_mk_atom("ok");
      arr[1] = erl_mk_int(sensor);
      arr[2] = erl_mk_int(pin);
      arr[3] = erl_mk_float(humidity);
      arr[4] = erl_mk_float(temperature);

      tuple  = erl_mk_tuple(arr, 5);

      erl_encode(tuple, buf);

      write_cmd(buf, erl_term_len(tuple));

      erl_free_term(tuple);
    }
  }

  return 1;
}
