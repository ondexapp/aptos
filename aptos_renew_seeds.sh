#!/bin/bash
echo "=================================================="
echo -e "\033[0;35m"
echo "       ___           ___          _____          ___           ___     ";
echo "      /  /\         /__/\        /  /::\        /  /\         /__/|    ";
echo "     /  /::\        \  \:\      /  /:/\:\      /  /:/_       |  |:|    ";
echo "    /  /:/\:\        \  \:\    /  /:/  \:\    /  /:/ /\      |  |:|    ";
echo "   /  /:/  \:\   _____\__\:\  /__/:/ \__\:|  /  /:/ /:/_   __|__|:|    ";
echo "  /__/:/ \__\:\ /__/::::::::\ \  \:\ /  /:/ /__/:/ /:/ /\ /__/::::\____";
echo "  \  \:\ /  /:/ \  \:\~~\~~\/  \  \:\  /:/  \  \:\/:/ /:/    ~\~~\::::/";
echo "   \  \:\  /:/   \  \:\  ~~~    \  \:\/:/    \  \::/ /:/      |~~|:|~~ ";
echo "    \  \:\/:/     \  \:\         \  \::/      \  \:\/:/       |  |:|   ";
echo "     \  \::/       \  \:\         \__\/        \  \::/        |  |:|   ";
echo "      \__\/         \__\/                       \__\/         |__|/    ";
echo -e "\e[0m"
echo "=================================================="

sleep 2

echo -e "\e[1m\e[32m1. Updating list of dependencies... \e[0m" && sleep 1
sudo apt-get update
# Installing yq to modify yaml files
sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
sudo chmod a+x /usr/local/bin/yq
cd $HOME/aptos

echo "=================================================="

echo -e "\e[1m\e[32m2. Download list of active seeds... \e[0m" && sleep 1
wget -P $HOME/aptos https://raw.githubusercontent.com/ondexapp/aptos/main/seeds.yml

echo "=================================================="

echo -e "\e[1m\e[32m3. Updating lists of seeds ... \e[0m" && sleep 1

/usr/local/bin/yq ea -i 'select(fileIndex==0).full_node_networks[0].seeds = select(fileIndex==1).seeds | select(fileIndex==0)' $HOME/aptos/public_full_node.yaml $HOME/aptos/seeds.yaml
rm $HOME/aptos/seeds.yaml
echo "=================================================="

echo -e "\e[1m\e[32m4. Restart aptos node ... \e[0m" && sleep 1

# If node was installed as docker service
sudo docker compose restart &> /dev/null

# If node was installed as systemctl services
sudo systemctl restart aptos-fullnode.service &> /dev/null
