# encoding: utf-8
# copyright: 2018, The Authors
# load data from Terraform output
content = inspec.profile.file("terraform.json")
params = JSON.parse(content)

# store vpc in variable
VPC_ID = params['vpc_id']['value']

BASTION_SG_NAME = params['bastion_sg_name']['value']
BASTION_SG_ID = params['bastion_sg_id']['value']
PRIVATE_SUBNETS = params['private_subnets']['value']
PUBLIC_SUBNETS = params['public_subnets']['value']
DB_SUBNETS = params['db_subnets']['value']

title 'example tests, these should be generated!'


describe aws_security_group(id: 'sg-bb9453c7') do
  it { should exist }
  its('vpc_id') { should eq VPC_ID }  
end

describe aws_security_group(group_name: BASTION_SG_NAME) do
  it { should exist }
  its('group_id') { should eq BASTION_SG_ID }
  its('vpc_id') { should eq VPC_ID }  
end


PRIVATE_SUBNETS.each do |net|
  describe aws_subnets.where( vpc_id: VPC_ID) do
      it { should exist }
      its('subnet_ids') { should include net }  
  end
end

PUBLIC_SUBNETS.each do |net|
  describe aws_subnets.where( vpc_id: VPC_ID) do
      it { should exist }
      its('subnet_ids') { should include net }  
  end
end


DB_SUBNETS.each do |net|
  describe aws_subnets.where( vpc_id: VPC_ID) do
      it { should exist }
      its('subnet_ids') { should include net }  
  end
end


# hard coded tests, this would be generated so this would be fine
describe aws_elb('mytest-elb-App') do
  its('availability_zones') { should include 'eu-west-1a' }
  its('availability_zones') { should include 'eu-west-1b' }
end

describe aws_elb('mytest-elb-web') do
  its('availability_zones') { should include 'eu-west-1a' }
  its('availability_zones') { should include 'eu-west-1b' }
end

describe aws_elb('mytest-elb-App') do
  its('external_ports') { should include 80 }
  its('external_ports.count') { should cmp 1 }
end

describe aws_elb('mytest-elb-web') do
  its('external_ports') { should include 80 }
  its('external_ports.count') { should cmp 1 }
end