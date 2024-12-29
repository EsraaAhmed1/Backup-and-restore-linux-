if [ "$#" -ne 3 ]
then
	echo "Enter 3 parameters please"
fi

dir="$1"
backupdir="$2"
max_backups="$3"

ls -lR "$dir" > "$backupdir/directory-info.last"
current_interval=$(date +"%Y-%m-%d-%H-%M-%S")
cp -r "$dir" "$backupdir/$current_interval"


	ls -lR "$dir" > "$backupdir/directory-info.new"
	
	
	if ! diff "$backupdir/directory-info.last" "$backupdir/directory-info.new" > /dev/null;
	then
		current_interval=$(date +"%Y-%m-%d-%H-%M-%S")
		cp -r "$dir" "$backupdir/$current_interval"
		mv "$backupdir/directory-info.new" "$backupdir/directory-info.last"
			
	fi
	
	count=$(($(find "$backupdir" -maxdepth 1 -type d | wc -l) - 1))
	if [ "$count" -gt "$max_backups" ]
	then
	oldest=$(ls -t "$backupdir" | tail -1)
	rm -rf "$backupdir/$oldest"
	fi

	
		
	
