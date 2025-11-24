#!/usr/bin/env nextflow

process FINDPEAKS {
  
    label 'process_high'
    container 'ghcr.io/bf528/homer_samtools:latest'
    publishDir params.outdir, mode: "copy"

    input:
    tuple val(input_name), val(ip_name), path(input_tagdir), path(ip_tagdir)

    output:
    tuple val(ip_name), val(input_name), path("${ip_name}_vs_${input_name}_peaks.txt"), emit: txt


    script:
    """
    findPeaks $ip_tagdir -style factor -F 1.5 -P 0.001 -L 1.5 -LP 0.001 -minDist 200 -size 300 -inputSize 600 -i $input_tagdir -o ${ip_name}_vs_${input_name}_peaks.txt
    """
    // -F 1.2 -P 0.01 -L 1.1 -LP 0.01
    stub:
    """
    touch ${rep}_peaks.txt
    """
}


