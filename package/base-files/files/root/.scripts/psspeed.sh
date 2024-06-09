#!/usr/bin/env bash

function clean_results()
{
      grep ^real | cut -dm -f2 | sort | uniq -c | sort -n
}

for i in {0..500};
do
      time sh -c "expr `sed -nu 's/^MemFree:[\t ]\+\([0-9]\+\) kB/\1/Ip' /proc/meminfo`/1024" &>/dev/nulll;
done 2>&1 | clean_results

# print separating line
printf "%$((${COLUMNS:-`tput cols`} - 10))s\n" ' ' | sed -u 's/ /-/g'

for i in {0..500};
do
      time sh -c "echo $(( `sed -nu 's/^MemFree:[\t ]\+\([0-9]\+\) kB/\1/Ip' /proc/meminfo`/1024 ))" &>/dev/null;
done 2>&1 | clean_results

exit $?