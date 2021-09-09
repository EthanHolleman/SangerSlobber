

rule ab1_to_fastq:
    conda:
        '../envs/Py.yml'
    input:
        lambda wildcards: SAMPLES.loc[SAMPLES['sample_name'] == wildcards.sample]['ab1']
    output:
        '{output_dir}/convert/fastq/untrimmed/{sample}.fastq'
    shell:'''
    python scripts/ab12fastq.py {input} --out {output}
    '''


rule fastq_to_tsv:
    conda:
        '../envs/Py.yml'
    input:
        '{output_dir}/convert/fastq/{trim_status}/{sample}.fastq'
    output:
        '{output_dir}/convert/fastq2tsv/{trim_status}/{sample}.tsv'
    shell:'''
    python scripts/fastq2ggplotready.py {input} --out {output}
    '''


rule concat_tsv_files:
    conda:
        '../envs/Py.yml'
    input:
        expand(
            '{output_dir}/convert/fastq2tsv/{trim_status}/{sample}.tsv', sample=SAMPLES['sample_name'],
            allow_missing=True
            )
    output:
        '{output_dir}/convert/concat/{trim_status}/all_samples.ggplot.tsv'
    shell:'''
    python scripts/concatDelim.py {input} {output}
    '''

