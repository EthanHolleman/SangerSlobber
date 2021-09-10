

rule concatenate_align_to_seqs:
    input:
        config['align_to']
    output:
        '{output_dir}/blast/db/concat_seqs.fa'
    shell:'''
    cat {input} > {output}
    '''

rule rename_sanger_sequences:
    conda:
        '../envs/Py.yml'
    input:
        '{sample_fasta_path}'
    output:
        '{sample_fasta_path}.renamed'
    params:
        sample_name=lambda wilcards: SAMPLES.loc[SAMPLES['fa'] == wilcards.sample_fasta_path]['sample_name'].values[0] 
    shell:'''
    python scripts/replace_fa_headers.py {input} {output} {params.sample_name}
    '''


rule concat_samples:
    input:
        expand(
            '{sample_fasta_path}.renamed',
            sample_fasta_path=list(SAMPLES['fa'])
        )
    output:
        '{output_dir}/concat/all_samples.fa'
    shell:'''
    cat {input} > {output}
    '''

# rule format_headers:
#     # remove spaces from fasta headers to force blast to use full description
#     # of each fasta record in outfmt 6.
#     conda:
#         '../envs/Py.yml'
#     input:
#         '{output_dir}/concat/all_samples.fa'
#     output:
#         '{output_dir}/concat/.all_samples.blast-ready'
#     params:
#         regex=config['header_regex']
#     shell:'''
#     #python scripts/format4blast.py {input} --regex "{params.regex}"
#     touch {output}
#   '''

rule make_blast_db:
    conda:
        '../envs/blast.yml'
    input:
        seqs='{output_dir}/blast/db/concat_seqs.fa',
    output:
        '{output_dir}/blast/db/local_db/local_db.ndb'
    params:
        db_dir=lambda wildcards: str(Path(wildcards.output_dir).joinpath(
            'blast/db/local_db')),
        db_path=lambda wildcards: str(Path(wildcards.output_dir).joinpath(
            'blast/db/local_db/local_db'))
    shell:'''
    mkdir -p {params.db_dir}
    makeblastdb -in {input.seqs} -parse_seqids -title "Local Blast DB" -dbtype nucl -out {params.db_path}
    '''

rule local_blast:
    conda:
        '../envs/blast.yml'
    input:
        db='{output_dir}/blast/db/local_db/local_db.ndb',
        query='{output_dir}/concat/all_samples.fa'
    output:
        '{output_dir}/blast/results/local_blast.tsv'
    params:
        db_path=lambda wildcards: str(Path(wildcards.output_dir).joinpath('blast/db/local_db/local_db')),
    shell:'''
    cat {input.query} | blastn -db {params.db_path} -perc_identity 0 -outfmt 6 > {output}
    '''


rule make_heatmap:
    conda:
        '../envs/R.yml'
    input:
        '{output_dir}/blast/results/local_blast.tsv'
    output:
        '{output_dir}/blast/results/length_heatmap.png'
    params:
        query_samples=list(SAMPLES['sample_name'])
    script:'../scripts/blastHeatmap.R'




