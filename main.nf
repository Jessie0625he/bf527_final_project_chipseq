#!/usr/bin/env nextflow
// Include your modules here

include {FASTQC} from './modules/fastqc'
include {TRIM} from './modules/trimmomatic'
include {BOWTIE2_BUILD} from './modules/bowtie2_build'
include {BOWTIE2_ALIGN} from './modules/bowtie2_align'
include {SAMTOOLS_FLAGSTAT} from './modules/samtools_flagstat'
include {SAMTOOLS_SORT} from './modules/samtools_sort'
include {SAMTOOLS_IDX} from './modules/samtools_idx'
include {BAMCOVERAGE} from './modules/deeptools_bamcoverage'
include {MULTIQC} from './modules/multiqc'
include {MULTIBWSUMMARY} from './modules/deeptools_multibwsummary'
include {PLOTCORRELATION} from './modules/deeptools_plotcorrelation'
include {TAGDIR} from './modules/homer_maketagdir'
include {FINDPEAKS} from './modules/homer_findpeaks'
include {POS2BED} from './modules/homer_pos2bed'
// include {BEDTOOLS_INTERSECT} from './modules/bedtools_intersect'
include {BEDTOOLS_REMOVE} from './modules/bedtools_remove'
include {ANNOTATE} from './modules/homer_annotatepeaks'
include {COMPUTEMATRIX} from './modules/deeptools_computematrix'
include {PLOTPROFILE} from './modules/deeptools_plotprofile'
include {FIND_MOTIFS_GENOME} from './modules/homer_findmotifsgenome'

workflow {

    //Here we construct the initial channels we need
    
    Channel.fromPath(params.samples)
    | splitCsv( header: true )
    | map{ row -> tuple(row.name, file(row.path)) }
    | set { read_ch }

    FASTQC(read_ch)
    
    TRIM(read_ch)
    BOWTIE2_BUILD(params.genome)
    BOWTIE2_ALIGN(TRIM.out.trimmed_reads, BOWTIE2_BUILD.out)
    SAMTOOLS_FLAGSTAT(BOWTIE2_ALIGN.out.align)
    SAMTOOLS_SORT(BOWTIE2_ALIGN.out.align)
    SAMTOOLS_IDX(SAMTOOLS_SORT.out.sorted)
    BAMCOVERAGE(SAMTOOLS_IDX.out)

    fastqc_res   = FASTQC.out.zip.mix(FASTQC.out.html).map { name, file -> file }
    trim_res     = TRIM.out.log.map { name, file -> file }
    flagstat_res = SAMTOOLS_FLAGSTAT.out.map { name, file -> file }
    multiqc_ch = fastqc_res.mix(trim_res, flagstat_res).collect()
    MULTIQC(multiqc_ch)

    bw_list = BAMCOVERAGE.out.bigwig.map { name, file -> file }.collect()
    
    MULTIBWSUMMARY(bw_list)
    PLOTCORRELATION(MULTIBWSUMMARY.out.npz)

    TAGDIR(BOWTIE2_ALIGN.out.align)
    // Get the TAGDIR outputs
    tagdir_ch = TAGDIR.out.tagdir
    
    // Separate IP and INPUT samples
    ip_tags = tagdir_ch.filter { name, path -> name.startsWith('BRD4_') }
    input_tags = tagdir_ch.filter { name, path -> name.startsWith('INPUT_') }
    
    // Create IP-INPUT pairs by pH condition
    peak_pairs_ch = ip_tags
        .combine(input_tags)  // Combine all IP with all INPUT
        .filter { ip_name, ip_path, input_name, input_path -> 
            // Filter to keep only matching pH conditions
            ip_name.contains('pH6.5') && input_name.contains('pH6.5') ||
            ip_name.contains('pH7.4') && input_name.contains('pH7.4')
        }
        .map { ip_name, ip_path, input_name, input_path -> 
            // Create tuple for FINDPEAKS input
            tuple(input_name, ip_name, input_path, ip_path)
        }
    

    FINDPEAKS(peak_pairs_ch)
    POS2BED(FINDPEAKS.out.txt)
    
    // rep1_peaks = POS2BED.out.bed.filter { it[0] =~ /rep1/ }
    // | map {input_name, ip_name, file -> tuple ("rep1", file)}
    // rep2_peaks = POS2BED.out.bed.filter { it[0] =~ /rep2/ }
    // | map {input_name, ip_name, file -> tuple ("rep2", file)}
    // BEDTOOLS_INTERSECT(rep1_peaks, rep2_peaks)
    
    // Get peaks with tuple structure preserved
    peaks_bed = POS2BED.out.bed
    
    //Use full sample names
    named_peaks = peaks_bed.map { ip_name, input_name, file -> 
        tuple(ip_name, file)}
    
    // Remove blacklist regions
    BEDTOOLS_REMOVE(named_peaks, params.blacklist)
    
    // Annotate peaks
    ANNOTATE(BEDTOOLS_REMOVE.out.cleaned, params.genome, params.gtf)
    
    // Find motifs for each condition
    FIND_MOTIFS_GENOME(BEDTOOLS_REMOVE.out.cleaned, params.genome)
    
    // Create heatmaps - use BRD4 IP samples only
    // matrix_ch = BAMCOVERAGE.out.bigwig
    //     .filter { name, file -> name.startsWith('BRD4_') }  // Changed from 'IP_' to 'BRD4_'
    
    // COMPUTEMATRIX(matrix_ch, params.ucsc_genes, params.window)
    // PLOTPROFILE(COMPUTEMATRIX.out.matrix)
    
    

}