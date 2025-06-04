#!/bin/bash

users=(chall1 chall2 chall3 chall4 chall5 chall6 chall7 chall8 chall9 chall10)

for user in "${users[@]}"; do
    sudo userdel -r -f "$user" 2>/dev/null
done

# Xóa các user khỏi AllowUsers trong sshd_config
if grep -q "^AllowUsers" /etc/ssh/sshd_config; then
    sudo sed -i 's/\(AllowUsers.*\)\(chall1\|chall2\|chall3\|chall4\|chall5\|chall6\|chall7\|chall8\|chall9\|chall10\)\s*//g' /etc/ssh/sshd_config
fi

# Khởi động lại dịch vụ SSH để áp dụng thay đổi
sudo systemctl restart ssh || sudo service ssh restart

echo "[+] Đã xóa toàn bộ user challenge và cập nhật sshd_config."
