#!/bin/bash
#
# Amir Samary - 2019
#
# This must not be used on production.
#

source /tmp/utils/imageBuildingUtils.sh

configure_iris;

prepare_databases_for_writing;

# Can't load our source code with NOSTU. We need our namespace to be available. So, let's start iris...
iris start iris

# Load IRISConfig.Installer and run it. It will load the rest of the source code.
load_and_run_installer;

# Cleanning up the image
clean_up;

exit