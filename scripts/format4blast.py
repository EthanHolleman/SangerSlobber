from Bio import SeqIO
import argparse


def get_args():

    parser = argparse.ArgumentParser(description='Remove spaces from fasta headers.')
    parser.add_argument('fasta', help='Path to fasta file to format format headers')

    return parser.parse_args()


def read_records(filepath):

    return SeqIO.parse(str(filepath), 'fasta')


def format_header(record):

    record.description = record.description.replace(' ', '_')
    return record


def rewrite_fasta(filepath, mod_records):

    SeqIO.write(mod_records, str(filepath), 'fasta')


def main():

    args = get_args()
    records = read_records(args.fasta)
    mod_records = [format_header(r) for r in records]
    rewrite_fasta(args.fasta, mod_records)


if __name__ == '__main__':
    main()

