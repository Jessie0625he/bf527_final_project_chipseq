#!/usr/bin/env nextflow

process BEDTOOLS_REMOVE {
   
    label 'process_high'
    container 'ghcr.io/bf528/bedtools:latest'
    publishDir params.outdir, mode:'copy'

    input:
    tuple val(name), path(peaks_bed)  // name can be sample name or condition label
    path blacklist

    output:
    tuple val(name), path("${name}_blacklist_filtered.bed"), emit: cleaned
    shell:
    """ 
    bedtools subtract -a $peaks_bed -b $blacklist -A > ${name}_blacklist_filtered.bed
    """

    stub:
    """
    touch repr_peaks_filtered.bed
    """
}