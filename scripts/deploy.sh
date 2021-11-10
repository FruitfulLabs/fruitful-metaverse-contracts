#!/usr/bin/env bash

set -eo pipefail

# import the deployment helpers
. $(dirname $0)/common.sh

# Deploy.
GenesisFruitfulBaseCharacterAddr=$(deploy GenesisFruitfulBaseCharacter)
log "GenesisFruitfulBaseCharacter deployed at:" $GenesisFruitfulBaseCharacterAddr

VRFFacetAddr=$(deploy VRFFacet)
log "VRFFacet deployed at:" $VRFFacetAddr
