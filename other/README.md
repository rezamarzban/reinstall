Setup Reinstall environment for VPS and so on

=

Setup Rescue System for VPS and so on

=

Setup Live Alpine for VPS and so on

=

Setup Remote Alpine for VPS and so on


Run (in case if your VPS OS is any Debian based OS):

```
wget https://raw.githubusercontent.com/rezamarzban/reinstall/refs/heads/main/other/setup.sh
chmod +x setup.sh
./setup.sh

```

Each time, To reactivate Live Alpine (Rescue System) at next boot, run:

```
./reactivate.sh

```

Then reboot and SSH to your server with:

Username: `root`

Password: `123@@@`

Note: Original Live Alpine Linux files can be downloaded from `https://dl-cdn.alpinelinux.org/alpine/v3.21/releases/x86_64/netboot-3.21.0/` webpage also. The `https://dl-cdn.alpinelinux.org/alpine/v3.21/main/x86_64/` contains packages for Alpine Linux Ver `3.21`.
