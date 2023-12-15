# knoxfs
## Prepare tor
Need to create tor hashed password, so install tor package

`apt update && apt install -y tor`

Generate tor hash password
`tor --hash-password your_password`
save for later

You can remove tor by 
`apt purge tor`

## Run tor-proxy

Tor-proxy repo
https://github.com/aaros-pl/tor-docker

Prepare your torrc file in current dir (example in repo), replace random hash with your password hash

Run tor container

```
docker run -d --privileged \
    --name tor-proxy \
    --restart=on-failure \
    --user debian-tor \
    -v $PWD/torrc:/etc/tor/torrc \
    -v hidden-services:/var/lib/tor \
    -p 9050:9050 \
    -p 9051:9051 \
    ghcr.io/aaros-pl/tor-docker:master-v2-onion@sha256:7c605a6930fff19bd0e3054fcb98dcd7b77f640376c0e52b2539ebd41de06715
```
    

You can check your tor-proxy container by running
`curl --proxy socks5h://localhost:9050 'https://wtfismyip.com/yaml'`

## Run knoxfsd

Knoxfs docker repo
https://github.com/aaros-pl/knoxfs

Run knoxfsd to obtain onion v2 address and init knoxfs daemon, replace tor-proxy-host-ip with your tor host ip, can be 127.0.0.1 (only if `--network=host` specified, don't use localhost) if run on the same machine.
You can wait for chain to sync.
```
docker run -a STDOUT \
    --network=host \
    --rm \
    -v knoxfsmn1-data:/data \
    ghcr.io/aaros-pl/knoxfs:v5.3.3-beta \
    -datadir=/data \
    -listen=1 \
    -discover=1 \
    -listenonion=1 \
    -proxy=127.0.0.1:9050 \
    -onion=127.0.0.1:9050 \
    -torcontrol=127.0.0.1:9051 \
    -torpassword=your_password \
    -debug=tor \
    -logtimestamps=0
```

when you obtain onion address from logs you can exit and remove container by Ctrl+C, then replace masternodeaddr with your onion address, and your private key, and tor-proxy-host-ip.
You can add your other masternodes by addnode to sync faster with network.

## Run your masternode
```
docker run -d \
    --network=host \
    --restart=on-failure \
    -v knoxfsmn1-data:/data \
    ghcr.io/aaros-pl/knoxfs:v5.3.3-beta \
    -datadir=/data \
    -listen=1 \
    -discover=1 \
    -listenonion=1 \
    -proxy=127.0.0.1:9050 \
    -onion=127.0.0.1:9050 \
    -torcontrol=127.0.0.1:9051 \
    -torpassword=your_password \
    -debug=tor \
    -logtimestamps=0 \
    -masternode=1 \
    -masternodeprivkey=yourmasternodeprivatekey \
    -masternodeaddr=onionv2address.onion:29929 \
    -addnode=yournodeip:29929
```

Donations KFX: KM8vUExoDPijNdBwdWatnXEA4gQWigHGvw
