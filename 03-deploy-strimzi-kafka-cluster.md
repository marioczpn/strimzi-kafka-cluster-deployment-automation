# Deploying STRIMZI cluster operator and Kafka cluster into local kubernetes


Challenge #3 - Create a script (or modify script from previous steps) which will install Strimzi Operator into a specific namespace (based on the script parameter) and deploy Kafka cluster to a specific namespace based on the other parameter of the script. The script should be able to deploy Kafka on the same namespace as Operator is installed to and also into a different one (see Strimzi docs how to do that) based on the user's input.

  

**Prerequisites:**

  

-  [ansible](https://docs.ansible.com/) 2.10.3

-  [minikube](https://minikube.sigs.k8s.io/docs/start/) version: v1.15.1

  

**Test Environment**

- MacOS

- 20.1.0 Darwin Kernel Version 20.1.0

- GNU bash, version 5.0.18(1)-release (x86_64-apple-darwin20.1.0)

  

## **How does it work?**

  

The deployment process is split in 3 more "sub-playbook/scripts", the ***03-deploy-strimzi-kafka-cluster.yaml*** is the main script that will invoke the sub-scripts which will provide functionatilies to *create namespace*, *deploy strimzi* and *kafka cluster* into kubernetes.

  

Let me describe a bit about the playbooks associated within:

  

# **Playbooks**

  

## **Main Script**

 
It is invoke the ***subscripts*** according with their responsibilities. The main script has the following tasks:

-  **Script Name:** 03-deploy-strimzi-kafka-cluster.yaml

	-  1. Delete/Create namespace for *STRIMZI* and *Kafka cluster*

	-  2. Deploy STRIMZI Cluster

	-  3. Deploy Kafka Cluster

**How to run?**

 The following command bellow will **run all subscripts:**
 
      ansible-playbook  playbooks/scripts/03-deploy-strimzi-kafka-cluster.yaml -e "operator_namespace=ops kafka_cluster_namespace=ops to_delete_ns=no"
      

# **Sub Scripts:**

  All subscripts are under *..scripts/deploy_strimzi_kafka_cluster_scripts folder/*.

## **First Script**

 
**Script Name:** 00-delete-create-namespace.yaml
  **Tasks**:

- Namespace Management like **delete**,**create** and **verify** funtions, behind the scenes it's using the [kubectl](https://kubernetes.io/docs/reference/kubectl/overview/) command.

- Thi script needs 2 extra parameters:

	-  *namespace_var* - the name of the kubernetes namespace.
	-  *to_delete_ns* - this flag controls if the namespace will be deleted or not.

## **How to run only this script?**

**IMPORTANT:** Attention to run this script with the flag ***to_delete_ns=yes***

- To execute the script directly, run the following command:

    ansible-playbook playbooks/scripts/deploy_strimzi_kafka_cluster_scripts/00-delete-create-namespace.yaml -e "namespace_var=ops to_delete_ns=no"


## **Second Script:**

  
**Script Name:** 01-deploy-strimzi-cluster-operator.yaml
**Tasks**:

1. Modify *060-Deployment-strimzi-cluster-operator.yaml* to add the **new container image** (you can set this image in *playbooks/config_vars/global_vars.yaml*) and [watch](https://strimzi.io/docs/operators/latest/full/deploying.html#con-cluster-operator-watch-options-str) options for a Cluster Operator deployment. It will verify and create if necessary.

 2. Modify/Deploy the *RoleBinding*.yaml. The namespace will be modified according to the parameter of the file to watch single or multiple namespaces and then deploy.

 3. Deploy Cluster Operator

Thi script needs 2 extra parameters:

- *namespace_var* - the name of the kubernetes namespace.
- *deploy_operator* - controls if the operator will be deployed.
- *install_cluster_roles* (optional) - defines if the ClusterRoleBindings will grant access to all namespaces

- *modify_role_binding (optional)* will deploy *RoleBinding*.yaml files

## **How to run only this script?**
**IMPORTANT:** Attention to run this script with the flag ***install_cluster_roles=yes***  **and/or modify_role_binding=yes**

To execute the script directly, run the following command:

    ansible-playbook playbooks/scripts/deploy_strimzi_kafka_cluster_scripts/01-deploy-strimzi-cluster-operator.yaml -e "namespace_var=ops deploy_operator=yes install_cluster_roles=yes"


## **Third Script**

 
**Script Name:** 02-deploy-strimzi-kafka-cluster.yaml
  **Tasks**:
  

 1. Modify/Deploy - kafka-ephemeral.yaml file
 2. Modify/Create Kafka Topics

Thi script needs 1 extra parameters to be executed:

- *kafka_cluster_namespace_var* - the namespace to be installed in kubernetes

## **How to run only this script?**
To execute the script directly, run the following command:

    ansible-playbook  playbooks/scripts/deploy_strimzi_kafka_cluster_scripts/02-deploy-strimzi-kafka-cluster.yaml -e "kafka_cluster_namespace_var=ops"



Logs Information:


    strimzi-kafka-cluster-automation mariocp$   ansible-playbook  playbooks/scripts/03-deploy-strimzi-kafka-cluster.yaml -e "operator_namespace=ops kafka_cluster_namespace=ops to_delete_ns=yes"
    [WARNING]: No inventory was parsed, only implicit localhost is available
    [WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'
    [WARNING]: Additional parameters in import_playbook statements are not supported. This will be an error in version 2.14
    
    PLAY [Deploying STRIMZI cluster operator and Kafka cluster into local kubernetes.] **********************************************************************************************
    
    TASK [Gathering Facts] **********************************************************************************************************************************************************
    ok: [localhost]
    
    PLAY [Setting namespaces and deploy Strimzi operator, Kafka cluster and internal client app.] ***********************************************************************************
    
    TASK [Removing the namespace -> ops] ********************************************************************************************************************************************
    changed: [localhost]
    
    TASK [Creating the new namespace -> ops] ****************************************************************************************************************************************
    changed: [localhost]
    
    TASK [Verifying if the the namespace was created.] ******************************************************************************************************************************
    changed: [localhost]
    
    TASK [debug] ********************************************************************************************************************************************************************
    ok: [localhost] => {
        "namespaces_result.stdout_lines": [
            "NAME              STATUS   AGE",
            "app               Active   5h51m",
            "default           Active   10h",
            "kube-node-lease   Active   10h",
            "kube-public       Active   10h",
            "kube-system       Active   10h",
            "ops               Active   1s"
        ]
    }
    
    PLAY [Setting namespaces and deploy Strimzi operator, Kafka cluster and internal client app.] ***********************************************************************************
    
    TASK [Removing the namespace -> ops] ********************************************************************************************************************************************
    skipping: [localhost]
    
    TASK [Creating the new namespace -> ops] ****************************************************************************************************************************************
    skipping: [localhost]
    
    TASK [Verifying if the the namespace was created.] ******************************************************************************************************************************
    skipping: [localhost]
    
    TASK [debug] ********************************************************************************************************************************************************************
    skipping: [localhost]
    
    PLAY [Setting namespaces and deploy Strimzi operator, Kafka cluster and internal client app.] ***********************************************************************************
    
    TASK [Gathering Facts] **********************************************************************************************************************************************************
    ok: [localhost]
    
    TASK [Modifying the container image from quay.io/strimzi to quay.io/marioczpn] **************************************************************************************************
    [WARNING]: Consider using the replace, lineinfile or template module rather than running 'sed'.  If you need to use command because replace, lineinfile or template is
    insufficient you can add 'warn: false' to this command task or set 'command_warnings=False' in ansible.cfg to get rid of this message.
    changed: [localhost]
    
    TASK [debug] ********************************************************************************************************************************************************************
    ok: [localhost] => {
        "modify_results.stdout_lines": []
    }
    
    TASK [Modifying the STRIMZI_NAMESPACE value "*" to watch all namespaces for Cluster Operator deployment.] ***********************************************************************
    changed: [localhost]
    
    TASK [Verifying if the clusterRoleBindings exists] ******************************************************************************************************************************
    changed: [localhost]
    
    TASK [Creating ClusterRoleBindings that grant cluster-wide access to all namespaces to the Cluster Operator] ********************************************************************
    fatal: [localhost]: FAILED! => {"changed": true, "cmd": "kubectl create clusterrolebinding strimzi-cluster-operator-namespaced --clusterrole=strimzi-cluster-operator-namespaced --serviceaccount ops:strimzi-cluster-operator\nkubectl create clusterrolebinding strimzi-cluster-operator-entity-operator-delegation --clusterrole=strimzi-entity-operator --serviceaccount ops:strimzi-cluster-operator\nkubectl create clusterrolebinding strimzi-cluster-operator-topic-operator-delegation --clusterrole=strimzi-topic-operator --serviceaccount ops:strimzi-cluster-operator\n", "delta": "0:00:00.750005", "end": "2020-11-28 21:12:41.261586", "msg": "non-zero return code", "rc": 1, "start": "2020-11-28 21:12:40.511581", "stderr": "error: failed to create clusterrolebinding: clusterrolebindings.rbac.authorization.k8s.io \"strimzi-cluster-operator-namespaced\" already exists\nerror: failed to create clusterrolebinding: clusterrolebindings.rbac.authorization.k8s.io \"strimzi-cluster-operator-entity-operator-delegation\" already exists\nerror: failed to create clusterrolebinding: clusterrolebindings.rbac.authorization.k8s.io \"strimzi-cluster-operator-topic-operator-delegation\" already exists", "stderr_lines": ["error: failed to create clusterrolebinding: clusterrolebindings.rbac.authorization.k8s.io \"strimzi-cluster-operator-namespaced\" already exists", "error: failed to create clusterrolebinding: clusterrolebindings.rbac.authorization.k8s.io \"strimzi-cluster-operator-entity-operator-delegation\" already exists", "error: failed to create clusterrolebinding: clusterrolebindings.rbac.authorization.k8s.io \"strimzi-cluster-operator-topic-operator-delegation\" already exists"], "stdout": "", "stdout_lines": []}
    ...ignoring
    
    TASK [debug] ********************************************************************************************************************************************************************
    ok: [localhost] => {
        "install_cluster_roles.stdout_lines": []
    }
    
    TASK [Modifying the namespace to ops of the files  ../dependencies/install/cluster-operator/*RoleBinding*.yaml files to watch the single and multiple namespaces.] **************
    changed: [localhost]
    
    TASK [debug] ********************************************************************************************************************************************************************
    ok: [localhost] => {
        "modify_rolebind_results.stdout_lines": []
    }
    
    TASK [Deplying Cluster RoleBinding's files to  {{ namespace_var}} defined on parameter {{modify_role_binding}}] *****************************************************************
    skipping: [localhost]
    
    TASK [debug] ********************************************************************************************************************************************************************
    ok: [localhost] => {
        "apply_role_bind.stdout_lines": "VARIABLE IS NOT DEFINED!"
    }
    
    TASK [Deploying Cluster Operator into "ops and deploy_operator flag is yes"] ****************************************************************************************************
    changed: [localhost]
    
    TASK [debug] ********************************************************************************************************************************************************************
    ok: [localhost] => {
        "deploy_cluster.stdout_lines": [
            "serviceaccount/strimzi-cluster-operator created",
            "clusterrole.rbac.authorization.k8s.io/strimzi-cluster-operator-namespaced unchanged",
            "rolebinding.rbac.authorization.k8s.io/strimzi-cluster-operator created",
            "clusterrole.rbac.authorization.k8s.io/strimzi-cluster-operator-global unchanged",
            "clusterrolebinding.rbac.authorization.k8s.io/strimzi-cluster-operator unchanged",
            "clusterrole.rbac.authorization.k8s.io/strimzi-kafka-broker unchanged",
            "clusterrolebinding.rbac.authorization.k8s.io/strimzi-cluster-operator-kafka-broker-delegation unchanged",
            "clusterrole.rbac.authorization.k8s.io/strimzi-entity-operator unchanged",
            "rolebinding.rbac.authorization.k8s.io/strimzi-cluster-operator-entity-operator-delegation created",
            "clusterrole.rbac.authorization.k8s.io/strimzi-topic-operator unchanged",
            "rolebinding.rbac.authorization.k8s.io/strimzi-cluster-operator-topic-operator-delegation created",
            "clusterrole.rbac.authorization.k8s.io/strimzi-kafka-client unchanged",
            "clusterrolebinding.rbac.authorization.k8s.io/strimzi-cluster-operator-kafka-client-delegation unchanged",
            "customresourcedefinition.apiextensions.k8s.io/kafkas.kafka.strimzi.io unchanged",
            "customresourcedefinition.apiextensions.k8s.io/kafkaconnects.kafka.strimzi.io unchanged",
            "customresourcedefinition.apiextensions.k8s.io/kafkaconnects2is.kafka.strimzi.io unchanged",
            "customresourcedefinition.apiextensions.k8s.io/kafkatopics.kafka.strimzi.io unchanged",
            "customresourcedefinition.apiextensions.k8s.io/kafkausers.kafka.strimzi.io unchanged",
            "customresourcedefinition.apiextensions.k8s.io/kafkamirrormakers.kafka.strimzi.io unchanged",
            "customresourcedefinition.apiextensions.k8s.io/kafkabridges.kafka.strimzi.io unchanged",
            "customresourcedefinition.apiextensions.k8s.io/kafkaconnectors.kafka.strimzi.io unchanged",
            "customresourcedefinition.apiextensions.k8s.io/kafkamirrormaker2s.kafka.strimzi.io unchanged",
            "customresourcedefinition.apiextensions.k8s.io/kafkarebalances.kafka.strimzi.io unchanged",
            "configmap/strimzi-cluster-operator created",
            "deployment.apps/strimzi-cluster-operator created"
        ]
    }
    
    TASK [Reverting changes from quay.io/marioczpn to quay.io/strimzi next deployment] **********************************************************************************************
    changed: [localhost]
    
    TASK [debug] ********************************************************************************************************************************************************************
    ok: [localhost] => {
        "modify_results.stdout_lines": []
    }
    
    PLAY [Setting namespaces and deploy Strimzi operator, Kafka cluster and internal client app.] ***********************************************************************************
    
    TASK [Gathering Facts] **********************************************************************************************************************************************************
    ok: [localhost]
    
    TASK [Modifying the container image from quay.io/strimzi to quay.io/marioczpn] **************************************************************************************************
    changed: [localhost]
    
    TASK [debug] ********************************************************************************************************************************************************************
    ok: [localhost] => {
        "modify_results.stdout_lines": []
    }
    
    TASK [Modifying the STRIMZI_NAMESPACE value "*" to watch all namespaces for Cluster Operator deployment.] ***********************************************************************
    skipping: [localhost]
    
    TASK [Verifying if the clusterRoleBindings exists] ******************************************************************************************************************************
    changed: [localhost]
    
    TASK [Creating ClusterRoleBindings that grant cluster-wide access to all namespaces to the Cluster Operator] ********************************************************************
    skipping: [localhost]
    
    TASK [debug] ********************************************************************************************************************************************************************
    ok: [localhost] => {
        "install_cluster_roles.stdout_lines": "VARIABLE IS NOT DEFINED!"
    }
    
    TASK [Modifying the namespace to ops of the files  ../dependencies/install/cluster-operator/*RoleBinding*.yaml files to watch the single and multiple namespaces.] **************
    changed: [localhost]
    
    TASK [debug] ********************************************************************************************************************************************************************
    ok: [localhost] => {
        "modify_rolebind_results.stdout_lines": []
    }
    
    TASK [Deplying Cluster RoleBinding's files to  ops defined on parameter yes] ****************************************************************************************************
    skipping: [localhost]
    
    TASK [debug] ********************************************************************************************************************************************************************
    ok: [localhost] => {
        "apply_role_bind.stdout_lines": "VARIABLE IS NOT DEFINED!"
    }
    
    TASK [Deploying Cluster Operator into "ops and deploy_operator flag is no"] *****************************************************************************************************
    skipping: [localhost]
    
    TASK [debug] ********************************************************************************************************************************************************************
    ok: [localhost] => {
        "deploy_cluster.stdout_lines": "VARIABLE IS NOT DEFINED!"
    }
    
    TASK [Reverting changes from quay.io/marioczpn to quay.io/strimzi next deployment] **********************************************************************************************
    changed: [localhost]
    
    TASK [debug] ********************************************************************************************************************************************************************
    ok: [localhost] => {
        "modify_results.stdout_lines": []
    }
    
    PLAY [Setting namespaces and Deploying Kafka Cluster] ***************************************************************************************************************************
    
    TASK [Gathering Facts] **********************************************************************************************************************************************************
    ok: [localhost]
    
    TASK [Setting kafka cluster namespace -> ops to ../../dependencies/kafka/kafka-ephemeral.yaml] **********************************************************************************
    changed: [localhost]
    
    TASK [Deploying the Kafka Cluster ../../dependencies/kafka/kafka-ephemeral.yaml for namespace -> ops] ***************************************************************************
    changed: [localhost]
    
    TASK [debug] ********************************************************************************************************************************************************************
    ok: [localhost] => {
        "deploy_kafka_results.stdout_lines": [
            "kafka.kafka.strimzi.io/ops-cluster created"
        ]
    }
    
    TASK [Verifying if the Kafka Cluster was successfully deployed] *****************************************************************************************************************
    changed: [localhost]
    
    TASK [debug] ********************************************************************************************************************************************************************
    ok: [localhost] => {
        "check_deployments_results.stdout_lines": [
            "NAME                       READY   UP-TO-DATE   AVAILABLE   AGE",
            "strimzi-cluster-operator   0/1     1            0           12s"
        ]
    }
    
    TASK [Reverting the changes added to namespace ops in ../../dependencies/kafka/kafka-ephemeral.yaml] ****************************************************************************
    changed: [localhost]
    
    TASK [Setting namespace ops for ../../dependencies/kafka/topics/*.yaml] *********************************************************************************************************
    changed: [localhost]
    
    TASK [Creating Kafka topics from ../../dependencies/kafka/topics to namespace ops] **********************************************************************************************
    changed: [localhost]
    
    TASK [debug] ********************************************************************************************************************************************************************
    ok: [localhost] => {
        "kfk_topic_results.stdout_lines": [
            "kafkatopic.kafka.strimzi.io/input-topic created",
            "kafkatopic.kafka.strimzi.io/internal-topic created",
            "kafkatopic.kafka.strimzi.io/streams-output-topic created"
        ]
    }
    
    TASK [Verifying if the Kafka Topic was successfully deployed] *******************************************************************************************************************
    changed: [localhost]
    
    TASK [debug] ********************************************************************************************************************************************************************
    ok: [localhost] => {
        "check_topic_results.stdout_lines": [
            "NAME                   CLUSTER             PARTITIONS   REPLICATION FACTOR   READY",
            "input-topic            ops-kafka-cluster   3            3                    ",
            "internal-topic         ops-kafka-cluster   3            3                    ",
            "streams-output-topic   ops-kafka-cluster   3            3                    "
        ]
    }
    
    TASK [Reverting changes of ../../dependencies/kafka/*.yaml to next kafka deployment] ********************************************************************************************
    changed: [localhost]
    
    TASK [Reverting changes of ../../dependencies/kafka/topics/*.yaml to next topic creation] ***************************************************************************************
    changed: [localhost]
    
    PLAY RECAP **********************************************************************************************************************************************************************
    localhost                  : ok=44   changed=23   unreachable=0    failed=0    skipped=9    rescued=0    ignored=1