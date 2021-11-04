# Terraform 導入

```
brew install tfenv
tfenv install
```

# Makefile

```
make init ENV=dev
make plan ENV=dev
make apply ENV=dev
make destroy ENV=dev
make fmt
make val
make c
```

# Terraformer

```
export AWS_ACCESS_KEY_ID=xxx
export AWS_SECRET_ACCESS_KEY=xxx
terraformer import aws --resources=xxx --regions=ap-northeast-1
```
