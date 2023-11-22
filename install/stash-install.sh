#!/usr/bin/env bash

# Copyright (c) 2021-2023 tteck
# Author: tteck (tteckster)
# License: MIT
# https://github.com/tteck/Proxmox/raw/main/LICENSE

source /dev/stdin <<< "$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing Dependencies"
$STD apt-get install -y ffmpeg
msg_ok "Installed Dependencies"

msg_info "Installing Stash"
mkdir -p /opt/stash
cd /opt/stash
wget -q https://github.com/stashapp/stash/releases/latest/download/stash-linux
chmod +x stash-linux
msg_ok "Installed Stash"

msg_info "Creating Service"
service_path="/etc/systemd/system/stash.service"
echo "[Unit]
Description=stash service
After=network.target

[Service]
Type=simple
User=root
ExecStart=/opt/stash/stash-linux

[Install]
WantedBy=multi-user.target" >$service_path
systemctl enable -q --now stash
msg_ok "Created Service"

motd_ssh
customize

msg_info "Cleaning up"
$STD apt-get autoremove
$STD apt-get autoclean
msg_ok "Cleaned"
