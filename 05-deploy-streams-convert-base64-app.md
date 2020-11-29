# Deploy Java Application which will use Kafka Streams API to consume all messages from topic X, convert to base64 format and produces to Y 
  
  

Challenge #4 - Create a simple application which will use Kafka Streams API. This application will consume all messages from topic X, convert them to base64 format and produce them to topic Y. Java is preferable for Streams application. Also create a makefile and script, which will build the application and build an image with the application inside and push it to the internal Kubernetes registry or to dockerhub/quay.

**Prerequisites:**

-  [ansible](https://docs.ansible.com/) 2.10.3
-  [minikube](https://minikube.sigs.k8s.io/docs/start/) version: v1.15.1

**Test Environment**

- MacOS
- 20.1.0 Darwin Kernel Version 20.1.0
- GNU bash, version 5.0.18(1)-release (x86_64-apple-darwin20.1.0)

## **How does it work?**

This script will deploy the **kafka-streams-convert-base64-app** (code is available [here](https://github.com/marioczpn/kafka-streams-convert-base64-app)).
This application is using the Kafka Streams api to consume all messages from topic X, convert them to base64 format and produce them to topic Y.

**Tasks**

 - Setting the bootstrap server in ../dependencies/deploy-streams-convert-base64-app/00-streams-convert-base64-app.yaml
 -  Deploy the quay.io/marioczpn/kafka-streams-convert-base64-app

This script needs 2 parameters:

 - *kafka_streams_app_namespace_var* - place where your application will be deployed.
 - *kafka_cluster_namespace_var* - it is used to define internal Kubernetes communication
  
## How to run the script?

To run use the following command:

    ansible-playbook playbooks/scripts/05-deploy-streams-convert-base64-app.yaml -e "kafka_streams_app_namespace_var=app kafka_cluster_namespace_var=ops"

**Results Logs**

I'm adding the execution logs from my local:

    strimzi-kafka-cluster-automation mariocp$ ansible-playbook playbooks/scripts/05-deploy-streams-convert-base64-app.yaml -e "kafka_streams_app_namespace_var=app kafka_cluster_namespace_var=ops"
    [WARNING]: No inventory was parsed, only implicit localhost is available
    [WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'
    
    PLAY [Deploying the streams-convert-base64-app which will use Kafka Streams API] ***************************************************************
    
    TASK [Gathering Facts] *************************************************************************************************************************
    ok: [localhost]
    
    TASK [Setting the bootstrap server to namespace -> app] ****************************************************************************************
    [WARNING]: Consider using the replace, lineinfile or template module rather than running 'sed'.  If you need to use command because replace,
    lineinfile or template is insufficient you can add 'warn: false' to this command task or set 'command_warnings=False' in ansible.cfg to get rid
    of this message.
    changed: [localhost]
    
    TASK [Deploying the "quay.io/marioczpn/kafka-streams-convert-base64-app" to namespace --> app] *************************************************
    changed: [localhost]
    
    TASK [debug] ***********************************************************************************************************************************
    ok: [localhost] => {
        "deploy_results.stdout_lines": [
            "deployment.apps/streams-convert-base64-app unchanged"
        ]
    }
    
    TASK [Reverting the bootstrap server changes to the next deployment.] **************************************************************************
    changed: [localhost]
    
    PLAY RECAP *************************************************************************************************************************************
    localhost                  : ok=5    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
