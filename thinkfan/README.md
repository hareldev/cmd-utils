Since hwmon path of devices is changing from time to time, we will create a script that updates it, each reastart of the service.

Instructions of creating such service:
https://gist.github.com/Yatoom/1c80b8afe7fa47a938d3b667ce234559#file-setup-md

After performing all 5 steps mentioned in the repo above, get the following details from your `thinkfan` service by running `service thinkfan status`:
1. Service configuration file (usually `/usr/local/lib/systemd/system/thinkfan.service`)
2. `thinkfan` executable (usually `/usr/local/sbin/thinkfan`)

We will then perform the following:
1. Download / add hwmon update script:
    
    Download the hwmon update script to the folder where `thinkfan` executable is kept.
    ```
    wget ....
    ```

2. Change this file to exectuable:

    ```
    sudo chmod +x /usr/local/sbin/thinkfanHwmonUpdate.sh
    ```

3. Add this script to the service Pre-Start:
   
    we will go and edit the `thinkfan` service, and add `ExecStartPre=` so the file will looks something like this:

    ```
    [Unit]
    Description=thinkfan 2.0.0
    After=sysinit.target
    After=systemd-modules-load.service

    [Service]
    Type=forking
    ExecStartPre=/usr/local/sbin/thinkfanHwmonUpdate.sh
    ExecStart=/usr/local/sbin/thinkfan $THINKFAN_ARGS
    PIDFile=/run/thinkfan.pid
    ExecReload=/bin/kill -HUP $MAINPID

    [Install]
    WantedBy=multi-user.target
    Also=thinkfan-sleep.service
    Also=thinkfan-wakeup.service
    ```
4. Reload the service configuration:
    ```
    sudo systemctl daemon-reload
    sudo systemctl reload thinkfan
    sudo systemctl restart thinkfan
    sudo systemctl status thinkfan
    ```
