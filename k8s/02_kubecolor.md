# Install `kubecolor` to make your `kubectl` feel better
<hr>

# 1. Pre-requisites
- Ubuntu machine 22.04 LTS.

# 2. Installation
- Prepare a `run.sh` file with rhe below content:
  ```sh
  #!/bin/bash

  apt update -y
  apt install wget -y

  wget -O kubecolor.tar.gz https://github.com/hidetatz/kubecolor/releases/download/v0.0.25/kubecolor_0.0.25_Linux_x86_64.tar.gz

  tar -xzvf kubecolor.tar.gz
  mv kubecolor /usr/local/bin/
  ```

- Now, you MUST allow execute permission for the `run.sh` file:
  ```sh
  chmod +x run.sh
  ```

- Run the `run.sh` file:
  ```sh
  ./run.sh
  ```

- Alias `kubectl` to `kubecolor`:
  ```bash
  echo alias kubectl='kubecolor' >> ~/.bashrc
  
  # Or if you like this style like me:
  echo alias k='kubecolor' >> ~/.bashrc

  source ~/.bashrc
  ```