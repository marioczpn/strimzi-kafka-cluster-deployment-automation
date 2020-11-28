

# Setup kubernetes cluster using minikube

Challenge #1 - Create a script which will set up a kubernetes cluster (minikube/kind/k3s/...) or use an existing one for the following steps.

**Prerequisites:**

 - ansible 2.10.3
 - minikube version: v1.15.1

**Test Environment**
- MacOS
	- 20.1.0 Darwin Kernel Version 20.1.0
	
As it's running from personal computer, I'm using local Kubernetes, [minikube](https://minikube.sigs.k8s.io/docs/start/)  and to avoid type each command every time, I created an [ansible](https://docs.ansible.com/)  script.

**How does it work?**
The script has two main things **pre-tasks** and **tasks**. The idea behind is to check if the minikube is installed, running and ready.
Adding the steps bellow:

**Pre-tasks**

 1. Minikube status check. The status define if it will be started or not.
 2. Check if minikube was deleted. Then it will set a configuration

**Tasks**
The tasks are split into 5 steps:

 1. Install minikube on MacOS using brew if doesn't exist.
 2. Delete minikube if the flag purge is true (Defined at he begining).
 3. Start minikube if is not running.
 4. Checking if the Docker is up and running.
 5. Run a simple kubectl to verify if everything is good.

## How to run the script?

To run use the following command:

    ansible-playbook playbooks/scripts/01-setup_kubernetes_cluster_minikube.yaml

**Results**
I'm adding the execution logs executed from my local:

