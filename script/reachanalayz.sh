INSIGHTS_PATH_ID=$(aws ec2 create-network-insights-path \
--source $INSTANCE_ID_1 --destination-port 22 \
--destination $INSTANCE_ID_2 --protocol tcp \
--output text --query
NetworkInsightsPath.NetworkInsightsPathId)

# wait for path to be available
aws ec2 wait network-insights-path-available \
--network-insights-path-ids $INSIGHTS_PATH_ID
echo "Path $INSIGHTS_PATH_ID is available"

ANALYSIS_ID_1=$(aws ec2 start-network-insights-analysis \
--network-insights-path-id $INSIGHTS_PATH_ID --output text \
--query NetworkInsightsAnalysis.NetworkInsightsAnalysisId)
# wait for analysis to be available
aws ec2 wait network-insights-analysis-succeeded \
--network-insights-analysis-ids $ANALYSIS_ID_1
echo "Analysis $ANALYSIS_ID_1 is available"

aws ec2 describe-network-insights-analyses \
--network-insights-analysis-ids $ANALYSIS_ID_1

aws ec2 authorize-security-group-ingress \
--protocol tcp --port 22 \
--source-group $INSTANCE_SG_ID_1 \
--group-id $INSTANCE_SG_ID_2

ANALYSIS_ID_2=$(aws ec2 start-network-insights-analysis \
--network-insights-path-id $INSIGHTS_PATH_ID --output text \
--query NetworkInsightsAnalysis.NetworkInsightsAnalysisId)

aws ec2 describe-network-insights-analyses \
--network-insights-analysis-ids $ANALYSIS_ID_2