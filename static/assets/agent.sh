#!/bin/sh
# nezha固定版本v0.20.5的安装agent脚本

NZ_BASE_PATH="/opt/nezha"
NZ_DASHBOARD_PATH="${NZ_BASE_PATH}/dashboard"
NZ_AGENT_PATH="${NZ_BASE_PATH}/agent"
NZ_DASHBOARD_SERVICE="/etc/systemd/system/nezha-dashboard.service"
NZ_DASHBOARD_SERVICERC="/etc/init.d/nezha-dashboard"
GITHUB_URL="https://github.com"

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'
export PATH="$PATH:/usr/local/bin"

os_arch=""
[ -e /etc/os-release ] && grep -i "PRETTY_NAME" /etc/os-release | grep -qi "alpine" && os_alpine='1'

sudo() {
    myEUID=$(id -ru)
    if [ "$myEUID" -ne 0 ]; then
        if command -v sudo > /dev/null 2>&1; then
            command sudo "$@"
        else
            err "错误: 您的系统未安装 sudo，因此无法进行该项操作。"
            exit 1
        fi
    else
        "$@"
    fi
}

check_systemd() {
    if [ "$os_alpine" != 1 ] && ! command -v systemctl >/dev/null 2>&1; then
        echo "不支持此系统：未找到 systemctl 命令"
        exit 1
    fi
}

err() {
    printf "${red}%s${plain}\n" "$*" >&2
}

success() {
    printf "${green}%s${plain}\n" "$*"
}

info() {
    printf "${yellow}%s${plain}\n" "$*"
}

geo_check() {
    # 初始化变量
    isCN=false
    
    api_list="https://blog.cloudflare.com/cdn-cgi/trace https://dash.cloudflare.com/cdn-cgi/trace https://developers.cloudflare.com/cdn-cgi/trace"
    ua="Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/81.0"
    
    for url in $api_list; do
        text="$(curl -A "$ua" -m 10 -s "$url" 2>/dev/null)"
        if [ $? -eq 0 ] && [ -n "$text" ]; then
            endpoint="$(echo "$text" | sed -n 's/.*h=\([^ ]*\).*/\1/p')"
            if echo "$text" | grep -qw 'CN'; then
                isCN=true
                break
            elif echo "$url" | grep -q "$endpoint"; then
                break
            fi
        fi
    done
}

pre_check() {
    umask 077

    ## os_arch
    case "$(uname -m)" in
        x86_64) os_arch="amd64" ;;
        i386|i686) os_arch="386" ;;
        aarch64|armv8b|armv8l) os_arch="arm64" ;;
        arm*) os_arch="arm" ;;
        s390x) os_arch="s390x" ;;
        riscv64) os_arch="riscv64" ;;
    esac

    ## 调用地理位置检查
    geo_check

    ## China_IP 自动切换
    if [ "${isCN:-false}" = true ]; then
        GITHUB_URL="https://gh-proxy.com/https://github.com"
        echo "检测到中国IP，已将 GITHUB_URL 修改为: $GITHUB_URL"
    fi
}


select_version() {
    if [ -z "$IS_DOCKER_NEZHA" ]; then
        info "请自行选择您的Agent安装方式（输入哪个都是一样的）："
        info "1. 安装Agent"
        info "2. 安装Agent"
        while true; do
            printf "请输入选择 [1-2]："
            read -r option
            case "${option}" in
                1)
                    IS_DOCKER_NEZHA=1
                    break
                    ;;
                2)
                    IS_DOCKER_NEZHA=0
                    break
                    ;;
                *)
                    err "请输入正确的选择 [1-2]"
                    ;;
            esac
        done
    fi
}

before_show_menu() {
    echo && info "* 按回车返回主菜单 *" && read temp
    show_menu
}

install_base() {
    # 检查必要的命令是否存在，如果不存在则安装
    missing_tools=""
    
    command -v curl >/dev/null 2>&1 || missing_tools="$missing_tools curl"
    command -v wget >/dev/null 2>&1 || missing_tools="$missing_tools wget"
    command -v unzip >/dev/null 2>&1 || missing_tools="$missing_tools unzip"
    
    if [ -n "$missing_tools" ]; then
        info "正在安装必要的工具:$missing_tools"
        install_soft $missing_tools
    fi
}

install_arch() {
    info "提示：Arch安装libselinux需添加nezha-agent用户，安装完会自动删除，建议手动检查一次"
    read -r -p "是否安装libselinux? [Y/n] " input
    case $input in
    [yY][eE][sS] | [yY])
        useradd -m nezha-agent
        sed -i "$ a\nezha-agent ALL=(ALL ) NOPASSWD:ALL" /etc/sudoers
        sudo -iu nezha-agent bash -c 'gpg --keyserver keys.gnupg.net --recv-keys 4695881C254508D1;
                                        cd /tmp; git clone https://aur.archlinux.org/libsepol.git; cd libsepol; makepkg -si --noconfirm --asdeps; cd ..;
                                        git clone https://aur.archlinux.org/libselinux.git; cd libselinux; makepkg -si --noconfirm; cd ..;
                                        rm -rf libsepol libselinux'
        sed -i '/nezha-agent/d' /etc/sudoers && sleep 30s && killall -u nezha-agent && userdel -r nezha-agent
        info "提示: 已删除用户nezha-agent，请务必手动核查一遍！"
        ;;
    [nN][oO] | [nN])
        echo "不安装libselinux"
        ;;
    *)
        echo "不安装libselinux"
        exit 0
        ;;
    esac
}

install_soft() {
    (command -v yum >/dev/null 2>&1 && sudo yum makecache && sudo yum install "$@" selinux-policy -y) ||
        (command -v apt >/dev/null 2>&1 && sudo apt update && sudo apt install "$@" selinux-utils -y) ||
        (command -v pacman >/dev/null 2>&1 && sudo pacman -Syu "$@" base-devel --noconfirm && install_arch) ||
        (command -v apt-get >/dev/null 2>&1 && sudo apt-get update && sudo apt-get install "$@" selinux-utils -y) ||
        (command -v apk >/dev/null 2>&1 && sudo apk update && sudo apk add "$@" -f)
}


selinux() {
    #Check SELinux
    if command -v getenforce >/dev/null 2>&1; then
        if getenforce | grep '[Ee]nfor'; then
            echo "SELinux是开启状态，正在关闭！"
            sudo setenforce 0 >/dev/null 2>&1
            find_key="SELINUX="
            sudo sed -ri "/^$find_key/c${find_key}disabled" /etc/selinux/config
        fi
    fi
}

install_agent() {
    install_base
    selinux

    echo "> 安装监控Agent"

    _version=v0.20.5

    # Nezha Monitoring Folder
    sudo mkdir -p $NZ_AGENT_PATH

    echo "正在下载监控端"
    NZ_AGENT_URL="${GITHUB_URL}/sky22333/shell/releases/download/${_version}/nezha-agent_linux_${os_arch}.zip"

    _cmd="wget -t 2 -T 60 -O nezha-agent_linux_${os_arch}.zip $NZ_AGENT_URL >/dev/null 2>&1"
    if ! eval "$_cmd"; then
        err "Release 下载失败，请检查本机能否连接 ${GITHUB_URL}"
        return 1
    fi

    sudo unzip -qo nezha-agent_linux_${os_arch}.zip &&
        sudo mv nezha-agent $NZ_AGENT_PATH &&
        sudo rm -rf nezha-agent_linux_${os_arch}.zip README.md

    if [ $# -ge 3 ]; then
        modify_agent_config "$@"
    else
        modify_agent_config 0
    fi

    if [ $# = 0 ]; then
        before_show_menu
    fi
}

modify_agent_config() {
    echo "> 修改 Agent 配置"

    if [ $# -lt 3 ]; then
        echo "请先在管理面板上添加Agent，记录下密钥"
            printf "请输入一个解析到面板所在IP的域名（不可套CDN）: "
            read -r nz_grpc_host
            printf "请输入面板RPC端口 (默认值 5555): "
            read -r nz_grpc_port
            printf "请输入Agent 密钥: "
            read -r nz_client_secret
            printf "是否启用针对 gRPC 端口的 SSL/TLS加密 (--tls)，需要请按 [y]，默认是不需要，不理解用户可回车跳过: "
            read -r nz_grpc_proxy
        echo "${nz_grpc_proxy}" | grep -qiw 'Y' && args='--tls'
        if [ -z "$nz_grpc_host" ] || [ -z "$nz_client_secret" ]; then
            err "所有选项都不能为空"
            before_show_menu
            return 1
        fi
        if [ -z "$nz_grpc_port" ]; then
            nz_grpc_port=5555
        fi
    else
        nz_grpc_host=$1
        nz_grpc_port=$2
        nz_client_secret=$3
        shift 3
        if [ $# -gt 0 ]; then
            args="$*"
        fi
    fi

    _cmd="sudo ${NZ_AGENT_PATH}/nezha-agent service install -s $nz_grpc_host:$nz_grpc_port -p $nz_client_secret $args >/dev/null 2>&1"

    if ! eval "$_cmd"; then
        sudo "${NZ_AGENT_PATH}"/nezha-agent service uninstall >/dev/null 2>&1
        sudo "${NZ_AGENT_PATH}"/nezha-agent service install -s "$nz_grpc_host:$nz_grpc_port" -p "$nz_client_secret" "$args" >/dev/null 2>&1
    fi
    
    success "Agent 配置 修改成功，请稍等 Agent 重启生效"

    #if [[ $# == 0 ]]; then
    #    before_show_menu
    #fi
}

show_agent_log() {
    echo "> 获取 Agent 日志"

    if [ "$os_alpine" != 1 ]; then
        sudo journalctl -xf -u nezha-agent.service
    else
        sudo tail -n 10 /var/log/nezha-agent.err
    fi

    if [ $# = 0 ]; then
        before_show_menu
    fi
}

uninstall_agent() {
    echo "> 卸载 Agent"

    sudo ${NZ_AGENT_PATH}/nezha-agent service uninstall

    sudo rm -rf $NZ_AGENT_PATH
    clean_all

    if [ $# = 0 ]; then
        before_show_menu
    fi
}

restart_agent() {
    echo "> 重启 Agent"

    sudo ${NZ_AGENT_PATH}/nezha-agent service restart

    if [ $# = 0 ]; then
        before_show_menu
    fi
}

clean_all() {
    if [ -z "$(ls -A ${NZ_BASE_PATH})" ]; then
        sudo rm -rf ${NZ_BASE_PATH}
    fi
}

show_usage() {
    echo "哪吒监控v0.20.5管理脚本使用方法: "
    echo "--------------------------------------------------------"
    echo "./nezha.sh                            - 显示管理菜单"
    echo "--------------------------------------------------------"
    echo "./nezha.sh install_agent              - 安装监控Agent"
    echo "./nezha.sh modify_agent_config        - 修改Agent配置"
    echo "./nezha.sh show_agent_log             - 查看Agent日志"
    echo "./nezha.sh uninstall_agent            - 卸载Agent"
    echo "./nezha.sh restart_agent              - 重启Agent"
    echo "--------------------------------------------------------"
}

show_menu() {
    printf "
    ${green}哪吒v0.20.5监控Agent管理脚本${plain}
    ————————————————-
    ${green}8.${plain}  安装监控Agent
    ${green}9.${plain}  修改Agent配置
    ${green}10.${plain} 查看Agent日志
    ${green}11.${plain} 卸载Agent
    ${green}12.${plain} 重启Agent
    ————————————————-
    ${green}0.${plain}  退出脚本
    "
    echo && printf "请输入选择 [0-13]: " && read -r num
    case "${num}" in
        0)
            exit 0
            ;;
        8)
            install_agent
            ;;
        9)
            modify_agent_config
            ;;
        10)
            show_agent_log
            ;;
        11)
            uninstall_agent
            ;;
        12)
            restart_agent
            ;;
        *)
            err "请输入正确的数字 [0-13]"
            ;;
    esac
}

pre_check

if [ $# -gt 0 ]; then
    case $1 in
        "install_agent")
            shift
            if [ $# -ge 3 ]; then
                install_agent "$@"
            else
                install_agent 0
            fi
            ;;
        "modify_agent_config")
            modify_agent_config 0
            ;;
        "show_agent_log")
            show_agent_log 0
            ;;
        "uninstall_agent")
            uninstall_agent 0
            ;;
        "restart_agent")
            restart_agent 0
            ;;
        *) show_usage ;;
    esac
else
    select_version
    show_menu
fi
