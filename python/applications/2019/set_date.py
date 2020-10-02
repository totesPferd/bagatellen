#!/usr/bin/env python3
import datetime

today =  datetime.date.today()

month_list = [ "Januar", "Februar", "M\\\"arz", "April", "Mai", "Juni", "Juli", "August", "September", "Oktober", "November", "Dezember" ]

with open("date.tex", "w") as fd:
   fd.write("%d.~%s~%d\n" % (today.day, month_list[today.month - 1], today.year))
