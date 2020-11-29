# Deploy Application to verify the kafka-streams-convert-base64 app is converting the messages from topic X to Y
  
  

Challenge #5 - Create a script, which will deploy your app and verify it. As a part of the deployment, you have to attach producer to topic X and consumer to topic Y to verify the streams app.

**Prerequisites:**

-  [ansible](https://docs.ansible.com/) 2.10.3
-  [minikube](https://minikube.sigs.k8s.io/docs/start/) version: v1.15.1

**Test Environment**

- MacOS
- 20.1.0 Darwin Kernel Version 20.1.0
- GNU bash, version 5.0.18(1)-release (x86_64-apple-darwin20.1.0)

## **How does it work?**

This script will deploy the **kafka-streams-integration-test-app** (code is available [here](https://github.com/marioczpn/kafka-streams-integration-test-app)).
The application attach  producer  to topic X,  and consumer to topic Y and verify if the kafka-streams-convert-base64-app is converting the message to base64 format.

**Tasks**

 - Setting the bootstrap server in ../dependencies/deploy-streams-convert-base64-app/01-producer-integration-test.yaml and 02-consumer-integration-test.yaml
 -  Deploy the quay.io/marioczpn/kafka-streams-integration-test-app

This script needs 2 parameters:

 - *kafka_integration_test_app_namespace_var* - place where your application will be deployed.
 - *kafka_cluster_namespace_var* - it is used to define internal Kubernetes communication
  
## How to run the script?

To run use the following command:

    ansible-playbook playbooks/scripts/06-deploy-integration-test.yaml -e "kafka_integration_test_app_namespace_var=app kafka_cluster_namespace_var=ops"

**Results Logs**

I'm adding the execution logs from my local:


    strimzi-kafka-cluster-automation mariocp$ ansible-playbook playbooks/scripts/06-deploy-integration-test.yaml -e "kafka_integration_test_app_namespace_var=app kafka_cluster_namespace_var=ops"
    [WARNING]: No inventory was parsed, only implicit localhost is available
    [WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'
    
    PLAY [Deploying the kafka-integration-test-app] ************************************************************************************************
    
    TASK [Gathering Facts] *************************************************************************************************************************
    ok: [localhost]
    
    TASK [Setting the bootstrap server for kafka cluster namespace] ********************************************************************************
    [WARNING]: Consider using the replace, lineinfile or template module rather than running 'sed'.  If you need to use command because replace,
    lineinfile or template is insufficient you can add 'warn: false' to this command task or set 'command_warnings=False' in ansible.cfg to get rid
    of this message.
    changed: [localhost]
    
    TASK [debug] ***********************************************************************************************************************************
    ok: [localhost] => {
        "replace_kafka_cluster.stdout_lines": []
    }
    
    TASK [Deploying the "kafka-integration-test-app" for namespace --> app] ************************************************************************
    changed: [localhost]
    
    TASK [debug] ***********************************************************************************************************************************
    ok: [localhost] => {
        "deploy_results.stdout_lines": [
            "deployment.apps/streams-convert-base64-app configured",
            "deployment.apps/producer-kafka-streams-integration-test-app unchanged",
            "deployment.apps/consumer-kafka-streams-integration-test-app unchanged"
        ]
    }
    
    TASK [Reverting the bootstrap server to the next deployment.] **********************************************************************************
    changed: [localhost]
    
    TASK [debug] ***********************************************************************************************************************************
    ok: [localhost] => {
        "revert_replace_kafka_cluster.stdout_lines": []
    }
    
    PLAY RECAP *************************************************************************************************************************************
    localhost                  : ok=7    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

   