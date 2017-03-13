#!/bin/sh

config=hyperion-hue.config.json

source ./vars

# copy config

hyperion_config () {
    scp -P22 $config root@${hyperion_ip}:/storage/.config/

    # stop old hyperion
    ssh -p22 root@${hyperion_ip} killall hyperiond

    # replace vars
    ssh -p22 root@${hyperion_ip} "sed -i 's/<hue-ip>/$hue_ip/' /storage/.config/${config}"
    ssh -p22 root@${hyperion_ip} "sed -i 's/<hue-username>/$hue_username/' /storage/.config/${config}"

    # start hyperion
    ssh -p22 root@${hyperion_ip} /storage/hyperion/bin/hyperiond.sh /storage/.config/${config}
}

hue_control () {
    scp -P22 hue-control.service root@${hyperion_ip}:/storage/.config/system.d/
    ssh -p22 root@${hyperion_ip} 'systemctl daemon-reload \
&& systemctl enable hue-control \
&& systemctl restart hue-control'
}

$1
