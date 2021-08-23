#include <assert.h>
#include <stdlib.h>

#include "legend.h"

int
grplot_legend_init(
      grplot_legend_t *pLegend
   ,  unsigned nrItem ) {
   assert(pLegend);

   int retval =  0;

   pLegend->nrItem =  nrItem;
   pLegend->pBuf =  (grplot_legend_item_t *) malloc(sizeof(grplot_legend_item_t) * nrItem);

   return retval;
}

int
grplot_legend_get_color(
      const grplot_legend_t *pLegend
   ,  DATA32 **ppColor
   ,  unsigned index ) {
   assert(pLegend);
   assert(index < pLegend->nrItem);

   int retval =  0;

   *ppColor =  &((pLegend->pBuf)[index].color);

   return retval;
}

int
grplot_legend_get_positional_inscription(
      const grplot_legend_t *pLegend
   ,  grplot_inscription_positional_inscription_t **ppPositionalInscription
   ,  unsigned index ) {
   assert(pLegend);
   assert(index < pLegend->nrItem);

   int retval =  0;

   *ppPositionalInscription =  &((pLegend->pBuf)[index].positionalInscription);

   return retval;
}

void
grplot_legend_destroy(
      grplot_legend_t *pLegend ) {
   assert(pLegend);

   free(pLegend->pBuf);
}


