# Convert a fastq file to a tsv file that is formated for plotting quality
# scores with ggplot2

from Bio import SeqIO
import pandas as pd
from pathlib import Path
from argparse import ArgumentParser


def get_args():

    parser = ArgumentParser()
    parser.add_argument("fastq", help="Path to fastq file to convert.")
    parser.add_argument(
        "--out",
        help="Path to output tsv file. If blank defaults \
        to name of fastq file with .tsv extension.",
    )
    return parser.parse_args()


def read_fastq_record(filepath):
    with open(str(filepath)) as handle:
        return list(SeqIO.parse(handle, "fastq-sanger"))


def fastq_to_df(fastq_records):
    rows = []
    for each_record in fastq_records:
        base_index = 0
        for each_base, each_score in zip(
            each_record.seq, each_record.letter_annotations["phred_quality"]
        ):
            rows.append(
                {
                    "Name": each_record.name,
                    "Base_index": base_index,
                    "Base": str(each_base),
                    "Phred_value": each_score,
                }
            )
            base_index += 1
    return pd.DataFrame(rows)


def write_tsv(df, fastq_path, output_path=None):
    fastq_path = Path(fastq_path)
    if not output_path:
        output_path = fastq_path.parent.joinpath(fastq_path.stem).with_suffix(".tsv")
    df.to_csv(str(output_path), sep="\t", index=False)
    return output_path


def main():

    args = get_args()
    records = read_fastq_record(args.fastq)
    print(records)
    df = fastq_to_df(records)
    write_tsv(df, args.fastq, args.out)


if __name__ == "__main__":
    main()

