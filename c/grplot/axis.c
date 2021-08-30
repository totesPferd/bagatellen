#include <assert.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "axis.h"

static const unsigned nrCharDoubleString =  13;

static grplot_axis_status_t
getStepWidth_linear(const grplot_axis_linear_step_t *, double *);

static grplot_axis_status_t
getStepWidth_logarithm(const grplot_axis_logarithm_step_t *, double *);

static grplot_axis_status_t
diffRange_init(grplot_axis_t *);

grplot_axis_status_t
grplot_axis_init(
      grplot_axis_t *pAxis
   ,  grplot_axis_type_t axisType
   ,  grplot_axis_scale_type_t scaleType
   ,  unsigned nrPixels
   ,  grplot_axis_val_t min
   ,  grplot_axis_val_t max ) {
   assert(pAxis);
   assert(nrPixels > 0);
   assert(
         (
               scaleType != grplot_axis_linear
            && scaleType != grplot_axis_logarithm )
      || min.numeric < max.numeric );
   assert(
         scaleType != grplot_axis_logarithm
      || min.numeric > 0.0 );

   pAxis->axisType =  axisType;
   pAxis->scaleType =  scaleType;
   pAxis->nrPixels =  nrPixels;
   pAxis->min =  min;
   pAxis->max =  max;

   return diffRange_init(pAxis);
}

grplot_axis_status_t
grplot_axis_is_inRange(const grplot_axis_t *pAxis, int *pStatus, grplot_axis_val_t val) {
   assert(pAxis);
   assert(pStatus);

   grplot_axis_status_t retval =  grplot_axis_ok;

   switch (pAxis->scaleType) {

      case grplot_axis_linear:
      case grplot_axis_logarithm: {
         *pStatus =  (pAxis->min).numeric <= val.numeric && val.numeric <= (pAxis->max).numeric;
      }
      break;

      case grplot_axis_time: {
         *pStatus =  (pAxis->min).time <= val.time && val.time <= (pAxis->max).time;
      }
      break;

      default: {
         assert(0);
      }
   }

   return retval;
}

grplot_axis_status_t
grplot_axis_get_double(const grplot_axis_t *pAxis, double *pResult, grplot_axis_val_t val) {
   assert(pAxis);

   grplot_axis_status_t retval =  grplot_axis_ok;

   double diffVal;

   switch (pAxis->scaleType) {
      case grplot_axis_linear: {
         assert((pAxis->min).numeric <= val.numeric);

         diffVal =  val.numeric - (pAxis -> min).numeric;
      }
      break;

      case grplot_axis_logarithm: {
         assert((pAxis->max).numeric >= val.numeric);
         assert((pAxis->min).numeric <= val.numeric);
         assert((pAxis->min).numeric > 0);
         assert(val.numeric > 0);

         double min =  log10((pAxis->min).numeric);
         double realVal =  log10(val.numeric);

         diffVal = realVal - min;
      }
      break;

      case grplot_axis_time: {
         diffVal = difftime(val.time, (pAxis->min).time);

      }
      break;

      default: {
         assert(0);
      }
   }
   *pResult =  diffVal / pAxis->diffRange;

   return retval;
}

grplot_axis_status_t
grplot_axis_get_string(const grplot_axis_t *pAxis, char **ppResult, grplot_axis_val_t val) {
   assert(pAxis);

   grplot_axis_status_t retval =  grplot_axis_ok;

   switch(pAxis->scaleType) {
      case grplot_axis_linear:
      case grplot_axis_logarithm: {
         *ppResult =  (char *) malloc(sizeof(char) * nrCharDoubleString);
         snprintf(*ppResult, nrCharDoubleString - 1, "%.5G", val.numeric);
         (*ppResult)[nrCharDoubleString - 1] =  '\0';
      }
      break;

      case grplot_axis_time: {
         char *ctimeStr =  ctime(&(val.time));
         *ppResult =  (char *) malloc(sizeof(char) * strlen(ctimeStr) + 1);
         strcpy(*ppResult, ctimeStr);
      }
      break;

      default: {
         assert(0);
      }
   }

   return retval;
}

grplot_axis_status_t
grplot_axis_step_init(const grplot_axis_t *pAxis, grplot_axis_step_t *pStep) {
   assert(pAxis);
   assert(pStep);

   grplot_axis_status_t retval =  grplot_axis_ok;

   switch(pAxis->scaleType) {
      case grplot_axis_linear: {
         pStep->linear.exponent =
            (int) floor(log10(((pAxis->max).numeric - (pAxis->min).numeric) / (double) (pAxis->nrPixels)));
         pStep->linear.mantissa =  grplot_axis_linear_step_one;
      }
      break;

      case grplot_axis_logarithm: {
         pStep->logarithm.base =
            (int) floor(log10((pAxis->max).numeric / (pAxis->min).numeric) / (double) (pAxis->nrPixels));
         pStep->logarithm.mantissa =  grplot_axis_logarithm_step_sixty;
      }
      break;

      case grplot_axis_time: {
         pStep->time =  grplot_axis_time_step_sec;
      }
      break;

      default: {
         assert(0);
      }
   }
      
   return retval;
}

grplot_axis_status_t
grplot_axis_step_next(const grplot_axis_t *pAxis, grplot_axis_step_t *pStep) {
   assert(pAxis);
   assert(pStep);

   grplot_axis_status_t retval =  grplot_axis_ok;

   switch(pAxis->scaleType) {
      case grplot_axis_linear: {
         switch (pStep->linear.mantissa) {
            case (grplot_axis_linear_step_one): {
               pStep->linear.mantissa =  grplot_axis_linear_step_two;
            }
            break;

            case (grplot_axis_linear_step_two): {
               pStep->linear.mantissa =  grplot_axis_linear_step_five;
            }
            break;

            case (grplot_axis_linear_step_five): {
               pStep->linear.exponent++;
               pStep->linear.mantissa =  grplot_axis_linear_step_one;
            }
            break;

            default: {
               assert(0);
            }
         }
      }
      break;

      case grplot_axis_logarithm: {
         switch (pStep->logarithm.mantissa) {
            case (grplot_axis_logarithm_step_zero): {
               pStep->logarithm.mantissa =  grplot_axis_logarithm_step_sixty;
            }
            break;

            case (grplot_axis_logarithm_step_sixty): {
               pStep->logarithm.mantissa =  grplot_axis_logarithm_step_twelve;
            }
            break;

            case (grplot_axis_logarithm_step_twelve): {
               pStep->logarithm.mantissa =  grplot_axis_logarithm_step_six;
            }
            break;

            case (grplot_axis_logarithm_step_six): {
               pStep->logarithm.base++;
               pStep->logarithm.mantissa =  grplot_axis_logarithm_step_zero;
            }
            break;

            default: {
               assert(0);
            }
         }
      }
      break;

      case grplot_axis_time: {
         switch (pStep->time) {
            case (grplot_axis_time_step_sec): {
               pStep->time =  grplot_axis_time_step_min;
            }
            break;

            case (grplot_axis_time_step_min): {
               pStep->time =  grplot_axis_time_step_hour;
            }
            break;

            case (grplot_axis_time_step_hour): {
               pStep->time =  grplot_axis_time_step_day;
            }
            break;

            case (grplot_axis_time_step_day): {
               pStep->time =  grplot_axis_time_step_month;
            }
            break;

            case (grplot_axis_time_step_month): {
               pStep->time =  grplot_axis_time_step_year;
            }
            break;

            case (grplot_axis_time_step_year): {
               retval =  grplot_axis_time_overflow;
            }
            break;

            default: {
               assert(0);
            }
         }
      }
      break;

      default: {
         assert(0);
      }
   }
      
   return retval;
}

grplot_axis_status_t
grplot_axis_next_val(const grplot_axis_t *pAxis, const grplot_axis_step_t *pStep, grplot_axis_val_t *pVal) {
   assert(pAxis);
   assert(pStep);
   assert(pVal);

   grplot_axis_status_t retval =  grplot_axis_ok;

   switch(pAxis->scaleType) {

      case grplot_axis_linear: {
         double stepWidth;
         getStepWidth_linear(&(pStep->linear), &stepWidth);
         double rem =  fmod(pVal->numeric, stepWidth);
         pVal->numeric += stepWidth - rem;
      }
      break;

      case grplot_axis_logarithm: {
         double stepWidth;
         getStepWidth_logarithm(&(pStep->logarithm), &stepWidth);
         double realVal =  log10(pVal->numeric);
         double rem =  fmod(realVal, stepWidth);
         double step =  stepWidth - rem;
         if (step < 1.0E-06) {
            step =  stepWidth;
         }
         realVal += step;
         pVal->numeric =  pow(10.0, realVal);
      }
      break;

      case grplot_axis_time: {
         struct tm *lt =  localtime(&(pVal->time));

         switch (pStep->time) {
            case grplot_axis_time_step_year: {
               lt->tm_mon =  0;
            }
            case grplot_axis_time_step_month: {
               lt->tm_mday =  1;
            }
            case grplot_axis_time_step_day: {
               lt->tm_hour =  0;
            }
            case grplot_axis_time_step_hour: {
               lt->tm_min =  0;
            }
            case grplot_axis_time_step_min: {
               lt->tm_sec =  0;
            }
            case grplot_axis_time_step_sec: {
            }

            default: {
               assert(0);
            }
         }
         switch (pStep->time) {
            case grplot_axis_time_step_year: {
               lt->tm_year++;
            }
            break;

            case grplot_axis_time_step_month: {
               lt->tm_mon++;
            }
            break;

            case grplot_axis_time_step_day: {
               lt->tm_mday++;
            }
            break;

            case grplot_axis_time_step_hour: {
               lt->tm_hour++;
            }
            break;

            case grplot_axis_time_step_min: {
               lt->tm_min++;
            }
            break;

            case grplot_axis_time_step_sec: {
               lt->tm_sec++;
            }
            break;

            default: {
               assert(0);
            }
         }

         pVal->time =  mktime(lt);
      }
      break;

      default: {
         assert(0);
      }
   }
      
   return retval;
}

static grplot_axis_status_t
getStepWidth_linear(const grplot_axis_linear_step_t *pStep, double *pResult) {
   assert(pStep);

   grplot_axis_status_t retval =  grplot_axis_ok;

   *pResult =  pow(10.0, (double) pStep->exponent);
   switch (pStep->mantissa) {
      case grplot_axis_linear_step_one:
      break;

      case grplot_axis_linear_step_two: {
         *pResult *= 2.0;
      }
      break;

      case grplot_axis_linear_step_five: {
         *pResult *= 5.0;
      }
      break;

      default: {
         assert(0);
      }
   }

   return retval;
}

static grplot_axis_status_t
getStepWidth_logarithm(const grplot_axis_logarithm_step_t *pStep, double *pResult) {
   assert(pStep);
   grplot_axis_status_t retval =  grplot_axis_ok;

   *pResult =  (double) pStep->base;
   switch (pStep->mantissa) {
      case grplot_axis_logarithm_step_zero:
      break;

      case grplot_axis_logarithm_step_sixty: {
         *pResult += 1.0 / 60.0;
      }
      break;

      case grplot_axis_logarithm_step_twelve: {
         *pResult += 1.0 / 12.0;
      }
      break;

      case grplot_axis_logarithm_step_six: {
         *pResult += 1.0 / 6.0;
      }
      break;

      default: {
         assert(0);
      }
   }

   return retval;
}

static grplot_axis_status_t
diffRange_init(grplot_axis_t *pAxis) {
   assert(pAxis);

   grplot_axis_status_t retval =  grplot_axis_ok;

   switch (pAxis->scaleType) {
      case grplot_axis_linear: {
         assert((pAxis->max).numeric > (pAxis->min).numeric);

         pAxis->diffRange =  (pAxis->max).numeric - (pAxis->min).numeric;
      }
      break;

      case grplot_axis_logarithm: {
         assert((pAxis->max).numeric > (pAxis->min).numeric);
         assert((pAxis->max).numeric > 0);
         assert((pAxis->min).numeric > 0);

         double max =  log10((pAxis->max).numeric);
         double min =  log10((pAxis->min).numeric);

         pAxis->diffRange =  max - min;
      }
      break;

      case grplot_axis_time: {
         pAxis->diffRange =  difftime((pAxis->max).time, (pAxis->min).time);
      }
      break;

      default: {
         assert(0);
      }
   }

   if (pAxis->diffRange <= 0.0) {
      retval =  grplot_axis_zero_range;
   }

   return retval;
}

