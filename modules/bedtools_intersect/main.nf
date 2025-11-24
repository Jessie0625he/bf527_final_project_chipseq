#!/usr/bin/env nextflow

process BEDTOOLS_INTERSECT {
    
    label 'process_high'
    container 'ghcr.io/bf528/bedtools:latest'
    publishDir params.outdir, mode:'copy'

    input:
    tuple val(rep1_peaks), path(bed1)
    tuple val(rep2_peaks), path(bed2)

    output:
    path("reproducible_peaks.bed")

    shell:
    """ 
    bedtools intersect -a $bed1 -b $bed2 -f 0.0001 -r > reproducible_peaks.bed
    """

    stub: 
    """
    touch repr_peaks.bed
    """
}