#!/bin/bash

##########################################################################################################################################################################################
                                                                            # SAMPLES MODULE #
##########################################################################################################################################################################################

## create a list of sample IDs
IFS=', ' read -r -a sample_list <<< ${bcbio_samples}
## create a list of name samples
IFS=', ' read -r -a file_name_list <<< ${bcbio_samples_fastq}

## get list lengths to determine from the user if the sample is multiple
count_samples="${#sample_list[@]}"
count_user_name_samples="${#file_name_list[@]}"
# echo "${count_samples} count samples"
# echo "${count_user_name_samples} usr cnt"
## get the number of samples from fastq
number_of_samples=$((${count_user_name_samples}/${count_samples}))
# echo "${number_of_samples} nbr"

## if user wants to download data 
if [[ ${bcbio_download_samples} = "yes" ]]; then

   ## download samples in input directory  
   cd ${bcbio_runs_input}
   ## counter to store the index
   cnt=0
   ## download, rename and gzip
   echo " --- [$(date +"%F %R")] Downloading samples using sra-tools in ${bcbio_runs_input}"
   #echo " --- [$(date +"%F %R")] Renaming and bgzipping files."
   
   ## configure SRA-tools' prefetch to download data in the current working directory
   vdb-config --prefetch-to-cwd

   for sample in ${sample_list[@]}
   do
      echo " --- [$(date +"%F %R")] Downloading sample $((${cnt} + 1)) of ${count_samples}"
      
      ## prefetch data from NCBI SRA
      prefetch ${sample} --max-size u
      
      ## extract FASTQ files from the prefetched SRA data
      fasterq-dump --split-files -O . -t . ${sample}
      
      if [[ ${number_of_samples} = 1 ]]; then
         ## rename samples as user input
         mv ${sample}.fastq ${file_name_list[${cnt}]}.fastq
         ## bgzip the samples
         bgzip -c ${file_name_list[cnt]}.fastq > ${file_name_list[${cnt}]}.fastq.gz
         rm -rf ${file_name_list[cnt]}.fastq
      fi
      if [[ ${number_of_samples} = 2 ]]; then
         ## rename samples as user input
         ## bgzip the samples
         mv ${sample}*1.fastq ${file_name_list[$((${cnt}*2))]}.fastq
         bgzip -c ${file_name_list[$((${cnt}*2))]}.fastq > ${file_name_list[$((${cnt}*2))]}.fastq.gz
         rm -rf ${file_name_list[$((${cnt}*2))]}.fastq

         mv ${sample}*2.fastq ${file_name_list[$((${cnt}*2+1))]}.fastq
         ## bgzip -c ${file_name_list[$((${cnt}*2))]}.fastq > ${file_name_list[$((${cnt}*2))]}.fastq.gz
         bgzip -c ${file_name_list[$((${cnt}*2+1))]}.fastq > ${file_name_list[$((${cnt}*2+1))]}.fastq.gz
         rm -rf ${file_name_list[$((${cnt}*2+1))]}.fastq
      fi

      cnt=$((${cnt} + 1))
   done
   
   ## cleanup
   rm *.fastq

fi

## for input data that is already on the disk
if [[ ${bcbio_download_samples} = "no" ]]; then
   ## go to source path where the samples are stored on the system
   cd ${bcbio_path_to_samples_on_sys}
   ## copy the samples in the input directory
   echo " --- [$(date +"%F %R")] Create soft links for samples into the input directory"
   for FILE in *
   do
      ## get the name of the file without the extension
      file_name=$(echo "${FILE}" | cut -f 1 -d '.')
      for val in ${file_name_list[@]}
      do
         ## for all files in directory compare the names with the list given as input and link them
         if [[ ${file_name} = ${val} ]]; then
            echo "${FILE}"
            #cp ${FILE} ${bcbio_runs_input}
            ln -s ${FILE} ${bcbio_runs_input}/${FILE}
         fi
      done
   done
fi
