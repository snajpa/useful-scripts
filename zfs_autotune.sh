#!/bin/bash

zpool=vz
tune_dirty_data_sync=1
tune_txg_timeout=1

cat_dirty_data_sync=$(cat /sys/module/zfs/parameters/zfs_dirty_data_sync)
cat_zfs_txg_timeout=$(cat /sys/module/zfs/parameters/zfs_txg_timeout)
txg_timeout_nsec=$(($cat_zfs_txg_timeout * 1000 * 1000 * 1000))

txgs_dirtys=$(cat /proc/spl/kstat/zfs/$zpool/txgs | awk '$3 ~ /C/ { print $4 }')
txgs_otimes=$(cat /proc/spl/kstat/zfs/$zpool/txgs | awk '$3 ~ /C/ { print $9 }')
txgs_stimes=$(cat /proc/spl/kstat/zfs/$zpool/txgs | awk '$3 ~ /C/ { print $12 }')
txgs_count=$(echo $txgs_dirtys | wc -w)

early_sync_txgs=0
ratio_early_sync_txgs=0
otime_underruns=0
ratio_otime_underruns=0
otime_overruns=0
ratio_otime_overruns=0
long_stimes=0
ratio_long_stimes=0

for dirty in $txgs_dirtys; do 
	dirty_to_max_ratio=$(( $dirty * 100 / $cat_dirty_data_sync ))
	if [ "$dirty_to_max_ratio" -ge 80 ]; then 
		early_sync_txgs=$(($early_sync_txgs + 1))
	fi
done

ratio_early_sync_txgs=$(($early_sync_txgs * 100 / $txgs_count));

for otime in $txgs_otimes; do
	otime_to_timeout_ratio=$(($otime * 100 / $txg_timeout_nsec))
	if [ "$otime_to_timeout_ratio" -ge 120 ]; then
		otime_overruns=$(($otime_overruns + 1))
	fi;
	if [ "$otime_to_timeout_ratio" -le 85 ]; then
		otime_underruns=$(($otime_underruns + 1))
	fi;
done

ratio_otime_overruns=$(( $otime_overruns * 100 / $txgs_count));
ratio_otime_underruns=$(( $otime_underruns * 100 / $txgs_count));

for stime in $txgs_stimes; do
	stime_to_otime_ratio=$(($stime * 100 / $txg_timeout_nsec))
	if [ "$stime_to_otime_ratio" -ge 50 ]; then
		long_stimes=$(($long_stimes + 1))
	fi;
done

ratio_long_stimes=$(( $long_stimes * 100 / $txgs_count));

if [ "$tune_dirty_data_sync" == 1 ] && [ "$ratio_early_sync_txgs" -ge 50 ]; then
	echo "# Increasing zfs_dirty_data_sync by 64M";
	echo $(($cat_dirty_data_sync + $(( 1024 * 1024 * 64)))) > /sys/module/zfs/parameters/zfs_dirty_data_sync;
	changed_dirty_data_sync=1
fi;

if [ "$tune_txg_timeout" == 1 ] && ([ "$ratio_otime_overruns" -ge 30 ] || [ "$ratio_long_stimes" -ge 30 ]); then
	echo "# Increasing zfs_txg_timeout by 5s"
	echo $(($cat_zfs_txg_timeout + 5)) > /sys/module/zfs/parameters/zfs_txg_timeout
	changed_txg_timeout=1
fi;

printf "txgs_count		= %s\n"		$txgs_count
printf "early_sync_txgs		= %s\n"		$early_sync_txgs
printf "dirty_data_sync		= %sM\n"	$(($(cat /sys/module/zfs/parameters/zfs_dirty_data_sync) / 1024 / 1024))
printf "ratio_early_sync_txgs	= %s%%\n"	$ratio_early_sync_txgs
printf "ratio_otime_overruns	= %s%%\n"	$ratio_otime_overruns
printf "ratio_otime_underruns	= %s%%\n"	$ratio_otime_underruns
printf "ratio_long_stimes	= %s%%\n"	$ratio_long_stimes
printf "changed_dirty_data_sync	= %s\n"		${changed_dirty_data_sync:-0}
printf "changed_txg_timeout	= %s\n"		${changed_txg_timeout:-0}
