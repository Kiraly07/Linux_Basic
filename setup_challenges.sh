#!/bin/bash


users=(chall1 chall2 chall3 chall4 chall5 chall6 chall7 chall8)

flags=(
  "ZmxhZ3sxMnllckMwbW1hbmRfY2F0fQ=="
  "ZmxhZ3syM3JlcEdyZXBfcHJvX3JvbX0="
  "ZmxhZ3szX2ZpbmRfZmlsZV9ub3Rlc30="
  "ZmxhZ3s0X3Rhcl9kZWNvbXByZXNzfQ=="
  "ZmxhZ3s1X2Jhc2U2NF9wbGF5ZXJ9"
  "ZmxhZ3s2X2xpc3RfcGVybWlzc2lvbn0="
  "ZmxhZ3s3X3BzX3N5c3RlbV9pbmZvfQ=="
  "ZmxhZ3sxMF9maW5kX2l0X2FsbH0="
)

echo "[*] Đang tạo các challenge..."

# Chuẩn bị danh sách user cho AllowUsers
allow_users=""

for i in "${!users[@]}"; do
    user=${users[$i]}
    flag=${flags[$i]}


    sudo useradd -m -s /bin/bash $user
    echo "$user:$user" | sudo chpasswd
    sudo usermod -s /bin/bash $user

    home_dir="/home/$user"
    chall_file="$home_dir/challenge.txt"
    flag_file="$home_dir/flag.txt"


    decoded_flag=$(echo "$flag" | base64 -d)


    case $i in
        0)
            echo "Dùng 'cat' để đọc nội dung file flag.txt" > "$chall_file"
            echo "$decoded_flag" > "$flag_file"
            ;;
        1)
            echo "Tìm dòng chứa 'flag' trong log.txt bằng grep" > "$chall_file"
            for i in {1..1000}; do
                echo "$decoded_flag" | rev >> "$home_dir/log.txt"
                done
            echo "$decoded_flag" >> "$home_dir/log.txt"
            for i in {1..500}; do
                echo "$decoded_flag" | rev >> "$home_dir/log.txt"
                done        
                ;;
        2)
            echo "Tìm file flag.txt bị ẩn trong thư mục" > "$chall_file"
            mkdir "$home_dir/hidden"
            echo "$decoded_flag" > "$home_dir/hidden/.flag.txt"
            ;;
        3)
            echo "Giải nén file archive.tar để tìm flag.txt" > "$chall_file"
            mkdir "$home_dir/extract"
            echo "$decoded_flag" > "$home_dir/extract/flag.txt"
            tar -cf "$home_dir/archive.tar" -C "$home_dir/extract" flag.txt
            rm -rf "$home_dir/extract"
            ;;
        4)
            echo "Giải mã file encoded.txt bằng base64" > "$chall_file"
            echo "$flag" > "$home_dir/encoded.txt"
            ;;
        5)
            echo "Cấp quyền thực thi cho file " > "$chall_file"
            echo "echo "$decoded_flag"" > "$home_dir/flag.sh"
            ;;
        6)
            echo "Tìm tất cả file có tên 'flag.txt' bằng 'find'" > "$chall_file"
            mkdir -p "$home_dir/a/b/c/v/z/x/n/m/"
            echo "$decoded_flag" > "$home_dir/a/b/c/v/z/x/n/m/flag.txt"
            ;;
        
        7)
            echo "Tìm tiến trình giả lập đang chứa flag bằng lệnh 'ps'" > "$chall_file"
            sudo -u chall7 bash -c "exec -a $decoded_flag sleep 1000 &"
            ;;
       
    esac

    chown -R $user:$user "$home_dir"
    chmod 700 "$home_dir"

 
    allow_users="$allow_users $user"
done


if ! grep -q "^AllowUsers" /etc/ssh/sshd_config; then
    echo "AllowUsers$allow_users" | sudo tee -a /etc/ssh/sshd_config
else
    sudo sed -i "/^AllowUsers/ s/$/$allow_users/" /etc/ssh/sshd_config
fi


sudo systemctl restart ssh || sudo service ssh restart

echo "[+] Tạo xong 10 challenge. SSH với user:pass tương ứng (vd: chall1/chall1)."
