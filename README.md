# warp_proxy
HTTP proxy container with IPv6 tunnel support which easy to deploy

# How to install
Any Linux machine will suit in.

Install docker and git
```bash
sudo apt update
# uninstall old docker packages
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
sudo apt install ca-certificates curl git
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin git
```
download warp_proxy
```bash
git clone https://github.com/sb0y/warp_proxy.git
```
Go to warp_proxy directory

```bash
cd warp_proxy
```
Run service

```bash
sudo docker compose up -d
```
Check logs

```bash
sudo docker compose logs warp_proxy
```

# How to test
```bash
curl https://ifconfig.me -U warp_proxy:changeme --proxy '127.0.0.1:3129'
```
if you have IPv6 in your system you may use
```bash
curl https://ifconfig.me -U warp_proxy:changeme --proxy '[::1]:3129'
```
