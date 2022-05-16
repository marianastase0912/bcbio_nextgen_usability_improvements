#!/bin/bash

echo ""
echo "--- [$(date +"%F %R")] Starting the ATAC-seq workflow"
echo "--- [$(date +"%F %R")] Using Python version: $(python --version)"
echo "--- [$(date +"%F %R")] Current PATH variable: ${PATH}"
echo "--- [$(date +"%F %R")] Using configuration file: " $1

##########################################################################################################################################################################################
                                                                            # ATAC-SEQ WORKFLOW #
##########################################################################################################################################################################################


# TODO restore/resume a previous analysis

# Run ATAC-seq Analysis
cd ${bcbio_runs_input}
echo "--- [$(date +"%F %R")] Configuring yaml template file for the samples in ${bcbio_runs_input} ATAC-seq workflow"

# Generate yaml file from template to match over the samples for the analysis
bcbio_nextgen.py -w template atac-example.yaml ${action_name}.csv *.gz

echo "--- [$(date +"%F %R")] Running analysis for ATAC-seq workflow"

# Go to work directory to run the analysis
cd ${bcbio_runs_input}/${action_name}/work

# Run analysis with the yaml file generated for the sample data
bcbio_nextgen.py ../config/${action_name}.yaml -n ${bcbio_total_cores%?}
