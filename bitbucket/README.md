# Use your SSH keys to authenticate to BitBucket (gitscm.cisco.com)

- It checks if your SSH keys are already configured in BitBucket. If it is, it does not do anything
- If it is not configured, it checks if you already have SSH keys (`id_rsa` and `id_rsa.pub`) in your `~/.ssh/` folder
    + If you already have SSH keys (`~/.ssh/id_rsa` and `~/.ssh/id_rsa.pub`), it adds the public key (`~/.ssh/id_rsa.pub`) to BitBucket
    + If you do not have SSH keys (`~/.ssh/id_rsa` and `~/.ssh/id_rsa.pub`), it will create SSH keys and then add the public key (`~/.ssh/id_rsa.pub`) to BitBucket