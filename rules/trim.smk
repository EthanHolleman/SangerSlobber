
rule trim_reads:
    conda:
        '../envs/trim.yml'
    input:
        '{output_dir}/convert/fastq/untrimmed/{sample}.fastq'
    output:
        '{output_dir}/convert/fastq/trimmed/{sample}.fastq'
    shell:'''
    trimmomatic SE -phred33 {input} {output} LEADING:5 TRAILING:5
    '''


    