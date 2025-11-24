#!/usr/bin/env nextflow

process FASTQC {
    label 'process_low'
    container 'ghcr.io/bf528/fastqc:latest'
    publishDir params.outdir, mode: "copy", pattern: '*.html'

    input:
    tuple val(name), path(fastq)
    
    output:
    tuple val(name), path('*.zip'), emit: zip
    tuple val(name), path('*.html'), emit: html

    shell:
    """
    fastqc $fastq -t $task.cpus
    """

    stub:
    """
    touch stub_${sample_id}_fastqc.zip
    touch stub_${sample_id}_fastqc.html
    """
}