REGION="/home/vzw531/data/GFH-project/distant/refs_files/output_1Mb_spaced_10kb_windows.bed"
FILEDIR="/home/vzw531/data/GFH-project/distant/Dated_phylogeny/fastas"
OUTDIR="/home/vzw531/data/GFH-project/distant/Dated_phylogeny/fastas/regions"

#module load bcftools/2.31.0  

for FILE in $FILEDIR/*fa.gz; do
  OUTFA=$(basename $FILE .gz)
  BN=$(basename $OUTFA .fa)
  bedtools getfasta -fi $FILE -bed $REGION -fo $OUTDIR/$OUTFA; 

  echo "Rename the header to add the samples name at the beginning of the chromosome and region."
  sed -i "s/^>/>${BN}_/" "$OUTDIR/$OUTFA"
  done


#select regions in the reference Sus Scrofa
REF="/projects/seqafrica/data/mapping/genomes/SusScrofa11_1.fasta"
REF_OUT="SusScrofa.fa"
SUS="SusScrofa"
bedtools getfasta -fi $REF -bed $REGION -fo $OUTDIR/$REF_OUT
sed -i "s/^>/>${SUS}_/" "$OUTDIR/$REF_OUT"


while read window; do
  CHR=$(echo "$window" | cut -f1)
  START=$(echo "$window" | cut -f2 )
  END=$(echo "$window" | cut -f3)

  REGION_NAME="${CHR}:${START}-${END}"

  for FILE in $OUTDIR/*fa; do
    BN=$(basename $FILE .fa)
    #OUTFILE="${BN}_${REGION_NAME}"
    OUTFILE="${CHR}_${START}_${END}.fa"
    grep "$REGION_NAME" -A1 $FILE >> $OUTDIR/$OUTFILE
  done; done < $REGION
