#!/bin/bash

# Function to get the CPU utilization
get_cpu_utilization() {
  # Get the average CPU utilization over 1 minute
  cpu_util=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
  echo $cpu_util
}

# Function to get the memory utilization
get_memory_utilization() {
  # Get memory utilization
  mem_util=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
  echo $mem_util
}

# Function to get the disk utilization
get_disk_utilization() {
  # Get disk utilization for the root partition
  disk_util=$(df / | grep / | awk '{print $5}' | sed 's/%//g')
  echo $disk_util
}

# Function to determine health status
determine_health_status() {
  cpu_util=$(get_cpu_utilization)
  mem_util=$(get_memory_utilization)
  disk_util=$(get_disk_utilization)
  
  if (( $(echo "$cpu_util < 60" | bc -l) )) && (( $(echo "$mem_util < 60" | bc -l) )) && (( $(echo "$disk_util < 60" | bc -l) )); then
    health_status="Healthy"
  else
    health_status="Not Healthy"
  fi

  if [[ $1 == "explain" ]]; then
    echo "CPU Utilization: $cpu_util%"
    echo "Memory Utilization: $mem_util%"
    echo "Disk Utilization: $disk_util%"
  fi

  echo "Health Status: $health_status"
}

# Main script execution
if [[ $1 == "explain" ]]; then
  determine_health_status "explain"
else
  determine_health_status
fi
