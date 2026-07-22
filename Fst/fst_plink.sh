module load plink/2.0.0 
plink2 --bcf /maps/projects/seqafrica/people/pls394/others/giantforsthog/GT/results/pig/vcf/SusScrofa_Wild_variable_sites_mergeDomes-Babir_nomultiallelics_noindels_10dp_2het.bcf.gz --make-bed --out SusScrofa_Wild_variable_sites_mergeDomes-Babir_nomultiallelics_noindels_10dp_2het

plink2 -bfile ./SusScrofa_Wild_variable_sites_mergeDomes-Babir_nomultiallelics_noindels_10dp_2het --within pop2.tsv --fst CATPHENO method=hudson --out SusScrofa_Wild_variable_sites_mergeDomes-Babir_nomultiallelics_noindels_10dp_2het_FstOut_pop --allow-extra-chr
