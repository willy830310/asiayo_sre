- [題目四](#題目四)
  - [問題描述](#問題描述)
  - [問題回覆](#問題回覆)
    - [日誌格式](#日誌格式)
    - [日誌發送方式](#日誌發送方式)
    - [ElasticSearch 設定](#elasticsearch-設定)
    - [Kibana相關設定](#kibana相關設定)

# 題目四
## 問題描述
試想已有一組 ELK/EFK 日誌服務集群,而今日有一新服務上線並且串接日誌紀錄,讓開發者能夠透過 Kibana 進行線上錯誤排查,你/妳會如何將日誌檔內容串接至 ELK/EFK 系統?考量的細節是什麼?

## 問題回覆

我會從以下幾個方向做規劃
- 日誌格式
- 日誌發送方式
- Elasticsearch index設定
- Kibana 相關設定

---

### 日誌格式

日誌格式可能是純文字或者是Json格式，格式則會影響到後續資料parsing的部份，且所有log檢查是否包含以下基本資訊:
- timestamp
- log level
- service name
- error code
- error name
- error message

---

### 日誌發送方式
考慮到輕量性跟data pipeline管理問題，會傾向在新服務的服務器上裝filebeat負責蒐集log(如果是k8s架構，則是用sidecar的方式負責傳送log)並傳送到logstash，並透過logstash統一做不同data source pipeline的管理，不同pipeline可以定義不同的input、output跟filter(針對資料格式做轉換之類的操作)，之後在擴展上也是在服務伺服器上裝輕量的filebeat來蒐集log，傳輸到logstash統一做資料處理

---

### ElasticSearch 設定
根據日誌搜尋的使用場景，會有相對應的設定要做調整來節省elastic search的記憶體使用

1. index template: 
   - 根據log的重要性和elasticsearch cluster node的數量去調整replica跟shard的設定
   - 根據搜尋方式去調整每個欄位的type，比如說error code=400，我們可能會直接搜尋error code這個欄位剛好等於400的資料，不會搜尋error code這個欄位包含4這個數字的所有資料
   - 根據error content的內容可能需要去客製化analyzer，比如說是HTML類型的log，或者是想要用中文作搜索
2. index處理:
   - 我們可能場景上只會去搜索過去七天的log，那我們可以寫script自動把七天前的index關起來，減少memory的使用
3. elasticsearch設定
   - 根據搜尋及時性的要求，在elasticsearch可以去調整一些如refresh跟flush interval的設定

---

### Kibana相關設定
考慮到可能會有不同部門或者是不同專案的使用者共用同一套ELK/EFK的狀況，理想上是可以把每個人的權限定義出來，只能在被賦予的權限範圍內做操作，比如說，可以限制某個使用者只有透過kibana取得elasticsearch 特定index的資料後拉報表的權限