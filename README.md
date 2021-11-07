# 事前準備

## aws cli の用意

```
$ alias laws='docker run --rm -it -v ~/.aws:/root/.aws amazon/aws-cli'
$ laws --version
aws-cli/2.3.4 Python/3.8.8 Linux/5.10.47-linuxkit docker/x86_64.amzn.2 prompt/off
```

## aws cli のプロファイルを用意

```
$ laws configure list --profile terraform
      Name                    Value             Type    Location
      ----                    -----             ----    --------
   profile                terraform           manual    --profile
access_key     ****************U7VE shared-credentials-file
secret_key     ****************zZuQ shared-credentials-file
    region           ap-northeast-1      config-file    ~/.aws/config
```

## aws cli の設定

```
# ページネーションを無効化する
$ laws configure set cli_pager '' --profile terraform
```

## Aurora を 11.9 からどこまでアップグレードか確認する

```
$ laws rds describe-db-engine-versions --engine aurora-postgresql --engine-version 11.9 --output table --query 'DBEngineVersions[].[ValidUpgradeTarget][][][].EngineVersion' --profile terraform
--------------------------
|DescribeDBEngineVersions|
+------------------------+
|  11.11                 |
|  11.12                 |
|  11.13                 |
|  12.4                  |
|  12.6                  |
|  12.7                  |
|  12.8                  |
+------------------------+
```

```
$ laws rds describe-db-engine-versions --engine aurora-postgresql --engine-version 12.8 --output table --query 'DBEngineVersions[].[ValidUpgradeTarget][][][].EngineVersion' --profile terraform
--------------------------
|DescribeDBEngineVersions|
+------------------------+
|  13.4                  |
+------------------------+
```

### 11.9 から段階を踏んで 13.4 にアップグレードする

```
11.9 => 12.8 => 13.4
```

# Terraform での作業内容

## engine、engine_version の変更点

`engine`、`engine_version`を`aws_rds_cluster`側の設定を参照するように変更。

```
resource "aws_rds_cluster_instance" "example" {
  engine                     = aws_rds_cluster.example.engine
  engine_version             = aws_rds_cluster.example.engine_version
}
```

## PostgreSQL12、PostgreSQL13のパラメーター類を作成

`PostgreSQL12`、`PostgreSQL13`のパラメーター類を事前に作成する。  
アップグレード完了後、`PostgreSQL11`、`PostgreSQL12`のパラメーター類を削除する。

- aws_rds_cluster_parameter_group
- aws_db_parameter_group

## 11.9 => 12.8 へのアップグレード

`12.8`へのアップグレード後、メンテナンスのアップデートを必要がある。  
上記の作業が完了後、Terraform側の`aurora_engine_version`を`12.8`へ更新し、差分が発生しないことを確認する。

```
$ laws rds modify-db-cluster \
--db-cluster-identifier tst-dev \
--engine-version 12.8 \
--db-cluster-parameter-group-name [PostgreSQL12のパラメーターを指定] \
--db-instance-parameter-group-name [PostgreSQL12のパラメーターを指定] \
--allow-major-version-upgrade \
--apply-immediately \
--profile terraform
```

## 12.8 => 13.4 へのアップグレード

`13.4`へのアップグレード後、メンテナンスのアップデートを必要がある。  
上記の作業が完了後、Terraform側の`aurora_engine_version`を`13.4`へ更新し、差分が発生しないことを確認する。

```
laws rds modify-db-cluster \
--db-cluster-identifier tst-dev \
--engine-version 13.4 \
--db-cluster-parameter-group-name [PostgreSQL13のパラメーターを指定] \
--db-instance-parameter-group-name [PostgreSQL13のパラメーターを指定] \
--allow-major-version-upgrade \
--apply-immediately \
--profile terraform
```
