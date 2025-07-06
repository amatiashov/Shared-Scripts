sudo apt update
sudo apt install -y ufw

sudo ufw allow OpenSSH
# Disable ICMP
sed -i '/ufw-before-input.*icmp/s/ACCEPT/DROP/g' /etc/ufw/before.rules
sudo ufw --force enable