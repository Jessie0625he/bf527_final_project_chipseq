#!/usr/bin/env nextflow

process ANNOTATE {

    label 'process_high'
    container 'ghcr.io/bf528/homer_samtools:latest'
    publishDir params.outdir, mode:'copy'

    input:
    tuple val(name), path(bed)  // name can be sample name or condition label
    path genome
    path gtf

    output:
    tuple val(name), path("${name}_annotated_peaks.txt"), emit: annotated

    shell:
    """
    annotatePeaks.pl $bed $genome -gtf $gtf > ${name}_annotated_peaks.txt
    """
}



