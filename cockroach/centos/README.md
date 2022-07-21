## Creating CockroachDB instances

This is a two-step process
1. Create instances
2. deploy CRDB on those instances


### Create Instances
- clone this repo and change dir
- Install terraform
    - Macos
      ```shell
        brew tap hashicorp/tap
        brew install hashicorp/tap/terraform
      ```
  
    - centos
        ```shell
        sudo yum install -y yum-utils
        sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
        sudo yum -y install terraform
      ```
- Initialize terraform.
    ```shell
    terraform init
    ```

- create inputs.json file with following syntax.
    ```shell
      {
        "region": "us-west-2",
        "az": "us-west-2a",
        "node_count": "1",
        "ami": "ami-0821373572f69d497",
        "instance_type": "c5.large",
        "pem_file_name": "<key-name>",
        "pem_file_path": "<path-to-file>/<key-name>.pem",
        "security_group": ["<your-sg>"],
        "subnet_id": "<your-subnet>",
        "user": "<username>"
      }
    ```
    NOTE: Please don't check in above inputs.json to github with actual values


- create instances
    ```shell
    terraform apply -var-file=inputs.json
    # it will ask to confirm the installation
  ```

### Manage CRDB
create instances step creates an inventory file which is provided as input to the setup scripts

- Install ansible
  - macos
    ```shell
    brew install ansible
    ```
  - centos
    ```shell
    sudo yum install epel-release
    sudo yum install ansible
    ```

#### Deploy/Destroy/Stop/Start/Restart/soft_destroy
NOTE:
2. You also need to set the PEM file argument in manage.sh file/provide it next to hostfile argument

- To deploy the cluster:
```bash
./manage.sh deploy <pem_file_path>
```


- To stop the cluster:
```bash
./manage.sh stop <pem_file_path>
```    
- To start the cluster:
```bash
./manage.sh start <pem_file_path>
```
- To restart the cluster:
```bash
./manage.sh restart <pem_file_path>
```
- To destroy the cluster(this will delete all data)
```bash
./manage.sh destroy <pem_file_path>
``` 
- To soft_destroy: This removes cluster and data but not the cockroach installation.
  This helps in faster re-deployments
```bash
./manage.sh soft_destroy <pem_file_path>
``` 

- To introduce chaos by killing some node randomly. This is will kill the precesses from any random host for 120 seconds. After 120 seconds it will be back up.
  Current iteration count is 10, means this will execute 10 times; each time killing random node.
  Change chaos_time from ./group_vars/all.yml to modify the amount of time the node will be down.
```bash
./manage.sh chaos <pem_file_path>
```

#### Directory Structure

After the deployment of the cluster, the directory structure on cluster nodes will look like this:

- *~/cockroach/data/*: Cockroach store.This includes all the data

- *~/cockroach/conf/*: This includes redirected output files and scripts. For internal use only.

#### Introducing CHAOS in the clusters.
Chaos is created by randomly killing a node in the cluster(by killing all cockroach processes on the node) for 2 minutes.
After 2 minutes the node will be back up again.

To introduce chaos in the clusters use:
```bash
./manage.sh chaos <pem_file_path>
```

NOTE:
- Number of iterations: 10 (Every iteration will kill the random node)
- Time for which the node will be down: default 2 minutes. Can be configured by changing "chaos_time" from ./group_vars/all.yml
- The chaos uses ./inventory hosts entries as cluster nodes. In case if you want to exclude certain nodes from getting killed, just comment them out in inventory.  


### Destroy/Delete the infrastructure

```shell
terraform destroy -var-file=inputs.json
```