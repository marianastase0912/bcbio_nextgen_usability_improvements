#!/bin/bash

echo ""
echo " --- [$(date +"%F %R")] Starting the ATAC-seq workflow"

##########################################################################################################################################################################################
                                                                            # ATAC-SEQ WORKFLOW #
##########################################################################################################################################################################################

# Run ATAC-seq Analysis
cd ${bcbio_runs_input}

echo " --- [$(date +"%F %R")] Configuring yaml template file for the samples in ${bcbio_runs_input} ATAC-seq workflow"

# Generate yaml file from template to match over the samples for the analysis
bcbio_nextgen.py -w template atac-example.yaml ${bcbio_exp_name}.csv *.gz

echo " --- [$(date +"%F %R")] Running bcbio-nextgen locally, using ${bcbio_total_cores} CPU cores"

# Go to work directory to run the analysis
cd ${bcbio_runs_input}/${bcbio_exp_name}/work

# Run analysis with the yaml file generated for the sample data
bcbio_nextgen.py ${bcbio_workflow_config}/${bcbio_exp_name}.yaml -n ${bcbio_total_cores}

## print message for workflow completed
echo " --- [$(date +"%F %R")] ATAC-seq workflow is finished."

## clean work directory
rm -rf ${bcbio_workflow_work}
