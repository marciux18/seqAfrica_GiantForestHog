BAMLIST="/home/vzw531/data/GFH-project/distant/Dated_phylogeny/bamlist.txt"
ANGSD="/maps/projects/seqafrica/apps/modules/software/angsd/0.940/bin/angsd"
REF="/projects/seqafrica/data/mapping/genomes/SusScrofa11_1.fasta"
REGION="/home/vzw531/data/GFH-project/distant/refs_files/SusScrofa_autosomes.txt"
OUTDIR="/home/vzw531/data/GFH-project/distant/Dated_phylogeny/fastas"

while read BAM; do
  BN=$(basename "$BAM" .SusScrofa.bam)
  $ANGSD -dofasta 2 \
    -setMinDepth 3 \
    -doCounts 1 \
    -rf "$REGION" \
    -uniqueOnly 1 \
    -remove_bads 1 \
    -minQ 25\
    -minMapQ 25 \
    -ref "$REF" \
    -i "$BAM" \
    -out $OUTDIR/"$BN" 
done < "$BAMLIST"
