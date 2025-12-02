#!/usr/bin/env nextflow

process NCBI_DATASETS {
    label 'process_low'
    conda 'envs/ncbidatasets_env.yml'
    publishDir params.outdir

    input:
    val(GCF)

    output:
    path('dataset/**/*.fna')

    shell:
    """ 
    datasets download genome accession $GCF --include genome
    unzip ncbi_dataset.zip -d dataset/
    """

}