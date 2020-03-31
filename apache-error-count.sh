

# capture apache log file specified via commandline in the variable `url`
url="$1"

# output contents of url into file named `apachelogfile.txt`
curl $url -o apachelogfile.txt

# count number of error responses between 400 & 500 
# save into variable `count`
count=$(awk '($9 >= 400) && ($9 <= 500) {print $9}' apachelogfile.txt | sort | uniq -c | awk '{sum+=$1} END{print sum}')

# format date into variable `date` to be used as subject for email
date=$(date '+%Y-%m-%d %H:%M:%S')

# if count is greater than 100... send mail
if [ $count -gt 100 ]
then
	echo "SENDING MAIL - $date"
	mail -s "Apache Error Report - $date" test@email.com <<< Number of HTTP 4xx/5xx Error responses: $count
fi


# 2. on a linux machine, you can use the command `crontab -e` (might need to preface with sudo)
# use something like
# 00 00 * * * /path/to/apache-error-count.sh
# This command runs `apache-error-count.sh` at midnight everyday