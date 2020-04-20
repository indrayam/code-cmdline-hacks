#!/bin/bash

# Bash function to setup SSH key pair files in BitBucket
function configure_ssh_keys () {
    SSHKEY_PUB_CONTENT=`cat $SSHKEY_PUB`
    echo "SSH Public Key:"
    echo "$SSHKEY_PUB_CONTENT"

    # Create BitBucket API payload
    PAYLOAD_FILE="/tmp/a.json"
    cat > $PAYLOAD_FILE <<- EOF
    {
        "text": "$SSHKEY_PUB_CONTENT"
    }
EOF
    API_PAYLOAD_CONTENT=`cat $PAYLOAD_FILE`
    echo "API Payload Content:"
    echo "$API_PAYLOAD_CONTENT"

    # Upload the key to BitBucket
    read -p "CEC ID: " CECID
    read -sp "CEC Password: " CECPASSWD
    GIT_API_URL="https://gitscm.cisco.com/rest/ssh/1.0/keys?user=$CECID"
    echo "Ready to upload the SSH Public Key to BitBucket..."
    curl --user "$CECID:$CECPASSWD" -H "Content-Type: application/json" --data @${PAYLOAD_FILE} -X POST ${GIT_API_URL}
}


# Define variables related to SSH key pair files
echo "Using $HOME to look for SSH keypair files"
SSHKEY="${HOME}/.ssh/id_rsa"
echo "Private key file name set to $SSHKEY"
SSHKEY_PUB="${SSHKEY}.pub"
echo "Public key file name set to $SSHKEY_PUB"

# Check if the user's SSH key is already configured in our BitBucket server (gitscm.cisco.com)
ssh -v git@gitscm.cisco.com 2>&1 | grep -i succeeded
GIT_STATUS=`echo $?`

# If SSH keys are already configured in BitBucket...
#...If SSH Public Key file exists but not configured in BitBucket
#...If neither
if [[ $GIT_STATUS -eq 0 ]]
then
  echo "Your SSH key pair files are already configured in BitBucket. You're all set!"
elif [[ -f $SSHKEY_PUB ]]
then
    echo "It seems like your SSH key pair files are not configured on BitBucket"
    echo "$SSHKEY_PUB exists"
    configure_ssh_keys
else
    echo "Since you have no $SSHKEY_PUB, you are not setup to use SSH Keys to authenticae on BitBucket.." 
    echo "Creating a SSH key pair.."
    ssh-keygen -q -t rsa -N '' -f ${SSHKEY}
    configure_ssh_keys
fi


