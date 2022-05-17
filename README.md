wajir
=====

Automatically watch Jira issues. Given a JQL query, the currently authenticated
user will be added as a watcher on all resulting issues.


## Usage
The following command adds ‘jira-user@example.com’ as a watcher on all Jira
issues in the “FAKE” project that are not already watched by that user.
Additionally, an email will be delivered to ‘jira-user@example.com’ using the
`/usr/local/bin/maildrop` program for each of those issues, containing the issue
summary, metadata, and description.

	$ wajir \
		--login 'jira-user@example.com' \
		--token 'jp3cy1PFmDiCw73JJO6YL9Dj' \
		--endpoint 'example.atlassian.net' \
		--sendmail '/usr/local/bin/maildrop' \
		--email-to 'jira-user@example.com' \
		'project = "FAKE" AND watcher != currentUser() ORDER BY created ASC'

The program is designed to run at a recurring interval (via `cron` or `launchd`
for example).


## Install
TODO


## Build

	$ git submodule init && git submodule update
	$ make build


## License
Copyright © 2022 Teddy Wing. Licensed under the GNU GPLv3+ (see the included
COPYING file).
