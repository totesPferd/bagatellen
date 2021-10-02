#define _XOPEN_SOURCE
#include <assert.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#include "input.h"

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

   {
      nrXAxis =  strtol(sptr, &tptr, 10);

      if (errno) {
         fprintf(stderr, "#%7l (record #1): %s\n", pLineBuf->nr, strerror(errno));
         errorMode =  1;
      }

      if (!errorMode) {
         if (nrXAxis > pMatrix->nrX) {
            fprintf(stderr, "#%7l (record #1): larger than max # x axis defined to %d. \n", pLineBuf->nr, nrXAxis, pMatrix->nrX);
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
         fprintf(stderr, "#%7l (record #2): %s\n", pLineBuf->nr, strerror(errno));
         errorMode =  1;
      }

      if (!errorMode) {
         if (nrYAxis > pMatrix->nrY) {
            fprintf(stderr, "#%7l (record #2): larger than max # y axis defined to %d. \n", pLineBuf->nr, nrYAxis, pMatrix->nrY);
            errorMode =  1;
         }
      }

      sptr =  tptr;
   }
   if (!sptr) {
      isTooFewRecords =  1;
   }
   {
      grplot_matrix_positional_axis_t *pXAxis, *pYAxis;
      grplot_diagram_t *pDiagram;

      int innerErrorMode =  errorMode;

      if (!errorMode) {
         grplot_matrix_diagram_status_t statusCode =  grplot_matrix_get_diagram(
               pMatrix
            ,  &pDiagram
            ,  nrXAxis
            ,  nrYAxis );
         if (statusCode != grplot_matrix_diagram_ok) {
            fprintf(stderr, "#%7l: diagram base invalid.\n", pLineBuf->nr);
            innerErrorMode =  1;
         }
      }

      if (!errorMode) {
         int statusCode =  grplot_matrix_get_positional_axis(
               pMatrix
            ,  grplot_axis_x_axis
            ,  &pXAxis
            ,  nrXAxis );
         if (statusCode) {
            fprintf(stderr, "#%7l: x axis invalid.\n", pLineBuf->nr);
            innerErrorMode =  1;
         }
      }

      if (!errorMode) {
         int statusCode =  grplot_matrix_get_positional_axis(
               pMatrix
            ,  grplot_axis_y_axis
            ,  &pYAxis
            ,  nrYAxis );
         if (statusCode) {
            fprintf(stderr, "#%7l: y axis invalid.\n", pLineBuf->nr);
            innerErrorMode =  1;
         }
      }

      errorMode =  innerErrorMode;

      {
         double radius;

         if (!isTooFewRecords) {
            radius =  strtod(sptr, &tptr);
      
            if (errno) {
               fprintf(stderr, "#%7l (record #3): %s\n", pLineBuf->nr, strerror(errno));
               errorMode =  1;
            }
         }
         if (sptr) {
            fprintf(stderr, "#%7l: too many records\n", pLineBuf->nr);
            errorMode =  1;
         }
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
