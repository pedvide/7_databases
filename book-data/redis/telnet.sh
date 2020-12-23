#---
# Excerpted from "Seven Databases in Seven Weeks",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/pwrdata for more book information.
#---
$ telnet localhost 6379
Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.
SET test hello
+OK
GET test
$5
hello
SADD stest 1 99
:2
SMEMBERS stest
*2
$1
1
$2
99
