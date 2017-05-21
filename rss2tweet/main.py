from rss2tweet.feeds import Feed, FeedService, FeedStorage
import tweepy
import time
import re
import yaml

with open('twitter_keys.secret.yaml') as f:
  twitter_config = yaml.load(f)

def send_status(msg):
  auth = tweepy.OAuthHandler(twitter_config['consumer_key'], twitter_config['consumer_secret'])
  auth.set_access_token(twitter_config['access_token'], twitter_config['access_token_secret'])
  twitter = tweepy.API(auth)
  twitter.update_status(status=msg)
  time.sleep(61)

def main():
  feed_service = FeedService('http://www.mol.fi/tyopaikat/tyopaikkatiedotus/haku/tyopaikat.rss?vuokrapaikka=---&hakusanakentta=sanahaku&alueet=Lappi%2C+&oppisopimus=false&lang=fi&ilmoitettuPvm=1&hakusana=')

  feed = Feed("Työtä pohjoisessa",
              feed_service,
              FeedStorage("last.rss"))
  entries = feed.get_new_entries()
  entries = sorted(entries, key=lambda entry: entry.published)

  for entry in entries:
    if not entry.title.startswith("Lisää ilmoituksia"):
      kunta = entry.title.split(', ')[-1].strip()
      message = "%s %s #työpaikat #%s" % (entry.title, entry.link, kunta)
      send_status(message)

if __name__ == '__main__':
  main()
