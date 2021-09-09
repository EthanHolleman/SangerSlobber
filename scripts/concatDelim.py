import pandas as pd
from argparse import ArgumentParser

def get_args():

    parser = ArgumentParser(description='Concatenate delim files in a header \
        aware fashion. Should not be used when dealing with many very large \
        files.')
    parser.add_argument('delim', nargs='+', help='Delim filepaths to concat.')
    parser.add_argument('out', help='Output filepath.')
    parser.add_argument('--sep', help='File seperator to use when reading file. \
                        Defaults to \\t',
                        default='\t')

    return parser.parse_args()

def concat(sep, output_path, *filepaths):
    dfs = []
    for each_path in filepaths:
        dfs.append(pd.read_csv(str(each_path), sep=sep))
    pd.concat(dfs, ignore_index=True).to_csv(
        str(output_path), sep=sep, index=False, header=True)


def main():
    
    args = get_args()
    concat(args.sep, args.out, *args.delim)

if __name__ == '__main__':
    main()

    
