str = "Thu Jan 14 18:20:01.968620 2016"
r1 = /\w{3} \w{3} \d{2} \d{2}:\d{2}:\d{2}.\d{3}/
r2 = /\d{4}$/
str1 = str.scan(r1)[0]
str2 = str.scan(r2)[0]

# p str1+" "+str2
# p r1.match(str)
# p /^(?<ip>\d+\.\d+\.\d+\.\d+)/.match('10.254.0.201 - - [14/Jan/2016:18:20:10 +0800] "GET /do_not_delete/noc.gif HTTP/1.1" 200 1770')['ip']
# p /^(?:[^ ]+ ){9}(?<bytes>\d+)/.match('10.254.0.201 - - [14/Jan/2016:18:20:03 +0800] "GET /tv/mlxc/style/style.css?0fc018efbc4b59435f227d0f823c02a3 HTTP/1.1" 200 15882')['bytes']
# p /^(?:[^ ]+ ){9}(?<bytes>\d+|\-)/.match('10.254.0.201 - - [14/Jan/2016:18:19:57 +0800] "GET /20150910/ARTI1441845973134744.shtml HTTP/1.1" 200 51344')['bytes']
# p /^(?:[^ ]+ ){9}(?<bytes>\d+|\-)/.match('10.254.0.201 - - [14/Jan/2016:18:19:57 +0800] "GET /20150910/ARTI1441845973134744.shtml HTTP/1.1" 200 51344')['bytes']
# p /^(?:[^ ]+ ){7}HTTP\/(?<http>\d+\.\d+)/.match('10.254.0.201 - - [14/Jan/2016:18:19:57 +0800] "GET /20150910/ARTI1441845973134744.shtml HTTP/1.1" 200 51344')['http']
# p /^(?:[^ ]+ ){8}(?<statuscode>\d+)/.match('10.254.0.201 - - [14/Jan/2016:18:19:57 +0800] "GET /20150910/ARTI1441845973134744.shtml HTTP/1.1" 200 51344')['statuscode']
# p /^(?:[^ ]+ ){9}(?<bytes>\d+|\-)/.match('10.254.0.201 - - [14/Jan/2016:18:19:57 +0800] "GET /20150910/ARTI1441845973134744.shtml HTTP/1.1" 200 51344')['bytes']
# p /^(?:[^ ]+ ){3}\[(?<bytes>\w+\/\w+\/\w+:\w+:\w+:\w+ \+\w+)\]/.match('10.254.0.201 - - [14/Jan/2016:18:19:57 +0800] "GET /20150910/ARTI1441845973134744.shtml HTTP/1.1" 200 51344')['bytes']

str = '10.254.0.156 - - [13/Jan/2016:08:30:03 +0800] "HEAD /pcheck.html HTTP/1.0" 404 -'
# str = '10.254.0.201 - - [13/Jan/2016:08:29:59 +0800] "GET /20151225/ARTI1451003920154546.shtml HTTP/1.1" 200 47502'
str = '10.254.0.201 - - [13/Jan/2016:08:36:49 +0800] "GET / HTTP/1.1" 403 209'
# p /^(?:[^\042]+\042){2} (?<test>\d+)/.match(str)['test']
# p /^(?:[^\042]+\042){2} \d+[ ]+(?<test>\d+|\-)/.match(str)['test']
# p /^(?:[^ ]+ ){7}HTTP\/(?<test>\d+\.\d+)/.match(str)['test']
str = '10.254.0.150 - - [13/Jan/2016:08:36:50 +0800] "-" 408 -'
# p str.include?('"-"')
# p str.index('\"-\"')
# p /^(?:[^\"]+\"){1}(?<test>.*)(?:\"[^\"]+)/.match(str)['test'].include?('-')
# p /^(?:[^ ]+ ){5}(?<test>\"-\")/.match(str)['test'].length > 0  

# str = '10.254.0.201 - - [13/Jan/2016:08:31:42 +0800] "GET /?q=print-439573653*57;&w=print-439573653*57;&e=print-439573653*57;&r=print-439573653*57;&t=print-439573653*57;&y=print-439573653*57;&u=print-439573653*57;&i=print-439573653*57;&o=print-439573653*57;&p=print-439573653*57;&a=print-439573653*57;&s=print-439573653*57;&d=print-439573653*57;&f=print-439573653*57;&g=print-439573653*57;&h=print-439573653*57;&j=print-439573653*57;&k=print-439573653*57;&l=print-439573653*57;&z=print-439573653*57;&x=print-439573653*57;&c=print-439573653*57;&v=print-439573653*57;&b=print-439573653*57;&n=print-439573653*57;&m=print-439573653*57;&1=print-439573653*57;&2=print-439573653*57;&3=print-439573653*57;&4=print-439573653*57;&5=print-439573653*57;&6=print-439573653*57;&7=print-439573653*57;&8=print-439573653*57;&9=print-439573653*57;&0=print-439573653*57;&asc=print-439573653*57;&cmd=print-439573653*57;&ev=print-439573653*57;&ss=print-439573653*57;&dir=print-439573653*57;&code=print-439573653*57; HTTP/1.1" 200 114782'
str = '10.254.0.201 - - [13/Jan/2016:08:30:02 +0800] "GET /tv/special/woman/style/main.js?def365ad7d8a89944b1c9db4523ff9a1 HTTP/1.1" 304 -'
str = '10.254.0.202 - - [13/Jan/2016:08:30:02 +0800] "GET http://zc.qq.com/cgi-bin/iframe/othmailreg/init_16?r=0.00248238630708418 HTTP/1.1" 404 989'
# 10.254.0.201 - - [13/Jan/2016:08:30:03 +0800] "GET /do_not_delete/noc.gif HTTP/1.1" 404 -
str = '10.254.0.201 - - [13/Jan/2016:08:30:02 +0800] "GET /yiyuwenhua/ HTTP/1.1" 200 534915'
# 10.254.0.201 - - [13/Jan/2016:08:30:03 +0800] "GET /20150108/ARTI1420677644841560.shtml HTTP/1.1" 200 48755
# 10.254.0.201 - - [13/Jan/2016:08:30:02 +0800] "GET /20151014/VIDE1444754326374806.shtml HTTP/1.1" 200 31836
# 10.254.0.201 - - [13/Jan/2016:08:30:03 +0800] "GET /do_not_delete/noc.gif HTTP/1.1" 404 -
# 10.254.0.201 - - [13/Jan/2016:08:30:03 +0800] "GET /do_not_delete/noc.gif HTTP/1.1" 404 -
str = '10.254.0.201 - - [13/Jan/2016:08:30:03 +0800] "GET /20150107/ARTI1420590645043409.shtml HTTP/1.1" 200 47266'
# 10.254.0.201 - - [13/Jan/2016:08:30:03 +0800] "GET /do_not_delete/noc.gif HTTP/1.1" 200 1770
# str = '10.254.0.156 - - [13/Jan/2016:08:30:03 +0800] "HEAD /pcheck.html HTTP/1.0" 404 -'
# 10.254.0.201 - - [13/Jan/2016:08:30:03 +0800] "GET /do_not_delete/noc.gif HTTP/1.1" 404 -
# 10.254.0.201 - - [13/Jan/2016:08:30:03 +0800] "GET /do_not_delete/noc.gif HTTP/1.1" 404 -
# 10.254.0.201 - - [13/Jan/2016:08:30:03 +0800] "GET /do_not_delete/noc.gif HTTP/1.1" 200 1770
# 10.254.0.201 - - [13/Jan/2016:08:30:03 +0800] "GET /do_not_delete/noc.gif HTTP/1.1" 404 -
# str = '10.254.0.201 - - [13/Jan/2016:08:30:03 +0800] "GET / HTTP/1.1" 200 114782'
# 10.254.0.201 - - [13/Jan/2016:08:30:04 +0800] "GET /do_not_delete/noc.gif HTTP/1.1" 200 1770

str = '10.254.0.201 - - [13/Jan/2016:07:44:52 +0800] "GET /?ub16e\" HTTP/1.1" 200 61335'

p /^(?:[^\"]+\"){1}(?<test>.*)(?:\"[^\"]+)/.match(str)['test'] == '-'
p str.include?('/?ub16e')
p /^(?<ip>\d+\.\d+\.\d+\.\d+)/.match(str)['ip']
p /^[^\"]+\"(?<method>[A-Za-z]+)/.match(str)['method']
p /^(?:[^ ]+ ){6}(?<resource>[^ ]+)/.match(str)['resource']
p /^(?:[^ ]+ ){7}HTTP\/(?<http>\d+\.\d+)/.match(str)['http']
p /^(?:[^\042]+\042){3} (?<statuscode>\d+)/.match(str)['statuscode']	
p /^(?:[^\042]+\042){3} \d+[ ]+(?<bytes>\d+|\-)/.match(str)['bytes']
p /^(?:[^ ]+ ){3}\[(?<time>\w+\/\w+\/\w+:\w+:\w+:\w+ \+\w+)\]/.match(str)['time']



# str = '::1 - - [13/Jan/2016:08:36:50 +0800] "OPTIONS * HTTP/1.0" 200 -'
# p /^(?:[^\/]+\/){3}(?<http>\d+\.\d+)/.match(str)['http']
# p /^(?:[^ ]+ ){8}(?<statuscode>\d+)/.match(str)['statuscode']
# p /^(?:[^ ]+ ){3}\[(?<time>\w+\/\w+\/\w+:\w+:\w+:\w+ \+\w+)\]/.match(str)['time']

# p /^(?:[^\/]+\/){3}(?<http>\d+\.\d+)/.match('::1 - - [14/Jan/2016:18:20:00 +0800] "OPTIONS * HTTP/1.0" 200 -')['http']
# p /^(?:[^ ]+ ){8}(?<statuscode>\d+)/.match('::1 - - [14/Jan/2016:18:20:00 +0800] "OPTIONS * HTTP/1.0" 200 -')['statuscode']
# p /^(?:[^ ]+ ){3}\[(?<statuscode>\w+\/\w+\/\w+:\w+:\w+:\w+ \+\w+)\]/.match('::1 - - [14/Jan/2016:18:20:00 +0800] "OPTIONS * HTTP/1.0" 200 -')['statuscode']

# p /^\[(?<time>[A-Za-z]+ [A-Za-z]+ \d+ \d+:\d+:\d+\.\d+ \d+)/.match('[Thu Jan 14 18:20:01.766188 2016] [include:error] [pid 22780] [client 10.254.0.201:54991] unable to include "/including/xdcbhy/index.shtml" in parsed file /data-1T/webserver/finance/20150217/ARTI1424125085937229.shtml, subrequest setup returned 403')['time']
# p /^(?:[^ ]+ ){5}\[(?<time>[\w]+)\:/.match('[Thu Jan 14 18:20:01.766188 2016] [include:error] [pid 22780] [client 10.254.0.201:54991] unable to include "/including/xdcbhy/index.shtml" in parsed file /data-1T/webserver/finance/20150217/ARTI1424125085937229.shtml, subrequest setup returned 403')['time']
# p /^(?:[^ ]+ ){5}\[\w+:(?<time>[\w]+)\]/.match('[Thu Jan 14 18:20:01.766188 2016] [include:error] [pid 22780] [client 10.254.0.201:54991] unable to include "/including/xdcbhy/index.shtml" in parsed file /data-1T/webserver/finance/20150217/ARTI1424125085937229.shtml, subrequest setup returned 403')['time']
# p /^(?:[^ ]+ ){7}(?<time>[\w]+)]/.match('[Thu Jan 14 18:20:01.766188 2016] [include:error] [pid 22780] [client 10.254.0.201:54991] unable to include "/including/xdcbhy/index.shtml" in parsed file /data-1T/webserver/finance/20150217/ARTI1424125085937229.shtml, subrequest setup returned 403')['time']
# p /^(?:[^ ]+ ){9}(?<time>\d+.\d+.\d+.\d+)/.match('[Thu Jan 14 18:20:01.766188 2016] [include:error] [pid 22780] [client 10.254.0.201:54991] unable to include "/including/xdcbhy/index.shtml" in parsed file /data-1T/webserver/finance/20150217/ARTI1424125085937229.shtml, subrequest setup returned 403')['time']
# p /^(?:[^ ]+ ){9}\d+.\d+.\d+.\d+\:(?<time>\d+)/.match('[Thu Jan 14 18:20:01.766188 2016] [include:error] [pid 22780] [client 10.254.0.201:54991] unable to include "/including/xdcbhy/index.shtml" in parsed file /data-1T/webserver/finance/20150217/ARTI1424125085937229.shtml, subrequest setup returned 403')['time']
# p /^(?:[^ ]+ ){10}(?<time>.*)$/.match('[Thu Jan 14 18:20:01.766188 2016] [include:error] [pid 22780] [client 10.254.0.201:54991] unable to include "/including/xdcbhy/index.shtml" in parsed file /data-1T/webserver/finance/20150217/ARTI1424125085937229.shtml, subrequest setup returned 403')['time']
# p /^\[(?:[^\[]+\[){3}client (?<test>\d+.\d+.\d+.\d+)/.match("[Wed Jan 13 13:24:47.356206 2016] [core:error] [pid 18374] (61)No data available: [client 10.254.0.201:60982] AH00036: access to /btvsports/ttrdsp/index.shtml failed (filesystem path '/data-1T/webserver/tv/btvsports/ttrdsp/index.shtml'), referer: http://www.brtn.cn/wzdt/")['test']
# p /^\[(?:[^\[]+\[){3}client \d+.\d+.\d+.\d+:(?<test>\d+)/.match("[Wed Jan 13 13:24:47.356206 2016] [core:error] [pid 18374] (61)No data available: [client 10.254.0.201:60982] AH00036: access to /btvsports/ttrdsp/index.shtml failed (filesystem path '/data-1T/webserver/tv/btvsports/ttrdsp/index.shtml'), referer: http://www.brtn.cn/wzdt/")['test']
# p /^\[(?:[^\[]+\[){3}client \d+.\d+.\d+.\d+:(?<test>\d+)/.match('[Wed Jan 13 13:24:07.120816 2016] [include:error] [pid 18309] [client 10.254.0.201:55655] unable to include "/bhy/kbhy/index.shtml" in parsed file /data-1T/webserver/gongyi/20150914/VIDE1442226375477260.shtml, subrequest returned 404')['test']
# p /^\[(?:[^\[]+\[){3}client (?<test>\d+.\d+.\d+.\d+)/.match('[Wed Jan 13 13:24:07.120816 2016] [include:error] [pid 18309] [client 10.254.0.201:55655] unable to include "/bhy/kbhy/index.shtml" in parsed file /data-1T/webserver/gongyi/20150914/VIDE1442226375477260.shtml, subrequest returned 404')['test']