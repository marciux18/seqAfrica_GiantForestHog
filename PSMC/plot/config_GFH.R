mu <- 1.49e-8
g <- 6
i.iteration <- 25
s <- 100
files <-list.files("/psmc/PSMC_OUT/",".psmc",full.names=T)
color_sp = c("#11dc43ff","#165927ff")
sp_name_u="Giant forest hog (Uganda)"
sp_name_g="Giant forest hog (Guinea)"
plot_name="GFH_psmc.png"

psmcFiles <- files
inds <- gsub(".psmc", "",basename(psmcFiles))

pop = data.frame(Pop=c(sp_name_g, rep(sp_name_u,length(inds)-1)),
        Ind = c(inds),
        Color=c(color_sp[1], rep(color_sp[2],length(inds)-1) 
))
