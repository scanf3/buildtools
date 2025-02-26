#!/bin/bash
# This script is used to extract clang-format executable file from llvm package

root_dir=$PWD

# clear the hash.md
cat /dev/null > hash.md

# Traverse all tar.gz under llvm directory 
echo "111"
pwd
ls
echo "111 end"
for file in buildtools-*.tar.gz;do
    # llvm files already exists
    raw_folder=$(echo $file | sed 's/.tar.gz//g')
    echo "raw folder"
    echo $raw_folder
    # extract the clang-format file
    clang_format_dir=$(echo $raw_folder | sed 's/llvm/clang-format/g')
    mkdir $clang_format_dir
    subdir=$(echo $raw_folder | awk -F"-" '{print $(NF-1)"-"$NF}')
    echo "222"
    ls
    echo "222 end"
    ls $root_dir/buildtools
    echo "333"
    ls $root_dir/buildtools/llvm
    cp $root_dir/buildtools/llvm/$subdir/bin/clang-format $clang_format_dir/
    
    # package the artifacts
    tar -czf $clang_format_dir.tar.gz $clang_format_dir

    # get the hash of file and write in hash.md
    hash=$(openssl dgst -sha256 "$clang_format_dir.tar.gz" | awk '{print $2}')
    echo "$clang_format_dir.tar.gz: $hash" - >> hash.md

    # delete llvm packages
    rm -rf $file
done

echo "Extraction and archiving completed."
