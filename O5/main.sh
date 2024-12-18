#!/bin/bash

start_time=$SECONDS

if [ $# -ne 1 ]; then
  echo "Error: Wrong parameters count. Enter folder name as parameter."
  exit 1
fi

folder_name=$1

print_folders_count() {
    echo -n "Total number of folders (including all nested ones) = "
   find ${1} -type d | grep -Ev '^[\.]{1,2}$' | wc -l
}

print_to5_folders() {
    echo "TOP 5 folders of maximum size arranged in descending order (path and size):"
    du ${1} -h --max-depth=1 | sort -hr | head -n 5 | awk '{print "- " $2",", $1}' | nl | column -t
    echo "etc up to 5"
}

print_number_of_files () {
    echo -n "Total number of files = "
    find ${1} -type f | wc -l
}

print_number_of_confs() {
    echo -n "Configuration files (with the .conf extension) = "
    find ${1} -type f -name "*.conf" | wc -l
}

print_number_of_texts() {
    echo -n "Text files = "
    find ${1} -type f -exec file {} + | grep text | wc -l
}

print_number_of_execs() {
    echo -n "Executable files = "
    find ${1} -type f -executable | wc -l
}

print_number_of_logs() {
    echo -n "Log files (with the extension .log) = "
    find ${1} -type f -name "*.log" | wc -l
}

print_number_of_arcs() {
    echo -n "Archive files = "
    find ${1} -type f -exec file {} + | grep archive | wc -l
}

print_number_of_arcs() {
    echo -n "Symbolic links = "
    find ${1} -type l | wc -l
}

print_top10_files() {
    echo "TOP 10 files of maximum size arranged in descending order (path, size and type):"
    find ${1} -type f -printf '%s %p\n' | sort -nr | head -n 10 | awk '{print NR,$0}' | while read number line ; do 
        size="${line%% *}" 
        path="${line#* }" 
        human_size=$(numfmt --to=iec --suffix=B $size)
        file_type=$(file --extension "$path" | awk '{print $2}')

         printf "%-2d - %s, %s, %s\n" "$number" "$path" "$human_size" "$file_type"
    done
    echo "etc up to 10"  
}

print_top10_exec() {
    echo "TOP 10 executable files of the maximum size arranged in descending order (path, size and MD5 hash of file):"
    find ${1} -type f -executable -printf '%s %p\n' | sort -nr | head -n 10 | awk '{print NR,$0}' | while read number line ; do
        size="${line%% *}" 
        path="${line#* }"
        md5_hash=$(md5sum "$path" | cut -d ' ' -f 1)
        human_size=$(numfmt --to=iec --suffix=B $size)
        
        printf "%-2d - %s, %s, %s\n" $number "$path" "$human_size" "$md5_hash"
    done
    echo "etc up to 10"  
}

if test -d "$folder_name" ; then
    print_folders_count "$folder_name"
    print_to5_folders "$folder_name"
    print_number_of_files "$folder_name"
    echo "Number of:"
    print_number_of_confs "$folder_name"
    print_number_of_texts "$folder_name"
    print_number_of_execs "$folder_name"
    print_number_of_logs "$folder_name"
    print_number_of_arcs "$folder_name"
    print_top10_files "$folder_name"
    print_top10_exec "$folder_name"
else 
    echo "Error: Directory ${folder_name} not found."
    exit 1
fi

end_time=$SECONDS

elapsed=$((end_time - start_time))

echo "Script execution time (in seconds) = ${elapsed}"