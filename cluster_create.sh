set -e
cd infra
export YC_TOKEN=$(yc iam create-token)
export KUBECTL_CONFIG_PATH="../deploy/ansible/kubernetes/files/config"
TF_IN_AUTOMATION=1 terraform init
TF_IN_AUTOMATION=1 terraform apply -auto-approve
echo "srv ansible_host=$(terraform output external_ip_address_srv) ansible_user=debian ansible_ssh_private_key_file"=~/.ssh/id_rsa > ../deploy/ansible/host
rm $KUBECTL_CONFIG_PATH | true
kubectl config unset contexts.yc-k8s-zonal | true
yc managed-kubernetes cluster get-credentials k8s-zonal --external | true
kubectl create -f sa.yaml | true
yc managed-kubernetes cluster get k8s-zonal --format json |   jq -r .master.master_auth.cluster_ca_certificate | awk '{gsub(/\\n/,"\n")}1' > ../deploy/ansible/kubernetes/files/ca.pem
kubectl create -f sa.yaml | true
export SA_TOKEN=$(kubectl -n kube-system get secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}') -o json | jq -r .data.token | base64 --d)
export MASTER_ENDPOINT=$(yc managed-kubernetes cluster get k8s-zonal --format json | jq -r .master.endpoints.external_v4_endpoint)
kubectl config set-cluster k8s-zonal --certificate-authority=/home/jenkins/.kube/ca.pem --server=$MASTER_ENDPOINT --kubeconfig=$KUBECTL_CONFIG_PATH
kubectl config set-credentials admin-user --token=$SA_TOKEN --kubeconfig=$KUBECTL_CONFIG_PATH
kubectl config set-context default --cluster=k8s-zonal --user=admin-user --kubeconfig=$KUBECTL_CONFIG_PATH
kubectl config use-context default --kubeconfig=$KUBECTL_CONFIG_PATH

cd ../deploy/ansible
ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook srv.yml -i host

cd ../../infra
echo "Agent IP: $(terraform output external_ip_address_srv)"