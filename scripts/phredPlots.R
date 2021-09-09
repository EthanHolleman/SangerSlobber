library(ggplot2)
library(ggpubr)
library(RColorBrewer)


read_tsv <- function(file.path){

    file.path <- as.character(file.path)
    as.data.frame(read.table(file.path, sep='\t', header=TRUE))

}


plot_phred <- function(df){


    named.bases <- as.vector(df$Base)
    num.samples <- unique(df$Name)
    names(named.bases) <- df$Base_index
    colors <- colorRampPalette(brewer.pal(8, "Dark2"))(length(num.samples))
    ggplot(df, aes(y=Phred_value, x=Base_index, fill=Name)) + 
            geom_bar(stat='identity', size=1, color='black') +
            theme_pubr() + scale_x_discrete(labels=named.bases) +
            facet_wrap(~Name) + labs(y='Phred score') +
            scale_fill_manual(values=colors) + 
            theme(legend.position = "none")
}

main <- function(){

    df <- read_tsv(snakemake@input)
    plot <- plot_phred(df)
    ggsave(snakemake@output, plot, dpi=500)

}

if (!interactive()){

    main()

}