# What this is
This is my snapshot configuration. It uses btrbk.

I have a systemd timer, that runs btrbk each hour to snapshot. The btrbk config for my laptop does only this; the btrbk config for my pc also backups the root and home snapshot periodically, performing incremental snapshots weekly, and a non incremental snapshot every month.

I also have a pacman hook, so that btrbk performs a snapshot (but no backup here as that can take a long time, that should run in the background) before and after each upgrade, install or remove operation.

With the use of grub-btrfs, i can boot into the snapshots on the fly.

# Setup
My folder structure:
```
/               subvol=@root
|- home         subvol=@home
|- var          subvol=@var
|- .snapshots   subvol=@snapshots
|- bulk         /dev/mybackupdrive
```

- have subvolume @snapshots mounted to /.snapshots
- have subvolume @root mounted to /
- have subvolume @home mounted to /home
- have subvolume @var mounted to /var (having this subvolume is important so that readonly snapshots can be easily booted into later)

Optional:
- have a backup drive with btrfs mounted to /bulk

For every following step, make sure that the folder and subvolume names in the configurations match yours if you don't have them named exactly like mine
- install btrbk
    - put your chosen btrbk config in /etc/btrbk/btrbk.conf. I have one for my laptop, and one for my desktop. The difference is that the desktop configuration performs regular backups to a backup drive.
    - test it with btrbk -nS run (-n dry-run, -S show schedule)
- start systemd timer
    - put the systemd service files in /usr/lib/systemd/system (btrbk installs these automatically; however the btrbk.timer runst daily, not hourly by default. The btrbk.timer file in this repository runs hourly, that beeing the only difference)
    - run `systemctl enable --now btrbk.timer`
- install pacman hooks
    - copy hooks, and hooks.bin to /etc/pacman.d/

Optional:
Install grub-btrfs. For me it worked without extra configuration; just run it once manually (`sudo /etc/grub.d/41_snapshots-btrfs && grub-mkconfig -o /boot/grub/grub.cfg`) to test it out, and then enable the systemd service. For this, having /var on a separate subvolume is critical, else journals and logging will fail when trying to boot into a readonly snapshot.

# What else you can do
- You can perform a snapshot manually with btrbk snapshot
- You can perform actions not defined in your btrbk configuration by defining things as parameters. For this read the btrbk documentation.
- You can perform a manual backup using btrfs send and recieve, sending a created snapshot to a different drive or location. Maybe watch out that btrbk doesn't run during this process and accidentally deletes the snapshot you are trying to back up; No idea what would happen or take precedence
- You can restore a snapshot you created. For this, consult the btrbk github README.md. There is no automatic tool to perform this

# sources
https://github.com/digint/btrbk
https://wiki.archlinux.org/title/pacman#Hooks
https://man.archlinux.org/man/alpm-hooks.5
https://wiki.archlinux.org/title/btrfs
