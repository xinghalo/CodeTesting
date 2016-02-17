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
p /^(?:[^ ]+ ){3}\[(?<bytes>\w+\/\w+\/\w+:\w+:\w+:\w+ \+\w+)\]/.match('10.254.0.201 - - [14/Jan/2016:18:19:57 +0800] "GET /20150910/ARTI1441845973134744.shtml HTTP/1.1" 200 51344')['bytes']

# p /^(?:[^\/]+\/){3}(?<http>\d+\.\d+)/.match('::1 - - [14/Jan/2016:18:20:00 +0800] "OPTIONS * HTTP/1.0" 200 -')['http']
# p /^(?:[^ ]+ ){8}(?<statuscode>\d+)/.match('::1 - - [14/Jan/2016:18:20:00 +0800] "OPTIONS * HTTP/1.0" 200 -')['statuscode']
p /^(?:[^ ]+ ){3}\[(?<statuscode>\w+\/\w+\/\w+:\w+:\w+:\w+ \+\w+)\]/.match('::1 - - [14/Jan/2016:18:20:00 +0800] "OPTIONS * HTTP/1.0" 200 -')['statuscode']

# p /^\[(?<time>[A-Za-z]+ [A-Za-z]+ \d+ \d+:\d+:\d+\.\d+ \d+)/.match('[Thu Jan 14 18:20:01.766188 2016] [include:error] [pid 22780] [client 10.254.0.201:54991] unable to include "/including/xdcbhy/index.shtml" in parsed file /data-1T/webserver/finance/20150217/ARTI1424125085937229.shtml, subrequest setup returned 403')['time']
# p /^(?:[^ ]+ ){5}\[(?<time>[\w]+)\:/.match('[Thu Jan 14 18:20:01.766188 2016] [include:error] [pid 22780] [client 10.254.0.201:54991] unable to include "/including/xdcbhy/index.shtml" in parsed file /data-1T/webserver/finance/20150217/ARTI1424125085937229.shtml, subrequest setup returned 403')['time']
# p /^(?:[^ ]+ ){5}\[\w+:(?<time>[\w]+)\]/.match('[Thu Jan 14 18:20:01.766188 2016] [include:error] [pid 22780] [client 10.254.0.201:54991] unable to include "/including/xdcbhy/index.shtml" in parsed file /data-1T/webserver/finance/20150217/ARTI1424125085937229.shtml, subrequest setup returned 403')['time']
# p /^(?:[^ ]+ ){7}(?<time>[\w]+)]/.match('[Thu Jan 14 18:20:01.766188 2016] [include:error] [pid 22780] [client 10.254.0.201:54991] unable to include "/including/xdcbhy/index.shtml" in parsed file /data-1T/webserver/finance/20150217/ARTI1424125085937229.shtml, subrequest setup returned 403')['time']
# p /^(?:[^ ]+ ){9}(?<time>\d+.\d+.\d+.\d+)/.match('[Thu Jan 14 18:20:01.766188 2016] [include:error] [pid 22780] [client 10.254.0.201:54991] unable to include "/including/xdcbhy/index.shtml" in parsed file /data-1T/webserver/finance/20150217/ARTI1424125085937229.shtml, subrequest setup returned 403')['time']
# p /^(?:[^ ]+ ){9}\d+.\d+.\d+.\d+\:(?<time>\d+)/.match('[Thu Jan 14 18:20:01.766188 2016] [include:error] [pid 22780] [client 10.254.0.201:54991] unable to include "/including/xdcbhy/index.shtml" in parsed file /data-1T/webserver/finance/20150217/ARTI1424125085937229.shtml, subrequest setup returned 403')['time']
# p /^(?:[^ ]+ ){10}(?<time>.*)$/.match('[Thu Jan 14 18:20:01.766188 2016] [include:error] [pid 22780] [client 10.254.0.201:54991] unable to include "/including/xdcbhy/index.shtml" in parsed file /data-1T/webserver/finance/20150217/ARTI1424125085937229.shtml, subrequest setup returned 403')['time']
