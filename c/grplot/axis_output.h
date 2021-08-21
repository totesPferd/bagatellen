#ifndef GRPLOT_AXIS_OUTPUT_H
#define GRPLOT_AXIS_OUTPUT_H

#include <Imlib2.h>

#include "axis.h"

#define MAX_NR_INSCRIPTIONS 64

typedef struct {
   char *text;
   int width, heigth; } grplot_axis_output_inscription_t;

typedef struct {
   grplot_axis_t axisSpec;
   Imlib_Font inscriptionFont;
   Imlib_Font labelFont;
   unsigned nrInscriptions; 
   grplot_axis_output_inscription_t label;
   grplot_axis_output_inscription_t upperInscription;
   grplot_axis_output_inscription_t inscriptions[MAX_NR_INSCRIPTIONS]; } grplot_axis_output_t;

#endif
