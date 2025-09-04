args <- commandArgs(trailingOnly = TRUE)

if (length(args) == 0) {
  stop("No file provided. Usage: Rscript plot_psmc_wconfig.R config.R")
}

input_file <- args[1]

# Check if file exists
if (!file.exists(input_file)) {
  stop(paste("File does not exist:", input_file))
}

# Source the provided file
cat("Sourcing:", input_file, "\n")
source(input_file)


psmcFiles <- files

psmc.result<-function(file, i.iteration, mu, s, g) {
  X<-scan(file=file,what="",sep="\n",quiet=TRUE)
  
  START<-grep("^RD",X)
  END<-grep("^//",X)
  
  X<-X[START[i.iteration+1]:END[i.iteration+1]]
  
  TR<-grep("^TR",X,value=TRUE)
  RS<-grep("^RS",X,value=TRUE)
  
  write(TR,"temp.psmc.result")
  theta0<-as.numeric(read.table("temp.psmc.result")[1,2])
  N0<-theta0/4/mu/s
  
  write(RS,"temp.psmc.result")
  a<-read.table("temp.psmc.result")
  Generation<-as.numeric(2*N0*a[,3]) # a[,3] is t_k
  Ne<-as.numeric(N0*a[,4]) #a[,4] is lambda_k
  
  file.remove("temp.psmc.result")
  
  n.points<-length(Ne)
  YearsAgo<-c(as.numeric(rbind(Generation[-n.points],Generation[-1])),
              Generation[n.points])*g
  Ne<-c(as.numeric(rbind(Ne[-n.points],Ne[-n.points])),
        Ne[n.points])
  
  data.frame(YearsAgo,Ne)
}


res <- lapply(psmcFiles, psmc.result, i.iteration, mu, s, g)
names(res) <- gsub(".psmc", "",basename(psmcFiles))

pop=pop

#remove the last 8 unreliable "rows"
res2 <- lapply(res, function(x) x[-((nrow(x) - 8):nrow(x)),])

# ---- Palette and group mapping ----
ind_to_pop <- setNames(pop$Pop, pop$Ind)
final_palette <- setNames(pop$Color, pop$Pop)

# One representative per pop
rep_inds <- sapply(unique(pop$Pop), function(p) {
  inds_in_pop <- pop$Ind[pop$Pop == p]
  intersect(inds_in_pop, names(res2))[1]
})

png(file = plot_name, width = 3200, height = 2400, res = 300)
par(mar = c(5, 5, 4, 1) + 0.1)

# First individual for axis setup
first_ind <- names(res2)[1]
suppressWarnings(
  plot(type = 'l',x = res2[[first_ind]]$YearsAgo, y = res2[[first_ind]]$Ne,
       log = 'x', col = "white",
       xlab = paste0("Years ago (mu=", mu, ", g=", g, ")"),
       ylab = "Effective Population Size",
       cex.lab = 1.5,
       ylim = c(0, 150000), cex.axis = 1.5)
)
for (i in seq_along(res2)) {
  ind <- names(res2)[i]
  pop_name <- ind_to_pop[ind]

    lines(x = res2[[ind]]$YearsAgo,
          y = res2[[ind]]$Ne,
          col = final_palette[pop_name],
          lwd = 2)
  }
legend("topleft", legend = names(rep_inds), col = final_palette[names(rep_inds)], lty = 1, lwd = 3, bty = "n", cex = 1.5)

dev.off()
