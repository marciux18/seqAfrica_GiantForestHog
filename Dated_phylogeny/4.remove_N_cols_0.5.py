from Bio import AlignIO
from Bio.Align import MultipleSeqAlignment
import sys
import os

# Check arguments
if len(sys.argv) != 3:
    print(f"Usage: python {os.path.basename(__file__)} input.fasta output.fasta")
    sys.exit(1)

input_file = sys.argv[1]
output_file = sys.argv[2]
max_N_fraction = 0.5  # You can also make this a 3rd argument if needed

# Load alignment
alignment = AlignIO.read(input_file, "fasta")
num_seqs = len(alignment)
alignment_len = alignment.get_alignment_length()

# Identify positions to keep
positions_to_keep = []
for i in range(alignment_len):
    column = alignment[:, i]
    N_count = column.upper().count('N')
    if N_count / num_seqs <= max_N_fraction:
        positions_to_keep.append(i)

# Build cleaned alignment
cleaned_records = []
for record in alignment:
    new_seq = ''.join(record.seq[i] for i in positions_to_keep)
    record.seq = record.seq.__class__(new_seq)  # Preserve sequence type
    cleaned_records.append(record)

cleaned_alignment = MultipleSeqAlignment(cleaned_records)

# Save cleaned alignment
AlignIO.write(cleaned_alignment, output_file, "fasta")

print(f"Original alignment length: {alignment_len}")
print(f"Cleaned alignment length: {len(positions_to_keep)}")
