#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <err.h>

#include "Raspberry_Pi_2/pi_2_dht_read.h"

int main(int argc, char *argv[]) {
  if (argc != 2) {
    fprintf(stderr, "Usage: %s <DHT GPIO Pin> \n", argv[0]);
    exit(EXIT_FAILURE);
  }

  float humidity = 0, temperature = 0;

  int pin = atoi(argv[1]);

  int result = pi_2_dht_read(22, pin, &humidity, &temperature);

  fprintf(stdout, "result: %d\ntemperature: %f\nhumidity: %f", result, temperature, humidity);
}
