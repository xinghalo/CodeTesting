str = "Thu Jan 14 18:20:01.968620 2016"
r1 = /\w{3} \w{3} \d{2} \d{2}:\d{2}:\d{2}.\d{3}/
r2 = /\d{4}$/
str1 = str.scan(r1)[0]
str2 = str.scan(r2)[0]

p str1+" "+str2