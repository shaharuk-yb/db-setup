# Deploy CockroachDB Cluster With Ansible 

## Prerequisites

- Configure ./hostfiles/inventory file with entries for the machines in your cluster. It should include all the machines you want to include in your setup.
  Also include the varables for region and datacenter, where your machines are located. (NOTE: this is just a logical separation, it actually depends on where your instance is)
    ```bash
        [nyc]
        <ip1>
        <ip2>
  
        [sfo]
        <ip1>
        <ip2>
        
        [tor]
        <ip1>
        <ip2>
        
        [all:vars]
        ansible_python_interpreter=/usr/bin/python3
        region=us
        
        [nyc:vars]
        datacenter=nyc
        
        [sfo:vars]
        datacenter=sfo
        
        [tor:vars]
        datacenter=tor
    ```   

## Deploy/Destroy/Stop/Start/Restart/soft_destroy
NOTE: 
1. If the second argument(hostfile) is not provided, then ./hostfiles/inventory is picked up by default.
2. You also need to set the PEM file argument in manage.sh file/provide it next to hostfile argument

- To deploy the cluster:
```bash
./manage.sh deploy <hostfile>
```


- To stop the cluster: 
```bash
./manage.sh stop <hostfile>
```    
- To start the cluster:
```bash
./manage.sh start <hostfile>
```
- To restart the cluster:
```bash
./manage.sh restart <hostfile>
```
- To destroy the cluster(this will delete all data)
```bash
./manage.sh destroy <hostfile> 
``` 
- To soft_destroy: This removes cluster and data but not the cockroach installation.
This helps in faster redeployments
```bash
./manage.sh soft_destroy <hostfile> 
``` 

- To introduce chaos by killing some node randomly. This is will kill the precesses from any random host for 120 seconds. After 120 seconds it will be back up. 
Current iteration count is 10, means this will execute 10 times; each time killing random node.
Change chaos_time from ./group_vars/all.yml to modify the amount of time the node will be down.
```bash
./manage.sh chaos
```

## Directory Structure

After the deployment of the cluster, the directory structure on cluster nodes will look like this:

- *~/cockroach/data/*: Cockroach store.This includes all the data 

- *~/cockroach/conf/*: This includes redirected output files and scripts. For internal use only.

# Introducing CHAOS in the clusters.
Chaos is created by randomly killing a node in the cluster(by killing all cockroach processes on the node) for 2 minutes.
After 2 minutes the node will be back up again.

To introduce chaos in the clusters use:
```bash
./manage.sh chaos
```

NOTE:
- Number of iterations: 10 (Every iteration will kill the random node)
- Time for which the node will be down: default 2 minutes. Can be configured by changing "chaos_time" from ./group_vars/all.yml
- The chaos uses ./hostfiles/inventory hosts entries as cluster nodes. In case if you want to exclude certain nodes from getting killed, just comment them out in inventory.  







 