FROM ubuntu:22.04

LABEL name="cdm-vcontainer" \
      maintainers="Cuong. Duong Manh" \
      email="cuongdm8499@gmail.com"
      
RUN apt update && apt install -y traceroute tmux make telnet git dnsutils curl wget vim && \
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    wget https://get.helm.sh/helm-v3.9.3-linux-amd64.tar.gz && tar xvf helm-v3.9.3-linux-amd64.tar.gz && \
    mv linux-amd64/helm /usr/local/bin && rm helm-v3.9.3-linux-amd64.tar.gz && \
    rm -rf linux-amd64 && \
    wget https://github.com/vmware-archive/octant/releases/download/v0.25.1/octant_0.25.1_Linux-64bit.deb && \
    dpkg -i octant_0.25.1_Linux-64bit.deb && rm octant_0.25.1_Linux-64bit.deb && \
    apt clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    mkdir -p ~/.kube && touch ~/.kube/config && \
    chmod o-r ~/.kube/config && chmod g-r ~/.kube/config && \
    wget -O kubecolor.tar.gz https://github.com/hidetatz/kubecolor/releases/download/v0.0.25/kubecolor_0.0.25_Linux_x86_64.tar.gz && \
    tar -xzvf kubecolor.tar.gz && \
    mv kubecolor /usr/local/bin/ && \
    rm -rf kubecolor.tar.gz && \
    echo "alias k=kubecolor" >> ~/.bashrc && \
    curl -LO https://github.com/kvaps/kubectl-node-shell/raw/master/kubectl-node_shell && \
    chmod +x ./kubectl-node_shell && \
    mv ./kubectl-node_shell /usr/local/bin/kubectl-node_shell

CMD ["/bin/bash"]

