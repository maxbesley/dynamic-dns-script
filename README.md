# Simple Dynamic DNS

This repo contains a small Bash script which makes sure that the IPv4 address of a
[Cloudflare](https://cloudflare.com) domain matches the IPv4 address of the host machine.
If the IP addresses already match then the script will do nothing.


## Usage

You can run the script once with

```
bash sync_dns.bash
```

However the script is meant to be run as a cron job.

So run the command

```
sudo crontab -e
```

Then paste in something like

```
0 5 * * * bash sync_dns.bash
```

Which will run the script every single day at 5:00AM.


## License

This code is made available under the [MIT License](https://opensource.org/licenses/MIT).
