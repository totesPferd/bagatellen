#define _XOPEN_SOURCE
#include <assert.h>
#include <stdio.h>
#include <string.h>
#include <time.h>

#include "json.h"

static void
printErrMsgIntro(const grplot_json_schema_location_t *);

static void
printColorErrMsgIntro(const grplot_json_schema_location_t *, const char *);

static void
printFontErrMsgIntro(const grplot_json_schema_location_t *, const char *);

static void
printInscriptionStyleErrMsgIntro(const grplot_json_schema_location_t *, const char *);

void
grplot_json_printErrMsg(
      const grplot_json_schema_location_t *pLocation
   ,  const char *text ) {
   assert(pLocation);
   assert(text);

   printErrMsgIntro(pLocation);
   fprintf(stderr, ": %s\n", text);
}

void
grplot_json_printColorErrMsg(
      const grplot_json_schema_location_t *pLocation
   ,  const char *colorDest
   ,  int errCode ) {
   assert(pLocation);
   assert(colorDest);

   if (errCode & grplot_json_error_red_integer) {
      printColorErrMsgIntro(pLocation, colorDest);
      fprintf(stderr, "red component must be integer\n");
   }

   if (errCode & grplot_json_error_green_integer) {
      printColorErrMsgIntro(pLocation, colorDest);
      fprintf(stderr, "green component must be integer\n");
   }

   if (errCode & grplot_json_error_blue_integer) {
      printColorErrMsgIntro(pLocation, colorDest);
      fprintf(stderr, "blue component must be integer\n");
   }

   if (errCode & grplot_json_error_alpha_integer) {
      printColorErrMsgIntro(pLocation, colorDest);
      fprintf(stderr, "alpha component must be integer\n");
   }

   if (errCode & grplot_json_error_red_range) {
      printColorErrMsgIntro(pLocation, colorDest);
      fprintf(stderr, "red component: permitted range 0..255\n");
   }

   if (errCode & grplot_json_error_green_range) {
      printColorErrMsgIntro(pLocation, colorDest);
      fprintf(stderr, "green component: permitted range 0..255\n");
   }

   if (errCode & grplot_json_error_blue_range) {
      printColorErrMsgIntro(pLocation, colorDest);
      fprintf(stderr, "blue component: permitted range 0.255\n");
   }

   if (errCode & grplot_json_error_alpha_range) {
      printColorErrMsgIntro(pLocation, colorDest);
      fprintf(stderr, "alpha component: permitted range 0.255\n");
   }

   if (errCode & grplot_json_error_color_object) {
      printColorErrMsgIntro(pLocation, colorDest);
      fprintf(stderr, "must be json object\n");
   }
}

void
grplot_json_printFontErrMsg(
      const grplot_json_schema_location_t *pLocation
   ,  const char *fontDest
   ,  int errCode ) {
   assert(pLocation);
   assert(fontDest);

   if (errCode & grplot_json_error_font_string) {
      printColorErrMsgIntro(pLocation, fontDest);
      fprintf(stderr, "must be json string\n");
   }
}

void
grplot_json_printNrErrMsg(
      const grplot_json_schema_location_t *pLocation
   ,  int errCode ) {
   assert(pLocation);

   if (errCode & grplot_json_error_nr_gt_zero) {
      grplot_json_printErrMsg(pLocation, "nr must be greater than zero");
   }

   if (errCode & grplot_json_error_nr_int) {
      grplot_json_printErrMsg(pLocation, "nr must be integer");
   }
}

void
grplot_json_printScaleErrMsg(
      const grplot_json_schema_location_t *pLocation
   ,  int errCode ) {
   assert(pLocation);

   if (errCode & grplot_json_error_scale_range) {
      grplot_json_printErrMsg(pLocation, "scale must be one of linear, logarithm, time");
   }

   if (errCode & grplot_json_error_scale_string) {
      grplot_json_printErrMsg(pLocation, "scale must be json string");
   }
}

void
grplot_json_printTextErrMsg(
      const grplot_json_schema_location_t *pLocation
   ,  int errCode ) {
   assert(pLocation);

   if (errCode & grplot_json_error_text_string) {
      grplot_json_printErrMsg(pLocation, "label text must be json string");
   }
}

void
grplot_json_printValErrMsg(
      const grplot_json_schema_location_t *pLocation
   ,  int errCode ) {
   assert(pLocation);

   if (errCode & grplot_json_error_val_gt_zero) {
      grplot_json_printErrMsg(pLocation, "val must be greater than 0.0 if using logarithmic scales");
   }

   if (errCode & grplot_json_error_val_timespec) {
      grplot_json_printErrMsg(pLocation, "val could not be parsed as time data");
   }

   if (errCode & grplot_json_error_val_junk) {
      grplot_json_printErrMsg(pLocation, "val contains junk after time data");
   }

   if (errCode & grplot_json_error_val_string) {
      grplot_json_printErrMsg(pLocation, "val must be string containing time data");
   }

   if (errCode & grplot_json_error_val_double) {
      grplot_json_printErrMsg(pLocation, "val must be floating point number");
   }
}

void
grplot_json_printAxisErrMsg(
      const grplot_json_schema_location_t *pLocation
   ,  grplot_axis_output_status_t status ) {
   assert(pLocation);

   switch (status) {

      case grplot_axis_output_ok:
      break;

      case grplot_axis_output_zero_range: {
         grplot_json_printErrMsg(
               pLocation
            ,  "max must be greater than min" );
      }
      break;

      case grplot_axis_output_time_overflow: {
         grplot_json_printErrMsg(
               pLocation
            ,  "no greater time interval available" );
      }
      break;

      case grplot_axis_output_inscription_buf_exceeded: {
         grplot_json_printErrMsg(
               pLocation
            ,  "too many inscriptions at axis" );
      }
      break;

      default: {
         assert(0);
      }
   }
}

void
grplot_json_printDiagramErrMsg(
      const grplot_json_schema_location_t *pLocation
   ,  grplot_diagram_status_t status ) {
   assert(pLocation);

   switch (status) {

      case grplot_diagram_ok:
      break;

      case grplot_diagram_empty_buf: {
         grplot_json_printErrMsg(
               pLocation
            ,  "empty input buf" );
      }
      break;

      case grplot_diagram_zero_range: {
         grplot_json_printErrMsg(
               pLocation
            ,  "max must be greater than min" );
      }
      break;

      default: {
         assert(0);
      }
   }
}

int
grplot_json_printMissingItemsInInstructionStyle(
      const grplot_json_schema_location_t *pLocation
   ,  const grplot_json_schema_inscription_style_t *pOut ) {
   assert(pLocation);
   assert(pOut);

   int retval =  0;

   if (!pOut->font) {
      retval =  1;
      grplot_json_printErrMsg(
            pLocation
         ,  "missing font." );
   }

   return retval;
}

int
grplot_json_printMissingItemsInAxisInstructionStyle(
      const grplot_json_schema_location_t *pLocation
   ,  const grplot_json_schema_axis_inscription_style_t *pOut ) {
   assert(pLocation);
   assert(pOut);

   int retval =  0;

   if (!(pOut->inscription).font) {
      retval =  1;
      grplot_json_printErrMsg(
            pLocation
         ,  "missing font in inscription part" );
   }
   if (!(pOut->label).font) {
      retval =  1;
      grplot_json_printErrMsg(
            pLocation
         ,  "missing font in label part" );
   }
   if (!(pOut->text)) {
      retval =  1;
      grplot_json_printErrMsg(
            pLocation
         ,  "missing label text" );
   }

   return retval;
}

int
grplot_json_printMissingItemsInDiagramInstructionStyle(
      const grplot_json_schema_location_t *pLocation
   ,  const grplot_json_schema_diagram_inscription_style_t *pOut ) {
   assert(pLocation);
   assert(pOut);

   int retval =  0;

   if (!(pOut->font)) {
      retval =  1;
      grplot_json_printErrMsg(
            pLocation
         ,  "missing font." );
   }

   return retval;
}

int
grplot_json_printMissingItemsInDiagramItemInstructionStyle(
      const grplot_json_schema_location_t *pLocation
   ,  const grplot_json_schema_diagram_item_inscription_style_t *pOut ) {
   assert(pLocation);
   assert(pOut);

   int retval =  0;

   if (!(pOut->text)) {
      retval =  1;
      grplot_json_printErrMsg(
            pLocation
         ,  "missing text in diagram item." );
   }

   return retval;
}

int
grplot_json_color(const json_t *pJson, DATA32 *pResult) {
   assert(pJson);
   assert(pResult);

   int retval =  0;

   *pResult =  0;

   if (json_is_object(pJson)) {
      {
         json_t *pRed =  json_object_get(pJson, "r");
         if (json_is_integer(pRed)) {
            int red =  json_integer_value(pRed);
            if (red >= 0 && red < 256) {
               ((unsigned char *) pResult)[2] =  red;
            } else {
               retval |=   grplot_json_error_red_range;
            }
         } else {
            retval |=   grplot_json_error_red_integer;
         }
      }
      {
         json_t *pGreen =  json_object_get(pJson, "g");
         if (json_is_integer(pGreen)) {
            int green =  json_integer_value(pGreen);
            if (green >= 0 && green < 256) {
               ((unsigned char *) pResult)[1] =  green;
            } else {
               retval |=   grplot_json_error_green_range;;
            }
         } else {
            retval |=   grplot_json_error_green_integer;
         }
      }
      {
         json_t *pBlue =  json_object_get(pJson, "b");
         if (json_is_integer(pBlue)) {
            int blue =  json_integer_value(pBlue);
            if (blue >= 0 && blue < 256) {
               ((unsigned char *) pResult)[0] =  blue;
            } else {
               retval |=   grplot_json_error_blue_range;
            }
         } else {
            retval |=   grplot_json_error_blue_integer;
         }
      }
      {
         json_t *pAlpha =  json_object_get(pJson, "a");
         if (json_is_integer(pAlpha)) {
            int alpha =  json_integer_value(pAlpha);
            if (alpha >= 0 && alpha < 256) {
               ((unsigned char *) pResult)[3] =  alpha;
            } else {
               retval |=   grplot_json_error_alpha_range;
            }
         } else {
            retval |=   grplot_json_error_alpha_integer;
         }
      }
   } else {
      retval |=  grplot_json_error_color_object;
   }

   return retval;
}

int
grplot_json_font(const json_t *pJson, const char **pResult) {
   assert(pJson);
   assert(pResult);

   int retval =  0;

   if (json_is_string(pJson)) {
      *pResult =  json_string_value(pJson);
   } else {
      retval |=  grplot_json_error_font_string;
   }

   return retval;
}

int
grplot_json_nr(const json_t *pJson, unsigned *pResult) {
   assert(pJson);
   assert(pResult);

   int retval =  0;

   if (json_is_integer(pJson)) {
      int val =  json_integer_value(pJson);
      if (val >= 0) {
         *pResult =  val;
      } else {
         retval |= grplot_json_error_nr_gt_zero;
      }
   } else {
      retval |= grplot_json_error_nr_int;
   }

   return retval;
}

int
grplot_json_scale(const json_t *pJson, grplot_axis_scale_type_t *pResult) {
   assert(pJson);
   assert(pResult);

   int retval =  0;

   if (json_is_string(pJson)) {
      const char *item =  json_string_value(pJson);
      if (!strcmp(item, "linear")) {
         *pResult =  grplot_axis_linear;
      } else if (!strcmp(item, "logarithm")) {
         *pResult =  grplot_axis_logarithm;
      } else if (!strcmp(item, "time")) {
         *pResult =  grplot_axis_time;
      } else {
         retval =  grplot_json_error_scale_range;
      }
   } else {
      retval |= grplot_json_error_scale_string;
   }

   return retval;
}

int
grplot_json_text(const json_t *pJson, const char **pResult) {
   assert(pJson);
   assert(pResult);

   int retval =  0;

   if (json_is_string(pJson)) {
      *pResult =  json_string_value(pJson);
   } else {
      retval |= grplot_json_error_text_string;
   }

   return retval;
}

int
grplot_json_val(
      const json_t *pJson
   ,  grplot_axis_scale_type_t scaleType
   ,  grplot_axis_val_t *pResult ) {
   assert(pJson);
   assert(pResult);

   int retval =  0;

   switch (scaleType) {

      case grplot_axis_linear: {
         if (json_is_real(pJson)) {
            pResult->numeric =  json_real_value(pJson);
         } else {
            retval |= grplot_json_error_val_double;
         }
      }
      break;

      case grplot_axis_logarithm: {
         if (json_is_real(pJson)) {
            pResult->numeric =  json_real_value(pJson);
            if (pResult->numeric <= 0.0) {
               retval |= grplot_json_error_val_gt_zero;
            }
         } else {
            retval |= grplot_json_error_val_double;
         }
      }
      break;

      case grplot_axis_time: {
         if (json_is_string(pJson)) {
            const char *timeStr =  json_string_value(pJson);
            struct tm time;
            time.tm_year =  0;
            time.tm_mon =  0;
            time.tm_mday =  1;
            time.tm_hour =  0;
            time.tm_min =  0;
            time.tm_sec =  0;
            const char *t =  strptime(timeStr, "%Y-%m-%d%n%H:%M:%S", &time);
            if (t) {
              if (*t) {
                 retval |= grplot_json_error_val_junk;
              } else {
                 pResult->time =  mktime(&time);
              }
            } else {
               retval |= grplot_json_error_val_timespec;
            }
         } else {
            retval |= grplot_json_error_val_string;
         }
      }
      break;

      default: {
         assert(0);
      }
   }

   return retval;
}

int
grplot_json_color_elem(
      const grplot_json_schema_location_t *pLocation
   ,  const json_t *pJson
   ,  const char *dest
   ,  const DATA32 *pDefault
   ,  DATA32 *pOut ) {
   assert(pLocation);
   assert(dest);
   assert(pOut);

   if (pDefault) {
      *pOut =  *pDefault;
   }

   int retval =  0;

   json_t *pElem =  json_object_get(pJson, "color");
   if (pElem) {
      int errCode =  grplot_json_color(
            pJson
         ,  pOut );
      grplot_json_printColorErrMsg(pLocation, dest, errCode);
      if (errCode) {
         retval =  1;
      }
   }

   return retval;
}

int
grplot_json_font_elem(
      const grplot_json_schema_location_t *pLocation
   ,  const json_t *pJson
   ,  const char *dest
   ,  const Imlib_Font *pDefault
   ,  Imlib_Font *pOut ) {
   assert(pLocation);
   assert(dest);
   assert(pOut);

   if (pDefault) {
      *pOut =  *pDefault;
   }

   int retval =  0;

   json_t *pElem =  json_object_get(pJson, "font");
   if (pElem) {
      const char *fontName;
      int errCode =  grplot_json_font(
            pJson
         ,  &fontName );
      grplot_json_printFontErrMsg(pLocation, dest, errCode);
   
      if (errCode) {
         retval =  1;
      } else {
         *pOut =  imlib_load_font(fontName);
         if (!pOut) {
            printFontErrMsgIntro(pLocation, dest);
            fprintf(stderr, " %s font could not be loaded.\n", fontName);
            retval =  1;
         }
      }
   }

   return retval;
}

int
grplot_json_nr_elem(
      const grplot_json_schema_location_t *pLocation
   ,  const json_t *pJson
   ,  const char *key
   ,  const unsigned *pDefault
   ,  unsigned *pOut ) {
   assert(pLocation);
   assert(pOut);

   int retval =  0;

   if (pDefault) {
      *pOut =  *pDefault;
   }

   json_t *pElem =  json_object_get(pJson, key);
   if (pElem) {
      int errCode =  grplot_json_nr(pJson, pOut);
      grplot_json_printNrErrMsg(pLocation, errCode);
      if (errCode) {
         retval =  1;
      }
   }

   return retval;
}

int
grplot_json_scale_elem(
      const grplot_json_schema_location_t *pLocation
   ,  const json_t *pJson
   ,  const grplot_axis_scale_type_t *pDefault
   ,  grplot_axis_scale_type_t *pOut ) {
   assert(pLocation);
   assert(pOut);

   if (pDefault) {
      *pOut =  *pDefault;
   }

   int retval =  0;

   json_t *pElem =  json_object_get(pJson, "scale");
   if (pElem) {
      int errCode =  grplot_json_scale(pJson, pOut);
      grplot_json_printScaleErrMsg(pLocation, errCode);
      if (errCode) {
         retval =  1;
      }
   }

   return retval;
}

int
grplot_json_text_elem(
      const grplot_json_schema_location_t *pLocation
   ,  const json_t *pJson
   ,  const char *sDefault
   ,  const char **pOut ) {
   assert(pLocation);
   assert(pJson);
   assert(sDefault);
   assert(pOut);

   if (sDefault) {
      *pOut =  sDefault;
   }

   int retval =  0;

   json_t *pElem =  json_object_get(pJson, "text");
   if (pElem) {
      int errCode =  grplot_json_text(pJson, pOut);
      grplot_json_printTextErrMsg(pLocation, errCode);
      if (errCode) {
         retval =  1;
      }
   }

   return retval;
}

int
grplot_json_val_elem(
      const grplot_json_schema_location_t *pLocation
   ,  const json_t *pJson
   ,  grplot_axis_scale_type_t scaleType
   ,  const char *key
   ,  const grplot_axis_val_t *pDefault
   ,  grplot_axis_val_t *pOut ) {
   assert(pLocation);
   assert(pOut);

   if (pDefault) {
      *pOut =  *pDefault;
   }

   int retval =  0;

   json_t *pElem =  json_object_get(pJson, key);
   if (pElem) {
      int errCode =  grplot_json_val(pJson, scaleType, pOut);
      grplot_json_printValErrMsg(pLocation, errCode);
      if (errCode) {
         retval =  1;
      }
   }

   return retval;
}

int
grplot_json_inscription_style_elem(
      const grplot_json_schema_location_t *pLocation
   ,  const json_t *pJson
   ,  const char *dest
   ,  const grplot_json_schema_inscription_style_t *pDefault
   ,  grplot_json_schema_inscription_style_t *pOut ) {
   assert(pLocation);
   assert(dest);
   assert(pOut);

   int retval =  0;

   grplot_json_init_inscription_style_elem(pDefault, pOut);

   json_t *pElem =  json_object_get(pJson, dest);
   if (pElem) {
      if (json_is_object(pElem)) {
         {
            const DATA32 *pItem =
                  pDefault
               ?  &(pDefault->color)
               :  NULL;
            int errMode =  grplot_json_color_elem(
                  pLocation
               ,  pElem
               ,  dest
               ,  pItem
               ,  &(pOut->color) );
            if (errMode) {
               retval =  1;
            }
         }
         {
            const Imlib_Font *pItem =
                  pDefault
               ?  &(pDefault->font)
               :  NULL;
            int errMode =  grplot_json_font_elem(
                  pLocation
               ,  pElem
               ,  dest
               ,  pItem
               ,  &(pOut->font) );
            if (errMode) {
               retval =  1;
            }
         }
      } else {
         printInscriptionStyleErrMsgIntro(pLocation, dest);
         fprintf(stderr, " must be json object.\n");
         retval =  1;
      }
   }

   return retval;
}

int
grplot_json_axis_inscription_style_elem(
      const grplot_json_schema_location_t *pLocation
   ,  const json_t *pJson
   ,  const grplot_json_schema_axis_inscription_style_t *pDefault
   ,  grplot_json_schema_axis_inscription_style_t *pOut ) {
   assert(pLocation);
   assert(pOut);

   int retval =  json_is_object(pJson);

   if (!retval) {
      grplot_json_init_axis_inscription_style_elem(pDefault, pOut);
   
      {
         const grplot_json_schema_inscription_style_t *pInscriptionStyle =
               pDefault
            ?  &(pDefault->inscription)
            :  NULL;
         int errMode =  grplot_json_inscription_style_elem(
               pLocation
            ,  pJson
            ,  "inscription"
            ,  pInscriptionStyle
            ,  &(pOut->inscription) );
         if (errMode) {
            retval =  1;
         }
      }
      {
         const grplot_json_schema_inscription_style_t *pLabelStyle =
               pDefault
            ?  &(pDefault->label)
            :  NULL;
         int errMode =  grplot_json_inscription_style_elem(
               pLocation
            ,  pJson
            ,  "label"
            ,  pLabelStyle
            ,  &(pOut->label) );
         if (errMode) {
            retval =  1;
         }
      }
      {
         const char *text =
               pDefault
            ?  pDefault->text
            :  NULL;
         int errMode =  grplot_json_text_elem(
               pLocation
            ,  pJson
            ,  text
            ,  &(pOut->text) );
         if (errMode) {
            retval =  1;
         }
      }
      {
         const unsigned *pNrPixels =
               pDefault
            ?  &(pDefault->nrPixels)
            :  NULL;
         int errMode =  grplot_json_nr_elem(
               pLocation
            ,  pJson
            ,  "nr"
            ,  pNrPixels
            ,  &(pOut->nrPixels) );
         if (errMode) {
            retval =  1;
         }
      }
      {
         const grplot_axis_scale_type_t *pScaleType =
               pDefault
            ?  &(pDefault->scaleType)
            :  NULL;
         int errMode =  grplot_json_scale_elem(
               pLocation
            ,  pJson
            ,  pScaleType
            ,  &(pOut->scaleType) );
         if (errMode) {
            retval =  1;
         }
      }
      {
         const DATA32 *pColor =
               pDefault
            ?  &(pDefault->color)
            :  NULL;
         int errMode =  grplot_json_color_elem(
               pLocation
            ,  pJson
            ,  "line"
            ,  pColor
            ,  &(pOut->color) );
         if (errMode) {
            retval =  1;
         }
      }
      {
         const grplot_axis_val_t *pVal =
               pDefault
            ?  &(pDefault->min)
            :  NULL;
         int errMode =  grplot_json_val_elem(
               pLocation
            ,  pJson
            ,  pOut->scaleType
            ,  "min"
            ,  pVal
            ,  &(pOut->min) );
         if (errMode) {
            retval =  1;
         }
      }
      {
         const grplot_axis_val_t *pVal =
               pDefault
            ?  &(pDefault->max)
            :  NULL;
         int errMode =  grplot_json_val_elem(
               pLocation
            ,  pJson
            ,  pOut->scaleType
            ,  "max"
            ,  pVal
            ,  &(pOut->max) );
         if (errMode) {
            retval =  1;
         }
      }
   } else {
      grplot_json_printErrMsg(pLocation, "axis must be json object");
   }

   return retval;
}

int
grplot_json_diagram_inscription_style_elem(
      const grplot_json_schema_location_t *pLocation
   ,  const json_t *pJson
   ,  const grplot_json_schema_diagram_inscription_style_t *pDefault
   ,  grplot_json_schema_diagram_inscription_style_t *pOut ) {
   assert(pLocation);
   assert(pOut);

   int retval =  json_is_object(pJson);

   if (!retval) {
      grplot_json_init_diagram_inscription_style_elem(pDefault, pOut);
   
      {
         const DATA32 *pElem =
               pDefault
            ?  &(pDefault->color)
            :  NULL;
         int errMode =  grplot_json_color_elem(
               pLocation
            ,  pJson
            ,  "diagramColor"
            ,  pElem
            ,  &(pOut->color) );
         if (errMode) {
            retval =  1;
         }
      }
      {
         const Imlib_Font *pElem =
               pDefault
            ?  &(pDefault->font)
            :  NULL;
         int errMode =  grplot_json_font_elem(
               pLocation
            ,  pJson
            ,  "legendFont"
            ,  pElem
            ,  &(pOut->font) );
         if (errMode) {
            retval =  1;
         }
      }
   } else {
      grplot_json_printErrMsg(pLocation, "diagram must be json object");
   }

   return retval;
}

int
grplot_json_diagram_item_inscription_style_elem(
      const grplot_json_schema_location_t *pLocation
   ,  const json_t *pJson
   ,  const grplot_json_schema_diagram_item_inscription_style_t *pDefault
   ,  grplot_json_schema_diagram_item_inscription_style_t *pOut ) {
   assert(pLocation);
   assert(pOut);

   int retval =  json_is_object(pJson);

   if (!retval) {
      grplot_json_init_diagram_item_inscription_style_elem(pDefault, pOut);

      {
         const DATA32 *pVal =  
               pDefault
            ?  &(pDefault->color)
            :  NULL;
         int errMode =  grplot_json_color_elem(
               pLocation
            ,  pJson
            ,  "diagramItem"
            ,  pVal
            ,  &(pOut->color) );
         if (errMode) {
            retval =  1;
         }
      }
      {
         const char *text =  
               pDefault
            ?  pDefault->text
            :  NULL;
         int errMode =  grplot_json_text_elem(
               pLocation
            ,  pJson
            ,  text
            ,  &(pOut->text) );
         if (errMode) {
            retval =  1;
         }
      }

   } else {
      grplot_json_printErrMsg(pLocation, "diagram item must be json object");
   }

   return retval;
}

void
grplot_json_init_inscription_style_elem(
      const grplot_json_schema_inscription_style_t *pDefault
   ,  grplot_json_schema_inscription_style_t *pOut ) {
   assert(pOut);

   if (pDefault) {
      pOut->color =  pDefault->color;
      pOut->font =  pDefault->font;
   } else {
      pOut->color =  0;
      pOut->font =  NULL;
   }
}

void
grplot_json_init_axis_inscription_style_elem(
      const grplot_json_schema_axis_inscription_style_t *pDefault
   ,  grplot_json_schema_axis_inscription_style_t *pOut ) {
   assert(pOut);

   if (pDefault) {
      grplot_json_init_inscription_style_elem(
            NULL
         ,  &(pOut->inscription) );
      grplot_json_init_inscription_style_elem(
            NULL
         ,  &(pOut->label) );
      pOut->scaleType =  pDefault->scaleType;
      pOut->color =  pDefault->color;
      pOut->nrPixels =  pDefault->nrPixels;
      pOut->min =  pDefault->min;
      pOut->max =  pDefault->max;
      pOut->text =  pDefault->text;
   } else {
      grplot_json_init_inscription_style_elem(
            &(pDefault->inscription)
         ,  &(pOut->inscription) );
      grplot_json_init_inscription_style_elem(
            &(pDefault->label)
         ,  &(pOut->label) );
      pOut->scaleType =  grplot_axis_linear;
      pOut->color =  0;
      pOut->nrPixels =  1024;
      (pOut->min).numeric =  0.0;
      (pOut->max).numeric =  1.0;
      pOut->text =  NULL;
   }

}

void
grplot_json_init_diagram_inscription_style_elem(
      const grplot_json_schema_diagram_inscription_style_t *pDefault
   ,  grplot_json_schema_diagram_inscription_style_t *pOut ) {
   assert(pOut);

   if (pDefault) {
      pOut->color =  pDefault->color;
      pOut->font =  pDefault->font;
   } else {
      pOut->color =  0;
      pOut->font =  NULL;
   }

}

void
grplot_json_init_diagram_item_inscription_style_elem(
      const grplot_json_schema_diagram_item_inscription_style_t *pDefault
   ,  grplot_json_schema_diagram_item_inscription_style_t *pOut ) {
   assert(pOut);

   if (pDefault) {
      pOut->color =  pDefault->color;
      pOut->text =  pDefault->text;
   } else {
      pOut->color =  0;
      pOut->text =  NULL;
   }

}

int
grplot_json_axis_default_general(
      const json_t *pJson
   ,  grplot_json_schema_axis_inscription_style_t *pOut ) {
   assert(pJson);
   assert(pOut);

   int retval =  0;

   grplot_json_init_axis_inscription_style_elem(NULL, pOut);

   grplot_json_schema_location_t location;
   location.locationType =  grplot_json_schema_axis_default_general;

   json_t *pInnerJson =  json_object_get(pJson, "default");
   if (pInnerJson) {
      retval =  grplot_json_axis_inscription_style_elem(
            &location
         ,  pInnerJson
         ,  NULL
         ,  pOut );
   }

   return retval;
}

int
grplot_json_axis_default(
      const json_t *pJson
   ,  const grplot_json_schema_axis_inscription_style_t *pDefault
   ,  grplot_json_schema_axis_inscription_style_t *pOut ) {
   assert(pJson);
   assert(pDefault);
   assert(pOut);

   int retval =  0;

   grplot_json_init_axis_inscription_style_elem(pDefault, pOut);

   grplot_json_schema_location_t location;
   location.locationType =  grplot_json_schema_axis_default;

   json_t *pInnerJson =  json_object_get(pJson, "default");
   if (pInnerJson) {
      retval =  grplot_json_axis_inscription_style_elem(
            &location
         ,  pInnerJson
         ,  pDefault
         ,  pOut );
   }

   return retval;
}

int
grplot_json_diagram_default(
      const json_t *pJson
   ,  const grplot_json_schema_diagram_inscription_style_t *pDefault
   ,  grplot_json_schema_diagram_inscription_style_t *pOut ) {
   assert(pJson);
   assert(pDefault);
   assert(pOut);

   int retval =  0;

   grplot_json_init_diagram_inscription_style_elem(pDefault, pOut);

   grplot_json_schema_location_t location;
   location.locationType =  grplot_json_schema_diagram_default;

   json_t *pInnerJson =  json_object_get(pJson, "default");
   if (pInnerJson) {
      retval =  grplot_json_diagram_inscription_style_elem(
            &location
         ,  pInnerJson
         ,  pDefault
         ,  pOut );
   }

   return retval;
}

int
grplot_json_diagram_base(
      const json_t *pJson
   ,  const grplot_json_schema_location_t *pLocation
   ,  const grplot_json_schema_diagram_item_inscription_style_t *pDefault
   ,  grplot_json_schema_diagram_item_inscription_style_t *pOut ) {
   assert(pJson);
   assert(pLocation);
   assert(pDefault);
   assert(pOut);

   int retval =  0;

   grplot_json_init_diagram_item_inscription_style_elem(pDefault, pOut);

   grplot_json_schema_location_t location;
   location.locationType =  grplot_json_schema_diagram_default;
   location.variant.diagramBase.x =  (pLocation->variant).diagram.base.x;
   location.variant.diagramBase.y =  (pLocation->variant).diagram.base.y;

   json_t *pInnerJson =  json_object_get(pJson, "default");
   if (pInnerJson) {
      retval =  grplot_json_diagram_item_inscription_style_elem(
            &location
         ,  pInnerJson
         ,  pDefault
         ,  pOut );
   }

   return retval;
}

int
grplot_json_matrix_init_axis(
      grplot_matrix_t *pMatrix
   ,  const grplot_json_schema_axis_inscription_style_t *pAxisInscriptionStyle
   ,  const grplot_json_schema_location_t *pLocation ) {
   assert(pMatrix);
   assert(pAxisInscriptionStyle);
   assert(pLocation);

   int retval =  grplot_json_printMissingItemsInAxisInstructionStyle(
         pLocation
      ,  pAxisInscriptionStyle );
   if (!retval) {
      grplot_axis_output_status_t statusCode =  grplot_axis_output_ok;
   
      switch ((pLocation->variant).axis.axisType) {
   
         case (grplot_axis_x_axis): {
            statusCode =  grplot_matrix_x_axis_init(
                  pMatrix
               ,  (pLocation->variant).axis.nr
               ,  pAxisInscriptionStyle->scaleType
               ,  (pAxisInscriptionStyle->inscription).font
               ,  (pAxisInscriptionStyle->inscription).color
               ,  (pAxisInscriptionStyle->label).font
               ,  (pAxisInscriptionStyle->label).color
               ,  pAxisInscriptionStyle->nrPixels
               ,  pAxisInscriptionStyle->color
               ,  pAxisInscriptionStyle->min
               ,  pAxisInscriptionStyle->max
               ,  pAxisInscriptionStyle->text );
         }
         break;
   
         case (grplot_axis_y_axis): {
            statusCode =  grplot_matrix_y_axis_init(
                  pMatrix
               ,  (pLocation->variant).axis.nr
               ,  pAxisInscriptionStyle->scaleType
               ,  (pAxisInscriptionStyle->inscription).font
               ,  (pAxisInscriptionStyle->inscription).color
               ,  (pAxisInscriptionStyle->label).font
               ,  (pAxisInscriptionStyle->label).color
               ,  pAxisInscriptionStyle->nrPixels
               ,  pAxisInscriptionStyle->color
               ,  pAxisInscriptionStyle->min
               ,  pAxisInscriptionStyle->max
               ,  pAxisInscriptionStyle->text );
         }
         break;
   
         default: {
            assert(0);
         }
      }

      if (statusCode != grplot_axis_output_ok) {
         grplot_json_printAxisErrMsg(pLocation, statusCode);
         retval =  1;
      }
   }

   return retval;
}

int
grplot_json_matrix_init_diagram(
      grplot_matrix_t *pMatrix
   ,  const grplot_json_schema_diagram_inscription_style_t *pDiagramInscriptionStyle
   ,  unsigned nrItem
   ,  const grplot_json_schema_location_t *pLocation ) {
   assert(pMatrix);
   assert(pDiagramInscriptionStyle);
   assert(pLocation);

   int retval =  grplot_json_printMissingItemsInDiagramInstructionStyle(
         pLocation
      ,  pDiagramInscriptionStyle );

   if (!retval) {
      grplot_diagram_status_t statusCode =  grplot_matrix_diagram_init(
            pMatrix
         ,  pDiagramInscriptionStyle->color
         ,  pDiagramInscriptionStyle->font
         ,  nrItem
         ,  (pLocation->variant).diagramBase.x
         ,  (pLocation->variant).diagramBase.y );
      if (statusCode != grplot_diagram_ok) {
         grplot_json_printDiagramErrMsg(pLocation, statusCode);
         retval =  1;
      }
   }

   return retval;
}

int
grplot_json_diagram_init_diagram_item(
      grplot_diagram_t *pDiagram
   ,  const grplot_json_schema_diagram_item_inscription_style_t *pDiagramItemInscriptionStyle
   ,  const grplot_json_schema_location_t *pLocation ) {
   assert(pDiagram);
   assert(pDiagramItemInscriptionStyle);
   assert(pLocation);

   int retval =  grplot_json_printMissingItemsInDiagramItemInstructionStyle(
         pLocation
      ,  pDiagramItemInscriptionStyle );
   if (!retval) {
      grplot_diagram_status_t statusCode =  grplot_diagram_item_init(
            pDiagram
         ,  pDiagramItemInscriptionStyle->color
         ,  pDiagramItemInscriptionStyle->text
         ,  (pLocation->variant).diagram.nr );
      if (statusCode != grplot_diagram_ok) {
         grplot_json_printDiagramErrMsg(pLocation, statusCode);
         retval =  1;
      }
   }
   
   return retval;
}

int
grplot_json_axis_data_item(
      grplot_matrix_t *pMatrix
   ,  const json_t *pJson
   ,  const grplot_json_schema_location_t *pLocation
   ,  const grplot_json_schema_axis_inscription_style_t *pDefault ) {
   assert(pMatrix);
   assert(pJson);
   assert(pLocation);
   assert(pDefault);

   grplot_json_schema_axis_inscription_style_t out;
   grplot_json_init_axis_inscription_style_elem(pDefault, &out);

   int retval =  grplot_json_axis_inscription_style_elem(
         pLocation
      ,  pJson
      ,  pDefault
      ,  &out );

   if (!retval) {
      retval =  grplot_json_matrix_init_axis(
            pMatrix
         ,  &out
         ,  pLocation );
   }

   return retval;
}

int
grplot_json_diagram_data_item(
      grplot_matrix_t *pMatrix
   ,  const json_t *pJson
   ,  const grplot_json_schema_location_t *pLocation
   ,  const grplot_json_schema_diagram_item_inscription_style_t *pDefaultItem
   ,  const grplot_json_schema_diagram_inscription_style_t *pDefault ) {
   assert(pMatrix);
   assert(pJson);
   assert(pLocation);
   assert(pDefaultItem);
   assert(pDefault);

   grplot_json_schema_diagram_inscription_style_t out;
   grplot_json_init_diagram_inscription_style_elem(pDefault, &out);

   int retval =  json_is_object(pJson);

   if (!retval) {
     unsigned nrInpBuf =  0;

     json_t *pInnerJson =  json_object_get(pJson, "items");
     if (pInnerJson) {
        if (json_is_array(pInnerJson)) {
           nrInpBuf =  json_array_size(pInnerJson);
        } else {
           retval =  1;
           grplot_json_printErrMsg(pLocation, "items in diagram must be array");
        }
     }

     if (!retval) {
        retval =  grplot_json_matrix_init_diagram(
               pMatrix
            ,  &out
            ,  nrInpBuf
            ,  pLocation );
        grplot_json_schema_diagram_item_inscription_style_t innerOut;
        grplot_json_diagram_base(
              pInnerJson
           ,  pLocation
           ,  pDefaultItem
           ,  &innerOut );
        {
           size_t nr;
           json_t *pDiagramItemJson;

           json_array_foreach(pInnerJson, nr, pDiagramItemJson) {
              if (!retval) {
                 grplot_json_schema_location_t location;
                 location.locationType =  grplot_json_schema_diagram;
                 location.variant.diagram.base.x =  (pLocation->variant).diagramBase.x;
                 location.variant.diagram.base.y =  (pLocation->variant).diagramBase.y;
                 location.variant.diagram.nr =  nr;
      
                 grplot_diagram_t *pDiagramItem;
                 grplot_matrix_get_diagram(
                       pMatrix
                    ,  &pDiagramItem
                    ,  location.variant.diagram.base.x
                    ,  location.variant.diagram.base.y );
                 retval =  grplot_json_diagram_item_data_item(
                       pDiagramItem
                    ,  pDiagramItemJson
                    ,  &location
                    ,  &innerOut );
              }
           }
        }
     }
   } else {
      grplot_json_printErrMsg(pLocation, "diagram must be json object");
   }

   return retval;
}

int
grplot_json_diagram_item_data_item(
      grplot_diagram_t *pDiagram
   ,  const json_t *pJson
   ,  const grplot_json_schema_location_t *pLocation
   ,  const grplot_json_schema_diagram_item_inscription_style_t *pDefault ) {
   assert(pDiagram);
   assert(pJson);
   assert(pLocation);
   assert(pDefault);

   grplot_json_schema_diagram_item_inscription_style_t out;
   grplot_json_init_diagram_item_inscription_style_elem(pDefault, &out);

   int retval =  grplot_json_diagram_item_inscription_style_elem(
         pLocation
      ,  pJson
      ,  pDefault
      ,  &out );

   if (!retval) {
      retval =  grplot_json_diagram_init_diagram_item(
            pDiagram
         ,  &out
         ,  pLocation );
   }

   return retval;
}

int
grplot_json_diagram_data(
      grplot_matrix_t *pMatrix
   ,  const json_t *pJson
   ,  const grplot_json_schema_diagram_item_inscription_style_t *pDefaultItem
   ,  const grplot_json_schema_diagram_inscription_style_t *pDefault ) {
   assert(pMatrix);
   assert(pJson);
   assert(pDefaultItem);
   assert(pDefault);

   grplot_json_schema_diagram_inscription_style_t out;
   grplot_json_init_diagram_inscription_style_elem(pDefault, &out);

   grplot_json_schema_diagram_item_inscription_style_t defaultItemOut;
   grplot_json_init_diagram_item_inscription_style_elem(pDefaultItem, &defaultItemOut);

   grplot_json_schema_location_t outerLocation;
   outerLocation.locationType =  grplot_json_schema_diagram_default;

   int retval =  json_is_object(pJson);

   if (!retval) {
     json_t *pInnerJson =  json_object_get(pJson, "items");
     if (pInnerJson) {
        if (json_is_array(pInnerJson)) {
           grplot_json_diagram_default(
                 pInnerJson
              ,  pDefault
              ,  &out );
           grplot_json_diagram_base(
                 pInnerJson
              ,  &outerLocation
              ,  pDefaultItem
              ,  &defaultItemOut );
           grplot_json_schema_location_t innerLocation;
           innerLocation.locationType =  grplot_json_schema_diagram_base;
           innerLocation.variant.diagramBase.x =  0;
           innerLocation.variant.diagramBase.y =  0;
           {
              size_t nr;
              json_t *pDiagramJson;

              json_array_foreach(pInnerJson, nr, pDiagramJson) {
                 if (!retval) {
                    retval =  grplot_json_diagram_data_item(
                          pMatrix
                       ,  pDiagramJson
                       ,  &innerLocation
                       ,  &defaultItemOut
                       ,  &out );
                    innerLocation.variant.diagramBase.x++;
                    if (innerLocation.variant.diagramBase.x >= pMatrix->nrX) {
                       innerLocation.variant.diagramBase.x =  0;
                       innerLocation.variant.diagramBase.y++;
                       if (innerLocation.variant.diagramBase.y >= pMatrix->nrY) {
                          retval =  1;
                       }
                    }
                 }
              }
              if (nr > pMatrix->nrDiagram) {
                 retval =  1;
                 grplot_json_printErrMsg(&innerLocation, "too many diagrams");
              } else if (nr < pMatrix->nrDiagram) {
                 retval =  1;
                 grplot_json_printErrMsg(&innerLocation, "too few diagrams");
              }
           }
        } else {
           retval =  1;
           grplot_json_printErrMsg(&outerLocation, "items in diagram component must be array");
        }
     } else {
        grplot_json_printErrMsg(&outerLocation, "mandatory diagram component");
     }
   } else {
      grplot_json_printErrMsg(&outerLocation, "diagram component must be json object");
   }

   return retval;
}


static void
printErrMsgIntro(
      const grplot_json_schema_location_t *pLocation ) {
   assert(pLocation);

   switch (pLocation->locationType) {

      case grplot_json_schema_base: {
         fprintf(stderr, "in base");
      }
      break;

      case grplot_json_schema_axis: {

         switch ((pLocation->variant).axis.axisType) {

            case grplot_axis_x_axis: {
               fprintf(stderr, "in x axis #%d", (pLocation->variant).axis.nr);
            }
            break;

            case grplot_axis_y_axis: {
               fprintf(stderr, "in y axis #%d", (pLocation->variant).axis.nr);
            }
            break;

            default: {
               assert(0);
            }
         }
      }
      break;

      case grplot_json_schema_axis_default: {

         switch ((pLocation->variant).axisDefault) {

            case grplot_axis_x_axis: {
               fprintf(stderr, "in x axis (default)");
            }
            break;

            case grplot_axis_y_axis: {
               fprintf(stderr, "in y axis (default)");
            }
            break;

            default: {
               assert(0);
            }
         }
      }
      break;

      case grplot_json_schema_axis_default_general: {
         fprintf(stderr, "in axis (default)");
      }
      break;

      case grplot_json_schema_diagram: {
         fprintf(stderr, "in diagram #(%d, %d, %d)"
            ,  (pLocation->variant).diagram.base.x
            ,  (pLocation->variant).diagram.base.y
            ,  (pLocation->variant).diagram.nr );
      }
      break;

      case grplot_json_schema_diagram_base: {
         fprintf(stderr, "in diagram base #(%d, %d)"
            ,  (pLocation->variant).diagramBase.x
            ,  (pLocation->variant).diagramBase.y );
      }
      break;

      case grplot_json_schema_diagram_default: {
         fprintf(stderr, "in diagram (default)");
      }
      break;

      default: {
         assert(0);
      }
   }
}

static void
printColorErrMsgIntro(
      const grplot_json_schema_location_t *pLocation
   ,  const char *dest ) {
   assert(pLocation);
   assert(dest);

   printErrMsgIntro(pLocation);
   fprintf(stderr, " (%s color): ", dest);
}

static void
printFontErrMsgIntro(
      const grplot_json_schema_location_t *pLocation
   ,  const char *dest ) {
   assert(pLocation);
   assert(dest);

   printErrMsgIntro(pLocation);
   fprintf(stderr, " (%s font): ", dest);
}

static void
printInscriptionStyleErrMsgIntro(
      const grplot_json_schema_location_t *pLocation
   ,  const char *dest ) {
   assert(pLocation);
   assert(dest);

   printErrMsgIntro(pLocation);
   fprintf(stderr, " (%s style): ", dest);
}
