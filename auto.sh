#!/bin/bash
# Tạo tên file với timestamp của ngày hiện tại
file_name="$(date +'%Y-%m-%d_%H-%M-%S').py"

# Tạo một file Python mới và ghi vào file
echo -e "print('Hello, $(date +'%Y-%m-%d')')" > "$file_name"

# In ra màn hình "Hello" cùng với ngày hiện tại
echo "Hello, $(date +'%Y-%m-%d')"

# Thực hiện các thao tác git (đẩy code lên GitHub)
git add .
git commit -m "Automated commit $(date +'%Y-%m-%d')"
git push origin main
