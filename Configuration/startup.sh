#!/bin/bash

# Exit with error if a command returns a non-zero status
set -e

DEFAULT_WWW_USER="guest"
DEFAULT_WWW_USER_ID="1000"

# Update system user if defined differently
if [ "${WWW_USER}" != "${DEFAULT_WWW_USER}" ]; then
	echo "Rename user \"${DEFAULT_WWW_USER}\" to \"${WWW_USER}\"!"
	usermod -d /home/${WWW_USER} -l ${WWW_USER} ${DEFAULT_WWW_USER}
	groupmod -n ${WWW_USER} ${DEFAULT_WWW_USER}
fi

# Update uid of system user if defined differently
if [ "${WWW_USER_ID}" != "${DEFAULT_WWW_USER_ID}" ]; then
	echo "Update \"${WWW_USER}\" user and group ID to \"${WWW_USER_ID}\"!"
	usermod --uid ${WWW_USER_ID} ${WWW_USER}
	groupmod --gid ${WWW_USER_ID} ${WWW_USER}
fi

# Run normal command
exec "$@"
