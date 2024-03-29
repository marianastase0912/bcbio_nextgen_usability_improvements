#!/bin/bash

echo ""
echo " --- [$(date +"%F %R")] Starting the Bulk RNA-seq workflow"

##########################################################################################################################################################################################
                                                                            # BULK RNA-SEQ WORKFLOW #
##########################################################################################################################################################################################

# Run Bulk RNA-seq Analysis
cd ${bcbio_runs_input}

echo " --- [$(date +"%F %R")] Configuring yaml template file for the samples in ${bcbio_runs_input} Bulk RNA-seq workflow"

# Generate yaml file from template to match over the samples for the analysis
bcbio_nextgen.py -w template bulk_rna.yaml ${bcbio_exp_name}.csv *.gz

echo " --- [$(date +"%F %R")] Running bcbio-nextgen locally, using ${bcbio_total_cores} CPU cores"

# Go to work directory to run the analysis
cd ${bcbio_runs_input}/${bcbio_exp_name}/work

# Run analysis with the yaml file generated for the sample data
bcbio_nextgen.py ${bcbio_workflow_config}/${bcbio_exp_name}.yaml -n ${bcbio_total_cores}

## clean work directory
rm -rf ${bcbio_workflow_work}

## print message for workflow completed
echo " --- [$(date +"%F %R")] Bulk RNA-seq workflow is finished."
