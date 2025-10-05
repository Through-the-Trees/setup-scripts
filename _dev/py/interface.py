#! /usr/bin/env python

from argparse import ArgumentParser
from http.client import HTTPResponse
from urllib.request import urlopen

REPO_URL = "https://raw.githubusercontent.com/Through-the-Trees/setup-scripts/refs/heads/"

def get_scripts(distro: str|None) -> list[str]:
    resp: HTTPResponse = urlopen(f"{REPO_URL}/{distro}/_list")
    if resp.status == 404:
        return []
    return [str(line).strip() for line in resp.readlines()]

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
        '-d', '--distro',
        help='Distribution `list` will list available distros',
        default='list',
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
    distro: str = args.distro
    script: str = args.script

    if script == 'list':
        print(get_scripts(branch, distro))
        return
    

if __name__ == "__main__":
    main()