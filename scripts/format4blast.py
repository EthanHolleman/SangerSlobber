from Bio import SeqIO
import argparse
import re


def get_args():

    parser = argparse.ArgumentParser(description='Remove spaces from fasta headers.')
    parser.add_argument('fasta', help='Path to fasta file to format format headers')
    parser.add_argument('--regex', default=None, help='Apply this regex to header and use result as the new header.')

    return parser.parse_args()


def read_records(filepath):

    return SeqIO.parse(str(filepath), 'fasta')


def format_header(record, regex=None):
    new_header = record.description.replace(' ', '_')
    print(new_header, regex)
    if regex:
        search = re.search(regex, record.description)
        print(search)
        if search:
            print(search, regex)
            new_header= search[0]
    
    record.description=''
    record.id=new_header

    return record


def rewrite_fasta(filepath, mod_records):

    SeqIO.write(mod_records, str(filepath), 'fasta')


def main():

    args = get_args()
    records = read_records(args.fasta)
    mod_records = [format_header(r, args.regex) for r in records]
    rewrite_fasta(args.fasta, mod_records)


if __name__ == '__main__':
    main()

