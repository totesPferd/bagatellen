#define _XOPEN_SOURCE
#include <assert.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#include "input.h"


static int
getVal(
      grplot_axis_val_t *
   ,  const grplot_axis_t *
   ,  const char *
   ,  char **
   ,  unsigned
   ,  unsigned );

void
grplot_input_interpret_line(
      grplot_matrix_t *pMatrix
   ,  grplot_input_line_buf_t *pLineBuf ) {
   assert(pMatrix);
   assert(pLineBuf);

   char *sptr =  pLineBuf->buf;
   char *tptr =  pLineBuf->buf;

   int errorMode =  0;
   int isTooFewRecords =  0;
   unsigned nrXAxis, nrYAxis;

   errno =  0;
   {
      nrXAxis =  strtol(sptr, &tptr, 10);

      if (errno) {
         fprintf(stderr, "#%7ld (record #1): %s\n", pLineBuf->nr, strerror(errno));
         errorMode =  1;
      }

      if (!errorMode) {
         if (nrXAxis > pMatrix->nrX) {
            fprintf(stderr, "#%7ld (record #1): larger than max # x axis defined to %d. \n", pLineBuf->nr, nrXAxis, pMatrix->nrX);
            errorMode =  1;
         }
      }

      sptr =  tptr;
   }
   if (!sptr) {
      isTooFewRecords =  1;
   }
   if (!isTooFewRecords) {
      nrYAxis =  strtol(sptr, &tptr, 10);

      if (errno) {
         fprintf(stderr, "#%7ld (record #2): %s\n", pLineBuf->nr, strerror(errno));
         errorMode =  1;
      }

      if (!errorMode) {
         if (nrYAxis > pMatrix->nrY) {
            fprintf(stderr, "#%7ld (record #2): larger than max # y axis defined to %d. \n", pLineBuf->nr, nrYAxis, pMatrix->nrY);
            errorMode =  1;
         }
      }

      sptr =  tptr;
   }
   if (!sptr) {
      isTooFewRecords =  1;
   }
   if (isTooFewRecords) {
      errorMode =  1;
   }
   {
      grplot_diagram_t *pDiagram;

      if (!errorMode) {
         grplot_matrix_diagram_status_t statusCode =  grplot_matrix_get_diagram(
               pMatrix
            ,  &pDiagram
            ,  nrXAxis
            ,  nrYAxis );
         if (statusCode != grplot_matrix_diagram_ok) {
            fprintf(stderr, "#%7ld: diagram base invalid.\n", pLineBuf->nr);
            errorMode =  1;
         }
      }

      unsigned nrD;
      grplot_axis_val_t valX, valY;
      double weight, radius;

      if (!isTooFewRecords) {
         nrD =  strtol(sptr, &tptr, 10);
   
         if (errno) {
            fprintf(stderr, "#%7ld (record #3): %s\n", pLineBuf->nr, strerror(errno));
            errorMode =  1;
         }
   
         if (!errorMode) {
            if (nrD > (pDiagram->inputBufMgmt).nrInpBufs) {
               fprintf(stderr, "#%7ld (record #3): larger than max # diagrams defined to %d. \n", pLineBuf->nr, nrXAxis, (pDiagram->inputBufMgmt).nrInpBufs);
               errorMode =  1;
            }
         }
   
         sptr =  tptr;
      }
      if (!sptr) {
         isTooFewRecords =  1;
      }
      if (!isTooFewRecords) {
         errorMode =  getVal(
               &valX
            ,  &(pDiagram->pXAxis->axisSpec)
            ,  sptr
            ,  &tptr
            ,  pLineBuf->nr
            ,  4 );
      }
      if (!sptr) {
         isTooFewRecords =  1;
      }
      if (!isTooFewRecords) {
         errorMode =  getVal(
               &valY
            ,  &(pDiagram->pYAxis->axisSpec)
            ,  sptr
            ,  &tptr
            ,  pLineBuf->nr
            ,  5 );
      }
      if (!sptr) {
         isTooFewRecords =  1;
      }
      if (!isTooFewRecords) {
         weight =  strtod(sptr, &tptr);
   
         if (errno) {
            fprintf(stderr, "#%7ld (record #6): %s\n", pLineBuf->nr, strerror(errno));
            errorMode =  1;
         }
   
         sptr =  tptr;
      }
      if (!sptr) {
         isTooFewRecords =  1;
      }
      if (!isTooFewRecords) {
         radius =  strtod(sptr, &tptr);
   
         if (errno) {
            fprintf(stderr, "#%7ld (record #7): %s\n", pLineBuf->nr, strerror(errno));
            errorMode =  1;
         }
      }
      if (isTooFewRecords) {
         fprintf(stderr, "#%7ld: too few records\n", pLineBuf->nr);
      } else if (!errorMode) {
         grplot_diagram_plot_point(
               pDiagram
            ,  valX
            ,  valY
            ,  weight
            ,  nrD
            ,  radius );
      }
   }
}

void
grplot_input_interpret(
      grplot_matrix_t *pMatrix ) {
   assert(pMatrix);

   grplot_input_line_buf_t lineBuf;
   lineBuf.nr =  0;

   int isEOF =  0;
   while (!isEOF) {
      for (int i =  0; i < GRPLOT_INPUT_BUF_SIZE; i++) {
         int ic =  getchar();
         if (ic == EOF) {
            lineBuf.buf[i] =  '\0';
            isEOF =  1;
            break;
         } else {
            char c =  (char) ic;
            if (c == '\n') {
               lineBuf.buf[i] =  '\0';
               break;
            } else {
               lineBuf.buf[i] =  c;
            }
         }
      }
      lineBuf.nr++;
      grplot_input_interpret_line(
            pMatrix
         ,  &lineBuf );
   }

}

static int
getVal(
      grplot_axis_val_t *pVal
   ,  const grplot_axis_t *pAxis
   ,  const char *sptr
   ,  char **pTptr
   ,  unsigned nr
   ,  unsigned rec ) {
   assert(pAxis);
   assert(pVal);
   assert(sptr);
   assert(pTptr);

   int retval =  0;

   switch (pAxis->scaleType) {

      case (grplot_axis_linear):
      case (grplot_axis_logarithm): {
         pVal->numeric =  strtol(sptr, pTptr, 10);
   
         if (errno) {
            fprintf(stderr, "#%7ld (record #%d): %s\n", nr, rec, strerror(errno));
            retval =  1;
         }
      }
      break;

      case (grplot_axis_time): {
         struct tm time;
         *pTptr =  strptime(sptr, "%Y-%m-%dT%H:%M:%S", &time);
         if (*pTptr) {
            pVal->time =  mktime(&time);
         } else {
            fprintf(stderr, "#%7ld (record #%d): time does not suit spec %%Y-%%m-%%dT%%H:%%M:%%S\n", nr, rec);
            retval =  1;
         }
      }
      break;

      default: {
         assert(0);
      }

   }

   return retval;

}
