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
PLUGIN_DIR="/app/TRSS-Yunzai/plugins"

echo -e "\n ================ \n ${Info} ${GreenBG} 拉取 TRSS-Yunzai 更新 ${Font} \n ================ \n"

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
echo -e "\n ================ \n ${Info} ${GreenBG} 更新 TRSS-Yunzai 运行依赖 ${Font} \n ================ \n"
pnpm i
set +e

echo -e "\n ================ \n ${Version} ${BlueBG} TRSS-Yunzai 版本信息 ${Font} \n ================ \n"

git log -1 --pretty=format:"%h - %an, %ar (%cd) : %s"


PLUGINS=($(find $PLUGIN_DIR -mindepth 1 -maxdepth 1 -type d))
for PLUGIN in "${PLUGINS[@]}"; do
    cd "$PLUGIN";
    PLUGIN_NAME=${PWD##*/}

    if [ -d .git ]; then
        echo -e "\n ================ \n ${Info} ${GreenBG} 拉取 $PLUGIN_NAME 更新 ${Font} \n ================ \n"

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
        echo -e "\n ================ \n ${Info} ${GreenBG} 更新 $PLUGIN_NAME 运行依赖 ${Font} \n ================ \n"
        cd "$WORK_DIR"
        yes | pnpm i --filter=$PLUGIN_NAME
        cd "$PLUGIN"
        set +e

        echo -e "\n ================ \n ${Version} ${BlueBG} $PLUGIN_NAME 版本信息 ${Font} \n ================ \n"

        git log -1 --pretty=format:"%h - %an, %ar (%cd) : %s"
    fi
done

echo -e "\n ================ \n ${Info} ${GreenBG} 初始化 Docker 环境 ${Font} \n ================ \n"

if [ -f "./config/config/redis.yaml" ]; then
    sed -i 's/127.0.0.1/redis/g' ./config/config/redis.yaml
    echo -e "\n  修改Redis地址完成~  \n"
fi

echo -e "\n ================ \n ${Info} ${GreenBG} 启动 TRSS-Yunzai ${Font} \n ================ \n"

set +e
cd "$WORK_DIR"
node app
EXIT_CODE=$?

if [[ $EXIT_CODE != 0 ]]; then
	echo -e "\n ================ \n ${Warn} ${YellowBG} 启动 TRSS-Yunzai 失败 ${Font} \n ================ \n"
	tail -f /dev/null
fi
