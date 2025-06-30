OUTDIR="/home/vzw531/data/GFH-project/distant/Dated_phylogeny/fastas_sites/regions"
CUTOFF=0.5  # 50% Ns

echo -e "Region\tSample\tN_fraction" > N_content_report.tsv

for file in "$OUTDIR"/chr*.fa; do
  REGION=$(basename "$file" .fa)
  # Read FASTA in 2-line chunks: header + sequence
  awk -v region="$REGION" -v cutoff="$CUTOFF" '
    BEGIN { FS="\n"; RS=">"; OFS="\t" }
    NR > 1 {
      header = $1
      gsub(/\r/, "", header)
      seq = $2
      gsub(/[^A-Za-z]/, "", seq)
      total = length(seq)
      N_count = gsub(/[Nn]/, "", seq)
      frac = (total > 0) ? N_count / total : 0
      print region, header, frac
    }
  ' "$file" >> N_content_report.tsv
done


# Calculate how many regions
# awk '{print $1}' N_content_report.tsv | uniq | wc -l
# 2254

# Select total regions with less than 50% missing values excluding Sus Scrofa (it's the reference so we know it has no missing data). 
grep -v "Sus" N_content_report.tsv | awk '($3 <0.5) {print $1}' | uniq | awk '{print $1".fa"}' > regions_0.5max_missingness.txt


# create passed and clean_fastas_miss0.5 (for the "cleaned" regions without Ns) folders                                                               
mkdir -p passed/clean_fastas_miss0.5
                                                                               
# move the regions in the passed folder                                                                                
while read line; do
mv $line passed/;
done < regions_0.5max_missingness.txt


# run the biopython code to remove sites with more than 50% Ns
INDIR='/home/vzw531/data/GFH-project/distant/Dated_phylogeny/fastas_sites/regions/passed'
OUTDIR='/home/vzw531/data/GFH-project/distant/Dated_phylogeny/fastas_sites/regions/passed/clean_fastas_miss0.5'

for FILE in $INDIR/chr*fa; do
OUT=$(basename $FILE .fa)
python remove_N_cols_0.5.py $FILE "$OUTDIR"/"$OUT"_clean.fa; done

