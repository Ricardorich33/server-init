# server-init

新服务器初始化与安全加固脚本（CentOS/RHEL）。

## 内容

- `init.sh`：时区、基础包、创建用户、SSH 加固、内核参数、fail2ban
- `configs/sshd-hardening.conf`：SSH 加固片段
- `configs/sysctl.conf`：网络与内核调优

## 使用

在仓库根目录以 root 执行：`bash init.sh`

执行前把 `init.sh` 顶部的 `ADMIN_USER` 和 `ADMIN_KEY` 改成你的环境。脚本会禁用密码登录，务必确认公钥配置正确，并保持一个已登录会话防止把自己锁在外面。
