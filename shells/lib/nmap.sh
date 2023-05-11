#!/bin/bash

# - `nmap_open_ports`           : 扫描目标上的开放端口.
# - `nmap_list_interfaces`      : 列出运行命令的主机上的所有网络接口.
# - `nmap_slow`                 : 慢速扫描，避免向目标日志发送垃圾邮件.
# - `nmap_fin`                  : 扫描以查看主机是否已启动 tcp fin 扫描.
# - `nmap_full`                 : 扫描所有端口的积极全面扫描，尝试确定操作系统和服务版本.
# - `nmap_check_for_firewall`   : tcp ack 扫描以检查防火墙是否存在.
# - `nmap_ping_through_firewall`: 使用 syn 和 ack 探测而不是仅仅通过 ping 来发现主机，以避免防火墙限制。
# - `nmap_fast`                 : 快速扫描前 300 个热门端口。
# - `nmap_detect_versions`      : 检测服务和操作系统的版本，在所有端口上运行。
# - `nmap_check_for_vulns`      : 使用 vulscan 脚本检查目标服务是否存在漏洞。
# - `nmap_full_udp`             : 与 nmap_full 相同，但通过 udp。
# - `nmap_traceroute`           : 尝试使用最常见的端口来跟踪路由.
# - `nmap_full_with_scripts`    : 与 nmap full 相同，但也运行所有脚本。
# - `nmap_web_safe_osscan`      : 对操作系统版本进行“更安全”的小扫描，因为仅连接到 http 和 https 端口看起来不那么具有攻击性。
# - `nmap_ping_scan`            : icmp 扫描活动主机。

# Some useful nmap aliases for scan modes

# Nmap options are:
#  -sS - TCP SYN scan
#  -v - verbose
#  -T1 - timing of scan. Options are paranoid (0), sneaky (1), polite (2), normal (3), aggressive (4), and insane (5)
#  -sF - FIN scan (can sneak through non-stateful firewalls)
#  -PE - ICMP echo discovery probe
#  -PP - timestamp discovery probe
#  -PY - SCTP init ping
#  -g - use given number as source port
#  -A - enable OS detection, version detection, script scanning, and traceroute (aggressive)
#  -O - enable OS detection
#  -sA - TCP ACK scan
#  -F - fast scan
#  --script=vuln - also access vulnerabilities in target

alias nmap_open_ports="nmap --open"
alias nmap_list_interfaces="nmap --iflist"
alias nmap_slow="sudo nmap -sS -v -T1"
alias nmap_fin="sudo nmap -sF -v"
alias nmap_full="sudo nmap -sS -T4 -PE -PP -PS80,443 -PY -g 53 -A -p1-65535 -v"
alias nmap_check_for_firewall="sudo nmap -sA -p1-65535 -v -T4"
alias nmap_ping_through_firewall="nmap -PS -PA"
alias nmap_fast="nmap -F -T5 --version-light --top-ports 300"
alias nmap_detect_versions="sudo nmap -sV -p1-65535 -O --osscan-guess -T4 -Pn"
alias nmap_check_for_vulns="nmap --script=vuln"
alias nmap_full_udp="sudo nmap -sS -sU -T4 -A -v -PE -PS22,25,80 -PA21,23,80,443,3389 "
alias nmap_traceroute="sudo nmap -sP -PE -PS22,25,80 -PA21,23,80,3389 -PU -PO --traceroute "
alias nmap_full_with_scripts="sudo nmap -sS -sU -T4 -A -v -PE -PP -PS21,22,23,25,80,113,31339 -PA80,113,443,10042 -PO --script all "
alias nmap_web_safe_osscan="sudo nmap -p 80,443 -O -v --osscan-guess --fuzzy "
alias nmap_ping_scan="nmap -n -sP"
