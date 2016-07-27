
# Kate Lee August 2014
# generate R scripts to create graphics for each line of output from mrna_hemi-meth_CpGi_overlap.txt (tab-delimited file)
#
# input: perl Rsripts.pl <mrna_hemi-meth_file.txt>



#!usr/bin/perl
use strict;
use warnings;

#my $file = $ARGV[0];
my $file_end = "R3_S6.txt";
open(FILE, "<mrna_hemi-meth_$file_end") || die "couldn't open mrna_HM_CpGi_overlap.txt file:$!";

system `mkdir graphics$file_end`;

while(<FILE>){
    chomp;
    if ($_=~ /^contig/) {next;}
    my @info = split("\t",$_);

# define plot boundaries, axes etc...
    open(OUT, ">graphics$file_end/$info[0]_$info[1].R") || die "couldn't open graphicRscripts/$info[0]_$info[1].R:$!";
    print OUT "png(\"$info[0]_$info[1].png\", width=20, height=25, units=\"cm\", res=200)\n";
    print OUT "# create plot\n";
    print OUT "par(mar=c(5, 5, 1, 1))\n";
    print OUT "plot(1, type=\"n\", xlab=\"contig $info[0]\", ylab=\"coverage\", xlim=c($info[1]-50,$info[2]+ 50), ylim=c(0.7, 5.3), axes=FALSE, ann=TRUE, cex.lab=1.5)\n";
    print OUT "axis(2,at=c(1:5),labels = c(\"RNA\", \"MeDIP\", \"MRE\", \"Hemi-meth\", \"CpG Island\"))\n";
    print OUT "axis(1, ann=TRUE)\n\n";

# plot the RNA
    print OUT "# plot the RNA\n";
    print OUT "y0 <- 1\n";
    print OUT "y1 <- 1\n";
    print OUT "x0 <- $info[1]\n";
    print OUT "x1 <- $info[2]\n\n";
    print OUT "segments( x0, y0, x1, y1, col=\"red\", lty=1, lwd=10, lend=1)\n";

# plot the medip data
    print OUT "# plot the MeDIP\n";
    print OUT "y0 <- 2\n";
    print OUT "y1 <- 2\n";
    my @medip = split(",", $info[6]);
    foreach (@medip) {
        my @medip_cov = split(":", $_);
        print OUT "x0 <- $medip_cov[0]\n";
        print OUT "x1 <- $medip_cov[1]\n";
        print OUT "segments( x0, y0, x1, y1, col=\"blue\", lty=1, lwd=10, lend=1)\n";
    }

# plot the mre data
    print OUT "# plot the MRE\n";
    print OUT "y0 <- 3\n";
    print OUT "y1 <- 3\n";
    my @mre = split(",", $info[7]);
    foreach (@mre) {
        my @mre_cov = split(":", $_);
        print OUT "x0 <- $mre_cov[0]\n";
        print OUT "x1 <- $mre_cov[1]\n";
        print OUT "segments( x0, y0, x1, y1, col=\"green\", lty=1, lwd=10, lend=1)\n";
    }


# plot hemi-methylated data
    print OUT "# plot the hemi-meth data\n";
    print OUT "y0 <- 4\n";
    print OUT "y1 <- 4\n";
    my @hemimeth = split(",", $info[5]);
    foreach (@hemimeth) {
        my @hemimeth_cov = split(":", $_);
        print OUT "x0 <- $hemimeth_cov[0]\n";
        print OUT "x1 <- $hemimeth_cov[1]\n";
        print OUT "segments( x0, y0, x1, y1, col=\"orange\", lty=1, lwd=10, lend=1)\n";
    }

# plot the cpg islands
    print OUT "\n# plot the CpG islands\n ";
    print OUT "y0 <- 5\n";
    print OUT "y1 <- 5\n";
    my @cpgisland = split(",", $info[8]);
    foreach (@cpgisland) {
        my @cpgisland_cov = split(":", $_);
        print OUT "x0 <- $cpgisland_cov[0]\n";
        print OUT "x1 <- $cpgisland_cov[1]\n";
        print OUT "segments( x0, y0, x1, y1, col=\"black\", lty=1, lwd=10, lend=1)\n";
    }

# plot the snps
    print OUT "\n# plot snps\n";
    my @snps = split(" ", $info[10]);
    foreach (@snps){
        #print $_."\n";
        $_ =~ /^(\w+)/;
        my $snp_type = $1;
        #print "$snp_type\n";                        # TESTED ;)
        $_ =~ /\|(\d+)\|/;
        my $snp_pos = $1;
        #print "$snp_pos\n";                         # TESTED ;)
        if ($snp_type eq "medip") {
            print OUT "y0 <- 1.8\n";
            print OUT "y1 <- 2.2\n";
            print OUT "x0 <- $snp_pos\n";
            print OUT "x1 <- $snp_pos\n";
            print OUT "segments( x0, y0, x1, y1, col=\"black\", lty=1, lwd=2, lend=1)\n";
            print OUT "y0 <- 0.8\n";
            print OUT "y1 <- 1.2\n";
            print OUT "x0 <- $snp_pos\n";
            print OUT "x1 <- $snp_pos\n";
            print OUT "segments( x0, y0, x1, y1, col=\"black\", lty=1, lwd=2, lend=1)\n";

        }
        else {
            print OUT "y0 <- 2.8\n";
            print OUT "y1 <- 3.2\n";
            print OUT "x0 <- $snp_pos\n";
            print OUT "x1 <- $snp_pos\n";
            print OUT "segments( x0, y0, x1, y1, col=\"black\", lty=1, lwd=2, lend=1)\n";
            print OUT "y0 <- 0.8\n";
            print OUT "y1 <- 1.2\n";
            print OUT "x0 <- $snp_pos\n";
            print OUT "x1 <- $snp_pos\n";
            print OUT "segments( x0, y0, x1, y1, col=\"black\", lty=1, lwd=2, lend=1)\n";
        }
    }
    close OUT
}

