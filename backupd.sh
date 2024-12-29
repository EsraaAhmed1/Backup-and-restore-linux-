if [ "$#" -ne 4 ]
then
	echo "Enter 4 parameters please"
fi

dir="$1"
backupdir="$2"
interval_secs="$3"
max_backups="$4"

ls -lR "$dir" > "$backupdir/directory-info.last"
current_interval=$(date +"%Y-%m-%d-%H-%M-%S")
cp -r "$dir" "$backupdir/$current_interval"

while true; do

	sleep "$interval_secs"
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
done

	
		
	
