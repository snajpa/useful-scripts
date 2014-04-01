useful-scipts
=============

check-zfs-health: check ZFS setup health (detect weird behavior)

example of use:
```
[root@node5.prg.vpsfree.cz]
 ~ # ./check-zfs-health 
Your ZFS setup is considered OK(0)
```


meminfo: memory info on vpsfree zfs systems

example of use:
```
[root@node3.prg.vpsfree.cz]
 ~ # ./meminfo 
mem_total                   128909 MB
slab_size                     6454 MB
dcache_size                   5604 MB
swapcache_size                2558 MB
buffers_size                    14 MB
arc_size                     28610 MB
arc_mfu_size                  8979 MB
arc_mfu_ghost_size            4374 MB
arc_mru_size                  4353 MB
arc_mru_ghost_size           24236 MB
zfs_arc_shrink_size           4028 MB
mem_free                      3355 MB
mem_free_no_cache             5927 MB
mem_swap_free                13934 MB
mem_swap_used                18727 MB
```
