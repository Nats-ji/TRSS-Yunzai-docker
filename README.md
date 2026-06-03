# TRSS Yunzai Docker

## Usage
With docker compose:
```yaml
services:
  yunzai:
    container_name: yunzai-bot
    image: ghcr.io/nats-ji/trss-yunzai-docker:main                                          # 是否在构建时安装锅巴插件
    restart: unless-stopped
    hostname: yunzai
    ports:
      - "2536:2536"                                                      # 映射锅巴插件端口，格式"主机端口:容器内部端口"
    volumes:
      - type: volume
        source: yunzai
        target: /app/TRSS-Yunzai/config
        volume:
          subpath: config #首次运行需要手动在yunzai volume下创建文件夹
      - type: volume
        source: yunzai
        target: /app/TRSS-Yunzai/logs
        volume:
          subpath: logs #首次运行需要手动在yunzai volume下创建文件夹
      - type: volume
        source: yunzai
        target: /app/TRSS-Yunzai/data
        volume:
          subpath: data #首次运行需要手动在yunzai volume下创建文件夹
      - type: volume
        source: yunzai
        target: /app/TRSS-Yunzai/temp
        volume:
          subpath: temp #首次运行需要手动在yunzai volume下创建文件夹
      - type: volume
        source: yunzai
        target: /app/TRSS-Yunzai/plugins
        volume:
          subpath: plugins #首次运行需要手动在yunzai volume下创建文件夹
    depends_on:
      redis:
        condition: service_healthy
      napcat:
        condition: service_started

  redis:
    container_name: yunzai-redis
    image: redis:alpine
    hostname: yunzai-redis
    restart: always
    volumes:
      # 前往 https://download.redis.io/redis-stable/redis.conf 下载配置文件，放入 ./redis/config 文件夹中
      # - ./redis/config:/etc/redis/    # Redis配置文件
      # command: /etc/redis/redis.conf    # 取消注释以应用Redis配置文件
      - type: volume
        source: yunzai
        target: /data
        volume:
          subpath: redis/data #首次运行需要手动在yunzai volume下创建文件夹
      - type: volume
        source: yunzai
        target: /logs
        volume:
          subpath: redis/logs #首次运行需要手动在yunzai volume下创建文件夹
    healthcheck:
      test: [ "CMD", "redis-cli", "PING" ]
      start_period: 10s
      interval: 5s
      timeout: 1s

  napcat:
    container_name: yunzai-napcat
    image: mlikiowa/napcat-docker:latest
    restart: always
    
    environment:
      - NAPCAT_UID=1000
      - NAPCAT_GID=1000
    
    ports:
      - 6099:6099
    
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - type: volume
        source: yunzai
        target: /app/napcat/config
        volume:
          subpath: napcat/config #首次运行需要手动在yunzai volume下创建文件夹
      - type: volume
        source: yunzai
        target: /app/.config/QQ
        volume:
          subpath: ntqq #首次运行需要手动在yunzai volume下创建文件夹
volumes:
  yunzai:
    name: yunzai
```


## Build

1. Install docker

2. Build images

```sh
git clone --depth 1 https://github.com/Nats-ji/TRSS-Yunzai-docker.git
cd ./TRSS-Yunzai-docker
sudo docker compose up

# stop the docker by press Ctrl+C
sudo vim ./yunzai/lagrange/appsettings.json
```

3. Edit as the following

```diff
{
    "Logging": {
        "LogLevel": {
            "Default": "Information",
            "Microsoft": "Warning",
            "Microsoft.Hosting.Lifetime": "Information"
        }
    },
--  "SignServerUrl": "",
++  "SignServerUrl": "put-url-here",
    "Account": {
        "Uin": 0,
        "Password": "",
        "Protocol": "Linux",
        "AutoReconnect": true,
        "GetOptimumServer": true
    },
    "Message": {
      "IgnoreSelf": true,
      "StringPost": false
    },
    "QrCode": {
        "ConsoleCompatibilityMode": false
    },
    "Implementations": [
        {
            "Type": "ReverseWebSocket",
--          "Host": "127.0.0.1",
--          "Port": 8080,
--          "Suffix": "/onebot/v11/ws",
++          "Host": "yunzai",
++          "Port": 2536,
++          "Suffix": "/OneBotv11",
            "ReconnectInterval": 5000,
            "HeartBeatInterval": 5000,
            "AccessToken": ""
        }
    ]
}
```

4. Edit other configs
```sh
# yunzai config location
./yunzai/config

# genshin plugin config location
./yunzai/plugins/genshin/config

# redis data location
./yunzai/redis
```

5. Start docker compose
```sh
sudo docker compose up
```

6. Backup data
```sh
sudo backup.sh

cd ./backups
ls
```

## Use with CasaOS

https://github.com/Nats-ji/casaos-rpi-apps-repo/tree/main
