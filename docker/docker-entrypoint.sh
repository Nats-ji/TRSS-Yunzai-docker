#!/usr/bin/env bash

set +e

GreenBG="\\033[42;37m"
YellowBG="\\033[43;37m"
BlueBG="\\033[44;37m"
Font="\\033[0m"

Version="${BlueBG}[版本]${Font}"
Info="${GreenBG}[信息]${Font}"
Warn="${YellowBG}[提示]${Font}"

WORK_DIR="/app/TRSS-Yunzai"
GENSHIN_PLUGIN_PATH="/app/TRSS-Yunzai/plugins/genshin"
MIAO_PLUGIN_PATH="/app/TRSS-Yunzai/plugins/miao-plugin"
LAGRANGE_PLUGIN_PATH="/app/TRSS-Yunzai/plugins/Lagrange-Plugin"
TRSS_PLUGIN_PATH="/app/TRSS-Yunzai/plugins/TRSS-Plugin"
XIAOYAO_CVS_PATH="/app/TRSS-Yunzai/plugins/xiaoyao-cvs-plugin"
PY_PLUGIN_PATH="/app/TRSS-Yunzai/plugins/py-plugin"
FanSky_Qs_PATH="/app/TRSS-Yunzai/plugins/FanSky_Qs"

if [[ ! -d "$HOME/.ovo" ]]; then
    mkdir ~/.ovo
fi

echo -e "\n ================ \n ${Info} ${GreenBG} 拉取 TRSS-Yunzai 更新 ${Font} \n ================ \n"

cd $WORK_DIR

if [[ -z $(git status -s) ]]; then
    echo -e " ${Warn} ${YellowBG} 当前工作区有修改，尝试暂存后更新。${Font}"
    git add .
    git stash
    git pull origin main --allow-unrelated-histories --rebase
    git stash pop
else
    git pull origin main --allow-unrelated-histories
fi

if [[ ! -f "$HOME/.ovo/yunzai.ok" ]]; then
    set -e
    echo -e "\n ================ \n ${Info} ${GreenBG} 更新 TRSS-Yunzai 运行依赖 ${Font} \n ================ \n"
    pnpm i
    touch ~/.ovo/yunzai.ok
    set +e
fi

echo -e "\n ================ \n ${Version} ${BlueBG} TRSS-Yunzai 版本信息 ${Font} \n ================ \n"

git log -1 --pretty=format:"%h - %an, %ar (%cd) : %s"


if [ -d $GENSHIN_PLUGIN_PATH"/.git" ]; then

    echo -e "\n ================ \n ${Info} ${GreenBG} 拉取 genshin-plugin 插件更新 ${Font} \n ================ \n"

    cd $GENSHIN_PLUGIN_PATH

    if [[ -n $(git status -s) ]]; then
        echo -e " ${Warn} ${YellowBG} 当前工作区有修改，尝试暂存后更新。${Font}"
        git add .
        git stash
        git pull origin main --allow-unrelated-histories --rebase
        git stash pop
    else
        git pull origin main --allow-unrelated-histories
    fi

    if [[ ! -f "$HOME/.ovo/genshin.ok" ]]; then
        set -e
        echo -e "\n ================ \n ${Info} ${GreenBG} 更新 genshin-plugin 运行依赖 ${Font} \n ================ \n"
        pnpm i
        touch ~/.ovo/genshin.ok
        set +e
    fi

    echo -e "\n ================ \n ${Version} ${BlueBG} genshin-plugin 插件版本信息 ${Font} \n ================ \n"

    git log -1 --pretty=format:"%h - %an, %ar (%cd) : %s"

fi


if [ ! -d $MIAO_PLUGIN_PATH"/.git" ]; then
    echo -e "\n ${Warn} ${YellowBG} 由于TRSS-Yunzai依赖miao-plugin，检测到目前没有安装，开始自动下载 ${Font} \n"
    git clone --depth=1 https://github.com/yoimiya-kokomi/miao-plugin.git $MIAO_PLUGIN_PATH
fi


if [ -d $MIAO_PLUGIN_PATH"/.git" ]; then

    echo -e "\n ================ \n ${Info} ${GreenBG} 拉取 喵喵插件 更新 ${Font} \n ================ \n"

    cd $MIAO_PLUGIN_PATH

    if [[ -n $(git status -s) ]]; then
        echo -e " ${Warn} ${YellowBG} 当前工作区有修改，尝试暂存后更新。${Font}"
        git add .
        git stash
        git pull origin master --allow-unrelated-histories --rebase
        git stash pop
    else
        git pull origin master --allow-unrelated-histories
    fi

    if [[ ! -f "$HOME/.ovo/miao.ok" ]]; then
        set -e
        echo -e "\n ================ \n ${Info} ${GreenBG} 更新 喵喵插件 运行依赖 ${Font} \n ================ \n"
        pnpm install -P
        touch ~/.ovo/miao.ok
        set +e
    fi

    echo -e "\n ================ \n ${Version} ${BlueBG} 喵喵插件版本信息 ${Font} \n ================ \n"
    git log -1 --pretty=format:"%h - %an, %ar (%cd) : %s"

fi


if [ ! -d $TRSS_PLUGIN_PATH"/.git" ]; then
    echo -e "\n ${Warn} ${YellowBG} 由于TRSS-Yunzai依赖trss-plugin，检测到目前没有安装，开始自动下载 ${Font} \n"
    git clone --depth=1 https://github.com/TimeRainStarSky/TRSS-Plugin.git $TRSS_PLUGIN_PATH
fi

if [ -d $TRSS_PLUGIN_PATH"/.git" ]; then

    echo -e "\n ================ \n ${Info} ${GreenBG} 拉取 trss-plugin 插件更新 ${Font} \n ================ \n"

    cd $TRSS_PLUGIN_PATH

    if [[ -n $(git status -s) ]]; then
        echo -e " ${Warn} ${YellowBG} 当前工作区有修改，尝试暂存后更新。${Font}"
        git add .
        git stash
        git pull origin main --allow-unrelated-histories --rebase
        git stash pop
    else
        git pull origin main --allow-unrelated-histories
    fi

    if [[ ! -f "$HOME/.ovo/trss.ok" ]]; then
        set -e
        echo -e "\n ================ \n ${Info} ${GreenBG} 更新 trss-plugin 运行依赖 ${Font} \n ================ \n"
        pnpm i
        touch ~/.ovo/trss.ok
        set +e
    fi

    echo -e "\n ================ \n ${Version} ${BlueBG} trss-plugin 插件版本信息 ${Font} \n ================ \n"

    git log -1 --pretty=format:"%h - %an, %ar (%cd) : %s"

fi


if [ ! -d $LAGRANGE_PLUGIN_PATH"/.git" ]; then
    echo -e "\n ${Warn} ${YellowBG} 由于TRSS-Yunzai依赖lagrange-plugin，检测到目前没有安装，开始自动下载 ${Font} \n"
    git clone --depth=1 https://github.com/TimeRainStarSky/Yunzai-Lagrange-Plugin.git $LAGRANGE_PLUGIN_PATH
fi

if [ -d $LAGRANGE_PLUGIN_PATH"/.git" ]; then

    echo -e "\n ================ \n ${Info} ${GreenBG} 拉取 Lagrange-Plugin 插件更新 ${Font} \n ================ \n"

    cd $LAGRANGE_PLUGIN_PATH

    if [[ -n $(git status -s) ]]; then
        echo -e " ${Warn} ${YellowBG} 当前工作区有修改，尝试暂存后更新。${Font}"
        git add .
        git stash
        git pull origin main --allow-unrelated-histories --rebase
        git stash pop
    else
        git pull origin main --allow-unrelated-histories
    fi

    if [[ ! -f "$HOME/.ovo/lagrange.ok" ]]; then
        set -e
        echo -e "\n ================ \n ${Info} ${GreenBG} 更新 Lagrange-Plugin 运行依赖 ${Font} \n ================ \n"
        pnpm i
        touch ~/.ovo/lagrange.ok
        set +e
    fi

    echo -e "\n ================ \n ${Version} ${BlueBG} Lagrange-Plugin 插件版本信息 ${Font} \n ================ \n"

    git log -1 --pretty=format:"%h - %an, %ar (%cd) : %s"

fi


if [ -d $PY_PLUGIN_PATH"/.git" ]; then

    echo -e "\n ================ \n ${Info} ${GreenBG} 拉取 py-plugin 插件更新 ${Font} \n ================ \n"

    cd $PY_PLUGIN_PATH

    if [[ -n $(git status -s) ]]; then
        echo -e " ${Warn} ${YellowBG} 当前工作区有修改，尝试暂存后更新。${Font}"
        git add .
        git stash
        git pull origin v3 --allow-unrelated-histories --rebase
        git stash pop
    else
        git pull origin v3 --allow-unrelated-histories
    fi

    if [[ ! -f "$HOME/.ovo/py.ok" ]]; then
        set -e
        echo -e "\n ================ \n ${Info} ${GreenBG} 更新 py-plugin 运行依赖 ${Font} \n ================ \n"
        cd $WORK_DIR
	pnpm install --filter=py-plugin
	
	cd $PY_PLUGIN_PATH
	poetry run pip install -r requirements.txt
	poetry run pip install nonebot2 nonebot-adapter-onebot
        touch ~/.ovo/py.ok
        set +e
    fi

    echo -e "\n ================ \n ${Version} ${BlueBG} py-plugin 插件版本信息 ${Font} \n ================ \n"

    git log -1 --pretty=format:"%h - %an, %ar (%cd) : %s"

fi

if [ -d $FanSky_Qs_PATH"/.git" ]; then

    echo -e "\n ================ \n ${Info} ${GreenBG} 拉取 FanSky_Qs 插件更新 ${Font} \n ================ \n"

    cd $FanSky_Qs_PATH

    if [[ -n $(git status -s) ]]; then
        echo -e " ${Warn} ${YellowBG} 当前工作区有修改，尝试暂存后更新。${Font}"
        git add .
        git stash
        git pull origin main --allow-unrelated-histories --rebase
        git stash pop
    else
        git pull origin main --allow-unrelated-histories
    fi

    if [[ ! -f "$HOME/.ovo/fansky.ok" ]]; then
        set -e
        echo -e "\n ================ \n ${Info} ${GreenBG} 更新 FanSky_Qs 运行依赖 ${Font} \n ================ \n"
        pnpm install
        touch ~/.ovo/fansky.ok
        set +e
    fi

    echo -e "\n ================ \n ${Version} ${BlueBG} FanSky_Qs 插件版本信息 ${Font} \n ================ \n"

    git log -1 --pretty=format:"%h - %an, %ar (%cd) : %s"

fi


if [ -d $XIAOYAO_CVS_PATH"/.git" ]; then

    echo -e "\n ================ \n ${Info} ${GreenBG} 拉取 xiaoyao-cvs 插件更新 ${Font} \n ================ \n"

    cd $XIAOYAO_CVS_PATH

    if [[ -n $(git status -s) ]]; then
        echo -e " ${Warn} ${YellowBG} 当前工作区有修改，尝试暂存后更新。${Font}"
        git add .
        git stash
        git pull origin master --allow-unrelated-histories --rebase
        git stash pop
    else
        git pull origin master --allow-unrelated-histories
    fi

    if [[ ! -f "$HOME/.ovo/xiaoyao.ok" ]]; then
        set -e
        echo -e "\n ================ \n ${Info} ${GreenBG} 更新 xiaoyao-cvs 插件运行依赖 ${Font} \n ================ \n"
#        pnpm add promise-retry superagent -w
        touch ~/.ovo/xiaoyao.ok
        set +e
    fi

    echo -e "\n ================ \n ${Version} ${BlueBG} xiaoyao-cvs 插件版本信息 ${Font} \n ================ \n"

    git log -1 --pretty=format:"%h - %an, %ar (%cd) : %s"
fi

if [ -d $GUOBA_PLUGIN_PATH"/.git" ]; then

    echo -e "\n ================ \n ${Info} ${GreenBG} 拉取 Guoba-Plugin 插件更新 ${Font} \n ================ \n"

    cd $GUOBA_PLUGIN_PATH

    if [[ -n $(git status -s) ]]; then
        echo -e " ${Warn} ${YellowBG} 当前工作区有修改，尝试暂存后更新。${Font}"
        git add .
        git stash
        git pull origin master --allow-unrelated-histories --rebase
        git stash pop
    else
        git pull origin master --allow-unrelated-histories
    fi

    if [[ ! -f "$HOME/.ovo/guoba.ok" ]]; then
        set -e
        echo -e "\n ================ \n ${Info} ${GreenBG} 更新 Guoba-Plugin 插件运行依赖 ${Font} \n ================ \n"
        pnpm add multer body-parser jsonwebtoken -w
        touch ~/.ovo/guoba.ok
        set +e
    fi

    echo -e "\n ================ \n ${Version} ${BlueBG} Guoba-Plugin 插件版本信息 ${Font} \n ================ \n"

    git log -1 --pretty=format:"%h - %an, %ar (%cd) : %s"
fi

set -e

cd $WORK_DIR

echo -e "\n ================ \n ${Info} ${GreenBG} 初始化 Docker 环境 ${Font} \n ================ \n"

if [ -f "./config/config/redis.yaml" ]; then
    sed -i 's/127.0.0.1/redis/g' ./config/config/redis.yaml
    echo -e "\n  修改Redis地址完成~  \n"
fi

echo -e "\n ================ \n ${Info} ${GreenBG} 启动 TRSS-Yunzai ${Font} \n ================ \n"

set +e
exec 0<&-
node .
EXIT_CODE=$?

if [[ $EXIT_CODE != 0 ]]; then
	echo -e "\n ================ \n ${Warn} ${YellowBG} 启动 TRSS-Yunzai 失败 ${Font} \n ================ \n"
	tail -f /dev/null
fi
