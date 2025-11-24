#!/usr/bin/env nextflow

process MULTIBWSUMMARY {

    label 'process_medium'
    container 'ghcr.io/bf528/deeptools:latest'
    publishDir params.outdir, mode: "copy"

    input:
    path(bw_all)
    
    output:
    path("bw_all.npz"), emit:npz
    path("multiBigwigSummary.tab"), emit: tab

    shell:
    """
    multiBigwigSummary bins -b *.bw -o bw_all.npz -bs 1000 --smartLabels --outRawCounts multiBigwigSummary.tab
    """

    stub:
    """
    touch bw_all.npz
    """
}