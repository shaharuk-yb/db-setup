#!/bin/bash

Helper () {
  echo
  echo "---------------------------COCKROACHDB SETUP HELP--------------------------------"
  echo "This script is used to manage the operations related to the COCKROACHDB cluster"
  echo
  echo "Syntax: manage.sh [deploy|destroy|start|stop|restart|soft_destroy] [hostile]"
  echo
  echo "hostfile default is ./hostfiles/inventory"
  echo
  echo "Options: "
  echo "deploy        sets up pre-requisites, installs starts cockroachdb cluster and creates db yb_demo with tables"
  echo "destroy       remove everything"
  echo "soft_destroy  removes everything except installation files "
  echo "start         start the existing cockroachdb cluster"
  echo "stop          stop the existing cockroachdb cluster"
  echo "restart       restart the existing cockroachdb cluster"
  echo "chaos         kill random machine processes for few minutes and restart them"
  echo
  echo "-------------------------------------------------------------------------------"
}

if [ $1 != "chaos" ] && [ -z $2 ]; then
  echo "---------------------------------------------------------------------------------"
  echo "        NO <hostfile> PROVIDED, USING DEFAULT: ./hostfiles/inventory"
  echo "---------------------------------------------------------------------------------"
fi

HOSTFILE=./inventory
PEM=${2:-~/.yugabyte/<key.pem>}

case $1 in
  deploy)
    echo "------------------------ Deploying new cluster --------------------------------"
    ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook ./main.yml -i ${HOSTFILE} --private-key ${PEM}
    ;;
  destroy)
    echo "------------------------ Destroying the cluster -------------------------------"
    ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook ./manage_cdb.yml -i ${HOSTFILE} -e destroy=true --private-key ${PEM}
    ;;
  stop)
    echo "------------------------ Stopping the cluster ---------------------------------"
    ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook ./manage_cdb.yml -i ${HOSTFILE} -e stop=true --private-key ${PEM}
    ;;
  start)
    echo "------------------------ Starting the cluster ---------------------------------"
    ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook ./manage_cdb.yml -i ${HOSTFILE} -e start=true --private-key ${PEM}
    ;;
  restart)
    echo "------------------------ Stopping and restarting the cluster -------------------"
    ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook ./manage_cdb.yml -i ${HOSTFILE} -e restart=true --private-key ${PEM}
    ;;
  soft_destroy)
    echo "------------------------------- soft_destroy the cluster -------------------------"
    ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook ./manage_cdb.yml -i ${HOSTFILE} -e soft_destroy=true --private-key ${PEM}
    ;;
  chaos)
    for i in {1..10}
    do
      echo "-------------------------------------------------------------------------------"
      echo "                Iteration $i started: Killing random node"
      echo "-------------------------------------------------------------------------------"
      ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook ./manage_cdb.yml -i ${HOSTFILE} -e chaos=true --private-key ${PEM}
      echo "-------------------------------------------------------------------------------"
      echo "                Iteration $i complete: The node is back up again"
      echo "-------------------------------------------------------------------------------"
    done
    echo "************** CHAOS iterations complete, all nodes should be up ****************"
    ;;
  *)
    echo
    echo "INVALID OPTION. Please provide one of the allowed options."
    Helper
    ;;
esac
