echo "*** Installing additional dependencies"
apk add --update bash jq curl git openssl coreutils

echo "*** Report Prepackaged with the Node Alpine Docker Image"
echo "*** node Version"
node --version
echo "*** npm Version"
npm --version

echo "*** Report Installed Dependencies in Alpine"
apk info -vv | sort

echo "*** Installing sfdx-cli"
npm i -g sfdx-cli
echo "*** Report SFDX Info"
sfdx --version
sfdx plugins --core

mkdir -p incremental/force-app
