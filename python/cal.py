#!/usr/bin/env python2
#-*- encoding: UTF-8 -*-

import argparse
import calendar
import datetime
import dateutil.rrule
import locale
import pyexiv2
import reportlab.pdfgen.canvas

#
# Einige Einstellungen

# Räumlicher Abstand von einem Tag zum nächsten.
diff_day  = (0, -25)

# Stelle, an der Monatsnamen erscheint.
month_name_place     =  (700, -100)

# Stellen, an denen Wochtagspanels gedruckt werden.
weekday_panel_places = [(600, -150), (600, -350)]

# Stellen, wo die Monatstage erscheinen (6 Wochen)
day_places           = [(700, -150), (700, -350),\
                        (750, -150), (750, -350),\
                        (800, -150), (800, -350) ]

# Stelle, an der das Kalenderbild erscheint.
pic_place            =  (50, -500)

# Abmessungen des Bildes
pic_dim               =  (489.6, 367.2)

# Stelle, an der die Bildunterschrift erscheint.
capt_place           =  (50, -550)

# Farbe, mit der Feiertage geschrieben werden:
RGB_free = (0.95, 0.3, 0.1)

# Farbe, mit der Werktage geschrieben werden:
RGB_work = (0.58, 0.58, 0.58)

# Standardfarbe für alles übrige:
RGB_standard = (0.58, 0.58, 0.58)

#
# Die Feiertage

# Sonntag
rrule_sonntag = dateutil.rrule.rrule(
 dateutil.rrule.YEARLY,            \
 byhour   = 0, \
 byminute = 0, \
 bysecond = 0, \
 byweekday  = [dateutil.rrule.SU] )

# Neujahr
rrule_neujahr = dateutil.rrule.rrule(
 dateutil.rrule.YEARLY,            \
 byhour   = 0, \
 byminute = 0, \
 bysecond = 0, \
 bymonth    = 1,                   \
 bymonthday = 1 )

# Heilige Drei Könige
rrule_dreik   = dateutil.rrule.rrule(
 dateutil.rrule.YEARLY,            \
 byhour   = 0, \
 byminute = 0, \
 bysecond = 0, \
 bymonth    = 1,                   \
 bymonthday = 6 )

# Heilige Drei Könige
rrule_frauent = dateutil.rrule.rrule(
 dateutil.rrule.YEARLY,            \
 byhour   = 0, \
 byminute = 0, \
 bysecond = 0, \
 bymonth    = 3,                   \
 bymonthday = 8 )

# Karfeitag
rrule_karf    = dateutil.rrule.rrule(
 dateutil.rrule.YEARLY,            \
 byhour   = 0, \
 byminute = 0, \
 bysecond = 0, \
 byeaster   = -2 )

# Ostermontag
rrule_ostermo = dateutil.rrule.rrule(
 dateutil.rrule.YEARLY,            \
 byhour   = 0, \
 byminute = 0, \
 bysecond = 0, \
 byeaster   = 1 )

# Tag der Arbeit
rrule_mai     = dateutil.rrule.rrule(
 dateutil.rrule.YEARLY,            \
 byhour   = 0, \
 byminute = 0, \
 bysecond = 0, \
 bymonth    = 5,                   \
 bymonthday = 1 )

# Christi Himmelfahrt
rrule_himmelf = dateutil.rrule.rrule(
 dateutil.rrule.YEARLY,            \
 byhour   = 0, \
 byminute = 0, \
 bysecond = 0, \
 byeaster   = 39 )

# Pfingstmontag
rrule_pfingst = dateutil.rrule.rrule(
 dateutil.rrule.YEARLY,            \
 byhour   = 0, \
 byminute = 0, \
 bysecond = 0, \
 byeaster   = 50 )

# Fronleichnam
rrule_fronl   = dateutil.rrule.rrule(
 dateutil.rrule.YEARLY,            \
 byhour   = 0, \
 byminute = 0, \
 bysecond = 0, \
 byeaster   = 60 )

# Mariae Himmelfahrt
rrule_mariaeh = dateutil.rrule.rrule(
 dateutil.rrule.YEARLY,            \
 byhour   = 0, \
 byminute = 0, \
 bysecond = 0, \
 bymonth    = 8,                  \
 bymonthday = 15 )

# Weltkindertag
rrule_kindert = dateutil.rrule.rrule(
 dateutil.rrule.YEARLY,            \
 byhour   = 0, \
 byminute = 0, \
 bysecond = 0, \
 bymonth    = 9,                  \
 bymonthday = 20 )

# Tag der Deutschen Einheit
rrule_einheit = dateutil.rrule.rrule(
 dateutil.rrule.YEARLY,            \
 byhour   = 0, \
 byminute = 0, \
 bysecond = 0, \
 bymonth    = 10,                  \
 bymonthday = 3 )

# Reformationstag
rrule_reform  = dateutil.rrule.rrule(
 dateutil.rrule.YEARLY,            \
 byhour   = 0, \
 byminute = 0, \
 bysecond = 0, \
 bymonth    = 10,                  \
 bymonthday = 31 )

# Allerheiligen
rrule_allerh  = dateutil.rrule.rrule(
 dateutil.rrule.YEARLY,            \
 byhour   = 0, \
 byminute = 0, \
 bysecond = 0, \
 bymonth    = 11,                  \
 bymonthday = 1 )

# Buß- & Bettag
rrule_bubt    = dateutil.rrule.rrule(
 dateutil.rrule.YEARLY,            \
 byweekday  = (dateutil.rrule.WE), \
 byhour   = 0, \
 byminute = 0, \
 bysecond = 0, \
 bymonth    = 11,                  \
 bymonthday = range(16,22) )

# Erster Weihnachtstag
rrule_xmas_1  = dateutil.rrule.rrule(
 dateutil.rrule.YEARLY,            \
 byhour   = 0, \
 byminute = 0, \
 bysecond = 0, \
 bymonth    = 12,                  \
 bymonthday = 25 )

# Zweiter Weihnachtstag
rrule_xmas_2  = dateutil.rrule.rrule(
 dateutil.rrule.YEARLY,            \
 byhour   = 0, \
 byminute = 0, \
 bysecond = 0, \
 bymonth    = 12,                  \
 bymonthday = 26 )

#
# Sonn- und Feiertage in den einzelnen Bundeslaendern, repraesentiert als dict von rrules.

rr_dict =  {}

rr_dict["Baden-Wuerttemberg"] =  dateutil.rrule.rruleset()
rr_dict["Baden-Wuerttemberg"].rrule(rrule_sonntag)
rr_dict["Baden-Wuerttemberg"].rrule(rrule_neujahr)
rr_dict["Baden-Wuerttemberg"].rrule(rrule_dreik)
rr_dict["Baden-Wuerttemberg"].rrule(rrule_karf)
rr_dict["Baden-Wuerttemberg"].rrule(rrule_ostermo)
rr_dict["Baden-Wuerttemberg"].rrule(rrule_mai)
rr_dict["Baden-Wuerttemberg"].rrule(rrule_himmelf)
rr_dict["Baden-Wuerttemberg"].rrule(rrule_pfingst)
rr_dict["Baden-Wuerttemberg"].rrule(rrule_fronl)
rr_dict["Baden-Wuerttemberg"].rrule(rrule_einheit)
rr_dict["Baden-Wuerttemberg"].rrule(rrule_allerh)
rr_dict["Baden-Wuerttemberg"].rrule(rrule_xmas_1)
rr_dict["Baden-Wuerttemberg"].rrule(rrule_xmas_2)

rr_dict["Bayern"] = dateutil.rrule.rruleset()
rr_dict["Bayern"].rrule(rrule_sonntag)
rr_dict["Bayern"].rrule(rrule_neujahr)
rr_dict["Bayern"].rrule(rrule_dreik)
rr_dict["Bayern"].rrule(rrule_karf)
rr_dict["Bayern"].rrule(rrule_ostermo)
rr_dict["Bayern"].rrule(rrule_mai)
rr_dict["Bayern"].rrule(rrule_himmelf)
rr_dict["Bayern"].rrule(rrule_pfingst)
rr_dict["Bayern"].rrule(rrule_fronl)
rr_dict["Bayern"].rrule(rrule_einheit)
rr_dict["Bayern"].rrule(rrule_allerh)
rr_dict["Bayern"].rrule(rrule_xmas_1)
rr_dict["Bayern"].rrule(rrule_xmas_2)

rr_dict["Berlin"] = dateutil.rrule.rruleset()
rr_dict["Berlin"].rrule(rrule_sonntag)
rr_dict["Berlin"].rrule(rrule_neujahr)
rr_dict["Berlin"].rrule(rrule_frauent)
rr_dict["Berlin"].rrule(rrule_karf)
rr_dict["Berlin"].rrule(rrule_ostermo)
rr_dict["Berlin"].rrule(rrule_mai)
rr_dict["Berlin"].rrule(rrule_himmelf)
rr_dict["Berlin"].rrule(rrule_pfingst)
rr_dict["Berlin"].rrule(rrule_einheit)
rr_dict["Berlin"].rrule(rrule_xmas_1)
rr_dict["Berlin"].rrule(rrule_xmas_2)

rr_dict["Brandenburg"] = dateutil.rrule.rruleset()
rr_dict["Brandenburg"].rrule(rrule_sonntag)
rr_dict["Brandenburg"].rrule(rrule_neujahr)
rr_dict["Brandenburg"].rrule(rrule_karf)
rr_dict["Brandenburg"].rrule(rrule_ostermo)
rr_dict["Brandenburg"].rrule(rrule_mai)
rr_dict["Brandenburg"].rrule(rrule_himmelf)
rr_dict["Brandenburg"].rrule(rrule_pfingst)
rr_dict["Brandenburg"].rrule(rrule_einheit)
rr_dict["Brandenburg"].rrule(rrule_reform)
rr_dict["Brandenburg"].rrule(rrule_xmas_1)
rr_dict["Brandenburg"].rrule(rrule_xmas_2)

rr_dict["Bremen"] = dateutil.rrule.rruleset()
rr_dict["Bremen"].rrule(rrule_sonntag)
rr_dict["Bremen"].rrule(rrule_neujahr)
rr_dict["Bremen"].rrule(rrule_karf)
rr_dict["Bremen"].rrule(rrule_ostermo)
rr_dict["Bremen"].rrule(rrule_mai)
rr_dict["Bremen"].rrule(rrule_himmelf)
rr_dict["Bremen"].rrule(rrule_pfingst)
rr_dict["Bremen"].rrule(rrule_einheit)
rr_dict["Bremen"].rrule(rrule_reform)
rr_dict["Bremen"].rrule(rrule_xmas_1)
rr_dict["Bremen"].rrule(rrule_xmas_2)

rr_dict["Hamburg"] = dateutil.rrule.rruleset()
rr_dict["Hamburg"].rrule(rrule_sonntag)
rr_dict["Hamburg"].rrule(rrule_neujahr)
rr_dict["Hamburg"].rrule(rrule_karf)
rr_dict["Hamburg"].rrule(rrule_ostermo)
rr_dict["Hamburg"].rrule(rrule_mai)
rr_dict["Hamburg"].rrule(rrule_himmelf)
rr_dict["Hamburg"].rrule(rrule_pfingst)
rr_dict["Hamburg"].rrule(rrule_einheit)
rr_dict["Hamburg"].rrule(rrule_reform)
rr_dict["Hamburg"].rrule(rrule_xmas_1)
rr_dict["Hamburg"].rrule(rrule_xmas_2)

rr_dict["Hessen"] = dateutil.rrule.rruleset()
rr_dict["Hessen"].rrule(rrule_sonntag)
rr_dict["Hessen"].rrule(rrule_neujahr)
rr_dict["Hessen"].rrule(rrule_karf)
rr_dict["Hessen"].rrule(rrule_ostermo)
rr_dict["Hessen"].rrule(rrule_mai)
rr_dict["Hessen"].rrule(rrule_himmelf)
rr_dict["Hessen"].rrule(rrule_pfingst)
rr_dict["Hessen"].rrule(rrule_fronl)
rr_dict["Hessen"].rrule(rrule_einheit)
rr_dict["Hessen"].rrule(rrule_xmas_1)
rr_dict["Hessen"].rrule(rrule_xmas_2)

rr_dict["Mecklenburg-Vorpommern"] = dateutil.rrule.rruleset()
rr_dict["Mecklenburg-Vorpommern"].rrule(rrule_sonntag)
rr_dict["Mecklenburg-Vorpommern"].rrule(rrule_neujahr)
rr_dict["Mecklenburg-Vorpommern"].rrule(rrule_karf)
rr_dict["Mecklenburg-Vorpommern"].rrule(rrule_ostermo)
rr_dict["Mecklenburg-Vorpommern"].rrule(rrule_mai)
rr_dict["Mecklenburg-Vorpommern"].rrule(rrule_himmelf)
rr_dict["Mecklenburg-Vorpommern"].rrule(rrule_pfingst)
rr_dict["Mecklenburg-Vorpommern"].rrule(rrule_einheit)
rr_dict["Mecklenburg-Vorpommern"].rrule(rrule_reform)
rr_dict["Mecklenburg-Vorpommern"].rrule(rrule_xmas_1)
rr_dict["Mecklenburg-Vorpommern"].rrule(rrule_xmas_2)

rr_dict["Niedersachsen"] = dateutil.rrule.rruleset()
rr_dict["Niedersachsen"].rrule(rrule_sonntag)
rr_dict["Niedersachsen"].rrule(rrule_neujahr)
rr_dict["Niedersachsen"].rrule(rrule_karf)
rr_dict["Niedersachsen"].rrule(rrule_ostermo)
rr_dict["Niedersachsen"].rrule(rrule_mai)
rr_dict["Niedersachsen"].rrule(rrule_himmelf)
rr_dict["Niedersachsen"].rrule(rrule_pfingst)
rr_dict["Niedersachsen"].rrule(rrule_einheit)
rr_dict["Niedersachsen"].rrule(rrule_reform)
rr_dict["Niedersachsen"].rrule(rrule_xmas_1)
rr_dict["Niedersachsen"].rrule(rrule_xmas_2)

rr_dict["Nordrhein-Westfalen"] = dateutil.rrule.rruleset()
rr_dict["Nordrhein-Westfalen"].rrule(rrule_sonntag)
rr_dict["Nordrhein-Westfalen"].rrule(rrule_neujahr)
rr_dict["Nordrhein-Westfalen"].rrule(rrule_karf)
rr_dict["Nordrhein-Westfalen"].rrule(rrule_ostermo)
rr_dict["Nordrhein-Westfalen"].rrule(rrule_mai)
rr_dict["Nordrhein-Westfalen"].rrule(rrule_himmelf)
rr_dict["Nordrhein-Westfalen"].rrule(rrule_pfingst)
rr_dict["Nordrhein-Westfalen"].rrule(rrule_fronl)
rr_dict["Nordrhein-Westfalen"].rrule(rrule_einheit)
rr_dict["Nordrhein-Westfalen"].rrule(rrule_allerh)
rr_dict["Nordrhein-Westfalen"].rrule(rrule_xmas_1)
rr_dict["Nordrhein-Westfalen"].rrule(rrule_xmas_2)

rr_dict["Rheinland-Pfalz"] = dateutil.rrule.rruleset()
rr_dict["Rheinland-Pfalz"].rrule(rrule_sonntag)
rr_dict["Rheinland-Pfalz"].rrule(rrule_neujahr)
rr_dict["Rheinland-Pfalz"].rrule(rrule_karf)
rr_dict["Rheinland-Pfalz"].rrule(rrule_ostermo)
rr_dict["Rheinland-Pfalz"].rrule(rrule_mai)
rr_dict["Rheinland-Pfalz"].rrule(rrule_himmelf)
rr_dict["Rheinland-Pfalz"].rrule(rrule_pfingst)
rr_dict["Rheinland-Pfalz"].rrule(rrule_fronl)
rr_dict["Rheinland-Pfalz"].rrule(rrule_einheit)
rr_dict["Rheinland-Pfalz"].rrule(rrule_allerh)
rr_dict["Rheinland-Pfalz"].rrule(rrule_xmas_1)
rr_dict["Rheinland-Pfalz"].rrule(rrule_xmas_2)

rr_dict["Saarland"] = dateutil.rrule.rruleset()
rr_dict["Saarland"].rrule(rrule_sonntag)
rr_dict["Saarland"].rrule(rrule_neujahr)
rr_dict["Saarland"].rrule(rrule_karf)
rr_dict["Saarland"].rrule(rrule_ostermo)
rr_dict["Saarland"].rrule(rrule_mai)
rr_dict["Saarland"].rrule(rrule_himmelf)
rr_dict["Saarland"].rrule(rrule_pfingst)
rr_dict["Saarland"].rrule(rrule_fronl)
rr_dict["Saarland"].rrule(rrule_mariaeh)
rr_dict["Saarland"].rrule(rrule_einheit)
rr_dict["Saarland"].rrule(rrule_allerh)
rr_dict["Saarland"].rrule(rrule_xmas_1)
rr_dict["Saarland"].rrule(rrule_xmas_2)

rr_dict["Sachsen"] = dateutil.rrule.rruleset()
rr_dict["Sachsen"].rrule(rrule_sonntag)
rr_dict["Sachsen"].rrule(rrule_neujahr)
rr_dict["Sachsen"].rrule(rrule_karf)
rr_dict["Sachsen"].rrule(rrule_ostermo)
rr_dict["Sachsen"].rrule(rrule_mai)
rr_dict["Sachsen"].rrule(rrule_himmelf)
rr_dict["Sachsen"].rrule(rrule_pfingst)
rr_dict["Sachsen"].rrule(rrule_einheit)
rr_dict["Sachsen"].rrule(rrule_reform)
rr_dict["Sachsen"].rrule(rrule_bubt)
rr_dict["Sachsen"].rrule(rrule_xmas_1)
rr_dict["Sachsen"].rrule(rrule_xmas_2)

rr_dict["Sachsen-Anhalt"] = dateutil.rrule.rruleset()
rr_dict["Sachsen-Anhalt"].rrule(rrule_sonntag)
rr_dict["Sachsen-Anhalt"].rrule(rrule_neujahr)
rr_dict["Sachsen-Anhalt"].rrule(rrule_dreik)
rr_dict["Sachsen-Anhalt"].rrule(rrule_karf)
rr_dict["Sachsen-Anhalt"].rrule(rrule_ostermo)
rr_dict["Sachsen-Anhalt"].rrule(rrule_mai)
rr_dict["Sachsen-Anhalt"].rrule(rrule_himmelf)
rr_dict["Sachsen-Anhalt"].rrule(rrule_pfingst)
rr_dict["Sachsen-Anhalt"].rrule(rrule_einheit)
rr_dict["Sachsen-Anhalt"].rrule(rrule_reform)
rr_dict["Sachsen-Anhalt"].rrule(rrule_xmas_1)
rr_dict["Sachsen-Anhalt"].rrule(rrule_xmas_2)

rr_dict["Schleswig-Holstein"] = dateutil.rrule.rruleset()
rr_dict["Schleswig-Holstein"].rrule(rrule_sonntag)
rr_dict["Schleswig-Holstein"].rrule(rrule_neujahr)
rr_dict["Schleswig-Holstein"].rrule(rrule_karf)
rr_dict["Schleswig-Holstein"].rrule(rrule_ostermo)
rr_dict["Schleswig-Holstein"].rrule(rrule_mai)
rr_dict["Schleswig-Holstein"].rrule(rrule_himmelf)
rr_dict["Schleswig-Holstein"].rrule(rrule_pfingst)
rr_dict["Schleswig-Holstein"].rrule(rrule_einheit)
rr_dict["Schleswig-Holstein"].rrule(rrule_reform)
rr_dict["Schleswig-Holstein"].rrule(rrule_xmas_1)
rr_dict["Schleswig-Holstein"].rrule(rrule_xmas_2)

rr_dict["Thueringen"] = dateutil.rrule.rruleset()
rr_dict["Thueringen"].rrule(rrule_sonntag)
rr_dict["Thueringen"].rrule(rrule_neujahr)
rr_dict["Thueringen"].rrule(rrule_karf)
rr_dict["Thueringen"].rrule(rrule_ostermo)
rr_dict["Thueringen"].rrule(rrule_mai)
rr_dict["Thueringen"].rrule(rrule_himmelf)
rr_dict["Thueringen"].rrule(rrule_pfingst)
rr_dict["Thueringen"].rrule(rrule_kindert)
rr_dict["Thueringen"].rrule(rrule_einheit)
rr_dict["Thueringen"].rrule(rrule_reform)
rr_dict["Thueringen"].rrule(rrule_xmas_1)
rr_dict["Thueringen"].rrule(rrule_xmas_2)

#
# Einige Hilfsprozeduren:

def get_col(day, weekday):
 """Ermittelt, in der wievielten Woche des Monats der Tag day
    enthalten ist.  Zählung beginnt mit 0."""
 col_cand = day // 7
 row_cand = day %  7
 if (weekday < row_cand):
  col_cand += 1
 return col_cand

def get_weekday_name(weekday):
 """Schreibt die abgekürzten Wochentagsbezeichnungen aus."""
 if   (weekday == 0):
  return locale.nl_langinfo(locale.ABDAY_2)
 elif (weekday == 1):
  return locale.nl_langinfo(locale.ABDAY_3)
 elif (weekday == 2):
  return locale.nl_langinfo(locale.ABDAY_4)
 elif (weekday == 3):
  return locale.nl_langinfo(locale.ABDAY_5)
 elif (weekday == 4):
  return locale.nl_langinfo(locale.ABDAY_6)
 elif (weekday == 5):
  return locale.nl_langinfo(locale.ABDAY_7)
 elif (weekday == 6):
  return locale.nl_langinfo(locale.ABDAY_1)

def get_month_name(month):
 """Schreibt den Monatsnamen aus."""
 if   (month == 1):
  return locale.nl_langinfo(locale.MON_1)
 elif (month == 2):
  return locale.nl_langinfo(locale.MON_2)
 elif (month == 3):
  return locale.nl_langinfo(locale.MON_3)
 elif (month == 4):
  return locale.nl_langinfo(locale.MON_4)
 elif (month == 5):
  return locale.nl_langinfo(locale.MON_5)
 elif (month == 6):
  return locale.nl_langinfo(locale.MON_6)
 elif (month == 7):
  return locale.nl_langinfo(locale.MON_7)
 elif (month == 8):
  return locale.nl_langinfo(locale.MON_8)
 elif (month == 9):
  return locale.nl_langinfo(locale.MON_9)
 elif (month == 10):
  return locale.nl_langinfo(locale.MON_10)
 elif (month == 11):
  return locale.nl_langinfo(locale.MON_11)
 elif (month == 12):
  return locale.nl_langinfo(locale.MON_12)

def setcolor(rr, month, day, canvas):
 """Richtige Farbe für den entsprechenden Tag wählen"""
 if (datetime.datetime(cmdline_args.year, month, day, 0, 0, 0) in rr):
  canvas.setFillColorRGB(RGB_free[0], RGB_free[1], RGB_free[2])
 else:
  canvas.setFillColorRGB(RGB_work[0], RGB_work[1], RGB_work[2])

def coeff_R2(c, (x, y)):
 """Multipliziert c in R mit Vektor (x, y) in R^2"""
 return (c * x, c * y)

def add_R2((x_1, y_1), (x_2, y_2)):
 """Addiert zwei Vektoren (x_1, y_1), (x_2, y_2)"""
 return (x_1 + x_2, y_1 + y_2)

###################################


locale.setlocale(locale.LC_ALL, "")


#
#
# Kommandozeilenparameter auswerten:
#
cmdline = argparse.ArgumentParser(
 description = """...baut Wandkalender in Form von PDF-Dateien zum
                  Ausdrucken und Aufhängen""")
countries =  list(rr_dict.keys())
countries.sort()
cmdline.add_argument("country", choices = countries, help = "Bundesland")
cmdline.add_argument("year", type = int, help = "Jahr")
cmdline_args = cmdline.parse_args()
#
# cmdline_args.country enthält das Bundesland
# cmdline_args.year enthält jetzt das Jahr
#
#

#
#

rr =  rr_dict[cmdline_args.country]
 
filename_out = str(cmdline_args.year).zfill(4) + ".PDF"

#
#
# Kalender bauen
#

calendar = calendar.Calendar()
canvas   = reportlab.pdfgen.canvas.Canvas(filename_out)

for month in range(1, 13):
 month_name  = get_month_name(month)
 filename_in = str(cmdline_args.year).zfill(4) + "-" + \
  str(month).zfill(2) + ".JPG"
 canvas.rotate(90)
 canvas.setFont("Helvetica", 25)
 canvas.setFillColorRGB(RGB_standard[0], RGB_standard[1], RGB_standard[2])
 canvas.drawString(month_name_place[0], month_name_place[1], month_name)
 canvas.drawImage(filename_in, pic_place[0], pic_place[1],
  width = pic_dim[0], height = pic_dim[1])
 for weekday_panel in weekday_panel_places:
  for weekday in range(0, 7):
   weekday_name = get_weekday_name(weekday)
   position     = add_R2(weekday_panel, coeff_R2(weekday, diff_day))
   canvas.drawString(position[0], position[1], weekday_name) 
 imageMetadata = pyexiv2.ImageMetadata(filename_in)
 imageMetadata.read()
 if ('Exif.Photo.UserComment' in imageMetadata.exif_keys):
  metadata = imageMetadata['Exif.Photo.UserComment'].value
  canvas.setFont("Helvetica", 13)
  canvas.drawString(capt_place[0], capt_place[1], metadata)
 canvas.setFont("Helvetica", 25)
 for (day, weekday) in calendar.itermonthdays2(cmdline_args.year, month):
  if (day == 0):
   continue

  weekday_name = get_weekday_name(weekday)
  col = get_col(day, weekday)
  position = add_R2(day_places[col], coeff_R2(weekday, diff_day))
  setcolor(rr, month, day, canvas)
  canvas.drawRightString(position[0], position[1], str(day))
 canvas.showPage()
canvas.save()

#
#
#
#
