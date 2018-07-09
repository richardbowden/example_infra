# ---

terraform reads its vars in a linar fashion. We will use this to have an override abiltiy. Common vars will exist in `terraform.tfvars` and stack specific vars will exist in mystack.tfvars. Note that the value terraform choses is the last value to got from the var files, the most right file will take presedance.

`terraform plan -var-file=terraform.tfvars -var-file=mystack.tfvars`
`terraform apply -var-file=terraform.tfvars -var-file=mystack.tfvars`
`terraform destroy -var-file=terraform.tfvars -var-file=mystack.tfvars`


Example stack specific settings / overrides.

`mystack.tfvars`

    stack_name = "mytest"

    bastion_remote_access_ssh = [
    "x.x.x.x/32,description of what this address if for",
    ]

    ssh_public_key = "ssh-rsa AAAAB3NAAAAB3NAAAAB3NAAAAB3NAAAAB3NAAAAB3NAAAAB3NAAAAB3NAAAAB3NAAAAB3NAAAAB3NAAAAB3NAAAAB3NAAAAB3NAAAAB3NAAAAB3NAAAAB3NAAAAB3NAAAAB3NAAAAB3NAAAAB3NAAAAB3NAAAAB3NAAAAB3NAAAAB3NAAAAB3NAAAAB3NAAAAB3NAAAAB3NAAAAB3NAAAAB3NAAAAB3NAAAAB3NAAAAB3NAAAAB3NAAAAB3NAAAAB3NAAAAB3NAAAAB3NAAAAB3NAAAAB3NAAAAB3NAAAAB3NAAAAB3N user@nasa"

    bastion_instance_size = "t2.xlarge"

    app_instance_size = "t2.xlarge"

    web_instance_size = "t2.xlarge"

    db_multi_az = false

    db_name = "example_database"

    db_user = "example"

    db_passwd = "supersecretpassword"

