apt update
apt install -y apt-transport-https ca-certificates curl software-properties-common
#docker源
curl -fsSL http://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] http://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable"

#kubeadm源
curl https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main
EOF

#安装docker、kubeadm以及k8s中不会通过docker容器部署的组件
apt update
apt install -y docker-ce kubeadm kubelet kubectl

cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "registry-mirrors": ["https://alzgoonw.mirror.aliyuncs.com","http://hub-mirror.c.163.com"]
}
EOF
systemctl daemon-reload
systemctl restart docker


## close swap /etc/fstab
reboot
