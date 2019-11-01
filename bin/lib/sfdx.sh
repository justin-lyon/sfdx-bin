#!/bin/bash

# Import utilities
. ./scripts/lib/utilities.sh

# Print SFDX Info
get_info () {
  echo "*** Print SFDX Info"
  sfdx --version
  sfdx plugins --core
  sfdx force:org:list
}

# Login to a Sandbox by JWT
jwt_login () {
  echo "*** Logging in to $4 as $3 at $5."
  sfdx force:auth:jwt:grant -d \
    --clientid $1 \
    --jwtkeyfile $2 \
    --username $3 \
    --setalias $4 \
    --instanceurl $5
}

# Web login to sandbox or prod
web_login () {
  HUB_ALIAS=${1:-"DevHub"}
  echo "*** Initialize web login to $HUB_ALIAS"
  sfdx force:auth:web:login \
    --setdefaultdevhubusername \
    --setalias $HUB_ALIAS
}

# Delete a Scratch Org
delete_org () {
  echo "*** Removing old scratch org, $1"
  sfdx force:org:delete \
    --noprompt \
    --targetusername $1
}

# Create a new Scratch Org
create_scratch () {
  DURATION=${2:-10}
  echo "*** Creating scratch Org. Alias: $1, for $DURATION days."
  sfdx force:org:create \
    --setdefaultusername \
    --setalias "$1" \
    --durationdays $DURATION \
    --definitionfile "$3"
}

# Push local to a Scratch Org.
source_push () {
  echo "*** Pushing metadata to $1"
  sfdx force:source:push \
    --targetusername $1
}

# Pull changes from a Scratch Org.
source_pull () {
  echo "*** Pulling changes from $1"
  sfdx force:source:pull \
    --targetusername $1
}

source_retrieve () {
  echo "*** Retrieving changes from $1"
  sfdx force:source:retrieve \
    --manifest manifest/package.xml
}

source_deploy () {
  echo "*** Deploying changes to $1"
  sfdx force:source:deploy \
    --targetusername $1 \
    --manifest manifest/package.xml
}

source_validate () {
  echo "*** Validating changes to $1"
  sfdx force:source:deploy \
    --targetusername $1 \
    --manifest manifest/package.xml \
    --checkonly \
    --testlevel RunLocalTests
}

# Import Data to scratch org
# Requires data path $2=data/my-plan.json
data_import () {
  echo "*** Importing data from $2 to $1"
  sfdx force:data:tree:import \
    --targetusername $1 \
    --plan $2
}

# Assign one Permission Set
assign_permset () {
  echo "*** Assigning $2 Permission Set in $1"
  sfdx force:user:permset:assign \
    --targetusername $1 \
    --permsetname $2
}

# Usage: $ bulk_assign_permsets $ORG_ALIAS $PERMSET_ONE $PERMSET_TWO $PERMSET_ETC
# ALT Usage: $ bulk_assign_permsets $1 ${@:2}
bulk_assign_permsets () {
  for i in "${@:2}"
  do
    assign_permset $1 $i
  done
}

# Run All Local Tests in Scratch Org
run_local_tests () {
  disable_error_trapping

  echo "*** Running All Local Apex Tests..."
  sfdx force:apex:test:run -c \
    --resultformat human \
    --testlevel RunLocalTests \
    -targetusername $1

  handle_error $RETURN_CODE
}
