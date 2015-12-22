yum makecache
yum install -y gcc python-devel python-virtualenv libselinux-python
easy_install pip

cd /tmp
virtualenv env --system-site-packages
env/bin/pip install -r /vagrant/requirements.txt
source env/bin/activate

cd /vagrant

if [ ! -f /vagrant/security.yml ]; then
  ./security-setup --enable=false
fi

hostname $1
