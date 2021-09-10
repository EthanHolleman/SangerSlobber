#!/usr/bin/env python3
import subprocess
import argparse
import re


def get_args():
    parser = argparse.ArgumentParser(
        description="Release all SLURM held jobs for a user (yourself)."
    )
    parser.add_argument("user", help="Your username")

    return parser.parse_args()


def request_job_ids(username):
    '"%.18i'
    proc = subprocess.Popen(
        ["squeue", "--user", username, "-o", '"%.18i"'],
        stdout=subprocess.PIPE,
        shell=True,
    )
    out, err = proc.communicate()
    return out


def extract_job_ids(job_ids):
    return re.findall(r"[\d_-]+", job_ids)


def release_all_jobs(job_ids):
    for each_id in job_ids:
        print('Realsing job', each_id)
        subprocess.run(["scontrol", "release", str(each_id)], shell=True)


def main():
    args = get_args()
    job_id_text = request_job_ids(args.user)
    job_ids = extract_job_ids(job_id_text)
    release_all_jobs(job_ids)


if __name__ == "__main__":
    main()

