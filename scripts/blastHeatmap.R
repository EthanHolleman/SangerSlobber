# Visualze the results of BLAST alignments

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
            geom_tile(color='black') + theme_pubr()


}