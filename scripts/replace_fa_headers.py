# replace fasta headers with sample names provided in the
# samples.tsv file

from Bio import SeqIO
import pandas as pd
from pathlib import Path
import argparse


def get_args():

    parser = argparse.ArgumentParser()
    parser.add_argument('fasta', help='Fasta with record to rename')
    parser.add_argument('out', help='Output path to write file with renamed header to.')
    parser.add_argument('header', help='The new header')

    return parser.parse_args()


def rename_header(sample_name, fasta_path, output_path):
    record = SeqIO.read(str(fasta_path), 'fasta')  # only should be one record per file
    record.id = sample_name
    record.description = ''
    SeqIO.write(record, str(output_path), 'fasta')


def main():

    args = get_args()
    # if not Path(args.out).is_dir():
    #     Path(args.out).mkdir(parents=True, exist_ok=True)
    rename_header(args.header, args.fasta, args.out)


if __name__ == '__main__':
    main()


    