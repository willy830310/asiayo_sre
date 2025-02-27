- [題目三](#題目三)
  - [問題描述](#問題描述)
  - [問題回覆](#問題回覆)
    - [權限不足](#權限不足)
    - [本身機器發生狀況](#本身機器發生狀況)
    - [加入機制減少問題發生](#加入機制減少問題發生)

# 題目三
## 問題描述
試想有一項目運行於 AWS EC2 機器之上,已確認該服務仍然正常運行中,但由於不明原因導致無法再次透過 SSH 登入確認狀態(已確認排除並非網路異常,亦非防火牆阻擋所導致)。請簡易描述你/妳將如何排查問題,並且讓服務恢復正常運作?考量的細節是什麼?如果可以,請試著回答造成無法登入的可能的肇因為何?

## 問題回覆

無法登入SSH的狀況我覺得有以下幾種
- 權限不足
- 本身機器發生狀況

### 權限不足
考慮到原本可以連線，但突然不能連線的情況，可能會是有人動到SSH server的設定或者是動到使用者帳號的權限。如果是SSH server的設定遭到修改，可能要去詢問此台機器的管理人員是否有修改。如果是使用者帳號的權限不小心遭到修改，可以去詢問雲端管理人員或者是查詢audit log(如果有權限的話)確認是否權限遭到修改

---

### 本身機器發生狀況
因為要SSH進去的時候會在家目錄建立一個File，假如機器硬碟空間不夠就可能會發生無法連線的狀況。要先解決這個問題，可以先把這顆硬碟mount到另外一台機器上，並清除此硬碟裡面的一些資料，之後再mount回原本的機器。硬碟空間不夠的原因可能是資料庫資料合理成長，也有可能是服務的log沒有設定rotate所導致

---

### 加入機制減少問題發生
根據此次發生的問題將相應的機制加上，比如說有人修改到IAM設定，發出通知，或者是加入log rotate的機制