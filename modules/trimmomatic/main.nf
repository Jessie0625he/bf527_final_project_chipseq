#!/usr/bin/env nextflow

process TRIM {
    label 'process_low'
    container 'ghcr.io/bf528/trimmomatic:latest'
    publishDir params.outdir

    input:
    tuple val(name), path(read)

    output:
    tuple val(name),path("*_trimmed.fastq.gz"), emit:trimmed_reads
    tuple val(name), path("*.log"), emit:log

    shell:
    """
    trimmomatic SE \
        -threads ${task.cpus} \
        -phred33 \
        ${read} \
        ${name}_trimmed.fastq.gz \
        ILLUMINACLIP:${params.adapter_fa}:2:30:10:2:True \
        LEADING:3 TRAILING:3 \
        2> ${name}_trim.log
    
    """
    
    stub:
    """
    touch ${sample_id}_stub_trim.log
    touch ${sample_id}_stub_trimmed.fastq.gz
    """
}
