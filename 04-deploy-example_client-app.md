# Deploy an example client application, which communicates with kafka

Challenge #4 - Deploy an example client application, which communicates with Kafka. You can use Strimzi examples for that step. The clients should be deployed into different namespace than Kafka and it should use internal Kubernetes communication (no need to use external listeners in Kafka). The deployment steps should be part of the previous script/scripts.

**Prerequisites:**

-  [ansible](https://docs.ansible.com/) 2.10.3
-  [minikube](https://minikube.sigs.k8s.io/docs/start/) version: v1.15.1

**Test Environment**

- MacOS
- 20.1.0 Darwin Kernel Version 20.1.0
- GNU bash, version 5.0.18(1)-release (x86_64-apple-darwin20.1.0)

## **How does it work?**

This script is deploying the [STRIMZI examples](https://github.com/strimzi/client-examples) and produce/consume messages to broker and also setting the listener to use the internal Kubernetes communication.

**Tasks**

 - Modify files placed in ../dependencies/deploy-example-client-app/ to add the namespace sent as parameter.
 -  Deploy the example client application

This script needs 2 parameters:

 - *client_example_app_namespace_var* - place where your application will be deployed.
 - kafka_cluster_namespace_var - it is used to define internal Kubernetes communication
  
## How to run the script?

To run use the following command:

    ansible-playbook playbooks/scripts/04-deploy-example_client-app.yaml  -e "client_example_app_namespace_var=app kafka_cluster_namespace_var=ops"

**Results Logs**

I'm adding the execution logs from my local:

    strimzi-kafka-cluster-automation mariocp$ ansible-playbook playbooks/scripts/04-deploy-example_client-app.yaml  -e "client_example_app_namespace_var=app kafka_cluster_namespace_var=ops "
    
    PLAY [Deploying an example client application, which communicates with Kafka] ******************************************************************
    
    TASK [Gathering Facts] *************************************************************************************************************************
    ok: [localhost]
    
    TASK [Setting the bootstrap server for kafka cluster namespace] **************************************************************************
    changed: [localhost]
    
    TASK [Deploying the example client application using the internal communication for namespace --> {{client_app_namespace}}] ********************
    changed: [localhost]
    
    TASK [debug] ***********************************************************************************************************************************
    ok: [localhost] => {
        "deploy_results.stdout_lines": [
            "deployment.apps/internal-app-consumer created",
            "deployment.apps/internal-app-producer created"
        ]
    }
    
    TASK [Reverting cahnges ../dependencies/deploy-example-client-app/*.yaml to the next deployment] ***********************************************
    changed: [localhost]
    
    PLAY RECAP *************************************************************************************************************************************
    localhost                  : ok=5    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0  

 


   