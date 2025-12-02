#!/usr/bin/env nextflow

process BOWTIE2_ALIGN {
   
    label 'process_high'
    container 'ghcr.io/bf528/bowtie2:latest'
    publishDir params.outdir, mode:'copy'

    input:
    tuple val(name), path(read)
    tuple val(genome), path(index)

    output:
    tuple val(name), path("${name}.bam"), emit:align

    shell:
    """ 
    bowtie2 -x bowtie2_index/${genome} -U ${read} | samtools view -bS - > ${name}.bam
    """
}