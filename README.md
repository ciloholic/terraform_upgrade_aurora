# Aurora を 11.9 からどこまでアップグレードか確認する

```
$ aws-vault exec $AWS_PROFILE -- aws rds describe-db-engine-versions --engine aurora-postgresql --engine-version 11.9 --output table --query 'DBEngineVersions[].[ValidUpgradeTarget][][][].EngineVersion'
--------------------------
|DescribeDBEngineVersions|
+------------------------+
|  11.11                 |
|  11.12                 |
|  11.13                 |
|  11.14                 |
|  11.15                 |
|  12.4                  |
|  12.6                  |
|  12.7                  |
|  12.8                  |
|  12.9                  |
|  12.10                 |
+------------------------+
```

```
$ aws-vault exec $AWS_PROFILE -- aws rds describe-db-engine-versions --engine aurora-postgresql --engine-version 12.10 --output table --query 'DBEngineVersions[].[ValidUpgradeTarget][][][].EngineVersion'
--------------------------
|DescribeDBEngineVersions|
+------------------------+
|  13.6                  |
+------------------------+
```

## 11.9 から段階を踏んで 13.6 にアップグレードする

```
11.9 => 12.10 => 13.6
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

## 11.9 => 12.10 へのアップグレード

`12.10`へのアップグレード後、メンテナンスのアップデートを必要がある。  
上記の作業が完了後、Terraform側の`aurora_engine_version`を`12.10`へ更新し、差分が発生しないことを確認する。

```
$ aws-vault exec $AWS_PROFILE -- aws rds modify-db-cluster \
--db-cluster-identifier tst-dev \
--engine-version 12.10 \
--db-cluster-parameter-group-name [PostgreSQL12のパラメーターを指定] \
--db-instance-parameter-group-name [PostgreSQL12のパラメーターを指定] \
--allow-major-version-upgrade \
--apply-immediately
```

## 12.10 => 13.6 へのアップグレード

`13.6`へのアップグレード後、メンテナンスのアップデートを必要がある。  
上記の作業が完了後、Terraform側の`aurora_engine_version`を`13.6`へ更新し、差分が発生しないことを確認する。

```
$ aws-vault exec $AWS_PROFILE -- aws rds modify-db-cluster \
--db-cluster-identifier tst-dev \
--engine-version 13.6 \
--db-cluster-parameter-group-name [PostgreSQL13のパラメーターを指定] \
--db-instance-parameter-group-name [PostgreSQL13のパラメーターを指定] \
--allow-major-version-upgrade \
--apply-immediately
```
