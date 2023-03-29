set -e
cd infra
export YC_TOKEN=$(yc iam create-token)
TF_IN_AUTOMATION=1 terraform init
TF_IN_AUTOMATION=1 terraform apply -auto-approve
echo "srv ansible_host=$(terraform output external_ip_address_srv) ansible_user=debian ansible_ssh_private_key_file"=~/.ssh/id_rsa > ../deploy/ansible/host
rm ../deploy/ansible/kubernetes/files/config
yc managed-kubernetes cluster  get-credentials k8s-zonal --external --kubeconfig ../deploy/ansible/kubernetes/files/config
cd ../deploy/ansible
ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook srv.yml -i host