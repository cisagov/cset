#!/bin/bash
shopt -s extglob dotglob nullglob

if [ -z "$DEPLOY_DIR" ]; then
	DEPLOY_DIR='//webaccluster/webservices/Acceptance/Websites/csetac'
fi

# Deploy
echo "Deploying build to $DEPLOY_DIR"

echo 'Creating swap folders'
mkdir $DEPLOY_DIR/SWAP_OUT
mkdir $DEPLOY_DIR/SWAP_IN

echo 'copying current build to SWAP_IN'
cp -r dist/* $DEPLOY_DIR/SWAP_IN

echo 'swapping old build for new'
mv $DEPLOY_DIR/!(SWAP_OUT|SWAP_IN|aspnet_client) $DEPLOY_DIR/SWAP_OUT
mv $DEPLOY_DIR/SWAP_IN/* $DEPLOY_DIR

echo 'removing swap folders'
rm -rf $DEPLOY_DIR/SWAP_IN
rm -rf $DEPLOY_DIR/SWAP_OUT

echo 'CSET Deployed'
