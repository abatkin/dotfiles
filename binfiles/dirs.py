#!env python3

import sys
import subprocess
import configparser
import argparse
import os


SPECIAL_SECTIONS = ["app_config", "DEFAULT"]
SECTION_TYPES = {}


def launch(launch_string, arg):
    args = launch_string.split(" ")
    def convert_arg(item):
        if item == "$":
            item = arg
        return os.path.expanduser(item)
    args = [convert_arg(item) for item in args]
    subprocess.Popen(args, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, stdin=subprocess.DEVNULL, close_fds=True)


def open_folder(config, item):
    launch(config["folder_launcher"], item["path"])


def section_type(f):
    section_name = f.__name__
    SECTION_TYPES[section_name] = f
    return f


@section_type
def folder(config, section_name, section):
    return {
        "path": section["path"],
        "launch": lambda path: open_folder(config, path),
        "icon": section.get("icon", "folder"),
    }


def get_cli_args():
    parser = argparse.ArgumentParser(prog="dirs.py", description="Get extra launcher entries for rofi")
    parser.add_argument("--config", default="~/.config/launch-entries.ini", help="Configuration file")
    parser.add_argument("command_key", nargs="?", help="Key of command to run")
    return parser.parse_args()


def get_config_file(cli_args):
    config_path = os.path.expanduser(cli_args.config)
    parser = configparser.ConfigParser()
    parser.read(config_path)
    return parser


def section_to_item(config, section_name, section):
    section_type = section.get("type")
    if not section_type:
        print(f"missing 'type' in {section_name}")
        sys.exit(1)
    section_constructor = SECTION_TYPES[section_type]
    return section_constructor(config, section_name, section)


def get_entries(config_file):
    config_section = config_file["app_config"]
    return {section_name: section_to_item(config_section, section_name, section) for section_name, section in config_file.items() if section_name not in SPECIAL_SECTIONS}


def main():
    cli_args = get_cli_args()
    config_file = get_config_file(cli_args)
    entries = get_entries(config_file)
    command_key = cli_args.command_key
    if command_key:
        if command_key not in entries:
            print(f"Unable to find find command with key {command_key}")
            sys.exit(1)
        item = entries[command_key]
        item["launch"](item)
    else:
        for k, v in entries.items():
            if "icon" in v:
                print(f"{k}\0icon\x1f{v['icon']}\n")
            else:
                print(f"{k}\n")


main()

