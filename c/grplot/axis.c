#include <assert.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>

#include "axis.h"

static const unsigned nrCharDoubleString =  13;

int
grplot_axis_get_double(grplot_axis_t *pAxis, double *pResult, grplot_axis_val_t val) {
   assert(pAxis);

   int retval =  0;

   double diffRange, diffVal;

   switch (pAxis->scaleType) {
      case grplot_axis_linear: {
         assert((pAxis->max).numeric >= val.numeric);
         assert((pAxis->min).numeric <= val.numeric);
         assert((pAxis->max).numeric > (pAxis->min).numeric);

         diffRange =  (pAxis->max).numeric - (pAxis->min).numeric;
         diffVal =  val.numeric - (pAxis -> min).numeric;
      }
      break;

      case grplot_axis_logarithm: {
         assert((pAxis->max).numeric >= val.numeric);
         assert((pAxis->min).numeric <= val.numeric);
         assert((pAxis->max).numeric > (pAxis->min).numeric);
         assert((pAxis->max).numeric > 0);
         assert((pAxis->min).numeric > 0);
         assert(val.numeric > 0);

         double max =  log10((pAxis->max).numeric);
         double min =  log10((pAxis->min).numeric);
         double realVal =  log10(val.numeric);

         diffRange =  max - min;
         diffVal = realVal - min;
      }
      break;

      case grplot_axis_time: {
         diffRange =  difftime((pAxis->max).time, (pAxis->min).time);
         diffVal = difftime(val.time, (pAxis->min).time);

      }
      break;

      default: {
         retval =  1;
      }
   }
   if (!retval) {
      assert(diffRange > 0.0);
      assert(diffVal <= diffRange);

      *pResult =  diffVal / diffRange;

      if (pAxis->axisType == grplot_axis_y_axis) {
        *pResult =  1.0 - *pResult;
      }
   }

   return retval;
}

int
grplot_axis_get_string(grplot_axis_t *pAxis, char **ppResult, grplot_axis_val_t val) {
   assert(pAxis);

   int retval =  0;

   switch(pAxis->scaleType) {
      case grplot_axis_linear:
      case grplot_axis_logarithm: {
         *ppResult =  (char *) malloc(sizeof(char) * nrCharDoubleString);
         snprintf(*ppResult, nrCharDoubleString - 1, "%.5G", val.numeric);
         *ppResult[nrCharDoubleString - 1] =  '\0';
      }
      break;

      case grplot_axis_time: {
         *ppResult =  ctime(&(val.time));
      }
      break;

      default: {
         retval =  1;
      }
   }

   return retval;
}

int
grplot_axis_step_init(grplot_axis_t *pAxis, grplot_axis_step_t *pStep) {
   assert(pAxis);
   assert(pStep);

   int retval =  0;

   switch(pAxis->scaleType) {
      case grplot_axis_linear: {
         (*pStep).linear.exponent =  0;
         (*pStep).linear.mantissa =  grplot_axis_linear_step_one;
      }
      break;

      case grplot_axis_logarithm: {
         (*pStep).logarithm.base =  0;
         (*pStep).logarithm.mantissa =  grplot_axis_logarithm_step_zero;
      }
      break;

      case grplot_axis_time: {
         (*pStep).time =  grplot_axis_time_step_sec;
      }
      break;

      default: {
         retval =  1;
      }
   }
      
   return retval;
}

int
grplot_axis_step_next(grplot_axis_t *pAxis, grplot_axis_step_t *pStep) {
   assert(pAxis);
   assert(pStep);

   int retval =  0;

   switch(pAxis->scaleType) {
      case grplot_axis_linear: {
         switch ((*pStep).linear.mantissa) {
            case (grplot_axis_linear_step_one): {
               (*pStep).linear.mantissa =  grplot_axis_linear_step_two;
            }
            break;

            case (grplot_axis_linear_step_two): {
               (*pStep).linear.mantissa =  grplot_axis_linear_step_five;
            }
            break;

            case (grplot_axis_linear_step_five): {
               (*pStep).linear.exponent++;
               (*pStep).linear.mantissa =  grplot_axis_linear_step_one;
            }
            break;

            default: {
               retval =  1;
            }
         }
      }
      break;

      case grplot_axis_logarithm: {
         switch ((*pStep).logarithm.mantissa) {
            case (grplot_axis_logarithm_step_zero): {
               (*pStep).logarithm.mantissa =  grplot_axis_logarithm_step_twelve;
            }
            break;

            case (grplot_axis_logarithm_step_twelve): {
               (*pStep).logarithm.mantissa =  grplot_axis_logarithm_step_six;
            }
            break;

            case (grplot_axis_logarithm_step_six): {
               (*pStep).logarithm.base++;
               (*pStep).logarithm.mantissa =  grplot_axis_logarithm_step_zero;
            }
            break;

            default: {
               retval =  1;
            }
         }
      }
      break;

      case grplot_axis_time: {
         switch ((*pStep).time) {
            case (grplot_axis_time_step_sec): {
               (*pStep).time =  grplot_axis_time_step_min;
            }
            break;

            case (grplot_axis_time_step_min): {
               (*pStep).time =  grplot_axis_time_step_hour;
            }
            break;

            case (grplot_axis_time_step_hour): {
               (*pStep).time =  grplot_axis_time_step_day;
            }
            break;

            case (grplot_axis_time_step_day): {
               (*pStep).time =  grplot_axis_time_step_month;
            }
            break;

            case (grplot_axis_time_step_month): {
               (*pStep).time =  grplot_axis_time_step_year;
            }
            break;

            case (grplot_axis_time_step_year): {
               retval =  2;
            }
            break;

            default: {
               retval =  1;
            }
         }
      }
      break;

      default: {
         retval =  1;
      }
   }
      
   return retval;
}
