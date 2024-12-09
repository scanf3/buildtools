#!/bin/bash
# This script is used to extract clang-format executable file from llvm package

root_dir=$PWD

# clear the hash.md
cat /dev/null > hash.md

# Traverse all tar.gz under llvm directory 
for file in buildtools-*.tar.gz;do
    # unzip the llvm package
    raw_folder=$(echo $file | sed 's/.tar.gz//g')

    mkdir $root_dir/$raw_folder
    tar -zxvf "$root_dir/$file" -C "$root_dir/$raw_folder/"

    
    # extract the clang-format file
    clang_format_dir=$(echo $raw_folder | sed 's/llvm/clang-format/g')
    mkdir $clang_format_dir
    cp $root_dir/$raw_folder/bin/clang-format $clang_format_dir/
    
    # package the artifacts
    tar -czf $clang_format_dir.tar.gz $clang_format_dir

    # get the hash of file and write in hash.md
    hash=$(openssl dgst -sha256 "$clang_format_dir.tar.gz" | awk '{print $2}')
    echo "$clang_format_dir.tar.gz: $hash" - >> hash.md

    # delete llvm packages
    rm -rf $file
done

echo "Extraction and archiving completed."