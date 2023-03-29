set -e
cd infra
export YC_TOKEN=$(yc iam create-token)
TF_IN_AUTOMATION=1 terraform init
TF_IN_AUTOMATION=1 terraform apply -destroy -auto-approve
