#!/usr/bin/expect
set pass [lindex $argv 0]
set encrypted [lindex $argv 1]
log_user 0
spawn "/usr/local/bin/gitload-Initialisation.sh" "$encrypted"
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