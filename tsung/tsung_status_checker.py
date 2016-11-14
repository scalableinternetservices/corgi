import sys
import spur
import time
import spur.ssh

if (len(sys.argv) < 5):
	print "Usage py tsung_status_checker <pem_file> <tsung_host> <ping_interval> <ping_count>"
	exit(1)

pem_file = sys.argv[1]
tsung_host = sys.argv[2]
ping_interval = int(sys.argv[3])
ping_count = int(sys.argv[4])

ec2_shell = spur.SshShell(
	hostname=tsung_host,
	username="ec2-user",
	private_key_file=pem_file,
	missing_host_key=spur.ssh.MissingHostKey.accept
)
tsung_status_call = "tsung status"

def ping_tsung():
	status = ec2_shell.run(["tsung", "status"])
	print status.output
	time.sleep(ping_interval)

for i in range(ping_count):
	ping_tsung()