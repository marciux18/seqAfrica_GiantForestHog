import pandas as pd

def spaced_regions(bed_file, output_file, region_length=10000, gap_after_region=500000):
    step = region_length + gap_after_region
    df = pd.read_csv(bed_file, sep='\t', header=None, names=['chr', 'start', 'end'])
    regions = []

    for _, row in df.iterrows():
        chrom = row['chr']
        start = int(row['start'])
        end = int(row['end'])

        current = start
        while current + region_length <= end:
            region_end = current + region_length
            regions.append([chrom, current, region_end])
            current += step  # move to next start

    pd.DataFrame(regions).to_csv(output_file, sep='\t', header=False, index=False)

# Example usage:
spaced_regions("SusScrofa_autosomes.bed", "output_500kb_spaced_10kb_windows.bed")

spaced_regions("SusScrofa_autosomes.bed", "output_1Mb_spaced_10kb_windows.bed",10000,1000000)
