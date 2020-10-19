#!/usr/bin/env python
import argparse
import subprocess

parser = argparse.ArgumentParser()
parser.add_argument('--vault-id', required=True)


def main():
    args = parser.parse_args()
    cmd = 'pass ansible/{}'.format(args.vault_id).split(' ')
    output = subprocess.check_output(cmd)
    print(output.strip())


if __name__ == '__main__':
    main()
