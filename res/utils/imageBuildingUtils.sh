#!/bin/bash

precondition_checks() {
        if [ $UID -eq 0 ]; then
                error "You should run this script as $ISC_PACKAGE_MGRUSER."
        exit 1;
        fi

        # IRIS images are expected to have all of the following environment
        # variables defined in the container at all times.
        assert_defined "ISC_PACKAGE_INSTANCENAME"
        assert_defined "ISC_PACKAGE_INSTALLDIR"

        if [ -n "$IRISSYS" ]; then
                test -d "$IRISSYS"
                exit_if_error "If IRISSYS is defined, it must be a valid directory"
        fi

        return 0;
}

assert_defined() {
        [[ -z "${!1}" ]] && echo "Environment variable $1 not set" && exit 1
}

exit_if_error() {
        if [ $(($(echo "${PIPESTATUS[@]}" | tr -s ' ' +))) -ne 0 ]; then
                error "$1"
                exit 1
        fi
}

error() {
        printf "%s Error: $1\n" $(date '+%Y%m%d-%H:%M:%S:%N')

        return 0;
}

# If IRIS is up, we bring it down and verify this.
# If IRIS is already down, this will be very fast.
ensure_iris_stopped() {
        assert_defined "ISC_PACKAGE_INSTANCENAME"
        assert_defined "ISC_PACKAGE_INSTALLDIR"

        iris stop "$ISC_PACKAGE_INSTANCENAME" quietly "$1"
        exit_if_error "Could not stop $ISC_PACKAGE_INSTANCENAME"
        "$ISC_PACKAGE_INSTALLDIR"/dev/Cloud/ICM/waitISC.sh "$ISC_PACKAGE_INSTANCENAME" 60 "down"
        exit_if_error "Could not stop $ISC_PACKAGE_INSTANCENAME"

        return 0;
}

# Start IRIS in single-user mode.
start_iris_single_user() {
        assert_defined "ISC_PACKAGE_INSTANCENAME"
        assert_defined "ISC_PACKAGE_INSTALLDIR"

        iris start "$ISC_PACKAGE_INSTANCENAME" nostu
        "$ISC_PACKAGE_INSTALLDIR"/dev/Cloud/ICM/waitISC.sh "$ISC_PACKAGE_INSTANCENAME" 60 "sign-on inhibited"
        exit_if_error "Could not start $ISC_PACKAGE_INSTANCENAME in single-user mode"

        return 0;
}

# Stop IRIS when it is in single-user mode.
ensure_iris_stopped_single_user() {
        ensure_iris_stopped "bypass"

        return 0;
}

# Run ObjectScript in single-user mode.  We will always start in %SYS,
# and not all system features will be available.
runObjectScriptSingleUser() {
        assert_defined "ISC_PACKAGE_INSTANCENAME"

        echo "$1" | iris session "$ISC_PACKAGE_INSTANCENAME" -B
        exit_if_error "\nObjectScript payload failed!  Payload was:\n$1"

        return 0;
}

runObjectScriptOnNS() {
        assert_defined "ISC_PACKAGE_INSTANCENAME"

        printf "s tSC=1 try { $1 } catch (e) { s tSC=e.AsStatus() } If \$System.Status.IsError(tSC) { Do \$System.Status.DisplayError(tSC) Do \$zu(4,\$j,1) w !! } Halt" | iris session "$ISC_PACKAGE_INSTANCENAME" -U$2
        exit_if_error "\nObjectScript payload failed!  Payload was:\n$1"

        return 0;
}

# Remove WIJ and journals
# These files are necessary for normal operation and durability, but if the
# system has stopped properly then we have no need of them and can remove
# them safely.
remove_WIJ() {
        assert_defined "ISC_PACKAGE_INSTALLDIR"

        # We don't rm with -f here, because this function should only be called
        # when there is a WIJ to remove.
        rm "$ISC_PACKAGE_INSTALLDIR"/mgr/IRIS.WIJ
        exit_if_error "Could not remove WIJ"

        return 0;
}

remove_logs() {
    assert_defined "ISC_PACKAGE_INSTALLDIR"

    rm -f $ISC_PACKAGE_INSTALLDIR/mgr/journal.log
    exit_if_error "Could not remove journal.log"

    rm -f $ISC_PACKAGE_INSTALLDIR/mgr/alerts.log
    exit_if_error "Could not remove alerts.log"

    rm -f $ISC_PACKAGE_INSTALLDIR/mgr/messages.log
    exit_if_error "Could not remove messages.log"
}

remove_iris_ids() {
    assert_defined "ISC_PACKAGE_INSTALLDIR"

    rm -f $ISC_PACKAGE_INSTALLDIR/mgr/iris.ids
    exit_if_error "Could not remove iris.ids"
}

remove_journals() {
        assert_defined "ISC_PACKAGE_INSTALLDIR"

        # Journal files will not exist if we've only run in single-user mode,
        # and this is okay, so we rm with -f
        rm -f "$ISC_PACKAGE_INSTALLDIR"/mgr/journal/*
        exit_if_error "Could not remove journal files"

        return 0;
}

configure_iris() {
    assert_defined "ISC_PACKAGE_INSTALLDIR"
    assert_defined "IRIS_GLOBAL_BUFFERS"
    assert_defined "IRIS_ROUTINE_BUFFERS"

    printf "\n Configuring global buffers..."
    sed -i "s/globals=.*/globals=0,0,$IRIS_GLOBAL_BUFFERS,0,0,0/" "$ISC_PACKAGE_INSTALLDIR"/iris.cpf
    exit_if_error "Could not configure global buffers."

    printf "\n Configuring routine buffers..."
    sed -i "s/routines=.*/routines=$IRIS_ROUTINE_BUFFERS/" "$ISC_PACKAGE_INSTALLDIR"/iris.cpf
    exit_if_error "Could not configure routine buffers."

    # The sed commands above change the permissions on the iris.cpf from irisowner:irisuser 664
    # to irisowner:irisowner 664. When that is the case, IRIS cannot start up because it runs
    # as irisuser which no longer has write permissions on the iris.cpf file
    chmod 666 "$ISC_PACKAGE_INSTALLDIR"/iris.cpf
    exit_if_error "Could not reset permissions to iris.cpf after configuring buffers."

        return 0;
}

configure_demo_user_password() {
    printf "\nConfiguring default users with password 'sys'...\n"
    echo "sys" >> /tmp/pwd.isc
    "$ISC_PACKAGE_INSTALLDIR"/dev/Container/changePassword.sh /tmp/pwd.isc
}

disable_user_passwords_expirations() {
    printf "\nDisable user password expirations...\n"
    ObjectScript='Do ##class(Security.Users).UnExpireUserPasswords("*")'
        runObjectScriptOnNS "$ObjectScript" "%SYS"
        return 0;
}

configure_alternate_journal() {
    assert_defined "ISC_PACKAGE_INSTALLDIR"

    printf "\n Configuring alternate journal directory..."
    sed -i "s/AlternateDirectory=.*/AlternateDirectory=\/usr\/irissys\/mgr\/journal2\//" "$ISC_PACKAGE_INSTALLDIR"/iris.cpf
    exit_if_error "Could not configure alternate journal file."

    # The sed commands above change the permissions on the iris.cpf from irisowner:irisuser 664
    # to irisowner:irisowner 664. When that is the case, IRIS cannot start up because it runs
    # as irisuser which no longer has write permissions on the iris.cpf file
    chmod 666 "$ISC_PACKAGE_INSTALLDIR"/iris.cpf
    exit_if_error "Could not reset permissions of iris.cpf after configuring journal file."

    mkdir "$ISC_PACKAGE_INSTALLDIR"/journal2/
    exit_if_error "Could not create alternate journal directory."

    chown $ISC_PACKAGE_MGRGROUP:$ISC_PACKAGE_MGRUSER "$ISC_PACKAGE_INSTALLDIR"/journal2
    exit_if_error "Could not set ownership of alternate journal directory."

    chmod g+w "$ISC_PACKAGE_INSTALLDIR"/journal2
    exit_if_error "Could not set permissions of alternate journal directory."

        return 0;
}

load_and_run_base_installer() {
    printf "\nLoading base installer...\n"
    ObjectScript='Set tSC=$System.OBJ.Load("/tmp/iris_project/IRISConfig/InstallerBase.cls","ck")'
        runObjectScriptOnNS "$ObjectScript" "%SYS"
        return 0;
}

load_and_run_installer() {
        printf "\n\nLoading Installer..."
    ObjectScript='Set tSC=$System.OBJ.Load("/tmp/iris_project/IRISConfig/Installer.cls","ck")'
        runObjectScriptOnNS "$ObjectScript" "%SYS"

    # Removing Eclipse/Atelier files so that when we try to load our project we don't get the
    # following error:
    # ERROR #5840: Unable to import file '/tmp/iris_project/.buildpath' as this is not a supported type.ERROR: Service 'twittersrv' failed to build: The command '/bin/sh -c /usr/irissys/demo/irisdemoinstaller.sh' returned a non-zero code: 1
    rm -f /tmp/iris_project/.buildpath
    rm -f /tmp/iris_project/.project
    rm -rf /tmp/iris_project/.settings

    printf "\n\nRunning Installer..."
    ObjectScript='Do ##class(IRISConfig.Installer).Install()'
        runObjectScriptOnNS "$ObjectScript" "%SYS"

    rm -rf /tmp/iris_project

        return 0;
}

# The touch command is necessary so we will bring the IRIS.DAT database files to our
# R/W layer and all the IRIS processes will get the same file descriptor to
# this file. That was necessary because some times, when compiling large groups
# of classes, IRIS will spawn parallel processes to speed up the compilation. Some
# of these processes would crash or dead-lock situations would occur because they would
# have the wrong file descriptor to the IRIS.DAT file (the one that is read-only).
prepare_databases_for_writing() {
        if [ -d $ISC_PACKAGE_INSTALLDIR/mgr/$IRIS_APP_NAME ]
        then
                touch $ISC_PACKAGE_INSTALLDIR/mgr/$IRIS_APP_NAME/IRIS.DAT
        fi
        touch $ISC_PACKAGE_INSTALLDIR/mgr/irislib/IRIS.DAT
}

clean_up() {
        # Make sure IRIS is down.
        ensure_iris_stopped;

        # Bring IRIS up in single-user mode.  This will allow us to open
        # an IRIS session without requiring us to encode a password here.
        # Not all features are available in this mode, but it is suitable
        # for most maintenance tasks.
        start_iris_single_user;

        # Tell SYS.Container whether or not to terminate on error. Syntax errors
        # or ObjectScript functions failing does not alter the exit code of an
        # "iris session" process, but SYS.Container will exit(1), unless it is
        # told to continue on error.
        # Useful for figuring out *if* something went wrong.
        # The default is to terminate.  Set this variable to 1 to change that.
        #export SYS_CONTAINER_CONTINUE_ON_ERROR=1

        # Tell SYS.Container whether or not to print errors.
        # Useful for figuring out *what* went wrong.
        # The default is to print errors.  Set this variable to 1 to change that.
        #export SYS_CONTAINER_QUIET=1

    # This entire block is being disabled because we don't want our password reset
    # We will be calling the individual functions on QuiesceForBundling(), except for ForcePasswordChange()
        # Run routine or class method in %SYS.
        # Note that this is equivalent to a copy/paste into an iris session prompt,
        # which does not allow blocks which span multiple lines.
        # If your ObjectScript does not include SYS.Container methods, you are
        # responsible for setting your own exit code.
        # ObjectScript='do ##class(SYS.Container).QuiesceForBundling() halt'
        # runObjectScriptSingleUser "$ObjectScript"

        ObjectScript='kill ^SYS("NODE") kill ^%SYS("JOURNAL") halt'
        runObjectScriptSingleUser "$ObjectScript"

        # Bring the system down cleanly
        ensure_iris_stopped_single_user;

        # Some files are needed for durability guarantees when the system is
        # operating, but if we know we've stopped cleanly, they're unnecesary.
        # Removing them reduces the size of our Docker image.
        remove_WIJ;
        remove_journals;
    remove_iris_ids;
    remove_logs;

        return 0;
}

# Make sure we have environment variables we need.
precondition_checks;