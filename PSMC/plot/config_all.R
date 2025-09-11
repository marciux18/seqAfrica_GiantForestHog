mu <- 1.29e-8
g <- 6
i.iteration <- 25
s <- 100
files <-list.files("/psmc/PSMC_OUT/",".psmc",full.names=T)
color_sp = c("#390099","#f77f00","#ffd166","#90a955", "#4f772d", "#ff006e")
plot_name="All_hogs_psmc.png"

psmcFiles <- files

inds <- gsub(".psmc", "",basename(psmcFiles))

pop = as.data.frame(read.table("/psmc/PSMC/species_list.txt", 
        header=F,
        col.names=c("Ind","Pop","Color"),
        sep="\t"))
