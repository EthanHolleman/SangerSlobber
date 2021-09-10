# Visualze the results of BLAST alignments
library(ggplot2)
library(ggpubr)
library(viridis)
library(gridExtra)
library(RColorBrewer)
library(grid)

read.outfmt.six <- function(file.path){

    file.path <- as.character(file.path)
    blast.df <- as.data.frame(read.table(file.path, sep='\t', header=FALSE))
    fmt.six.headers <- c(
        "qseqid","sseqid","pident","length","mismatch","gapopen",
        "qstart","qend","sstart","send","evalue","bitscore"
        )
    colnames(blast.df) <- fmt.six.headers

    return(blast.df)
    
}


make.heatmap <- function(blast.df, fill){


    ggplot(blast.df, aes_string(x="qseqid", y="sseqid", fill=fill)) +
            geom_tile(color='black', size=1) + theme_pubr() + 
            labs(x='Reference seqs',y='Sanger sequences') +
            theme(axis.text.x = element_text(angle = 45, hjust=1)) +
            scale_fill_viridis()


}

check.for.alignment <- function(sample.names, blast.df){
    aligned <- sample.names %in% unique(blast.df$qseqid)
    align.df <- data.frame(sample=sample.names, aligned=aligned)
    ggplot(align.df, aes(y=sample.names, x=aligned, fill=aligned)) + 
    geom_tile(color='black', size=1) + theme_pubr() + 
    scale_color_brewer(palette='Dark2') + labs(x='Alignment status', y='') +
    theme(legend.position = "none")

}

arrange.plots <- function(heatmap, table){


    ggarrange(heatmap, table, nrow=1, ncol=2)

}


main <- function(){

    blast.df <- read.outfmt.six(snakemake@input)
    heatmap <- make.heatmap(blast.df, fill='length')
    table <- check.for.alignment(as.vector(snakemake@params[['query_samples']]), blast.df)
    plot <- arrange.plots(heatmap, table)
    ggsave(as.character(snakemake@output), plot, width=9, height=9, dpi=500)

}


if (!interactive()){

    main()

}