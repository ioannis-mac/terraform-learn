# terraform-learn

This script is created for using Azure Cloud Provider to create:
 1) One resource group
 2) Virtual Machine with public IP address
 3) Virtual Network
 4) Virtual Subnet Mask
 5) Network Interface

The goal is to add a block named "lifecycle" with "ignore_changes" on the size. This will prevent changes on size when any modifications on it are detected, giving the ability of better "permission" managing on the machine.

Clone the project and 


Execute: 

    $ terraform init
    $ terraform plan
    $ terraform apply

Then, run the following command to note down the time of the machine creation: 

    $ az vm list --resource-group from-terraform-ioannis-resources | grep timeCreated

Then, try to change the size on the script and execute:

    $ terraform plan
    $ terraform apply

Notice that the changes are not taken under account. You can verify by running the following command: 

    $ az vm list --resource-group from-terraform-ioannis-resources | grep vmSize

or by connecting via a browser on Azure Portal and checking on the VM there.

Now, change the size of the VM manually by running the command: 

    $  az vm resize --resource-group from-terraform-ioannis-resources --name from-terraform-ioannis-vm --size Standard_DS2_v2

Then, check again, and verify that the timeCreated is still the same:

    $ az vm list --resource-group from-terraform-ioannis-resources | grep timeCreated