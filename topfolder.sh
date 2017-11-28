#!/usr/bin/env bash
max_depth=3
 
largest_root_dirs=$(sudo -u hdfs hdfs dfs -du -s '/*' | sort -nr | perl -ane 'print "$F[2] "')
 
printf "%15s  %s\n" "TBytes" "directory"
for ld in $largest_root_dirs; do
    printf "%s  %s\n" $(sudo -u hdfs hdfs dfs -du -s $ld| cut -d' ' -f1 | awk 'BEGIN {total=0}{total=$1}END{print total/1024/1024/1024/1024"TB"}') $ld
    all_dirs=$(sudo -u hdfs hdfs dfs -ls -R $ld | egrep '^dr........' | perl -ane "scalar(split('/',\$_)) <= $max_depth && print \"\$F[7]\n\"" )
 
    for d in $all_dirs; do
        line=$(sudo -u hdfs hdfs dfs -du -s $d)
        size=$(echo $line | cut -d' ' -f1 | awk 'BEGIN {total=0}{total=$1}END{print total/1024/1024/1024/1024"TB"}')
        parent_dir=${d%/*}
        child=${d##*/}
        if [ -n "$parent_dir" ]; then
            leading_dirs=$(echo $parent_dir | perl -pe 's/./-/g; s/^.(.+)$/\|$1/')
            d=${leading_dirs}/$child
        fi
        printf "%s  %s\n" $size $d
    done
done
