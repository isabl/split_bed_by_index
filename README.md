Nim Program to split bed files based on estimated read counts in each interval based on the index of a bam file.

This program splits based on read estimates without counting the reads.
If more exact read counts are need use [split_bed_by_reads](https://github.com/papaemmelab/split_bed_by_reads).

This is useful for parallelization of bioinformatics algorithms that allow input regions.
When runtime of the algorithms is linearly correlated with number of reads in the region,
this program should create regions with similar runtime.

# How It Works

Bam indexs (bai files) store information on file byte offsets for different regions of the bam.
This allows for random access of reads from the bam file. The linear index is split up into 16,384 base chunks.
It also stores the total number of mapped and unmapped reads for each contig. Using the total number of reads and bytes for a contig we can estimate the average number of bytes per read.
The bytes per read value is then used to estimate the number of reads in the 16,384 base chunks overlapped by the requested regions and split based on a maximum.

# Installation:

Install nim and compile nim script

```
curl https://nim-lang.org/choosenim/init.sh -sSf|sed "s/need_tty=yes/need_tty=no/g" | sh
export PATH=$HOME/.nimble/bin:$PATH

export PATH=${OPT_DIR}/.nimble/bin:$PATH
nimble install -y https://github.com/papaemmelab/split_bed_by_index --nimbleDir:${OPT_DIR}/.nimble
```

Download the binaries:

```
wget -O ${BIN_DIR}/split_bed_by_index https://github.com/papaemmelab/split_bed_by_index/releases/download/0.1.0/split_bed_by_index && \
chmod +x ${BIN_DIR}/split_bed_by_index
export PATH=${BIN_DIR}:$PATH
```

# Usage:

```
Split bed intervals by estimated read counts from bam index

Usage:
  split_bed_by_index [options] <BED> <BAM> <OUT>

Arguments:
  <BED>     Input bed file
  <BAM>     Input bam file
  <OUT>     Output bed file

Options:
  -h --help                 Show this screen.
  -v --version              Show version.
  -c --count <count>        Number of reads to split  [default: 1000000].
  -m --merge                Merge overlapping regions before split.
  -s --subsplit <method>    Subsplit regions by exact or guess of reads  [default: exact].
```

If there are significantly more reads in a 16kb chunk than the split count one of two subsplit methods can be used. **exact** method will count the reads in this chunk and split accordingly. **guess** method will split the chunk into equal size regions based on the total number of estimated reads. The exact method will be slow when used but will be accurate, while the guess method is instantaneous but can be very inaccurate if the reads are not distributed evenly. 

# Credit
* Max Levine [@mflevine](https://github.com/mflevine)
* Inspired by [indexcov](https://github.com/brentp/goleft/tree/master/indexcov) by Brent Pederson [@brentp](https://github.com/brentp)
* [hts-nim-tools](https://github.com/brentp/hts-nim-tools) by Brent Pederson [@brentp](https://github.com/brentp)
