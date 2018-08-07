#!/bin/sh
#title           :task.sh
#description     :task manager for specific stuff designed by quera.ir for rahnema college internship.
#author		     :Ali Piry <yripila@gmail.com>
#usage		     :bash task.sh
#==============================================================================

if [ ! -f tasks.txt ]; then
    touch tasks.txt
fi

if [[ $1 = "add" ]] || [[ $1 = "list" ]] || [[ $1 = "done" ]]; then
  if [ $1 == "add" ]; then
    if [[ ! -n ${@:2} ]]; then
      (>&2 echo "[Error] This command needs an argument")
      exit 1
    else
      var=${@:2}
      input=$(echo "$var" | tr '[:upper:]' '[:lower:]')
      if [[ $input = *"(important)"* ]]; then
        task_priority="M"
      elif [[ $input = *"(very important)"* ]]; then
        task_priority="H"
      else
        task_priority="L"
      fi
      echo "$task_priority ${@:2}" >> tasks.txt
      lineNumber=$(wc -l < tasks.txt)
      lineNumber=${lineNumber// /}
      echo "Added task $lineNumber with priority $task_priority"
    fi
  fi

  if [[ $1 == "list" ]]; then
    if [[ ! -s tasks.txt ]]; then
      echo "No tasks found..."
    fi
    filename="tasks.txt"
    while read -r line
    do
        count=$((count+1))
        name="$line"

        if [[ $line = *"L"* ]]; then
          name="*     ${name:2}"
        elif [[ $line = *"M"* ]]; then
          name="***   ${name:2}"
        elif [[ $line = *"H"* ]]; then
          name="***** ${name:2}"
        fi
        echo "$count $name"
    done < "$filename"
  fi

  if [[ $1 == "done" ]]; then
    if [[ ! -n ${@:2} ]]; then
      (>&2 echo "[Error] This command needs an argument")
      exit 1
    else
      name=$(sed -n $2p tasks.txt)
      sed -i '.bak' $2d "tasks.txt"
      echo "Completed task $2: ${name:2}"
    fi
  fi
else
  (>&2 echo "[Error] Invalid command")
  exit 1
fi
