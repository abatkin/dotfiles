#!/usr/bin/python

import sys
import subprocess


def get_entries():
    return {
        "Documents": folder("/home/abatkin/Documents"),
        "Applications": folder("/home/abatkin/Applications"),
        "Downloads": folder("/home/abatkin/Downloads"),
        "3D": folder("/home/abatkin/Documents/3d"),
    }


def launch(*args):
    subprocess.Popen(args, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, stdin=subprocess.DEVNULL, close_fds=True)


def open_folder(item):
    launch("dolphin", "--new-window", item['path'])


def folder(path):
    return {
        "path": path,
        "launch": open_folder,
        "icon": "folder",
    }


def main():
    entries = get_entries()
    if len(sys.argv) == 1:
        for k, v in entries.items():
            if "icon" in v:
                print(f"{k}\0icon\x1f{v['icon']}\n")
            else:
                print(f"{k}\n")
    else:
        key = sys.argv[1]
        if key not in entries:
            sys.exit(1)
        item = entries[key]
        item["launch"](item)

main()

