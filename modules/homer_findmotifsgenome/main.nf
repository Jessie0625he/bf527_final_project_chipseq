#!/usr/bin/env nextflow

process FIND_MOTIFS_GENOME {

    label 'process_high'
    container 'ghcr.io/bf528/homer_samtools:latest'
    publishDir params.outdir, mode: "copy"

    input:
    path(filtered_bed)
    path(genome)


    output:
    path("motifs")

    script:
    """
    findMotifsGenome.pl $filtered_bed $genome motifs/ -size 200 -mask
    """

    stub:
    """
    mkdir motifs
    """
}


