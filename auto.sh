#!/bin/bash

# Sử dụng ngày hiện tại làm seed để đảm bảo cùng một ngày sẽ có cùng số commit
DATE_SEED=$(date +'%Y-%m-%d')
DAY_NUMBER=$(date -j -f "%Y-%m-%d" "$DATE_SEED" "+%j" 2>/dev/null || date +%j)

# Tạo số ngẫu nhiên dựa trên ngày (0-999)
RANDOM_NUM=$(( (DAY_NUMBER * 17 + 23) % 1000 ))

# Quyết định số lượng commit cho ngày hôm nay (phân phối tự nhiên và đẹp hơn)
# 5% không commit, 8% 1-2 commits, 12% 3-4 commits, 15% 5-6 commits, 
# 20% 7-8 commits, 18% 9-10 commits, 12% 11-12 commits, 7% 13-15 commits, 3% 16-20 commits
if [ $RANDOM_NUM -lt 50 ]; then
    COMMIT_COUNT=0
elif [ $RANDOM_NUM -lt 130 ]; then
    COMMIT_COUNT=$(( 1 + (RANDOM_NUM % 2) ))
elif [ $RANDOM_NUM -lt 250 ]; then
    COMMIT_COUNT=$(( 3 + (RANDOM_NUM % 2) ))
elif [ $RANDOM_NUM -lt 400 ]; then
    COMMIT_COUNT=$(( 5 + (RANDOM_NUM % 2) ))
elif [ $RANDOM_NUM -lt 600 ]; then
    COMMIT_COUNT=$(( 7 + (RANDOM_NUM % 2) ))
elif [ $RANDOM_NUM -lt 780 ]; then
    COMMIT_COUNT=$(( 9 + (RANDOM_NUM % 2) ))
elif [ $RANDOM_NUM -lt 900 ]; then
    COMMIT_COUNT=$(( 11 + (RANDOM_NUM % 2) ))
elif [ $RANDOM_NUM -lt 970 ]; then
    COMMIT_COUNT=$(( 13 + (RANDOM_NUM % 3) ))
else
    COMMIT_COUNT=$(( 16 + (RANDOM_NUM % 5) ))
fi

echo "Date: $DATE_SEED | Random seed: $RANDOM_NUM | Commits today: $COMMIT_COUNT"

# Nếu không có commit nào, thoát
if [ $COMMIT_COUNT -eq 0 ]; then
    echo "No commits scheduled for today. Skipping..."
    exit 0
fi

# Tạo các commit với thời gian ngẫu nhiên trong ngày
for i in $(seq 1 $COMMIT_COUNT); do
    # Tạo timestamp ngẫu nhiên trong ngày (giữa 8h-22h)
    HOUR_OFFSET=$(( (DAY_NUMBER * 7 + i * 13) % 14 + 8 ))
    MINUTE_OFFSET=$(( (DAY_NUMBER * 11 + i * 19) % 60 ))
    
    # Tạo tên file với timestamp
    file_name="$(date +'%Y-%m-%d')_commit_${i}_${HOUR_OFFSET}-${MINUTE_OFFSET}.py"
    
    # Tạo nội dung file với một số thay đổi ngẫu nhiên
    RANDOM_CODE=$(( (DAY_NUMBER * i * 3) % 1000 ))
    echo -e "# Auto-generated on $DATE_SEED\n# Commit $i of $COMMIT_COUNT\nprint('Hello from commit $i, value: $RANDOM_CODE')\nprint('Date: $DATE_SEED')" > "$file_name"
    
            # Commit với message đa dạng hơn
            COMMIT_MESSAGES=(
                "Update: $DATE_SEED commit $i"
                "Fix: minor changes on $DATE_SEED"
                "Refactor: code improvements"
                "Add: new feature implementation"
                "Update: documentation and comments"
                "Fix: bug fixes and optimizations"
                "Enhance: performance improvements"
                "Add: utility functions"
                "Update: configuration files"
                "Fix: edge case handling"
                "Refactor: clean up code structure"
                "Add: test cases"
                "Update: dependencies"
                "Fix: memory leaks"
                "Enhance: user experience"
                "Add: error handling"
                "Update: API endpoints"
                "Fix: security vulnerabilities"
                "Refactor: optimize algorithms"
                "Add: logging functionality"
            )
    MSG_INDEX=$(( (DAY_NUMBER * i) % ${#COMMIT_MESSAGES[@]} ))
    COMMIT_MSG="${COMMIT_MESSAGES[$MSG_INDEX]}"
    
    git add "$file_name"
    git commit -m "$COMMIT_MSG" --date="$DATE_SEED ${HOUR_OFFSET}:${MINUTE_OFFSET}:00"
    
    echo "Created commit $i/$COMMIT_COUNT: $COMMIT_MSG"
done

# Push tất cả commits cùng lúc
git push origin main
