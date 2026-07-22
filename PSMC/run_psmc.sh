# Load snakemake module

module load snakemake

WORKDIR='/home/data/GFH-project/PSMC/scripts/'
threads=80
snakemake \
    --configfile ${WORKDIR}config.yaml \
    --snakefile ${WORKDIR}psmc.snakefile \
    -c ${threads}
