#!/bin/bash
set -e

TF_OUTPUT=$(terraform output -json)

frontend_ip=$(echo "$TF_OUTPUT" | jq -r '.frontend_public_ip.value')
bastion_ip=$(echo "$TF_OUTPUT" | jq -r '.bastion_public_ip.value')
backend_ip=$(echo "$TF_OUTPUT" | jq -r '.backend_private_ip.value')
db_endpoint=$(echo "$TF_OUTPUT" | jq -r '.db_endpoint.value' | cut -d':' -f1 )
s3_name=$(echo "$TF_OUTPUT" | jq -r '.s3_bucket_name.value')
db_password=$(echo "$TF_OUTPUT" | jq -r '.db_password.value')

echo "$TF_OUTPUT" | jq -r '.key_pair_private_key.value' | sed '/^$/d' > deployer-key.pem
chmod 600 deployer-key.pem

aws s3 cp ./app s3://$s3_name/ --recursive

cat <<EOF > inventory.ini
[frontend]
$frontend_ip ansible_user=ec2-user ansible_connection=ssh ansible_ssh_private_key_file=deployer-key.pem

[backend]
$backend_ip ansible_user=ec2-user ansible_connection=ssh ansible_ssh_private_key_file=deployer-key.pem ansible_ssh_common_args='-o ProxyCommand="ssh -i deployer-key.pem -o StrictHostKeyChecking=no -W %h:%p -q ec2-user@$bastion_ip"'

[backend:vars]
db_endpoint=$db_endpoint
db_password=$db_password
s3_name=$s3_name
EOF
