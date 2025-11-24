#!/usr/bin/env nextflow

process BEDTOOLS_REMOVE {
   
    label 'process_high'
    container 'ghcr.io/bf528/bedtools:latest'
    publishDir params.outdir, mode:'copy'

    input:
    path(peaks_bed)
    path(blacklist)

    output:
    path("${peaks_bed.baseName}_blacklist_filtered.bed")

    shell:
    """ 
    bedtools subtract -a $peaks_bed -b $blacklist -A > ${peaks_bed.baseName}_blacklist_filtered.bed
    """

    stub:
    """
    touch repr_peaks_filtered.bed
    """
}