#!/usr/bin/env nextflow

process SAMTOOLS_FLAGSTAT {

    label 'process_high'
    container 'ghcr.io/bf528/samtools:latest'
    publishDir params.outdir, mode:'copy'

    input:
    tuple val(name), path(bam)

    output:
    tuple val(name), path("${name}_flagstat.txt")

    shell:
    """
    samtools flagstat ${bam} > ${name}_flagstat.txt
    """

    stub:
    """
    touch ${name}_flagstat.txt
    """
}