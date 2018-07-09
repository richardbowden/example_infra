#cloud-config
packages:
 - htop
 - jq

runcmd:
  - [ amazon-linux-extras, install, nginx1.12, -y ]
  - [ sed, -i, -e,  '38,57{/./d}', /etc/nginx/nginx.conf ]
  - [ mv, /usr/lib/systemd/system/nginx.service, /usr/lib/systemd/system/nginx.service_old ]
  - [ mv, /usr/lib/systemd/system/nginx.service_new, /usr/lib/systemd/system/nginx.service ]
  - [ systemctl, enable, nginx.service ]
  - [ systemctl, restart, nginx.service]

write_files:
-   content: |
        server {
          location / {
              proxy_pass http://${app_elb};
          }
        }
    path: /etc/nginx/conf.d/exampleapp.conf

-   content: |
        [Unit]
        Description=The nginx HTTP and reverse proxy server
        After=network.target remote-fs.target nss-lookup.target

        [Service]
        Type=forking
        PIDFile=/run/nginx.pid
        
        ExecStartPre=/usr/bin/rm -f /run/nginx.pid
        ExecStartPre=/usr/sbin/nginx -t
        ExecStart=/usr/sbin/nginx
        ExecReload=/bin/kill -s HUP $MAINPID
        KillSignal=SIGQUIT
        TimeoutStopSec=5
        KillMode=process
        PrivateTmp=true
        Restart=always
        RestartSec=3

        [Install]
        WantedBy=multi-user.target
    path: /usr/lib/systemd/system/nginx.service_new

output : { all : '| tee -a /var/log/cloud-init-output.log' }

final_message: "The system is finally up, after $UPTIME seconds"