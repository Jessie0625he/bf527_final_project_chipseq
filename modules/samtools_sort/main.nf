#!/usr/bin/env nextflow

process SAMTOOLS_SORT {
    
    label 'process_medium'
    container 'ghcr.io/bf528/samtools:latest'
    publishDir params.outdir, mode:'copy'

    input:
    tuple val(name), path(bam)

    output:
    tuple val(name), path("${name}.sorted.bam"), emit:sorted

    shell:
    """ 
    samtools sort -@ $task.cpus $bam > ${name}.sorted.bam
    """

    stub:
    """
    touch ${sample_id}.stub.sorted.bam
    """
}