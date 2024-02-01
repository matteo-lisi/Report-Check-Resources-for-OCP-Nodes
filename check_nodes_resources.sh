#!/bin/bash
# Version: 2.0
#
# Author Matteo Lisi
#

# Allocatable and Allocated Resources Report of all NODES
LOG_FILE="nodes_resources.csv"
echo "NodeName;Pods;Unschedulable;TotalCPU;TotalMemory;CPU_Requests;CPU_Requests(%);CPU_Limits;CPU_Limits(%);Memory_Requests;Memory_Requests(%);Memory_Limits;Memory_Limits(%)" | tee "${LOG_FILE}" | column -t -s ';' 
for node in $(oc get nodes -o name | cut -d/ -f2); do
  echo -ne "Process the Node: $node\r"
  oc describe node "$node" | grep -E -A8 "Allocatable|Allocated resources|Taints|Non-terminated Pods" | \
    grep -E "Unschedulable|Non-terminated Pods|cpu|memory" | grep -v MemoryPressure | tr -d "\(\)" | xargs | \
    awk -v NODENAME="$node" '{print NODENAME";"$9";"$2";"$4";"$6";"$13";"$14";"$15";"$16";"$18";"$19";"$20";"$21}' | tee -a "${LOG_FILE}" | column -t -s ';' 
done
column -t -s ';' "${LOG_FILE}"
