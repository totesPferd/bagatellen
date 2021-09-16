#ifndef GRPLOT_LEGEND_H
#define GRPLOT_LEGEND_H

#include "inscription.h"

typedef enum {
      grplot_legend_ok = 0 } grplot_legend_status_t;

typedef struct {
   grplot_inscription_positional_inscription_t positionalInscription;
   DATA32 color; } grplot_legend_item_t;

typedef struct {
   unsigned nrItem;
   Imlib_Font font;
   int height, width;
   grplot_legend_item_t *pBuf; } grplot_legend_t;

grplot_legend_status_t
grplot_legend_init(
      grplot_legend_t *
   ,  Imlib_Font
   ,  unsigned );

grplot_legend_status_t
grplot_legend_inscription_init(
      grplot_legend_t *
   ,  const char *
   ,  DATA32
   ,  unsigned );

grplot_legend_status_t
grplot_legend_get_color(
      const grplot_legend_t *
   ,  DATA32 **
   ,  unsigned );

grplot_legend_status_t
grplot_legend_get_positional_inscription(
      const grplot_legend_t *
   ,  grplot_inscription_positional_inscription_t **
   ,  unsigned );

grplot_legend_status_t
grplot_legend_prepare(
      grplot_legend_t * );

grplot_legend_status_t
grplot_legend_draw_LB_horizontal(
      const grplot_legend_t *
   ,  int
   ,  int );

void
grplot_legend_destroy(
      grplot_legend_t *);

#endif
