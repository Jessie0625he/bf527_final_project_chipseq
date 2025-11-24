#!/usr/bin/env nextflow

process SAMTOOLS_IDX {

    label 'process_single'
    container 'ghcr.io/bf528/samtools:latest'
    publishDir params.outdir, mode: 'copy'

    input:
    tuple val(name), path(sortedbam)

    output:
    tuple val(name), path(sortedbam),path("*.bai"), emit: index


    script:
    """
    samtools index --threads $task.cpus $sortedbam
    """

    stub:
    """
    touch ${sample_id}.stub.sorted.bam.bai
    """
}