#!/usr/bin/env bash
# 新服务器初始化（CentOS/RHEL）
set -euo pipefail

TIMEZONE="Asia/Shanghai"
ADMIN_USER="ops"
ADMIN_KEY="ssh-rsa 请替换成你的公钥"

echo ">>> 设置时区"
timedatectl set-timezone "$TIMEZONE"

echo ">>> 安装常用软件"
yum install -y epel-release
yum install -y vim htop lsof telnet tree unzip bash-completion

echo ">>> 创建运维用户"
id "$ADMIN_USER" &>/dev/null || useradd -m -s /bin/bash "$ADMIN_USER"
mkdir -p "/home/$ADMIN_USER/.ssh"
echo "$ADMIN_KEY" > "/home/$ADMIN_USER/.ssh/authorized_keys"
chown -R "$ADMIN_USER:$ADMIN_USER" "/home/$ADMIN_USER/.ssh"
chmod 700 "/home/$ADMIN_USER/.ssh"
chmod 600 "/home/$ADMIN_USER/.ssh/authorized_keys"
usermod -aG wheel "$ADMIN_USER"

echo ">>> SSH 加固"
cp /etc/ssh/sshd_config "/etc/ssh/sshd_config.bak.$(date +%F)"
sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
systemctl restart sshd

echo ">>> 内核参数"
cp /etc/sysctl.conf "/etc/sysctl.conf.bak.$(date +%F)"
cat configs/sysctl.conf >> /etc/sysctl.conf
sysctl -p

echo ">>> fail2ban"
yum install -y fail2ban
systemctl enable --now fail2ban

echo "完成。请确认能用 $ADMIN_USER + 私钥登录后，再关闭当前会话。"
