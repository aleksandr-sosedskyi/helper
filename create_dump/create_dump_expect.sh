#!/usr/bin/expect -f

set sudo_password [lindex $argv 0]
set server [lindex $argv 1]

set timeout -1

# Pass sudo password when prompt
spawn ./create_dump_base.sh $server
expect "*password for*"
send "$sudo_password\r"
expect eof
