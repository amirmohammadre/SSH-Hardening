#!/usr/bin/bash

function sec_conf_SSH()	    {
	
	cp   /etc/ssh/sshd_config   /etc/ssh/sshd_config.bak

	echo "--- (1) Set configuration parameters security for service SSH ---"


	sed -i '/PermitEmptyPasswords/d'  /etc/ssh/sshd_config  
	sed -i '$a\PermitEmptyPasswords no'  /etc/ssh/sshd_config
	echo "[+] Disable SSH Access via Empty Password"


	sed -i '/PermitRootLogin/d'  /etc/ssh/sshd_config   	    
	sed -i '$a\PermitRootLogin no'  /etc/ssh/sshd_config
	echo "[+] Disable SSH Root Login"


	sed -i '/MaxStartups/d'  /etc/ssh/sshd_config   	    
	sed -i '$a\MaxStartups 10:30:60'  /etc/ssh/sshd_config
	echo "[+] Set MaxStartups Parameter"


	sed -i '/MaxSessions/d'  /etc/ssh/sshd_config   	    
	sed -i '$a\MaxSessions 10'  /etc/ssh/sshd_config
	echo "[+] Set MaxSessions Parameter"


	sed -i '/MaxAuthTries/d'  /etc/ssh/sshd_config   	    
	sed -i '$a\MaxAuthTries 4'  /etc/ssh/sshd_config
	echo "[+] Set MaxAuthTries Parameter"


	sed -i '/LogLevel/d'  /etc/ssh/sshd_config   	    
	sed -i '$a\LogLevel INFO'  /etc/ssh/sshd_config
	echo "[+] Set LogLevel to INFO SSH"


	sed -i '/ClientAliveCountMax/d'  /etc/ssh/sshd_config   	    
	sed -i '$a\ClientAliveCountMax 0'  /etc/ssh/sshd_config
	echo "[+] Set SSH Client Alive Count Max to zero"


	sed -i '/X11Forwarding/d'  /etc/ssh/sshd_config   	    
	sed -i '$a\X11Forwarding no'  /etc/ssh/sshd_config
	echo "[+] Disable X11 Forwarding In SSH"


	sed -i '/AllowTcpForwarding/d'  /etc/ssh/sshd_config   	    
	sed -i '$a\AllowTcpForwarding no'  /etc/ssh/sshd_config
	echo "[+] Disable SSH TCP Forwarding"


	sed -i '/ClientAliveInterval/d'  /etc/ssh/sshd_config   	    
	sed -i '$a\ClientAliveInterval 300'  /etc/ssh/sshd_config
	echo "[+] Set SSH Client Alive Interval"


	sed -i '/GSSAPIAuthentication/d'  /etc/ssh/sshd_config   	    
	sed -i '$a\GSSAPIAuthentication no'  /etc/ssh/sshd_config
	echo "[+] Disable GSSAPI Authentication"

	
	sed -i '/Compression/d'  /etc/ssh/sshd_config   	    
	sed -i '$a\Compression no'  /etc/ssh/sshd_config
	echo "[+] Disable Compression"


	sed -i '/IgnoreRhosts/d'  /etc/ssh/sshd_config   	    
	sed -i '$a\IgnoreRhosts yes'  /etc/ssh/sshd_config
	echo "[+] Disable SSH Support For .rhosts Files"


	sed -i '/LoginGraceTime/d'  /etc/ssh/sshd_config   	    
	sed -i '$a\LoginGraceTime 60'  /etc/ssh/sshd_config
	echo "[+] Set LoginGraceTime Parameter"


	sed -i '/PrintLastLog/d'  /etc/ssh/sshd_config   	    
	sed -i '$a\PrintLastLog yes'  /etc/ssh/sshd_config
	echo "[+] Set PrintLastLog Parameter"


	sed -i '/Protocol/d'  /etc/ssh/sshd_config   	    
	sed -i '$a\Protocol 2'  /etc/ssh/sshd_config
	echo "[+] Set Protocol 2 Parameter"


	systemctl reload sshd.service

}

sec_conf_SSH	    

echo 

echo "################################################################"
echo 

read -p "Enter a user for login server by ssh (except of root): " USER
echo

while true; do
	read -p "Enter Password: " -s PASSWORD
	echo 
	read -p "Password (again): " -s PASSWORD2
	echo

	if [ "$PASSWORD" = "$PASSWORD2" ]; then
		if [ -f /etc/debian_version ]; then
			useradd -m -d /home/$USER -s /usr/bin/bash -G sudo $USER
			echo "$USER:$PASSWORD" | chpasswd
			break
		else
			useradd -m -d /home/$USER -s /usr/bin/bash -G wheel $USER
			echo "$USER:$PASSWORD" | chpasswd
			break
		fi
	else
		echo "Passwords do not match. Please try again."
	fi
done

echo

echo "[+] Create $USER Successfully"

sed -i '/AllowUsers/d'  /etc/ssh/sshd_config   	    
sed -i "\$a\AllowUsers $USER"  /etc/ssh/sshd_config
echo "[+] Set Allow User $USER login with ssh"

systemctl restart sshd.service

echo "Done configure SSH service :)"
echo 

