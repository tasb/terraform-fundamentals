# Run Checkov on the Terraform code

## Scan code

```bash
checkov -d .

checkov -f main.tf
```

## Scan plan file

```bash
terraform init
terraform plan -out tf.plan
terraform show -json tf.plan > tf.json
checkov -f tf.json
```
