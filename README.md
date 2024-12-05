# TRSS Yunzai Docker

1. Install docker

2. Build images

```sh
git clone --depth 1 https://github.com/Nats-ji/TRSS-Yunzai-docker.git
cd ./TRSS-Yunzai-docker
sudo docker compose up

# stop the docker by press Ctrl+C
sudo vim ./lagrange/appsettings.json
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
./yunzai/genshin_config

# redis data location
./redis
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
