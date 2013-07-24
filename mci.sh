#!/bin/bash
# To make it easier to run this script you can add this line to your .bash_profile: alias mci=~/mci.sh
# Version 2.0

# Setup here the folder location of your workspace
WORKSPACE_FOLDER="/cygdrive/c/development/workspace"

declare -A projects
projects=(
  	["adm"]="automated-deployment-manager"
		["ati"]="automated-test-intelligence"
		["bil"]="billing"
		["cendris"]="cendris"
		["cin"]="customer-inventory"
		["ce2e"]="consumer-end-to-end-test-suite"
		["crts"]="consumer-regression-test-suite"
		["cua"]="customer-assurance"
		["db"]="zon"
		["docdata"]="docdata"
		["dms"]="document-management-system"
		["ixi"]="ixi"
		["mfapi"]="mediafarm-api"
		["nopa"]="notification-partners"
		["nid"]="nid"
		["orc"]="orchestration"
		["orcapi"]="orchestration-api"
		["orcitest"]="orchestration-itest"
		["prv"]="provisioning"
		["pupa"]="publication-partners"
		["zon"]="zon"
		["bos"]="bos"
		["svap"]="singleview-api"
		["blis"]="blacklist"
		["eca"]="ecadyre"
	)
	
declare -A maven
maven=(
		["st"]="-D skipTests"
		["sits"]="-D skipITs"
	)
	
if [ $1 ]
then
	PROJECT_KEY="${1%-*}"
	PROJECT_SUBNAME="${1#*-}"
	PROJECT_NAME=${projects[$PROJECT_KEY]}
else
	echo "Enter project key to build"
	echo "usage: mci [proj_key] [mvn_options]"
	echo
	echo Actual Projects:
		for p_key in "${!projects[@]}"
		do
		 	printf "  [%s] = %s\n" "$p_key" "${projects[$p_key]}"
		done
	echo Actual Maven Options:
		for m_option in "${!maven[@]}"
		do
			printf "  [%s] = %s\n" "$m_option" "${maven[$m_option]}"
		done
	
	read proj_name
	export PROJ_KEY=$proj_name
	PROJECT_KEY="${PROJ_KEY%-*}"
	PROJECT_SUBNAME="${PROJ_KEY#*-}"
fi

if [ $2 ]
then
	MAVEN_ARGS=${maven[$2]}
else
	MAVEN_ARGS=""
fi

if [ $PROJECT_SUBNAME ]
then
	PROJECT_NAME=${projects[$PROJECT_KEY]}
	if [ $PROJECT_SUBNAME != $PROJECT_KEY ]
	then
		PROJECT_PATH=$WORKSPACE_FOLDER/$PROJECT_NAME/$PROJECT_NAME-$PROJECT_SUBNAME
	else
		PROJECT_PATH=$WORKSPACE_FOLDER/$PROJECT_NAME
	fi

	echo Executing... mvn clean install $MAVEN_ARGS on project $PROJECT_PATH
	cd $PROJECT_PATH ; mvn clean install $MAVEN_ARGS
else
	echo Project not found! Nothing is run.
fi
