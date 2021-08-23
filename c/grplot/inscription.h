#ifndef GRPLOT_INSCRIPTION_H
#define GRPLOT_INSCRIPTION_H

#include <Imlib2.h>

typedef struct {
   char *text;
   int width, height; } grplot_inscription_t;

typedef struct {
   grplot_inscription_t inscription;
   unsigned positionPerPixel; } grplot_inscription_positional_inscription_t;

int
grplot_inscription_init(grplot_inscription_t *, Imlib_Font, char *);

int
grplot_inscription_set_color(DATA32);

int
grplot_inscription_draw_LB_horizontal(
      const grplot_inscription_t *
   ,  DATA32
   ,  Imlib_Font
   ,  int
   ,  int );

int
grplot_inscription_draw_LB_vertical(
      const grplot_inscription_t *
   ,  DATA32
   ,  Imlib_Font
   ,  int
   ,  int );

int
grplot_inscription_draw_LC_vertical(
      const grplot_inscription_t *
   ,  DATA32
   ,  Imlib_Font
   ,  int
   ,  int );

int
grplot_inscription_draw_LT_horizontal(
      const grplot_inscription_t *
   ,  DATA32
   ,  Imlib_Font
   ,  int
   ,  int );

int
grplot_inscription_draw_RB_vertical(
      const grplot_inscription_t *
   ,  DATA32
   ,  Imlib_Font
   ,  int
   ,  int );

int
grplot_inscription_draw_RC_horizontal(
      const grplot_inscription_t *
   ,  DATA32
   ,  Imlib_Font
   ,  int
   ,  int );

int
grplot_inscription_draw_positional_LB_horizontal(
      const grplot_inscription_positional_inscription_t *
   ,  DATA32
   ,  Imlib_Font
   ,  int
   ,  int );

int
grplot_inscription_draw_positional_LC_vertical(
      const grplot_inscription_positional_inscription_t *
   ,  DATA32
   ,  Imlib_Font
   ,  int
   ,  int );

int
grplot_inscription_draw_positional_LT_horizontal(
      const grplot_inscription_positional_inscription_t *
   ,  DATA32
   ,  Imlib_Font
   ,  int
   ,  int );

int
grplot_inscription_draw_positional_RC_horizontal(
      const grplot_inscription_positional_inscription_t *
   ,  DATA32
   ,  Imlib_Font
   ,  int
   ,  int );

#endif
