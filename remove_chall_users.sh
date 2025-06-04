#!/bin/bash

users=(chall1 chall2 chall3 chall4 chall5 chall6 chall7 chall8 )

for user in "${users[@]}"; do
    sudo userdel -r -f "$user" 2>/dev/null
done

if grep -q "^AllowUsers" /etc/ssh/sshd_config; then
    sudo sed -i 's/\(AllowUsers.*\)\(chall1\|chall2\|chall3\|chall4\|chall5\|chall6\|chall7\|chall8\)\s*//g' /etc/ssh/sshd_config
fi

sudo systemctl restart ssh || sudo service ssh restart

echo "[+] Đã xóa toàn bộ user challenge và cập nhật sshd_config."
