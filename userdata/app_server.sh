#cloud-config
packages:
 - htop
 - jq

runcmd: 
 - [ aws, s3, cp, "s3://rbexamplebuiltbin/latest.zip", ./ ]
 - [ unzip, latest.zip, -d, app_server ]
 - [ chmod, "+x", /app_server/write_sysd_config.sh]
 - [ /app_server/write_sysd_config.sh ]

output : { all : '| tee -a /var/log/cloud-init-output.log' }

final_message: "The system is finally up, after $UPTIME seconds"