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

  ETERM * arr[5], *tuple;
  unsigned char buf[BUFSIZ];

  for(;;){

    erl_init(NULL, 0);

    sleep(3);

    if (0){

      float humidity = (float)rand()/(float)(RAND_MAX/50);
      float temperature = (float)rand()/(float)(RAND_MAX/30);

      arr[0] = erl_mk_atom("ok");
      arr[1] = erl_mk_int(pin);
      arr[2] = erl_mk_int(sensor);
      arr[3] = erl_mk_float(humidity);
      arr[4] = erl_mk_float(temperature);

      tuple  = erl_mk_tuple(arr, 5);

      erl_encode(tuple, buf);

      write_cmd(buf, erl_term_len(tuple));

      erl_free_term(tuple);

    } else {

      arr[0] = erl_mk_atom("error");
      arr[1] = erl_mk_int(-1);

      tuple  = erl_mk_tuple(arr, 2);

      erl_encode(tuple, buf);

      write_cmd(buf, erl_term_len(tuple));

      erl_free_term(tuple);
    }

  }

}
