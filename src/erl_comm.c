#include <ei.h>

typedef unsigned char byte;

int read_exact(byte *buf, int len) {
  int i, got=0;

  do {
    if ((i = read(0, buf+got, len-got)) <= 0)
      return(i);
    got += i;
  } while (got<len);

  return(len);
}

int write_exact(char *buf, int len) {
  int i, wrote = 0;

  do {
    if ((i = write(1, buf+wrote, len-wrote)) <= 0)
      return (i);
    wrote += i;
  } while (wrote<len);

  return (len);
}

int read_cmd(byte *buf){
  int len;

  if (read_exact(buf, 2) != 2)
    return(-1);
  len = (buf[0] << 8) | buf[1];
  return read_exact(buf, len);
}

int write_cmd(char *buf, int len) {
  char li;

  li = (len >> 8) & 0xff;
  write_exact(&li, 1);

  li = len & 0xff;
  write_exact(&li, 1);

  return write_exact(buf, len);
}

void write_success(int pin, int sensor, float humidity, float temperature) {
  ei_x_buff response;
  ei_x_new(&response);
  ei_x_encode_version(&response);

  ei_x_encode_tuple_header(&response, 5);

  ei_x_encode_atom(&response, "ok");
  ei_x_encode_long(&response, pin);
  ei_x_encode_long(&response, sensor);
  ei_x_encode_double(&response, humidity);
  ei_x_encode_double(&response, temperature);

  write_cmd(response.buff, response.index);

  ei_x_free(&response);
}

void write_error(int result) {
  ei_x_buff response;
  ei_x_new(&response);
  ei_x_encode_version(&response);

  ei_x_encode_tuple_header(&response, 2);
  ei_x_encode_atom(&response, "error");
  ei_x_encode_long(&response, result);

  write_cmd(response.buff, response.index);
  ei_x_free(&response);
}
