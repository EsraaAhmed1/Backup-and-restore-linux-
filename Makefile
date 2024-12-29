backup_dir := /home/esraa-ahmed/8162-lab2/lab2/backupdir
source_dir := /home/esraa-ahmed/8162-lab2/lab2/test
interval_secs := 5
max_backups := 3 

backup: pre-build
	@bash backupd.sh $(source_dir) $(backup_dir) $(interval_secs) $(max_backups)

restore: pre-build
	@bash restore.sh $(source_dir) $(backup_dir) 

pre-build:
	@if [ ! -d "$(backup_dir)" ]; then \
		echo "creating backup directory"; \
		mkdir -p "$(backup_dir)"; \
	fi

