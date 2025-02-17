- [問題補充說明](#問題補充說明)
  - [k8s yaml](#k8s-yaml)
  - [Terraform code](#terraform-code)

# 問題補充說明

## k8s yaml
因為沒有AWS的環境可以直接測試，此folder下面只有大致會用到的conponant設定檔，用文字補充可能需要做測試調整的地方

- 在雲端為了要符合at least privilege的準則，在application使用的service account跟terraform使用的service account可能都要額外做多次的測試
- 在DB持久化掛volume的部分，要支援可自動擴展的關係，在底層volume的部分必須要能支援read/write many，可能需要改寫成其他選項(EX: NFS)，但假如說用NFS可能會因為網路的關係導致效能問題
- 目前沒有考慮到RBAC的設計，可能會影響到的是使用者權限針對某些K8s kind的權限，另外還有綁定deployment的service account，讓其可以有權限呼叫AWS其他服務
- 如果要蒐集DB跟application的metrics，可能可以用sidecar的方式額外安裝metrics exporter

## Terraform code
相比於EKS auto mode，我比較熟悉GKE auto pilot，因此這邊我會以GKE需要注意的點做說明

- 在網段大小規劃會分成 pod/service ip range，需要根據未來規劃去做調整
- 針對control plane的存取權限做限制