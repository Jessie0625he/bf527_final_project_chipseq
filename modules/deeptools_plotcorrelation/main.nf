#!/usr/bin/env nextflow

process PLOTCORRELATION {

    label 'process_medium'
    container 'ghcr.io/bf528/deeptools:latest'
    publishDir params.outdir, mode: "copy"

    input:
    path(npz)
    
    output:
    path("correlation_plot_pearson.png")
    path("correlation_plot_spearman.png")
    

    shell:
    """
    plotCorrelation -in $npz -c pearson -p heatmap -o correlation_plot_pearson.png --plotNumbers --colorMap PiYG --plotTitle "Sample Correlation Heatmap (Pearson)"
    plotCorrelation -in $npz -c spearman -p heatmap -o correlation_plot_spearman.png --plotNumbers --colorMap PiYG --plotTitle "Sample Correlation Heatmap (spearman)"
    """

    stub:
    """
    touch correlation_plot.png
    """
}






