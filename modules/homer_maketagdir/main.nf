#!/usr/bin/env nextflow

process TAGDIR {

    label 'process_medium'
    container 'ghcr.io/bf528/homer_samtools:latest'
    publishDir params.outdir, mode: "copy"

    input:
    tuple val(name), path(bam)

    output:
    tuple val(name), path("${name}_tags"), emit:tagdir

    // makeTagDirectory ${name}_tags ${name}.bam
    script:
    """
    makeTagDirectory ${name}_tags ${name}.bam
    """

    stub:
    """
    mkdir ${sample_id}_tags
    """
}


