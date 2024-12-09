#!/bin/bash
# This script is used to extract clang-format executable file from llvm package

root_dir=$PWD

# 遍历当前目录下的 llvm 目录
for file in buildtools-*.tar.gz;do
    # 解压tar.gz文件
    raw_folder=$(echo $file | sed 's/.tar.gz//g')
    echo "111"
    echo $file
    echo $raw_folder
    mkdir $root_dir/$raw_folder
    tar -zxvf "$root_dir/$file" -C "$root_dir/$raw_folder/"

    
    # 拷贝文件
    clang_format_dir=$(echo $raw_folder | sed 's/llvm/clang-format/g')
    mkdir $clang_format_dir
    cp $root_dir/$raw_folder/bin/clang-format $clang_format_dir/
    
    # 打包成新的产物
    tar -czf $clang_format_dir.tar.gz $clang_format_dir
done

echo "Extraction and archiving completed."