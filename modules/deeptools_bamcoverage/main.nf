#!/usr/bin/env nextflow

process BAMCOVERAGE {

    label 'process_high'
    container 'ghcr.io/bf528/deeptools:latest'
    publishDir params.outdir, mode: 'copy'

    input:
    tuple val(name), path(sortedbam), path(bai)

    output:
    tuple val(name), path('*.bw'), emit: bigwig

    script:
    """
    bamCoverage -b $sortedbam -o ${name}.bw -p $task.cpus
    """

    stub:
    """
    touch ${sample_id}.bw
    """
}