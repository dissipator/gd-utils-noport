# okteto 使用
## 安装kubenetes和okteto
这一步主要用于配置好本地环境和必要的软件，首先在自身目录下创建配置文件

### 配置环境变量
将配置export到环境，也就是

export KUBECONFIG=$HOME//okteto_kube.conf

这里建议将其加入到主shell文件，这里以bash为例，
```
echo "export KUBECONFIG=$HOME/.okteto_kube.conf" >> ~/.bashrc
```
### 安装kubectl和okteto软件
首先是kubernetes管理客户端软件kubectl（该应用与kubernetes master节点api进行交互，后续所有应用都是通过该软件进行操作）
```
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
```
其次是安装okteto的cli客户端，这个主要用于在本地部署应用的时候，可以让kubernetes应用随着本地文件的改变实时更新，我并没有使用到。

安装代码
```
curl https://get.okteto.com -sSfL | sh
```
软件安装好之后，接下来测试kubernetes集群连接情况，这里直接使用一个python的示例来进行测试。

```
okteto init
cat>okteto.yml<<EOF
name: gdbot
image: okteto/gdbot:14
command:
- /start.sh
workdir: /
forward:
- 80:80
EOF
okteto build -t registry.cloud.okteto.net/dissipator/gdbot:14 .
okteto build
kubectl apply -f k8s.yml
kubectl get pods
okteto up
okteto down
```
