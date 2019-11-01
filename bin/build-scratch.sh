#!/bin/bash

#Import methods
. ./lib/sfdx.sh

create_scratch $1 10 config/project-scratch-def.json
source_push $1
data_import $1 data/Account-Contact-Case-plan.json
bulk_assign_permsets $1 LWCDemoApp ConsoleNav

echo "*** New Scratch Org, $1, ready."
echo "*** Enter: sfdx force:org:open"