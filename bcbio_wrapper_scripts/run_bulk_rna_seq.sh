#!/bin/bash

echo ""
echo "--- [$(date +"%F %R")] Starting the Bulk RNA-seq workflow"
echo "--- [$(date +"%F %R")] Using configuration from directory: " ${path_to_scripts}

##########################################################################################################################################################################################
                                                                            # BULK RNA-SEQ WORKFLOW #
##########################################################################################################################################################################################

# TODO restore/resume a previous analysis

# Run Bulk RNA-seq Analysis
cd ${bcbio_runs_input}
echo "--- [$(date +"%F %R")] Configuring yaml template file for the samples in ${bcbio_runs_input} Bulk RNA-seq workflow"

# Generate yaml file from template to match over the samples for the analysis
bcbio_nextgen.py -w template abulk_rna.yaml ${action_name}.csv *.gz

echo "--- [$(date +"%F %R")] Running analysis for Bulk RNA-seq workflow"

# Go to work directory to run the analysis
cd ${bcbio_runs_input}/${action_name}/work

# Run analysis with the yaml file generated for the sample data
bcbio_nextgen.py ../config/${action_name}.yaml -n ${bcbio_total_cores%?}
