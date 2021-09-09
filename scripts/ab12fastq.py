# Convert an ab1 formated file to a pseudo-fastq file. Quality scores
# should be interpreted directly

from Bio import SeqIO
from argparse import ArgumentParser
from pathlib import Path


def get_args():

    parser = ArgumentParser()
    parser.add_argument("ab1", help="Path to ab1 formated file.")
    parser.add_argument(
        "--out",
        help="Path to output fastq file. If not specified \
                        defaults to name of ab1 file with fastq extension.",
        default=None,
    )

    return parser.parse_args()


def ab1_to_fastq(ab1_path, output_path=None):
    ab1_path = Path(ab1_path)
    if not output_path:
        output_path = ab1_path.parent.joinpath(ab1_path.stem).with_suffix(".fastq")
    with open(str(output_path), "w") as output_handle:
        with open(ab1_path, "rb") as input_handle:
            records = SeqIO.parse(input_handle, "abi")
            SeqIO.write(records, output_handle, "fastq")
    return output_path


def main():
    args = get_args()
    ab1_to_fastq(args.ab1, args.out)


if __name__ == "__main__":
    main()
