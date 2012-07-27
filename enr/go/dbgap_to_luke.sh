#!/bin/bash
#BSUB -J dbgap_to_luke[1-4215]
#BSUB -R rusage[mem=6,argon_io=3]
#BSUB -o dbgap_to_luke.log
#BSUB -q compbio-week
set -e
in=$(find /broad/compbio/aksarkar/dbgap/analyses -type f | sort | \
    sed -n "$LSB_JOBINDEX p")
ld=/broad/compbio/aksarkar/annotations/1kg-ld
zcat $in | \
    python $HOME/code/util/dbgap_to_bed.py | \
    bedtools intersect -a stdin -b /broad/hptmp/aksarkar/haploreg.bed.gz -wb | \
    awk '{print $9, $5}' | \
    python $HOME/code/ld/1kg/expand.py $ld/ceu-index.txt $ld/CEU.txt 0.8 | \
    gzip >$LSB_JOBINDEX.out.gz
