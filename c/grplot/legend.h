#ifndef GRPLOT_LEGEND_H
#define GRPLOT_LEGEND_H

#include "inscription.h"

typedef struct {
   grplot_inscription_positional_inscription_t positionalInscription;
   DATA32 color; } grplot_legend_item_t;

typedef struct {
   unsigned nrItem;
   grplot_legend_item_t *pBuf; } grplot_legend_t;

int
grplot_legend_init(
      grplot_legend_t *
   ,  unsigned );

int
grplot_legend_get_color(
      const grplot_legend_t *
   ,  DATA32 **
   ,  unsigned );

int
grplot_legend_get_positional_inscription(
      const grplot_legend_t *
   ,  grplot_inscription_positional_inscription_t **
   ,  unsigned );

void
grplot_legend_destroy(
      grplot_legend_t *);

#endif
