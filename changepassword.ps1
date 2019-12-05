$oldpassword "abcefg"
$newpassword "abcedfg"

Set-ADAccountPassword -Identity esposij- -OldPassword (ConvertTo-SecureString -AsPlainText $oldpassword -force) -NewPassword (ConvertTo-SecureString -AsPlainText $newpassword -Force)