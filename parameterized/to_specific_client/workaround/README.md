# A gross workaround

This is a very gross workaround to synthesize some things I have learned recently.


It leverages:

- ugly shell script
- python
- Nomad HCL2


```bash
RunOutput=`nomad job run -var node_id=f7bc1f2d-34b1-eaf8-b7d3-253f2e7de4d6 example.nomad`
AllocId=$(echo "$RunOutput" | awk '/Allocation/{ print $2}'| tr -d "\"")
if []
then
	echo "No allocation found"
	exit 1
fi

FullAllocId=$(nomad alloc status -verbose $AllocId | grep -e '^ID' | awk '{print $3}')