import pandas as pd
from pathlib import Path


OUT_DIR = config['output_dir']
SAMPLES = pd.read_csv(config['samples'], sep='\t').set_index('sample_name', drop=False)
TRIM_STATUSES = ['trimmed', 'untrimmed']

include:'rules/convert.smk'
include:'rules/trim.smk'
include:'rules/qc.smk'
include:'rules/blast.smk'

concat_tsv_files = str(Path(OUT_DIR).joinpath('convert/concat/trimmed/all_samples.ggplot.tsv'))
all_fastqc = str(Path(OUT_DIR).joinpath('fastqc/.all.trimmed.done'))
multiqc = str(Path(OUT_DIR).joinpath('multiqc'))
BLAST = str(Path(OUT_DIR).joinpath('blast/results/local_blast.tsv'))

rule all:
    input:
        concat_tsv_files,
        all_fastqc,
        multiqc,
        BLAST
        