#!/bin/bash
# Diagnostic script to check pool infrastructure configuration

available_cardano_node_version () {
  local version="$(curl -s https://api.github.com/repos/input-output-hk/cardano-node/releases/latest \
    | jq -r .tag_name | grep -oP "[\d.]+")"
  echo $version
}

installed_cardano_node_version () {
  local version="$(cardano-cli --version \
    | grep -oP "cardano-cli ([\d.]+)" \
    | cut -d " " -f2)"
  echo $version
}

ram_size () {
    local ramsize="$(free | grep -oP "Mem: +\d+"| tr -d -c 0-9)"
    echo $ramsize
}

number_cpu_cores () {
    # with hyper threading
    # grep ^cpu\\scores /proc/cpuinfo | uniq |  awk '{print $4}' 
    local ncpus="$(grep -c ^processor /proc/cpuinfo)"
    echo $ncpus
}

ssh_port () {
   local sshport="$(grep -P "^Port" /etc/ssh/sshd_config | tr -d -c 0-9)"
   echo $sshport
}

if [ $(available_cardano_node_version) == $(installed_cardano_node_version) ]
then
    echo "cardano-node up-to-date:"
else
    echo "cardano-node update available:"
fi

# Check installed cardano-node version
echo -e "\tinstalled version: $(installed_cardano_node_version)"

# Check latest available cardano-node version
echo -e "\tAvailable version: $(available_cardano_node_version)"

## Check system requirements
echo "Available RAM: $(ram_size)"
echo "Available CPU cores: $(number_cpu_cores)"

## Check Security
echo "SSH port: $(ssh_port)"

