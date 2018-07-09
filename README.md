---

## TFVARS
terraform reads its vars in a linar fashion. We will use this to have an override abiltiy. Common vars will exist in `terraform.tfvars` and stack specific vars will exist in mystack.tfvars. Note that the value terraform choses is the last value to got from the var files, the most right file will take presedance.

    terraform plan -var-file=terraform.tfvars -var-file=mystack.tfvars
    terraform apply -var-file=terraform.tfvars -var-file=mystack.tfvars
    terraform destroy -var-file=terraform.tfvars -var-file=mystack.tfvars


## Example stack specific settings / overrides.

also, see terraform.tfvars for general settings that have not been overriden, like subnet ranges and so on.

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

    deploy_bucket = "rbexamplebuiltbin"

    app_ssm_kms_key = "alias/aws/ssm"


### Notes:

This is designed to deploy example_app, a simple crud app that is written in go and uses psql. The zip file `latest.zip` in deployable_app needs to be put in an s3 bucket. This binary in that zip is compiled for linux

Then update `./userdata/app_server.sh` at line `- [ aws, s3, cp, "s3://rbexamplebuiltbin/latest.zip", ./ ]` with the new s3 bucket

`./outputs.tf` is commented out due to on a destroy terraform still moans that the outputs cannot output as there is no state, i just dont like seeing false errors.


### TODO: 

- make `./userdata/app_server.sh` to be rendered by terraform template that uses the `deploy_bucket` param that is used for setting the IAM polices for the bucket. 
    
        Had an issue that the template provider some how altered the YAML for cloud-init, which made it fail, will revisit another time.

- maybe introduce ansible, but for now it feels to heavy for this project

- fix `aws_db_instance` this has an issue with final snapshots, terraform still does not honor the `don't backup my database`, there is a github issue for this https://github.com/terraform-providers/terraform-provider-aws/issues/92
