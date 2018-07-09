# Running terraform

terraform reads its vars in a linar fashion. We will use this to have an override abiltiy. Common vars will exist in `terraform.tfvars` and stack specific vars will exist in mystack.tfvars. Note that the value terraform choses is the last value to got from the var files, the most right file will take presedance.

`terraform plan -var-file=terraform.tfvars -var-file=mystack.tfvars`
`terraform apply -var-file=terraform.tfvars -var-file=mystack.tfvars`
`terraform destroy -var-file=terraform.tfvars -var-file=mystack.tfvars`