#!/usr/bin/env nextflow

process POS2BED {

    label 'process_medium'
    container 'ghcr.io/bf528/homer_samtools:latest'
    publishDir params.outdir, mode: "copy"

    input:
    tuple val(ip_name), val(input_name), path(peaks_file)

    output:
    tuple val(ip_name), val(input_name), path("${peaks_file.baseName}.bed"), emit: bed

    script:
    """
    pos2bed.pl $peaks_file > ${peaks_file.baseName}.bed
    """

    stub:
    """
    touch ${homer_txt.baseName}.bed
    """
}


