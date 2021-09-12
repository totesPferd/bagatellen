#ifndef GRPLOT_JSON_H
#define GRPLOT_JSON_H

#include <Imlib2.h>
#include <jansson.h>

#include "axis.h"
#include "axis_output.h"
#include "diagram.h"
#include "matrix.h"

typedef enum {
      grplot_json_schema_base
   ,  grplot_json_schema_axis
   ,  grplot_json_schema_axis_default
   ,  grplot_json_schema_axis_default_general
   ,  grplot_json_schema_diagram_base
   ,  grplot_json_schema_diagram
   ,  grplot_json_schema_diagram_default } grplot_json_schema_location_type_t;

typedef struct {
   grplot_axis_type_t axisType;
   unsigned nr; } grplot_json_schema_axis_t;

typedef struct {
   unsigned x;
   unsigned y; } grplot_json_schema_diagram_base_t;

typedef struct {
   grplot_json_schema_diagram_base_t base;
   unsigned nr; } grplot_json_schema_diagram_t;

typedef union {
   int base;
   grplot_axis_type_t axisDefault;
   grplot_json_schema_axis_t axis;
   grplot_json_schema_diagram_base_t diagramBase;
   grplot_json_schema_diagram_t diagram; } grplot_json_schema_variant_t;

typedef struct {
   grplot_json_schema_location_type_t locationType;
   grplot_json_schema_variant_t variant; } grplot_json_schema_location_t;

typedef struct {
   DATA32 color;
   Imlib_Font font; } grplot_json_schema_inscription_style_t;

typedef struct {
   grplot_json_schema_inscription_style_t inscription;
   grplot_json_schema_inscription_style_t label;
   grplot_axis_scale_type_t scaleType;
   DATA32 color;
   const char *text;
   unsigned nrPixels;
   grplot_axis_val_t min;
   grplot_axis_val_t max; } grplot_json_schema_axis_inscription_style_t;

typedef struct {
   DATA32 color;
   Imlib_Font font; } grplot_json_schema_diagram_inscription_style_t;

typedef struct {
   DATA32 color;
   const char *text; } grplot_json_schema_diagram_item_inscription_style_t;

void
grplot_json_printErrMsg(
      const grplot_json_schema_location_t *
   ,  const char * );

void
grplot_json_printColorErrMsg(
      const grplot_json_schema_location_t *
   ,  const char *
   ,  int );

void
grplot_json_printFontErrMsg(
      const grplot_json_schema_location_t *
   ,  const char *
   ,  int );

void
grplot_json_printNrErrMsg(
      const grplot_json_schema_location_t *
   ,  int );

void
grplot_json_printScaleErrMsg(
      const grplot_json_schema_location_t *
   ,  int );

void
grplot_json_printTextErrMsg(
      const grplot_json_schema_location_t *
   ,  int );

void
grplot_json_printValErrMsg(
      const grplot_json_schema_location_t *
   ,  int );

void
grplot_json_printAxisErrMsg(
      const grplot_json_schema_location_t *
   ,  grplot_axis_output_status_t );

void
grplot_json_printDiagramErrMsg(
      const grplot_json_schema_location_t *
   ,  grplot_diagram_status_t );

int
grplot_json_printMissingItemsInInstructionStyle(
      const grplot_json_schema_location_t *
   ,  const grplot_json_schema_inscription_style_t * );

int
grplot_json_printMissingItemsInAxisInstructionStyle(
      const grplot_json_schema_location_t *
   ,  const grplot_json_schema_axis_inscription_style_t * );

int
grplot_json_printMissingItemsInDiagramInstructionStyle(
      const grplot_json_schema_location_t *
   ,  const grplot_json_schema_diagram_inscription_style_t * );

int
grplot_json_printMissingItemsInDiagramItemInstructionStyle(
      const grplot_json_schema_location_t *
   ,  const grplot_json_schema_diagram_item_inscription_style_t * );

const int grplot_json_error_red_integer =  1;
const int grplot_json_error_green_integer =  2;
const int grplot_json_error_blue_integer =  4;
const int grplot_json_error_alpha_integer =  8;
const int grplot_json_error_red_range =  16;
const int grplot_json_error_green_range =  32;
const int grplot_json_error_blue_range =  64;
const int grplot_json_error_alpha_range =  128;
const int grplot_json_error_color_object =  256;
int
grplot_json_color(const json_t *, DATA32 *);

const int grplot_json_error_font_string =  256;
int
grplot_json_font(const json_t *, const char **);

const int grplot_json_error_nr_gt_zero =  1;
const int grplot_json_error_nr_int =  128;
int
grplot_json_nr(const json_t *, unsigned *);

const int grplot_json_error_scale_range =  16;
const int grplot_json_error_scale_string =  256;
int
grplot_json_scale(const json_t *, grplot_axis_scale_type_t *);

const int grplot_json_error_text_string =  256;
int
grplot_json_text(const json_t *, const char **);

const int grplot_json_error_val_gt_zero =  1;
const int grplot_json_error_val_timespec =  2;
const int grplot_json_error_val_junk =  4;
const int grplot_json_error_val_string =  256;
const int grplot_json_error_val_double =  512;
int
grplot_json_val(const json_t *, grplot_axis_scale_type_t, grplot_axis_val_t *);

int
grplot_json_color_elem(
      const grplot_json_schema_location_t *
   ,  const json_t *
   ,  const char *
   ,  const DATA32 *
   ,  DATA32 * );

int
grplot_json_font_elem(
      const grplot_json_schema_location_t *
   ,  const json_t *
   ,  const char *
   ,  const Imlib_Font *
   ,  Imlib_Font * );

int
grplot_json_nr_elem(
      const grplot_json_schema_location_t *
   ,  const json_t *
   ,  const char *
   ,  const unsigned *
   ,  unsigned * );

int
grplot_json_scale_elem(
      const grplot_json_schema_location_t *
   ,  const json_t *
   ,  const grplot_axis_scale_type_t *
   ,  grplot_axis_scale_type_t * );

int
grplot_json_text_elem(
      const grplot_json_schema_location_t *
   ,  const json_t *
   ,  const char *
   ,  const char ** );

int
grplot_json_val_elem(
      const grplot_json_schema_location_t *
   ,  const json_t *
   ,  grplot_axis_scale_type_t
   ,  const char *
   ,  const grplot_axis_val_t *
   ,  grplot_axis_val_t * );

int
grplot_json_inscription_style_elem(
      const grplot_json_schema_location_t *
   ,  const json_t *
   ,  const char *
   ,  const grplot_json_schema_inscription_style_t *
   ,  grplot_json_schema_inscription_style_t * );

int
grplot_json_axis_inscription_style_elem(
      const grplot_json_schema_location_t *
   ,  const json_t *
   ,  const grplot_json_schema_axis_inscription_style_t *
   ,  grplot_json_schema_axis_inscription_style_t * );

int
grplot_json_diagram_inscription_style_elem(
      const grplot_json_schema_location_t *
   ,  const json_t *
   ,  const grplot_json_schema_diagram_inscription_style_t *
   ,  grplot_json_schema_diagram_inscription_style_t * );

int
grplot_json_diagram_item_inscription_style_elem(
      const grplot_json_schema_location_t *
   ,  const json_t *
   ,  const grplot_json_schema_diagram_item_inscription_style_t *
   ,  grplot_json_schema_diagram_item_inscription_style_t * );

void
grplot_json_init_inscription_style_elem(
      const grplot_json_schema_inscription_style_t *
   ,  grplot_json_schema_inscription_style_t * );

void
grplot_json_init_axis_inscription_style_elem(
      const grplot_json_schema_axis_inscription_style_t *
   ,  grplot_json_schema_axis_inscription_style_t * );

void
grplot_json_init_diagram_inscription_style_elem(
      const grplot_json_schema_diagram_inscription_style_t *
   ,  grplot_json_schema_diagram_inscription_style_t * );

void
grplot_json_init_diagram_item_inscription_style_elem(
      const grplot_json_schema_diagram_item_inscription_style_t *
   ,  grplot_json_schema_diagram_item_inscription_style_t * );

int
grplot_json_axis_default_general(
      const json_t *
   ,  grplot_json_schema_axis_inscription_style_t * );

int
grplot_json_axis_default(
      const json_t *
   ,  const grplot_json_schema_axis_inscription_style_t *
   ,  grplot_json_schema_axis_inscription_style_t * );

int
grplot_json_diagram_default(
      const json_t *
   ,  const grplot_json_schema_diagram_inscription_style_t *
   ,  grplot_json_schema_diagram_inscription_style_t * );

int
grplot_json_diagram_base(
      const json_t *
   ,  const grplot_json_schema_location_t *
   ,  const grplot_json_schema_diagram_item_inscription_style_t *
   ,  grplot_json_schema_diagram_item_inscription_style_t * );

int
grplot_json_matrix_init_axis(
      grplot_matrix_t *
   ,  const grplot_json_schema_axis_inscription_style_t *
   ,  const grplot_json_schema_location_t * );

int
grplot_json_matrix_init_diagram(
      grplot_matrix_t *
   ,  const grplot_json_schema_diagram_inscription_style_t *
   ,  unsigned
   ,  const grplot_json_schema_location_t * );

int
grplot_json_diagram_init_diagram_item(
      grplot_diagram_t *
   ,  const grplot_json_schema_diagram_item_inscription_style_t *
   ,  const grplot_json_schema_location_t * );

int
grplot_json_axis_data_item(
      grplot_matrix_t *
   ,  const json_t *
   ,  const grplot_json_schema_location_t *
   ,  const grplot_json_schema_axis_inscription_style_t * );

int
grplot_json_diagram_data(
      grplot_matrix_t *
   ,  const json_t *
   ,  const grplot_json_schema_diagram_item_inscription_style_t *
   ,  const grplot_json_schema_diagram_inscription_style_t * );

int
grplot_json_diagram_data_item(
      grplot_matrix_t *
   ,  const json_t *
   ,  const grplot_json_schema_location_t *
   ,  const grplot_json_schema_diagram_item_inscription_style_t *
   ,  const grplot_json_schema_diagram_inscription_style_t * );

int
grplot_json_diagram_item_data_item(
      grplot_diagram_t *
   ,  const json_t *
   ,  const grplot_json_schema_location_t *
   ,  const grplot_json_schema_diagram_item_inscription_style_t * );

int
grplot_json_root_elem(
      grplot_matrix_t *
   ,  json_t * );

#endif
