**Resources**:
  * **Source code**: [https://github.com/luksa/kubernetes-in-action](https://github.com/luksa/kubernetes-in-action)

# Chap 2. First steps with Docker and K8s
## 2.2. Setting up a K8s cluster
* [Optional] Run the cluster in **KinD**:
  ```bash
  kind create cluster --name k8s-playground --config resources/me/config.yaml

  # verify the installation succeeded
  docker container ls

  minikube start --nodes 2 -p multinode-demo
  ```

* List all clusters in Minikube:
  ```bash
  minikube profile list
  ```
### 2.2.1. Running a local single-node K8s cluster with Minikube
* Installing Minikube using the below command:
  ```bash
  curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/

  # verify the installation succeeded
  minikube version
  ```

* Starting a K8s cluster with Minikube:
  ```bash
  minikube start
  ```
  ![](./img/chap02/01.png)

* Installing Kubectl using the below command:
  ```bash
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && chmod +x kubectl && sudo mv kubectl /usr/local/bin/

  # verify the installation succeeded
  kubectl version --short
  kubectl cluster-info
  ```
  ![](./img/chap02/02.png)
  ![](./img/chap02/03.png)

### 2.2.2. Using a hosted K8s cluster with Google K8s Engine
* Setting up a Google Cloud Project and downloading the necessary client binaries:
  * Following this instruction to get started: [https://cloud.google.com/container-engine/docs/before-you-begin](https://cloud.google.com/container-engine/docs/before-you-begin).
  * After that, you can install `kubectl` tool in `gcloud` by the below command:
    ```bash
    gcloud components install kubectl
    ```
* Creating a K8s cluster with 3-nodes:
  ```bash
  gcloud container clusters create kubia --num-nodes 3 --machine-type f1-micro --zone asia-northeast1-a
  ```

## 2.3. Running our first app on K8s
### 2.3.1. Deplying your Node.js app
* Prepare `manhcuong8499/kubia` image:
  ```bash
  cd resources/me/chap02/kubia
  docker build -t kubia .
  docker tag kubia manhcuong8499/kubia
  docker push manhcuong8499/kubia
  ```

* Deloy kubia app in K8s:
  ```bash
  kubectl run kubia --image=manhcuong8499/kubia --port=8080
  ```

#### 2.3.1.1. Introducing Pods
* Listing all pods in the cluster:
  ```bash
  kubectl get pods
  ```
  ![](./img/chap02/04.png)

* To see more information about the pods, use the `describe` command:
  ```bash
  kubectl describe pod kubia
  ```
  ![](./img/chap02/05.png)

### 2.3.2. Accessing your web application
* Tell K8s expose the `kubia` app to the outside world by creating a service object:
  ```bash
  kubectl expose pod kubia --type=NodePort --name kubia-http
  ```
  ![](./img/chap02/06.png)

* Listing all services in the cluster:
  ```bash
  kubectl get services
  ```
  ![](./img/chap02/07.png)

* Get IP-Address:
  ```bash
  minikube service kubia-http --url
  ```
  ![](./img/chap02/08.png)

* Testing the app:
  ```bash
  curl http://192.168.49.2:30884
  ```
  ![](./img/chap02/09.png)

### 2.3.3. Horizontally scaling the application
* Create kubia service:
  ```bash
  kubectl create deployment kubia --image=manhcuong8499/kubia
  ```
  ![](./img/chap02/10.png)

* Get replication controller:
  ```bash
  kubectl get replicasets
  ```
  ![](./img/chap02/11.png)
  * The `DISIRED` column shows the number of replicas that we want to have.

* To scale up the number of replicas of your pod, you need to change the desired replica count on the replication controller:
  ```bash
  kubectl scale deployment kubia --replicas=3
  ```
  ![](./img/chap02/12.png)

* Verify the number of pods:
  ```bash
  kubectl get all
  ```
  ![](./img/chap02/13.png)

* Get the IP-Address of the service:
  ```bash
  minikube service -p multinode-demo --all
  ```
  ![](./img/chap02/14.png)

* Testing:
  ```bash
  curl <url>
  ```
  ![](./img/chap02/15.png)

# Chapter 3. Pods: running containers in K8s
## 3.1. Creating pods from YAML or JSON descriptors
### 3.1.1. Examining a YAML descriptor of an existing pod
* Three important sections are found in almost all K8s resources:
  * `metadata`: Includes the name, namespace, labels, and other information about the pod.
  * `spec`: Contains the actual description of the pod's contents, such as the pod's containers, volumes, and other data.
  * `status`: Contains the current information about the running pod, such as what condition the pod is in, the description and status of each container, and the pod's internal IP and other basic info.

### 3.1.2. Creating a simple YAML descriptor for a pod
* When you implement a descriptor, you can use the `kubectl explain` command to get more information about the fields that you can use in the descriptor:
  ```bash
  kubectl explain pod.spec
  kubectl explain pods
  ```
### 3.1.3. Using `kubectl create` to create the pod
* To create the pod from your YAML file:
  ```bash
  kubectl create -f resources/me/chap03/kubia-manual.yaml
  ```
  ![](./img/chap03/01.png)

* Verity:
  ```bash
  kubectl get all
  ```
  ![](./img/chap03/02.png)

### 3.1.4. View application logs
* To view the logs of a container in a pod, use the `kubectl logs` command:
  ```bash
  kubectl logs kubia-manual
  ```
  ![](./img/chap03/03.png)

* If you have multiple pods running on the same app, use this command to view the logs of a specific container in a specific pod:
  ```bash
  kubectl logs kubia-manual -c kubia
  ```
  ![](./img/chap03/04.png)

### 3.1.5. Sending requests to the pod
* To forward your machine's local port 8888 to port 8080 of your `kubia-manual` pod:
  ```bash
  kubectl port-forward kubia-manual 8888:8080
  ```
  ![](./img/chap03/05.png)
  * The port forwarder is running and you can connect to your pod through the local port.

* Try sending requests to the forwarded port:
  ```bash
  curl localhost:8888
  ```
  ![](./img/chap03/06.png)

## 3.2. Organizing pods with labels
### 3.2.1. Specifying labels when creating a pod
* See the file [kubia-manual-with-labels.yaml](./resources/me/chap03/kubia-manual-with-labels.yaml) to understand. Now run this app.
  ```bash
  kubectl create -f resources/me/chap03/kubia-manual-with-labels.yaml
  ```
  ![](./img/chap03/07.png)

* List all available labels:
  ```bash
  kubectl get pods --show-labels
  ```
  ![](./img/chap03/08.png)

* List all pods with a specific label:
  ```bash
  kubectl get pods -l creation_method=manual --show-labels
  kubectl get pods -L creation_method,env --show-labels  # create a new column following the labels
  ```
  ![](./img/chap03/09.png)

### 3.2.2. Modifying labels on existing pods
* Assign label `creation_method=manual` to the `kubia-manual` pod:
  ```bash
  kubectl label pod kubia-manual creation_method=manual
  kubectl get pods --show-labels
  ```
  ![](./img/chap03/10.png)

## 3.3. Listing subset of pods through labal selectors
* Get all the pods that `creation_method` equal to `manual`:
  ```bash
  kubectl get pods -l creation_method=manual --show-labels
  ```
  ![](./img/chap03/11.png)

* List all pods that include the `env` label, whatever its value is:
  ```bash
  kubectl get pods -l env --show-labels
  ```
  ![](./img/chap03/12.png)

* And those that do not have the `env` label:
  ```bash
  kubectl get pods -l '!env' --show-labels
  ```
  ![](./img/chap03/13.png)

* Similarly, you could also match pods with the following label selectors:
  * `creation_method!=manual` to select pods with the `creation_method` label with any value other than `manual`.
  * `env in (prod,devel)` to selects pods with the `env` label set to either `prod` or `devel`.
  * `env notin (prod,devel)` to select pods with the `env` label set to any value other than `prod` or `devel`.

## 3.4. Using labels and selectors to constrain pod scheduling
* Use can use the field `nodeSelector` to specify the nodes you want to deploy your pods.

## 3.5. Anootating pods
* Annotation helps you to add more metadata to your pods, such as company name, version, bla bla bla.
  ```bash
  kubectl annotate pod kubia-manual mycompany.com/someannotation="foo bar"
  kubectl describe pod kubia-manual
  ```
  ![](./img/chap03/14.png)

## 3.6. Using namespaces to group resources
* Get all current namespaces:
  ```bash
  kubectl get ns
  ```
  ![](./img/chap03/15.png)

* Get all pods of namespace `kube-system`:
  ```bash
  kubectl get pods --namespace kube-system
  ```
  ![](./img/chap03/16.png)

### 3.6.1. Creating a namespace
* Creating a namespace from YAML file:
  ```bash
  kubectl create -f resources/me/chap03/custom-namespace.yaml
  kubectl get ns
  ```
  ![](./img/chap03/17.png)

* Creating a namespace from command line:
  ```bash
  kubectl create namespace custom-namespace-2
  ```
  ![](./img/chap03/18.png)

* To create resources in the namespace you have created, use the command:
  ```bash
  kubectl create -f resources/me/chap03/kubia-manual.yaml --namespace custom-namespace
  kubectl get all -n custom-namespace
  ```
  ![](./img/chap03/19.png)

* To switch to different namespace, use the command:
  ```bash
  kubectl config set-context --current --namespace custom-namespace
  kubectl config view | grep namespace # get current namespace
  ```
  ![](./img/chap03/20.png)

## 3.7. Stopping and removing pods
* Delete a pod by name
  ```bash
  kubectl delete pod kubia-manual
  ```

* Delete pods using label selectors
  ```bash
  kubectl delete pods -l creation_method=manual
  ```

* Delete pods by deleting the whole namespace
  ```bash
  kubectl delete ns custom-namespace
  ```

* Delete all pods in a namespace, while keeping the namespace
  ```bash
  kubectl delete pods --all
  ```

* Delete all resources in a namespace:
  ```bash
  kubectl delete all --all
  ```

# Chapter 4. Replication and other controllers: deploying managed pods
## 4.1. Keep pods healthy
### 4.1.1. Introducing liveness probes
* K8s can probe a container using one of the three mechanisms:
  * An **HTTP GET** probe performs an HTTP GET request on the container's IP address, a port and path you specify. If the probe receives a response, and the response code does not represent an error (in other words, if the HTTP response code is 2xx or 3xx), the probe is considered successful. If the server returns an error response code or if it does not respond at all, the probe is considered a failure and the container will be restarted as a result.
  * A **TCP socket** probe tries to open a TCP connection to the specified port of the container. If the connection is established successfully, the probe is successful. Otherwise, the container is restarted.
  * An **EXEC** probe executes an arbitrary command inside the container and checks the command's exit status code. If the status code is 0, the probe is successful. All other codes are considered failures.

### 4.1.2. Creating an HTTP-based liveness probe
* In `liveness` you need to specify the field `livenessProbe` in the `YAML` config file.
* Create `manhcuong8499/kubia-unhealthy` image:
  ```bash
  cd resources/me/chap04/kubia-unhealthy
  docker build -t kubia-unhealthy .
  docker tag kubia-unhealthy manhcuong8499/kubia-unhealthy
  docker push manhcuong8499/kubia-unhealthy
  ```
* Run our app:
  ```bash
  kubectl create -f resources/me/chap04/kubia-liveness-probe.yaml
  kubectl get pods kubia-liveness
  ```

* When you want to figure out why the previous container terminated, you can use the command:
  ```bash
  kubectl describe pod kubia-liveness
  ```
  ![](./img/chap04/01.png)

### 4.1.3. Configuring additional properties if the liveness probe.
* You can tell to K8s to wait a period of time before starting to probe the container, see the file and take a deep dive to field `initialDelaySeconds` of file [kubia-liveness-probe-initial-delay.yaml](./resources/me/chap04/kubia-liveness-probe-initial-delay.yaml)

## 4.2. Introducing ReplicationControllers
* A **ReplicationController** is a K8s resource that ensures its pods are **always kept running**.
* Look at the below image to find out how it works:
  ![](./img/chap04/02.png)

* A **ReplicationController**'s job is to make sure that an exact number of pods always matches its labels selector. It will work like the below image:
  ![](./img/chap04/03.png)

### 4.2.1. Understanding the three parts of a ReplicationController
* A **ReplicationController** has **three essential parts**:<br>
  ![](./img/chap04/04.png)<br>
  * A _label selector_, which determines what pods are in the **ReplicationController**'s scope.
  * A _replica count_, which specifies the desired number of pods that should be running.
  * A _pod template_, which is used when creating new pod replicas.

### 4.2.2. Creating a ReplicationController
* **Important**:
  * You need to specify the field `spec.replicas.selector.app` of ReplicationController and the field `metadata.labels.app` of pod template to be the same.
  * Or you just only specify the field `metadata.labels.app` of pod template and the field `spec.replicas.selector` will be automatically created by K8s.

* Create the app with [kubia-rc.yaml](./resources/me/chap04/kubia-rc.yaml) config file.
  ```bash
  kubectl create -f resources/me/chap04/kubia-rc.yaml
  kubectl get all --show-labels
  ```
  ![](./img/chap04/05.png)

* For example, try to **delete one of the pods manually** to see how ReplicationController spins up a new one **immediately** to replace it, bringing the number of matching pods back to three.
  ```bash
  kubectl delete pod <pod_name>
  ```
  ![](./img/chap04/06.png)

* Getting information about a **ReplicationController**.
  ```bash
  kubectl get rc
  ```
  ![](./img/chap04/07.png)

* Or `describe` a **ReplicationController**.
  ```bash
  kubectl describe rc kubia
  ```
  ![](./img/chap04/08.png)

### 4.2.3. Moving pods in and out of the scope of a  **ReplicationController**
* Although a pod is not tied to a ReplicationController, the pod does reference it in the `metadata.ownerReferences` field., which you can use to easily find which ReplicationController a pod belongs to.
* So, if you change the label of a pod, it will be removed from the scope of the ReplicationController. So the ReplicationController will create a new pod to replace it.
  ```bash
  kubectl label pod <pod_name> <label_field>=<new_value> --overwrite
  kubectl get pods -L app
  ```
  ![](./img/chap04/09.png)
  * So in this case, the pod which not be referenced to will keep be running until you delete it manually.

* Edit a running ReplicationController by the below command:
  ```bash
  kubectl edit rc <replication_controller_name>
  ```
### 4.2.4. Horizontally scalling pods
* Scale the **ReplicationController of Kubia** app up to 10 replicas:
  ```bash
  kubectl scale rc kubia --replicas=10
  kubectl get pods -L app --show-labels
  ```
  ![](./img/chap04/10.png)

### 4.2.5. Deleting a ReplicationController
* When you delete a ReplicationController, all the pods it manages will be deleted as well.
  ```bash
  kubectl delete rc kubia
  kubectl get pods -L app --show-labels
  ```
  ![](./img/chap04/11.png)

* But when you only want to delete the ReplicationController, and keep its managed pods alive, you the below command:
  ```bash
  kubectl delete rc kubia --cascade=false
  ```

## 4.3. Using ReplicaSets instead of ReplicationControllers
* Similar to **ReplicationController**, it is a new generation of **ReplicationController** and replaces the old one completely _(ReplicationController will eventually be deprecated)_.

### 4.3.1 Comparing a ReplicaSet to a ReplicationController
* A single ReplicationController can not match pods with the label `env=production` and those with the label `env=devel` at the same time. It can only match either pods with the `env=production` label or pods with the `env=devel` label. But a single ReplicaSet can match both sets of pods and treat them as a single group.

### 4.3.2. Defining a ReplicaSet
* Create a ReplicaSet with [kubia-replicaset.yaml](./resources/me/chap04/kubia-replicaset.yaml) config file.
  ```bash
  kubectl create -f resources/me/chap04/kubia-replicaset.yaml
  kubectl get all --show-labels
  ```
  ![](./img/chap04/12.png)
  
* Get all the **ReplicaSet**:
  ```bash
  kubectl get rs
  ```
  ![](./img/chap04/13.png)

* Describe **ReplicaSet**
  ```bash
  kubectl describe rs kubia
  ```
  ![](./img/chap04/14.png)

### 4.3.3. Using the ReplicaSet's more expressive label selectors
* Discover the field `spec.replicas.selector.matchExpressions:` in the file [kubia-replicaset-matchexpressions.yaml](./resources/me/chap04/kubia-replicaset-matchexpressions.yaml).
  ```bash
  kubectl create -f resources/me/chap04/kubia-replicaset-matchexpressions.yaml
  kubectl get all --show-labels
  ```
  ![](./img/chap04/15.png)

## 4.4. Running exactly one pod on each node with DaemonSets
* A **DaemonSet** ensures that **exactly one pod** is running on each node in the cluster. It is useful for running a pod that provides a service to the entire node, such as a logging agent or a monitoring agent.
  ![](./img/chap04/16.png)
* In the case of a node goes down, the DaemonSet does not create a new pod on another node to replace the one that went down. It only creates a new pod on a new node when a new node is added to the cluster.
* You also use DaemonSet when you want to run a pod on specific nodes, not all nodes in the cluster. This is done by specifying a `nodeSelector` in the pod template.

* Creating a DaemonSet YAML definition:
  * Look at the file  [ssd-monitor-daemonset.yaml](./resources/me/chap04/ssd-monitor-daemonset.yaml).
  ```bash
  cd ./resources/me/chap04/ssd-monitor
  docker build -t ssd-monitor .
  docker tag ssd-monitor manhcuong8499/ssd-monitor
  docker push manhcuong8499/ssd-monitor
  ```
  
  ```bash
  kubectl create -f resources/me/chap04/ssd-monitor-daemonset.yaml
  kubectl get ds # get daemonset resources
  ```
  ![](./img/chap04/17.png)
  * There is nothing to happen, because you **forgot to label your nodes with the `disk=ssd` label**.

* Labeling nodes with `disk=ssd` label:
  ```bash
  kubectl get nodes
  kubectl label node multinode-demo-m02 disk=ssd
  kubectl get all --show-labels
  ```
  ![](./img/chap04/18.png)
  * Now there is exactly one pod running this DaemonSet.
  * DaemonSet will create a new pod on a new node when a new node is added to the cluster.

* Let remove the label `disk=ssd` from the node `multinode-demo-m02`:
  ```bash
  kubectl label node multinode-demo-m02 disk=hdd --overwrite
  kubectl get all --show-labels
  ```
  ![](./img/chap04/19.png)
  * You can see, when you have changed the label of the node, the DaemonSet will remove the pod from the node.
  * Now, there is nothing happen like the first time you create the DaemonSet.

## 4.5. Running pods that perform a single completable task
* If you only want to run a task that terminates after completing its work, use need to use a **Job**.
### 4.5.1. Introducing  the Job resource
* K8s includes support for this through the Job resource, it allows to run a pod whose container is not restarted when the process running inside finishes successfully. Once it does, the pod is considered complete.

### 4.5.1. Defining a Job resource
* Following the file [](./resources/me/chap04/batch-job.yaml).
* Build the image:
  ```bash
  cd ./resources/me/chap04/batch-job
  docker build -t batch-job .
  docker tag batch-job manhcuong8499/batch-job
  docker push manhcuong8499/batch-job
  ```

* Create the Job:
  ```bash
  kubectl create -f resources/me/chap04/batch-job.yaml
  kubectl get all --show-labels
  kubectl logs <pod_name>
  ```
  ![](./img/chap04/20.png)
  ![](./img/chap04/21.png)
  * The job is completed after 2 minutes.

* To get job:
  ```bash
  kubectl get jobs
  ```
  ![](./img/chap04/22.png)

### 4.5.2. Running multiple pod instances in a Jon sequentially
* Following file [](./resources/me/chap04/multi-completion-batch-job.yaml)
  * It is only completed when all the pods are completed _(in this example is 5)_.
  * Run as sequential, not parallel.
  ```bash
  kubectl create -f resources/me/chap04/multi-completion-batch-job.yaml
  kubectl get all --show-labels
  ```
  ![](./img/chap04/23.png)
  ![](./img/chap04/24.png)

* If you want to run them as parallel, following file [multi-completion-parallel-batch-job.yaml](./resources/me/chap04/multi-completion-parallel-batch-job.yaml)
  ```bash
  kubectl create -f resources/me/chap04/multi-completion-parallel-batch-job.yaml
  kubectl get all --show-labels
  ```
  ![](./img/chap04/25.png)
* You also change the number of pods which is able to run at same time when your job is on the fly.
  ```bash
  kubectl edit job multi-completion-batch-job
  ```
  * and then edit the field `spec.parallelism: 2` to `spec.parallelism: 3`

### 4.5.3. Limiting the time allowed for a Job pod to complete
* You can also limit the time allowed for a Job pod to complete by specifying a `spec.activeDeadlineSeconds` field in the Job YAML definition.
* Look at the file [time-limited-batch-job.yaml](./resources/me/chap04/time-limited-batch-job.yaml).

## 4.6. Scheduling Jobs to run periodically or once in the future
### 4.6.1. Creating a CronJob
* Look at the file [cronjob.yaml](./resources/me/chap04/cronjob.yaml). You specify time to run the job in the field `spec.schedule`.
* Sometime, you can also add field `spec.startingDeadlineSeconds` to specify the duration time that the job can be delayed before it is considered failed.
  * For example: If you set `spec.startingDeadlineSeconds: 15`, one of the times the job is supposed to run is 10:30:00, if it does not start by 10:30:15 for whatever reason, the job will not run and will be shown as failed.

# Chapter 5. Services: enabling clients to discover and talk to pods
## 5.1. Introducing services
### 5.1.1. Creating services
* Creating a service through kubectl expose: We can use `expose` command to create a service, we can expose the **ReplicationController** or **ReplicaSet**. But this option is not recommended.
* Creating a service throught a YAML file:
  * Look at the file [kubia-svc.yaml](./resources/me/chap05/kubia-svc.yaml) and then use this file to create our service.
  ```bash
  kubectl create -f resources/me/chap05/kubia-svc.yaml
  kubectl get svc # get all available services
  ```
  ![](./img/chap05/01.png)
  * But this is the cluster IP, it's only accessible from inside the cluster
* There are several ways that you can send your request to this above service:
  * Creating a pod that will send the request to the service's cluster IP and log the response.
  * You `ssh` into one of the K8s nodes and use the `curl` command.
  * You can execute `curl` command inside one of your existing pods through the `kubectl exec` command.

* Now let's make requests to our service:
  ```bash
  kubectl get pods
  kubectl describe pod <pod_name>
  kubectl exec <pod_name> -- curl -s <api_endpoints>
  ```
  ![](./img/chap05/02.png)
  ![](./img/chap05/03.png)

* There is a big thing you need to know that when you make a request to K8s, it will choose a random pod to send the request to. So, you can see the response is different each time you make a request. In the case you want to keep the affinity between the client and the previous pod, you need to set the field `spec.sessionAffinity: ClientIP` in the service YAML file.
  * This will make the service to :send the request to the same pod that the client has previously sent the request to.

* **Expose multiple ports in the same service**
  * You can expose multiple ports for your service like this:
  ```yaml
  apiVersion: v1
  kind: Service
  metadata:
    name: kubia
    spec:
      ports:
      - name: http
        port: 80
        targetPort: 8080
      - name: https
        port: 443
        targetPort: 8443
      selector:
        app: kubia
  ```

* **Using named ports**:
  * If you have a pod like this:
  ```yaml
  kind: Pod
  spec:
    containers:
    - name: kubia
      ports:
      - name: http
      containerPort: 8080
      - name: https
      containerPort: 8443
  ```

  * And now you want your service to use this pod's ports, you can do this:
  ```yaml
  apiVersion: v1
  kind: Service
  spec:
    ports:
    - name: http
      port: 80
      targetPort: http
    - name: https
      port: 443
      targetPort: https
  ```
  * So later if you chage the pod's port, you don't need to change the service's port.