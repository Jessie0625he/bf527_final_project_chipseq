#!/usr/bin/env nextflow

process MULTIQC {

    container 'ghcr.io/bf528/multiqc:latest'
    publishDir params.outdir

    input:
    path("*")

    output:
    path("multiqc_report.html")

    script:
    """
    multiqc . -f
    """

    stub:
    """
    touch multiqc_report.html
    """
}