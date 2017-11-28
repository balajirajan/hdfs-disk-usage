usage:
change the maxdepth and root folder and measurement(MB/GB/TB) as per your requirement in the script.
1. max_depth:
	 It set as 3, which means it will travers upto folder1/folder2/folder3.
2. Root folder:
	 Default as "/". change the path in variable "largest_root_dirs" on line#4.
	  largest_root_dirs=$(sudo -u hdfs hdfs dfs -du -s '/*' | sort -nr | perl -ane 'print "$F[2] "')
3. Measurements: 
	for TB: awk 'BEGIN {total=0}{total=$1}END{print total/1024/1024/1024/1024"TB"}' 
	for TB: awk 'BEGIN {total=0}{total=$1}END{print total/1024/1024/1024"GB"}' 
	for TB: awk 'BEGIN {total=0}{total=$1}END{print total/1024/1024"MB"}' 
