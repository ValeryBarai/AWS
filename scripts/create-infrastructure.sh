#!/bin/bash

USER_NAME=user3
instance_type=t2.micro
image_id=ami-02fc24d56bc5f3d67 #ami-09693313102a30b2c
vpc_id=vpc-08b950cd8140c7403
KEY_NAME=user3
SHUTDOWN_TYPE=stop
SUBNET_ID=subnet-060d8c5c243f86664

TAGS="ResourceType=instance,Tags=[{Key=installation_id,Value=${USER_NAME}-1},{Key=Name, Value=NAME}]"

start_vm()
{
  local private_ip_address="$1"
  local public_ip_address="$2"
  local name="$3"
  local user_data="$4"

  local tags=$(echo $TAGS | sed s/NAME/$name/)
  #local tags=$(TAGS/NAME/$name}

  aws ec2 run-instances \
    --image-id "$image_id" \
    --instance-type "$instance_type" \
    --key-name "$KEY_NAME" \
    --subnet-id "$SUBNET_ID" \
    --instance-initiated-shutdown-behavior "$SHUTDOWN_TYPE" \
    --private-ip-address "$private_ip_address" \
    --tag-specifications "$TAGS" \
    --user-data "$user_data" \
    --${public_ip}
}


start()
{
	start_vm 10.1.1.31 accociate-public-ip-address user3-vm1 file://${PWD}/scripts/initial-command.sh
# alternative configuration of file adding  			file://<( initial_command )

# for i in {2..3}; do
#	start_vm 10.1.1.$((30+i)) no-accociate-public-ip-address user3-vm$i
# done
}

stop()
{                                                                               
  ids=($(                                                                       
      aws ec2 describe-instances \
      --query 'Reservations[*].Instances[?KeyName==`'$KEY_NAME'`].InstanceId' \
      --output text                                                               
  ))                                                                            
  aws ec2 terminate-instances --instance-ids "${ids[@]}"                        
			  }     

if [ "$1" = start ]; then
  start
elif [ "$1" = stop ]; then
  stop
else
  cat <<EOF

Usage:

  $0 start|stop
EOF
fi
