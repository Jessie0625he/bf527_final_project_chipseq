#!/usr/bin/env nextflow

process BEDTOOLS_INTERSECT {
    
    label 'process_high'
    container 'ghcr.io/bf528/bedtools:latest'
    publishDir params.outdir, mode:'copy'

    input:
    path peaks_ph65  // BRD4_pH6.5_LPS peaks
    path peaks_ph74  // BRD4_pH7.4_LPS peaks

    output:
    path "ph65_specific.bed", emit: ph65_bed
    path "ph74_specific.bed", emit: ph74_bed
    path "common_peaks.bed", emit: common

    shell:
    """ 

    bedtools intersect -a $peaks_ph65 -b $peaks_ph74 -v > ph65_specific.bed
    bedtools intersect -a $peaks_ph74 -b $peaks_ph65 -v > ph74_specific.bed
    bedtools intersect -a $peaks_ph65 -b $peaks_ph74 -u > common_peaks.bed

    """
}