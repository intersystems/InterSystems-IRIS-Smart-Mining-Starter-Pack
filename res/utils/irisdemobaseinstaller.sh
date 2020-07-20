#!/bin/bash
#
# Amir Samary - 2019
#
# This must not be used on production.
#

source /tmp/utils/imageBuildingUtils.sh

prepare_databases_for_writing;

# This will configure all default users with the password 'sys'. This is just a demo base image.
configure_demo_user_password;

# This will prevent an alert level 1 on messages.log about not having the secondary journal configured
configure_alternate_journal;

printf "\nLoading base installer...\n"

# Can't load our source code with NOSTU. We need our namespace to be available. So, let's start iris...
iris start iris

# SuperUser will never expire again. This is just a demo base image.
disable_user_passwords_expirations;

# Now let's load and run our the base class for our Installer. This will just load the class IRISConfig.BaseInstaller.cls
load_and_run_base_installer;

# Finally, we can load IRISConfig.Installer and run it
load_and_run_installer;

# Cleanning up the base image
clean_up;

exit