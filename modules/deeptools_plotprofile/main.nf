#!/usr/bin/env nextflow

process PLOTPROFILE {
    
    label 'process_medium'
    container 'ghcr.io/bf528/deeptools:latest'
    publishDir params.outdir, mode: "copy"

    input:
    tuple val(name), path(gz)
    
    output:
    tuple val(name), path("${name}_signal_coverage.png")

    shell:
    """
    plotProfile -m $gz -o ${name}_signal_coverage.png
    """

}