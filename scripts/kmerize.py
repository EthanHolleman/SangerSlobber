# Break up an individual fasta record into a tsv of kmers
# of a given length

import argparse
import pandas as pd
from dataclasses import dataclass, asdict
from Bio import SeqIO

@dataclass
class Kmer:
    start: int
    end: int
    seq: str


def get_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('fasta', help='Path to single record fasta file to kmerize.')
    parser.add_argument('out', help='Output path')
    parser.add_argument('--kmer-length', type=int, default=8, help='Length of kmers')

    return parser.parse_args()

def kmerize(string, kmer_length):
    for i in range(0, len(string)-kmer_length):
        start, end = i, i+kmer_length
        yield Kmer(start, end, string[start:end])


def write_kmer_table(kmers, output_path):
    table = [asdict(kmer) for kmer in kmers]
    pd.DataFrame(table).to_csv(str(output_path), sep='\t', index=False)


def read_record(fasta_path):
    return SeqIO.read(fasta_path, 'fasta')


def main():

    args = get_args()
    record = read_record(args.fasta)
    kmers = kmerize(str(record.seq), args.kmer_length)
    write_kmer_table(kmers, args.out)

if __name__ == '__main__':
    main()






