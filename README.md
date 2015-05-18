useful-scipts
=============

arcmap: show amount of ARC by dataset
meminfo: memory info on vpsfree zfs systems
zfs-modprobe-conf: /etc/modprobe.d/zfs.conf generator for vpsfree systems

Examples of use:

arcmap
======
```
[root@dev1.prg.vpsfree.cz]
 ~/useful-scripts # ./arcmap storage
storage                                                     0M
storage/export                                              0M
storage/images                                              0M
storage/libvirt                                             0M
storage/libvirt/arch                                        8M
storage/libvirt/arch@download                               0M
storage/vz                                                210M
storage/vz/101                                              0M
storage/vz/private                                        676M
```

meminfo
=======
```
[root@dev1.prg.vpsfree.cz]
 ~/useful-scripts # ./meminfo -v
mem_total                    23970 MB
mem_free                     19641 MB
mem_free_no_cache            19702 MB
mem_swap_free                30655 MB
mem_swap_used                    0 MB
slab_size                      355 MB
dcache_size                    423 MB
swapcache_size                   0 MB
buffers_size                    61 MB
committed                     2512 MB

arc_c_max                     6144 MB
arc_c                         6144 MB
arc_size                       976 MB
arc_hdr_size                    12 MB
arc_l2_hdr_size                  0 MB
arc_mfu_size                   278 MB
arc_mfu_ghost_size               0 MB
arc_mru_size                   642 MB
arc_mru_ghost_size               0 MB
arc_meta_limit                1536 MB
arc_meta_used                   84 MB
arc_meta_max                    85 MB
```

zfs-modprobe-conf
=================
```
[root@dev1.prg.vpsfree.cz]
 ~/useful-scripts # ./zfs-modprobe-conf 
# Optimal settings for 24 G RAM
#     zfs_arc_max = 6144 M
#     zfs_arc_meta_limit = 1536 M
#     zfs_arc_meta_prune = 256000
#     zfs_txg_history = 15
#     zfs_txg_timeout = 10
#     zfs_dirty_data_sync = 512 M
#     
options zfs \
    zfs_arc_max=6442450944 \
    zfs_arc_meta_limit=1610612736 \
    zfs_arc_meta_prune=256000 \
    zfs_txg_history=15 \
    zfs_txg_timeout=10 \
    zfs_dirty_data_sync=536870912
```
