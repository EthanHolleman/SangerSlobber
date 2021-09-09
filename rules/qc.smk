

rule run_fastqc:
    conda:
        '../envs/qc.yml'
    input:
        expand(
            '{output_dir}/convert/fastq/{trim_status}/{sample}.fastq', 
            sample=SAMPLES['sample_name'],
            allow_missing=True
        )
    output:
        directory('{output_dir}/fastqc/{trim_status}')
    shell:'''
    mkdir -p {output}
    fastqc -o {output} {input}
    '''

rule run_all_fastqc:
    input:
        expand(
            '{output_dir}/fastqc/{trim_status}', 
            output_dir=OUT_DIR, trim_status=TRIM_STATUSES)
    output:
        '{output_dir}/fastqc/.all.trimmed.done'
    shell:'''
    touch {output}
    '''

rule run_multiqc:
    conda:
        '../envs/qc.yml'
    input:
        fastqc='{output_dir}/fastqc/.all.trimmed.done',
        reads=expand(
            '{output_dir}/convert/fastq/{trim_status}/{sample}.fastq',
            sample=SAMPLES['sample_name'], trim_status=TRIM_STATUSES,
            output_dir=OUT_DIR
        ),
    output:
        directory('{output_dir}/multiqc')
    params:
        analysis_dir=OUT_DIR
    shell:'''
    multiqc -d -o {output} {params.analysis_dir}
    '''