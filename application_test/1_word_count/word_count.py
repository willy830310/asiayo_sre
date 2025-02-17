from collections import defaultdict

## 讀檔
with open ("./word.txt","r") as reader:
    lines = reader.readlines()

## 用defaultdict去定義value的datatype是int
word_count = defaultdict(int)

for line in lines:
    ## 移除,
    line = line.replace(",","")
    ## 使用space當做split的delimiter
    words = line.split(" ")
    for word in words:
        ## 因為case insensitive，所以統一轉小寫
        word = word.lower()
        word_count[word] += 1

max_key = max(word_count, key=word_count.get)
max_value = word_count.get(max_key)

print(max_value, max_key)