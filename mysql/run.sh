#!/bin/bash

SCRIPT_PATH=$(readlink -f "$0")
DIRECTORY_PATH=$(dirname "${SCRIPT_PATH}")

function init_configuration()
{
    echo "Init Mysql conf";

    CONFIG_FILE="${DIRECTORY_PATH}/extra/my.cnf"
    if [[ -e "${CONFIG_FILE}" ]]; then
        cp -f "${CONFIG_FILE}" /etc/mysql/conf.d/custom.cnf
        echo "File \"${CONFIG_FILE}\" successfully imported."
    fi
}

function start_mysql()
{
    mysqld --user=root &
    PROCESS_ID=$!

    echo "Waiting MySQL..."

    until mysqladmin ping &> /dev/null; do
        sleep 1
    done

    echo "MySQL is alive."
}

function init_databases()
{
    echo "Init databases";

    EXTRA_PATH="${DIRECTORY_PATH}/extra"
    if [[ -d "${EXTRA_PATH}" ]]; then
        DATABASES_FILES="$(find "${EXTRA_PATH}" -maxdepth 1 -type f -name *.sql | sort)"
        if [[ ! -z "${DATABASES_FILES}" ]]; then
            for FILE in ${DATABASES_FILES}; do
                FILENAME="$(basename "${FILE}")"

                IMPORT_OUTPUT="$(mysql -u root -p${MYSQL_ROOT_PASSWORD} < "${FILE}" 2>&1)"
                if [[ ! -z "${IMPORT_OUTPUT}" ]]; then
                    echo "An error occured during the \"${FILENAME}\" import. ${IMPORT_OUTPUT}."
                else
                    echo "File \"${FILENAME}\" successfully imported."
                fi

                rm "${FILE}"
                service mysql reload
            done
        fi
    fi
}

LOCK_FILE="/var/docker.lock"
if [[ ! -e "${LOCK_FILE}" ]]; then
    cp /docker-entrypoint.sh /docker-entrypoint-custom.sh
    sed -i -e "s|exec \"\$@\"|#exec \"\$@\"|g" /docker-entrypoint-custom.sh
    rm -rf /var/run/mysqld/*
    chgrp mysql /var/run/mysqld/
    chmod g+w /var/run/mysqld/
    /bin/bash /docker-entrypoint-custom.sh mysqld --user=root

    init_configuration
    start_mysql
    init_databases
    touch "${LOCK_FILE}"
    wait "${PROCESS_ID}"
else
    rm -rf /var/run/mysqld/*
    chgrp mysql /var/run/mysqld/
    chmod g+w /var/run/mysqld/
    /bin/bash /docker-entrypoint.sh mysqld --user=root
fi
