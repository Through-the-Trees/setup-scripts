#! /usr/bin/env python

from argparse import ArgumentParser
from http.client import HTTPResponse
from urllib.request import urlopen

REPO_URL = "raw.githubusercontent.com/Through-the-Trees/setup-scripts/refs/heads"

def get_scripts(branch: str, platform: str) -> list[str]:
    resp: HTTPResponse = urlopen(f"https://{REPO_URL}/{branch}/{platform}/_list")
    if resp.status == 404:
        return []
    return [script.decode('utf-8').strip() for script in resp.readlines()]

def get_parser() -> ArgumentParser:
    parser = ArgumentParser('Refurbiser Tools')

    parser.add_argument(
        '-b', '--branch',
        help='Branch to run scripts from',
        default='main',
        metavar='',
        type=str,
    )
    parser.add_argument(
        '-p', '--platform',
        help='Platform to get scripts for (linux|windows|macos)',
        metavar='',
        type=str,
    )
    parser.add_argument(
        '-s', '--script',
        help='Script to run (list) to list available',
        default='list',
        metavar='',
        type=str,
    )
    return parser

def main() -> None:
    args = get_parser().parse_args()
    branch: str = args.branch
    platform: str = args.platform
    script: str = args.script

    if script == 'list':
        print(get_scripts(branch, platform))
        return
    

if __name__ == "__main__":
    main()