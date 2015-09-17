
#!/bin/bash
dir=${0%/*}

red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`

# Description: sends the message to the standard output
# parameters: $@ string to be appended in the log file
logger.log_it() { echo "$@"; }

# Description: logs the message in the standard output and returns 0
# parameters: $@ whatever is passed to be logged
success() { logger.log_it "$@"; return 0; }

# Description: logs the message in the standard output and returns 1
# parameters: $@ whatever is passed to be logged
failure() { logger.log_it "$@"; return 1; }

# Description: verifies if the command passed as argument exists in 0
# parameters: $@ shell commands to be called
assertions.verify_command() {
  eval "$@" > /dev/null
  if [ $? -eq 0 ]; then
    success "${green}[Command OK] ------: $@"
  else
    failure "${red}[Command FAIL] ----: $@"
  fi
}

reference=$1
version=$2

assertions.verify_command vagrant --version
if [ $? -ne 0 ]; then
  printf "${red} looks like you don't have Vagrant available, please follow this instructions: \n http://docs.vagrantup.com/v2/installation/index.html"
  exit 1
fi

assertions.verify_command ansible --version
if [ $? -ne 0 ]; then
  printf "${red} looks like you don't have Ansible available, please follow this instructions: \n http://docs.ansible.com/ansible/intro_installation.html"
  exit 1
fi

assertions.verify_command vagrant up subunit_box

if [ -z $reference ] || [ -z $version ]; then
  printf "\n\n${yellow}INFO: arguments not suplied (reference or version) \nif you want to clone an specific patch please suply the reference and the version like this: \n${yellow}'bash deploy.sh refs/changes/81/213481/11 FETCH_HEAD'"
  printf "\n\n ${green} *** cloning from Master ***\n"
  ANSIBLE_FORCE_COLOR=true ANSIBLE_HOST_KEY_CHECKING=false PYTHONUNBUFFERED=1 ansible-playbook --private-key=/home/juraci/.vagrant.d/insecure_private_key --user=vagrant --inventory-file=hosts -e "ansible_ssh_user=vagrant" --sudo -v --limit='subunit-box' subunit_servers.yaml
else
  printf "\n\n *** ${yellow} cloning from reference ${reference} and version ${version} *** ${green}"
  ANSIBLE_FORCE_COLOR=true ANSIBLE_HOST_KEY_CHECKING=false PYTHONUNBUFFERED=1 ansible-playbook --private-key=/home/juraci/.vagrant.d/insecure_private_key --user=vagrant --inventory-file=hosts -e "ansible_ssh_user=vagrant" -e "reference=$reference" -e "version=$version" --sudo -v --limit='subunit-box' subunit_servers.yaml
fi

