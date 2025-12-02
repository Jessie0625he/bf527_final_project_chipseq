#!/usr/bin/env nextflow

process FIND_MOTIFS_GENOME {

    label 'process_high'
    container 'ghcr.io/bf528/homer_samtools:latest'
    publishDir params.outdir, mode: "copy"

    input:
    tuple val(name), path(filtered_bed)  // name can be sample name or condition label
    path genome


    output:
    tuple val(name), path("${name}_motifs"), emit: motifs

    script:
    """
    findMotifsGenome.pl $filtered_bed $genome ${name}_motifs -size 200 -mask -p $task.cpus
    """
}


