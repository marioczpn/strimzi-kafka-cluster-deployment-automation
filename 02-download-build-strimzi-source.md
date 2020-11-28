

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

    ansible-playbook playbooks/scripts/02-download-build-strimzi-source.yaml

**Results**

Adding the execution logs executed from my local:

   