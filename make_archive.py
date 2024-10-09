import hashlib
import os
import shutil


def read_ensure_file():
    with open('cipd.ensure', 'r') as f:
        content = f.read()

    subdirs = []
    for line in content.split(os.linesep):
        if line and line.startswith('@Subdir'):
            subdirs.append(line[8:])
    return subdirs


def make_archive(subdirs):
    for subdir in subdirs:
        print(f'compressing {subdir.replace('/', '-')}.tar.gz')
        shutil.make_archive(subdir.replace('/', '-'), 'gztar', subdir)


def generate_hash_file(subdirs):
    for subdir in subdirs:
        with open(f'{subdir.replace('/', '-')}.tar.gz', 'rb') as f:
            hash = hashlib.sha256(f.read()).hexdigest()
        with open('hash.md', 'a') as f:
            f.write(f'{subdir.replace('/', '-')}.tar.gz: {hash}\n')


subdirs = read_ensure_file()
make_archive(subdirs)
generate_hash_file(subdirs)