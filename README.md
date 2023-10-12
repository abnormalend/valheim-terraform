# valheim-terraform

## Links

https://valheim.fandom.com/wiki/Valheim_Dedicated_Server
https://dev.to/briancaffey/on-demand-serverless-valheim-server-setup-with-aws-cdk-discord-interactions-and-gitlab-ci-58pj
https://developer.valvesoftware.com/wiki/SteamCMD#Linux
https://aws.amazon.com/blogs/gametech/hosting-your-own-dedicated-valheim-server-in-the-cloud/
https://lunajacob.medium.com/dedicated-valheim-server-built-with-terraform-gcp-caca8a64fd3b
https://github.com/kpenfound/valheim-server
https://michaeljherold.com/articles/provisioning-a-valheim-server-with-terraform/
https://github.com/ElijahGartin/valheim-dedicated-server-aws
https://github.com/valheimPlus/ValheimPlus

## Scripts

### Install Script

    #!/bin/sh
    steamcmd +@sSteamCmdForcePlatformType linux +force_install_dir /path/to/server +login anonymous +app_update 896660 -beta none validate +quit

### Startup Script

    #!/bin/sh
    export templdpath=$LD_LIBRARY_PATH  
    export LD_LIBRARY_PATH=./linux64:$LD_LIBRARY_PATH  
    export SteamAppID=892970

    echo "Starting server PRESS CTRL-C to exit"  
    ./valheim_server.x86_64 -name "<servername>" -port 2456 <-nographics> <-batchmode> -world "$WORLD_NAME" -password "$SERVER_PASSWORD" -public 1 >> /tmp/valheim_log.txt < /dev/null &  
    export LD_LIBRARY_PATH=$templdpath