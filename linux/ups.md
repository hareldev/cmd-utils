## Install nut server + client:
```
sudo dnf install nut
```

## Locate UPS ID
You could run `lsusb` to get a list of your USB devices -

```
...
Bus 003 Device 014: ID 0001:0000 Fry's Electronics MEC0003
...
```

## Locate it using nut-scanner:
ln -s /lib64/libusb-1.0.so.0.4.0 /usr/lib64/libusb-1.0.so

sudo nut-scanner -U

[The list of drivers here](https://networkupstools.org/stable-hcl.html) should provide some guidance in finiding your matching driver.
For this kind of UPS, it's usually recommended to use `nutdrv_qx`

## Add your device settings
to `/etc/ups/ups.conf` and `/etc/ups/upsd.conf` end of file:

```
[Home-UPS]
driver = nutdrv_qx
port = auto
```

## Add users:
```
[admin]
      password = 1234
      actions = SET FSD
      instcmds = ALL
      upsmon master
```

## Restart the service:
```
sudo upsdrvctl stop
sudo upsdrvctl start
```
or reload using `sudo upsdrvctl -c reload`

## Check the client
```
upsc -l
```
Should list the current connected UPS devices

```
upsc Home-UPS
```
List all commands:
```
upscmd -l Home-UPS
```

## To disable beeper:
```
upscmd Home-UPS beeper.toggle
```




