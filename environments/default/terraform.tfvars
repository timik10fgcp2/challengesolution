org_id = "217318466844"
service_folder_id = "1092037491882"
billing_accnt_id ="0120E3-B61230-46D05F"
hostproject="hostproject-341120" # means host project id
serviceprojectname="serviceproject"
serviceprojectid="serviceproject-28456748530" # type in something unique or just use random id in project factory module

# please note the below many variables are actually lists
# it is done for rapid scenario testing - imagine you need 2 vms on sub3 behind the load balancer
# just  change  sub3vms = ["private-vm1"] to sub3vms = ["private-vm1","private-vm2"]
# similarly for subnets+cidrranges+regions
# please note that it is user responsibility to verify intergrity - e.g. the number of regions shoud match the number of subnets
regions = ["us-west1","us-west2","us-west3","us-west4"]
subnetnames=["sub1","sub2","sub3","sub4"]
cidrranges=["10.0.0.0/24","10.0.1.0/24","10.0.2.0/24","10.0.3.0/24"]
allowinternet = "public" # that's a tag for vms that should be accesible from internet
subnetswithnat = ["sub3"]
sub1vms = ["public-vm1"]
sub3vms = ["private-vm1"]
machine_type = "e2-micro"
backendtag = "backend"