SERVER = ubuntu-twitter
ZIP = workinginlapland.zip
USER = workinnordictwitter
APPDIR = rss2tweet_$(shell date +%s)


help:
	To deploy run 'make deploy'

deploy: upload
	ssh -t $(SERVER) "sudo su - $(USER) -c 'mkdir $(APPDIR) && cd $(APPDIR) && unzip /tmp/$(ZIP) && cd .. && ln -s $(APPDIR)/ rss2tweet'"
	ssh -t $(SERVER) "sudo su - $(USER) -c 'cd rss2tweet && python3 -m venv venv'"


upload: zip
	scp $(ZIP) $(SERVER):/tmp

zip:
	zip -r $(ZIP) rss2tweet/ requirements.txt twitter_keys.secret.yaml
