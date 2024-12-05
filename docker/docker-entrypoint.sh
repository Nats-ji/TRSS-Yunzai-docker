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
CONFIG_DIR="/app/TRSS-Yunzai/config"
PLUGIN_DIR="/app/TRSS-Yunzai/plugins"

# Check if config empty
if [ ! "$(ls -A $CONFIG_DIR)" ]; then
    echo -e "\n ================ \n ${Info} ${GreenBG} 初始化 Docker 环境 ${Font} \n ================ \n" 
    git reset --hard

    # Clone plugins
    git clone --depth=1 https://github.com/TimeRainStarSky/Yunzai-genshin.git /app/TRSS-Yunzai/plugins/genshin
    git clone --depth=1 https://github.com/yoimiya-kokomi/miao-plugin /app/TRSS-Yunzai/plugins/miao-plugin
    git clone --depth=1 https://github.com/TimeRainStarSky/TRSS-Plugin /app/TRSS-Yunzai/plugins/TRSS-Plugin

    if [ -f "$HOME/.INSTALL_GUOBA" ]; then
        git clone --depth=1 https://github.com/guoba-yunzai/guoba-plugin.git /app/TRSS-Yunzai/plugins/Guoba-Plugin/
    fi
fi

echo -e "\n ================ \n ${Info} ${GreenBG} 拉取 Yunzai 更新 ${Font} \n ================ \n"

cd $WORK_DIR

if [[ -z $(git status -s) ]]; then
    echo -e " ${Warn} ${YellowBG} 当前工作区有修改，尝试暂存后更新。${Font}"
    git add .
    git stash
    git pull --allow-unrelated-histories --rebase
    git stash pop
else
    git pull --allow-unrelated-histories
fi

set -e
echo -e "\n ================ \n ${Info} ${GreenBG} 更新 Yunzai 运行依赖 ${Font} \n ================ \n"
pnpm i
set +e

echo -e "\n ================ \n ${Version} ${BlueBG} Yunzai 版本信息 ${Font} \n ================ \n"

git log -1 --pretty=format:"%h - %an, %ar (%cd) : %s"


PLUGINS=($(find $PLUGIN_DIR -mindepth 1 -maxdepth 1 -type d))
for PLUGIN in "${PLUGINS[@]}"; do
    cd "$PLUGIN";
    PLUGIN_NAME=${PWD##*/}

    if [ -d .git ]; then
        echo -e "\n ================ \n ${Info} ${GreenBG} 拉取 $PLUGIN_NAME 插件更新 ${Font} \n ================ \n"

        if [[ -n $(git status -s) ]]; then
            echo -e " ${Warn} ${YellowBG} 当前工作区有修改，尝试暂存后更新。${Font}"
            git add .
            git stash
            git pull --allow-unrelated-histories --rebase
            git stash pop
        else
            git pull --allow-unrelated-histories
        fi

        if [ -f "./package.json" ]; then
            set -e
            echo -e "\n ================ \n ${Info} ${GreenBG} 更新 $PLUGIN_NAME 插件运行依赖 ${Font} \n ================ \n"
            PKG_NAME=$(npm pkg get name)

            cd "$WORK_DIR"
            yes | pnpm i --filter=$PKG_NAME
            cd "$PLUGIN"
            set +e
        fi

        echo -e "\n ================ \n ${Version} ${BlueBG} $PLUGIN_NAME 插件版本信息 ${Font} \n ================ \n"

        git log -1 --pretty=format:"%h - %an, %ar (%cd) : %s"
    fi
done

echo -e "\n ================ \n ${Info} ${GreenBG} 初始化 Yunzai 设置 ${Font} \n ================ \n"

if [ -f "./config/config/redis.yaml" ]; then
    sed -i 's/127.0.0.1/redis/g' ./config/config/redis.yaml
    echo -e "\n  修改Redis地址完成~  \n"
fi

echo -e "\n ================ \n ${Info} ${GreenBG} 启动 Yunzai ${Font} \n ================ \n"

set +e
cd "$WORK_DIR"
node app
EXIT_CODE=$?

if [[ $EXIT_CODE != 0 ]]; then
	echo -e "\n ================ \n ${Warn} ${YellowBG} 启动 Yunzai 失败 ${Font} \n ================ \n"
	tail -f /dev/null
fi
