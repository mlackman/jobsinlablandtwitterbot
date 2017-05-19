ssh -t ubuntu-twitter "rm -rf /tmp/puppets && rm /tmp/puppets.zip"
ssh -t ubuntu-twitter "mkdir /tmp/puppets"
zip -r puppets.zip .
scp puppets.zip ubuntu-twitter:/tmp
ssh -t ubuntu-twitter "cd /tmp && unzip -o puppets.zip -d puppets && cd puppets && sudo puppet apply --modulepath /etc/puppet/modules:/tmp/puppets/:/tmp/puppets/modules/ manifests/site.pp"
rm puppets.zip

