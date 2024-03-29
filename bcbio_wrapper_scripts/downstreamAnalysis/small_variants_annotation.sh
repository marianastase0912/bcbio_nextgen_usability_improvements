#!/bin/bash

##########################################################################################################################################################################################
                                                                         # SMALL VARIANTS #
##########################################################################################################################################################################################

# test if  varcall-analysis-small-var.vcf.gz file exists
if [ -f  ${bcbio_exp_name}-small-var.vcf.gz ]; then
    echo " --- [$(date +"%F %R")] Performing variant annotation on small variants."

    # extract VCF file
    gunzip -f *vcf.gz

    # extract the file name without the extension
    vcf_file="${bcbio_exp_name}-small-var.vcf.gz"
    vcf_file_name=$(echo "${vcf_file}" | cut -f 1 -d '.')
    
    ## filter out variants that do not PASS the filters
    echo " --- [$(date +"%F %R")] Removing variants that did not pass quality filters"

    bcftools view -Ov -f .,PASS ${vcf_file_name}.vcf > ${vcf_file_name}-filtered.vcf
    mv ${vcf_file_name}-filtered.vcf ${vcf_file_name}.vcf

    ## reorder the samples; generate stats, annotate variants and extract relevant columns into a tab-separated file
    ## create stats for each VCF file

    echo " --- [$(date +"%F %R")] Reordering the samples in the VCF files and generating variant statistics"
    bcftools stats ${vcf_file_name}.vcf > ${vcf_file_name}-bcf.stats.txt
    echo " --- [$(date +"%F %R")] Variant statistics were written to the file: ${vcf_file_name}-bcf.stats.txt"

    ## extract relevant columns (GT and AD,DP) from a VCF file into tab-separated files
    echo " --- [$(date +"%F %R")] Extracting genotypes to a tab-separated file: ${vcf_file_name}-GT.table"
    gatk VariantsToTable -R ${genome_dir}/seq/${bcbio_genome:?}.fa -V ${vcf_file_name}.vcf -F CHROM -F POS -F ID -F REF -F ALT -GF GT -O ${vcf_file_name}-GT.table
    echo " --- [$(date +"%F %R")] Done  vcf file"

    if [ ${bcbio_annotated_species} = "yes" ]; then
        ## annotate variants with Ensembl VEP
        
        # gzip --keep  /export/home/acs/stud/m/maria.nastase0912/bcbio_nextgen/genomes/Scerevisiae/sacCer3/rnaseq/ref-transcripts.gtf 
        # bgzip --keep ${vcf_file_name}.vcf
        # bcftools index ${vcf_file_name}.vcf.gz
        # bgzip -d ${vcf_file_name}.vcf.gz
        
        ## run VEP using the cache for our species
        # echo " --- [$(date +"%F %R")] Running VEP once, with the official cache for our species
        # ${bcbio_install_path:?}/extra/envs/py3/bin/vep --fork 4 --vcf --biotype --check_existing --distance 1000000 --symbol --species ${bcbio_vep_species} --cache --cache_version ${bcbio_ensembl_ver} --dir_cache ${genome_dir}/vep --input_file ${vcf_file_name}.vcf --output_file ${vcf_file_name}-vep.vcf --force_overwrite --stats_file ${vcf_file_name}-vep.stats --stats_text --offline --max_sv_size 1000000000
        # echo " --- [$(date +"%F %R")] VCF file with annotations was saved as: ${vcf_file_name}-vep.vcf"

        ## run VEP again and output a tab-separated file with only the most severe consequence per variant, skipping stats generation this time
        # echo " --- [$(date +"%F %R")] Running VEP a second time, to generate the most severe consequence per variant"
        # ${bcbio_install_path:?}/extra/envs/py3/bin/vep --fork 4 --tab --pick --no_stats --biotype --check_existing --distance 1000000 --symbol --species ${bcbio_vep_species} --cache --cache_version ${bcbio_ensembl_ver} --dir_cache ${genome_dir}/vep --input_file ${vcf_file_name}.vcf --output_file ${vcf_file_name}-vep.table --force_overwrite --offline --max_sv_size 1000000000
        # echo " --- [$(date +"%F %R")] Variant consequences were written to the file: ${vcf_file_name}-vep.table"
        
        ## run VEP using the cache for our species
        echo " --- [$(date +"%F %R")] Running VEP with the official cache for the species: ${bcbio_vep_species}, version ${bcbio_ensembl_ver}"
        ${bcbio_install_path:?}/extra/envs/py3/bin/vep --fork 4 --tab --pick --biotype --check_existing --distance 1000000 --symbol --species $(echo "$bcbio_vep_species" | awk '{print tolower($0)}') --cache --cache_version ${bcbio_ensembl_ver} --dir_cache ${genome_dir}/vep --input_file ${vcf_file_name}.vcf --output_file ${vcf_file_name}-vep.table --force_overwrite --stats_file ${vcf_file_name}-vep.stats --stats_text --offline --max_sv_size 1000000000
        echo " --- [$(date +"%F %R")] Variant consequences were written to the file: ${vcf_file_name}-vep.table"
        
    else
    
        rm -f ${genome_dir}/rnaseq/ref-transcripts.gtf.gz

        sort -k 1,1 -k 4,4n -k 5,5n ${genome_dir}/rnaseq/ref-transcripts.gtf > ${genome_dir}/rnaseq/ref-transcripts_sorted.gtf 
        
        mv ${genome_dir}/rnaseq/ref-transcripts_sorted.gtf ${genome_dir}/ref-transcripts.gtf

        bgzip --keep ${genome_dir}/rnaseq/ref-transcripts.gtf
        tabix ${genome_dir}/rnaseq/ref-transcripts.gtf.gz
        # ---
        # TODO add custom genome scenario
        # echo "CUSTOM"
        
        ## run VEP with custom annotations from the GTF file
        # echo " --- [$(date +"%F %R")] Running VEP once, with custom annotations from the GTF file: ${genome_dir}/rnaseq/ref-transcripts.gtf"
        # ${bcbio_install_path:?}/extra/envs/py3/bin/vep --fork 4 --vcf --biotype --check_existing --distance 1000000 --symbol --fasta ${genome_dir}/seq/${bcbio_genome:?}.fa --custom ${genome_dir}/rnaseq/ref-transcripts.gtf.gz,ref-transcripts,gtf,overlap,0 --input_file ${vcf_file_name}.vcf --output_file ${vcf_file_name}-vep.vcf --force_overwrite --stats_file ${vcf_file_name}-vep.stats --stats_text --offline --max_sv_size 1000000000
        # echo " --- [$(date +"%F %R")] VCF file with annotations was saved as: ${vcf_file_name}-vep.vcf"
        
        ## run VEP again and output a tab-separated file with only the most severe consequence per variant, skipping stats generation this time
        # echo " --- [$(date +"%F %R")] Running VEP a second time, to generate the most severe consequence per variant"
        # ${bcbio_install_path:?}/extra/envs/py3/bin/vep --fork 4 --tab --pick --no_stats --biotype --check_existing --distance 1000000 --symbol --fasta ${genome_dir}/seq/${bcbio_genome:?}.fa --custom ${genome_dir}/rnaseq/ref-transcripts.gtf.gz,ref-transcripts,gtf,overlap,0 --input_file ${vcf_file_name}.vcf --output_file ${vcf_file_name}-vep.table --force_overwrite --offline --max_sv_size 1000000000
        # echo " --- [$(date +"%F %R")] Variant consequences were written to the file: ${vcf_file_name}-vep.table"
        
        ## run VEP with custom annotations from the GTF file
        echo " --- [$(date +"%F %R")] Running VEP with custom annotations from the GTF file: ${genome_dir}/rnaseq/ref-transcripts.gtf"
        ${bcbio_install_path:?}/extra/envs/py3/bin/vep --fork 4 --tab --pick --biotype --check_existing --distance 1000000 --symbol --fasta ${genome_dir}/seq/${bcbio_genome:?}.fa --custom ${genome_dir}/rnaseq/ref-transcripts.gtf.gz,ref-transcripts,gtf,overlap,0 --input_file ${vcf_file_name}.vcf --output_file ${vcf_file_name}-vep.table --force_overwrite --stats_file ${vcf_file_name}-vep.stats --stats_text --offline --max_sv_size 1000000000
        echo " --- [$(date +"%F %R")] Variant consequences were written to the file: ${vcf_file_name}-vep.table"
        
    fi
    
else
    echo " --- [$(date +"%F %R")] Small variants have not been called, or there was an error while calling them."
fi
