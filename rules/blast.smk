

rule concatenate_align_to_seqs:
    input:
        config['align_to']
    output:
        '{output_dir}/blast/db/concat_seqs.fa'
    shell:'''
    cat {input} > {output}
    '''

rule concat_samples:
    input:
        SAMPLES['fa']  # fasta foramted samples
    output:
        '{output_dir}/concat/all_samples.fa'
    shell:'''
    cat {input} > {output}
    '''

rule format_headers:
    # remove spaces from fasta headers to force blast to use full description
    # of each fasta record in outfmt 6.
    conda:
        '../envs/Py.yml'
    input:
        '{output_dir}/concat/all_samples.fa'
    output:
        '{output_dir}/concat/.all_samples.blast-ready'
    shell:'''
    python scripts/format4blast.py {input}
    touch {output}
    '''

rule make_blast_db:
    conda:
        '../envs/blast.yml'
    input:
        '{output_dir}/blast/db/concat_seqs.fa'
    output:
        '{output_dir}/blast/db/local_db/local_db.ndb'
    params:
        db_dir=lambda wildcards: str(Path(wildcards.output_dir).joinpath(
            'blast/db/local_db')),
        db_path=lambda wildcards: str(Path(wildcards.output_dir).joinpath(
            'blast/db/local_db/local_db'))
    shell:'''
    mkdir -p {params.db_dir}
    makeblastdb -in {input} -parse_seqids -title "Local Blast DB" -dbtype nucl -out {params.db_path}
    '''

rule local_blast:
    conda:
        '../envs/blast.yml'
    input:
        db='{output_dir}/blast/db/local_db/local_db.ndb',
        query='{output_dir}/concat/all_samples.fa',
        blast_ready='{output_dir}/concat/.all_samples.blast-ready'  # sample headers are formated

    output:
        '{output_dir}/blast/results/local_blast.tsv'
    params:
        db_path=lambda wildcards: str(Path(wildcards.output_dir).joinpath('blast/db/local_db/local_db'))
    shell:'''
    which blastn
    cat {input.query} | blastn -db {params.db_path} -outfmt 6 > {output}
    '''





