#!/usr/bin/expect
set pass [lindex $argv 0]
set encrypted [lindex $argv 1]
set basedir [file dirname $argv0]
log_user 0
spawn "$basedir/Initialisation.sh" "$encrypted"
log_user 1

expect {
    "Enter passphrase" {
        send "$pass\r"
        exp_continue
    }
    "Please enter the passphrase to unlock the OpenPGP secret key:" {
        send "$pass\r"
        exp_continue
    }
    eof
}