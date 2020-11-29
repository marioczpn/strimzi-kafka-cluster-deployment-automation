

# Download/Build the STRIMZI project and push them into container registry

Challenge #2 - Create a script (or modify script from previous steps) to build Strimzi project, build it’s images and push them into local kubernetes container registry (or use dockerhub, quay...)

**Prerequisites:**

 - [make](https://www.gnu.org/software/make/) GNU Make 3.81
 - [mvn](https://maven.apache.org/index.html) Apache Maven 3.5.4 
 - [yq](https://github.com/mikefarah/yq) yq version 3.4.1
 - [docker](https://docs.docker.com/install/) version 19.03.13
- [ansible](https://docs.ansible.com/) 2.10.3
- [minikube](https://minikube.sigs.k8s.io/docs/start/) version: v1.15.1


**Test Environment**
 - MacOS
	- 20.1.0 Darwin Kernel Version 20.1.0
	- GNU bash, version 5.0.18(1)-release (x86_64-apple-darwin20.1.0)
	

**How does it work?**

The script has 4 main tasks and it is reponsible to *verify/create* a directory, *download* the [STRIMZI](https://strimzi.io/) code and execute a  *build* to generate a docker image into your local container registry and also remote.

Adding a short info about the tasks bellow:

**Tasks**

 1. **Directory's** tasks - It verifies if directory exits otherwise it will be created.
	- Check directory *exists*
	- Create a new directory with name (*../source/*) with 0755 permission
	- Remove directory at the end of the script.

 2. **GIT's** task is used to  download STRIMZI code from repository within '*master*' branch.
 3. **Build's** task is used to build the project and it will create local/remote docker's image into container registry. This impor
	- **IMPORTANT**: 
		- If you don't have one already, create an account on the  Docker container Registry. Then log your local Docker client into the Hub using:
    
    ```
	docker login
    ```
	-  Make sure that the  `DOCKER_ORG`  environment variable is set to the same value as your username on Docker Hub.
    ```
     export DOCKER_ORG=docker_username
    ```
 4. **Remove directory** this task is removing the folder *"../source"* created previously.
 

## How to run the script?

To run use the following command:

    ansible-playbook playbooks/scripts/02-download-build-strimzi-source.yaml -e "skip_build=no"

**INFO**: If you want to skip the build just set the extra parameters: skip_build=yes


    ansible-playbook playbooks/scripts/02-download-build-strimzi-source.yaml -e "skip_build=yes"


**Results Logs**

I'm adding the execution logs from my local:

    strimzi-kafka-cluster-automation mariocp$  ansible-playbook playbooks/scripts/02-download-build-strimzi-source.yaml -e "skip_build=no"
    [WARNING]: No inventory was parsed, only implicit localhost is available
    [WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'
    
    PLAY [Download and Build Strimzi project into local/remote container registry.] ****************************************************************
    
    TASK [Gathering Facts] *************************************************************************************************************************
    ok: [localhost]
    
    TASK [Check directory exists] ******************************************************************************************************************
    ok: [localhost]
    
    TASK [Echo if directory already exist] *********************************************************************************************************
    ok: [localhost] => {
        "msg": "The directory is already exist"
    }
    
    TASK [Create project directory and set its permissions] ****************************************************************************************
    ok: [localhost]
    
    TASK [Checkout Git repository] *****************************************************************************************************************
    changed: [localhost]
    
    TASK [Building Strimzi source and generate image.] *********************************************************************************************
    skipping: [localhost]
    
    TASK [debug] ***********************************************************************************************************************************
    ok: [localhost] => {
        "build_result.stdout_lines": "VARIABLE IS NOT DEFINED!"
    }
    
    TASK [Remove directory] ************************************************************************************************************************
    skipping: [localhost]
    
    PLAY RECAP *************************************************************************************************************************************
    localhost                  : ok=6    changed=1    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0