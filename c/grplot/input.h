#ifndef GRPLOT_INPUT_H
#define GRPLOT_INPUT_H

#include "matrix.h"

#define GRPLOT_INPUT_BUF_SIZE 1024


typedef struct {
   unsigned long nr;
   char buf[GRPLOT_INPUT_BUF_SIZE]; } grplot_input_line_buf_t;

void
grplot_input_interpret_line(
      grplot_matrix_t *
   ,  grplot_input_line_buf_t * );

void
grplot_input_interpret(
      grplot_matrix_t * );

#endif
