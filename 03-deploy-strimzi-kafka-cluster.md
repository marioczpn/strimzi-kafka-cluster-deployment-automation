

# Deploying STRIMZI cluster operator and Kafka cluster into local kubernetes

Challenge #3 - Create a script (or modify script from previous steps) which will install Strimzi Operator into a specific namespace (based on the script parameter) and deploy Kafka cluster to a specific namespace based on the other parameter of the script. The script should be able to deploy Kafka on the same namespace as Operator is installed to and also into a different one (see Strimzi docs how to do that) based on the user's input.

**Prerequisites:**

- [ansible](https://docs.ansible.com/) 2.10.3
- [minikube](https://minikube.sigs.k8s.io/docs/start/) version: v1.15.1

**Test Environment**
 - MacOS
	- 20.1.0 Darwin Kernel Version 20.1.0
	- GNU bash, version 5.0.18(1)-release (x86_64-apple-darwin20.1.0)
	

## **How does it work?**

The deployment process is split in 3 more "sub-playbook/scripts", the ***03-deploy-strimzi-kafka-cluster.yaml*** is the main script that will invoke the sub-scripts which will provide functionatilies to *create namespace*, *deploy strimzi* and *kafka cluster* into kubernetes.

Let me describe a bit about the playbooks associated within:

## **Playbooks**

**Main Script** is responsible to invoke the sub-scripts according with their functions. The main script has the following tasks:

 - **Script Name:** 03-deploy-strimzi-kafka-cluster.yaml
	 - 1. Delete/Create namespace for *STRIMZI* and *Kafka cluster*
	 - 2. Deploy STRIMZI Cluster
	 - 3. Deploy Kafka Cluster
	 
**How to run?**


**Sub Scripts:**

All subscripts are under *..scripts/deploy_strimzi_kafka_cluster_scripts folder/*.

**First subscript**

**Script Name:** 00-delete-create-namespace.yaml 
- **Tasks**:
		 
	- Namespace Management like **delete**,**create** and **verify** funtions, behind the scenes it's using the [kubectl](https://kubernetes.io/docs/reference/kubectl/overview/) command.
		 - Thi script needs 2 extra parameters:
			 - *namespace_var* - the name of the kubernetes namespace.
			 - *to_delete* - this flag controls if the namespace will be deleted or not.
			 
 **How to run just this script?**

**IMPORTANT:** Attention to run this script with the flag ***to_delete=yes***
	 - To execute the script directly, run the following command:

    ansible-playbook playbooks/scripts/deploy_strimzi_kafka_cluster_scripts/00-delete-create-namespace.yaml -e "namespace_var=ops to_delete=no"

**Second Script:** 

  **Script Name:**  01-deploy-strimzi-cluster-operator.yaml
		- **Tasks**:
		 - 1. Modify 060-Deployment-strimzi-cluster-operator.yaml to add the **new container image** (you can set this image in *playbooks/config_vars/global_vars.yaml*)  and [watch](https://strimzi.io/docs/operators/latest/full/deploying.html#con-cluster-operator-watch-options-str) options for a Cluster Operator deployment. It will verify and create if necessary.
		 - 2. Modify/Deploy the *RoleBinding*.yaml. The namespace will be modified according to the parameter  of the file to watch single or multiple namespaces and then deploy.
		 - 3. Deploy Cluster Operator

Thi script needs 2 extra parameters:
			 - *namespace_var* - the name of the kubernetes namespace.
			 - *deploy_operator* -  controls if the operator will be deployed. 
			 - *install_cluster_roles* (optional) - defines if the ClusterRoleBindings will grant access to all namespaces
			 - *modify_role_binding (optional)* will deploy *RoleBinding*.yaml files
		 
 **How to run just this script?**

**IMPORTANT:** Attention to run this script with the flag ***install_cluster_roles=yes*** **and/or modify_role_binding=yes**
	
To execute the script directly, run the following command:

     ansible-playbook  playbooks/scripts/deploy_strimzi_kafka_cluster_scripts/01-deploy-strimzi-cluster-operator.yaml -e "operator_namespace=ops deploy_operator=yes install_cluster_roles=yes"

 