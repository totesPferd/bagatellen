#ifndef GRPLOT_AXIS_OUTPUT_H
#define GRPLOT_AXIS_OUTPUT_H

#include <Imlib2.h>

#include "axis.h"
#include "inscription.h"

#define MAX_NR_INSCRIPTIONS 64

typedef enum {
      grplot_axis_output_ok =  0
   ,  grplot_axis_output_zero_range
   ,  grplot_axis_output_time_overflow
   ,  grplot_axis_output_inscription_buf_exceeded } grplot_axis_output_status_t;

typedef struct {
   grplot_axis_t axisSpec;
   Imlib_Font inscriptionFont;
   DATA32 inscriptionColor;
   Imlib_Font labelFont;
   DATA32 labelColor;
   unsigned nrInscriptions; 
   DATA32 lineColor;
   unsigned length, width;
   grplot_inscription_t label;
   grplot_inscription_t upperInscription;
   grplot_inscription_positional_inscription_t inscriptions[MAX_NR_INSCRIPTIONS]; } grplot_axis_output_t;

grplot_axis_output_status_t
grplot_axis_output_inscription_init(grplot_inscription_t *, Imlib_Font, char *);

grplot_axis_output_status_t
grplot_axis_output_positional_inscription_init(
      const grplot_axis_t *
   ,  grplot_inscription_positional_inscription_t *
   ,  Imlib_Font
   ,  grplot_axis_val_t );

grplot_axis_output_status_t
grplot_axis_output_init(
      grplot_axis_output_t *
   ,  grplot_axis_type_t
   ,  grplot_axis_scale_type_t
   ,  Imlib_Font
   ,  DATA32
   ,  Imlib_Font
   ,  DATA32
   ,  unsigned
   ,  DATA32
   ,  grplot_axis_val_t
   ,  grplot_axis_val_t
   ,  char * );

void
grplot_axis_output_destroy(grplot_axis_output_t *);

grplot_axis_output_status_t
grplot_axis_output_draw(
      grplot_axis_output_t *
   ,  unsigned
   ,  unsigned
   ,  int
   ,  int );

#endif
