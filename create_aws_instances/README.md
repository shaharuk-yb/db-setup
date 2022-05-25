
# Create instances on AWS

### Prerequisites
- install terraform https://learn.hashicorp.com/tutorials/terraform/install-cli 
```shell
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

- install aws cli and configure on your machine(since this terraform script considers you have local aws config done)
```shell
create_aws_instances $aws configure
AWS Access Key ID [****************ABCD]:
AWS Secret Access Key [****************pqrs]:
Default region name [us-west-2]:
Default output format [None]:
```

### How to
- clone this repo
```shell
git clone git@github.com:shaharuk-yb/db-setup.git
cd db-setup/create_aws_instance
```

- initialize terrraform
```shell
terraform init
```

- change variable.tf file according to values applicable to your account. You can also override these defaults at runtime.

- create instances
```shell
terrform apply --auto-approve -lock=false
```

- destroy instances
```shell
terraform  destroy --auto-approve -lock=false
```

### NOTE: If you run destroy, the instances your created from current directory will get destroyed. If you want to create instance in another az by changing the variables, it will be good idea to run that in another directory.