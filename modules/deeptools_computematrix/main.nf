#!/usr/bin/env nextflow

process COMPUTEMATRIX {
    
    label 'process_high'
    container 'ghcr.io/bf528/deeptools:latest'
    publishDir params.outdir, mode: "copy"

    input:
    tuple val(name), path(bw)
    path(bed)
    val(window)
    
    output:
    tuple val(name), path("${name}_matrix.gz"), emit:matrix

    shell:
    """
    computeMatrix scale-regions -S $bw -R $bed -a $window -b $window -o ${name}_matrix.gz
    """

    stub:
    """
    touch ${sample_id}_matrix.gz
    """
}