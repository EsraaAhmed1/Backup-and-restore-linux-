if [ $# -ne 2 ]
then 
	echo "Enter 2 parameters please"
fi

dir="$1"
backup_dir="$2"

temp_array=($(find "$backup_dir" -mindepth 1 -maxdepth 1 -type d ! -path "$backupdir" -printf "%T@ %p\n" | sort -n | cut -d' ' -f2-))

array=()
for entry in "${temp_array[@]}"; do
    array+=("${entry#* }") 
done


for direc in "${array[@]}"
do 
	echo "$direc"
done

array_length=${#array[@]}
current_index=`expr $array_length - 1`
source_timestamp=$(stat -c %Y "$dir")

for i in "${!array[@]}"
do 
	destination_timestamp=$(stat -c %Y "${temp_array[i]}")
	if [ "$source_timestamp" -eq "$destination_timestamp" ]
	then
		current_index=$i
		break
	fi
done


while true 
do
	echo "Enter 1: if you want to restore previous version"
    	echo "Enter 2: if you want to restore next version"
    	echo "Enter 3: if you want to exit"
    	
    	read digit
    	
    	if [ "$digit" -eq 1 ]
    	then
    		if [ "$current_index" -le 0 ]
    		then
    			echo "No older backup available to restore"
    		else
    			previous_index=`expr $current_index - 1`
    			previous="${array[$previous_index]}"
    			rsync -a --delete "$previous"/ "$dir"/
    			echo "Restored to previous version: ${array[previous_index]}"
    			current_index="$previous_index"
    		fi
    	elif [ "$digit" -eq 2 ]
    	then
    		if [ "$current_index" -ge `expr $array_length - 1` ]
    		then
    			echo "$current_index"
    			echo "No newer backup available to restore"
    		else
    			echo "$current_index"
    			next_index=`expr $current_index + 1`
    			next="${array[$next_index]}"
    			rsync -a --delete "$next"/ "$dir"/
    			echo "Restored to next version: ${array[next_index]}"
    			current_index="$next_index"
    		fi
    	elif [ "$digit" -eq 3 ]
    	then
    		break
    	else
    		echo "Invalid input : Enter 1 or 2 or 3"
    	fi
done
    		
