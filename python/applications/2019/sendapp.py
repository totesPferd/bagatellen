#!/usr/bin/env python3
import email.mime.application
import email.mime.multipart
import email.mime.text
import getopt
import json
import smtplib
import sys

#--- config area ---
from_addr =  "georgi.rybakov@gmx.net"
local_hostname =  "eva.fritz.box"
smtp_host =  "waltraud.fritz.box"
source_socket =  ("eva.fritz.box", 0)
#--- ---

#--- cmdline parsing. ---
attach_filename =  "cv_and_certs.pdf"
config_file =  "data.json"
text_file =  "text"
output_file =  "Bewerbung"

def usage(f):
   f.write("python -m <script_name> [[-a|--attachment=]<attachment pdf file>] [[-c|--cfg=]<config file name>] [[-o|--output=]<output file name>] [[-t|--text=]<inline text>]\n")

try:
   opts, args =  getopt.getopt(sys.argv[1:], "a:c:ho:t:", ["attachment=", "cfg=", "help", "output=", "text="])
except:
   sys.exit(2)

for o, a in opts:
   if o in ("-a", "--attachment="):
      attach_filename =  a
   elif o in ("-c", "--cfg="):
      config_file =  a
   elif o in ("-h", "--help"):
      usage(sys.stdout)
      sys.exit(0)
   elif o in ("-o", "--output="):
      output_file =  a
   elif o in ("-t", "--text="):
      text_file =  a
   else:
      sys.stderr.write("undefined cmdline option %s%s\n" % (o, a))
      usage(sys.stderr)
      sys.exit(2)
#--- ---

#--- config file parsing ---
try:
   with open(config_file, "r") as fd:
      try:
         config_data =  json.load(fd)
      except json.JSONDecodeError:
         sys.stderr.write("JSON syntax problem in config \"%s\"\n" % (config_file))
         sys.exit(2)
except FileNotFoundError:
   sys.stderr.write("config file \"%s\" not found\n" % (config_file))
   sys.exit(2)

if "email" in config_data.keys():
   email_config_data =  config_data["email"]
else:
   sys.stderr.write("\"email:\" param expected in %s\n" % (config_file))
   sys.exit(2)

if "receiver" in email_config_data.keys():
   to_addr =  email_config_data["receiver"]
else:
   sys.stderr.write("\"email.receiver:\" param expected in %s\n" % (config_file))
   sys.exit(2)

if "subject" in email_config_data.keys():
   subject =  email_config_data["subject"]
else:
   sys.stderr.write("\"email.subject:\" param expected in %s\n" % (config_file))
   sys.exit(2)
#--- ---

msg =  email.mime.multipart.MIMEMultipart()
msg['Subject'] =  subject
msg['From'] =  from_addr
msg['To'] =  to_addr

with open(text_file) as fd:
   base =  email.mime.text.MIMEText(fd.read())
base.add_header("Content-Disposition", "inline")
msg.attach(base)

with open(attach_filename, "rb") as fd:
   attachment =  email.mime.application.MIMEApplication(fd.read(), "pdf")
attachment.add_header("Content-Disposition", "attachment", filename = attach_filename)
msg.attach(attachment)

with open(output_file, "w") as fd:
   fd.write(msg.as_string())

with smtplib.SMTP(smtp_host, local_hostname = local_hostname, source_address = source_socket) as connection:
   connection.set_debuglevel(True)
   connection.send_message(msg)
   connection.quit()
