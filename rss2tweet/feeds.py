import requests
import dateutil.parser
import feedparser
import os

class Entry(object):

  def __init__(self, feed_entry:dict, fields:dict):
    self._feed_entry = feed_entry

    self._field_names = []
    for name,klass in fields.items():
      self._field_names.append(name)
      setattr(self, name, klass(feed_entry[name]))
    self._field_names.sort()

  def __str__(self):
    representation = ""
    for field in self._field_names:
      representation += "%s: %s\n" % (field, getattr(self, field))
    return representation

  def __eq__(self, other):
    return str(self) == str(other)

class FeedService(object):
  """Reads RSS feed from given url"""

  def __init__(self, url):
    self._url = url

  def read_feed(self):
    response = requests.get(self._url)
    if response.status_code != 200:
      raise "GOT status %d" % response.status_code
    print(response.text)
    return response.text

class FeedStorage(object):

  def __init__(self, filename):
    self._filename = filename

  def feed_exists(self):
    """Checks if feed exists in storage"""
    return os.path.exists(self._filename)

  def get(self):
    with open(self._filename, "rt", encoding='utf-8') as f:
      return f.read()

  def store(self, content):
    with open(self._filename, 'w', encoding='utf-8') as f:
      f.write(content)

class Feed(object):

  def __init__(self, name, feed_service, feed_storage, entry_factory_method=None):
    self.entry_factory_method = entry_factory_method or (lambda rssentry: Entry(rssentry,{"title":str, "link":str, "published":dateutil.parser.parse }))
    self.name = name
    self._feed_service = feed_service
    self._feed_storage = feed_storage

  def get_new_entries(self):
    old_entries = self._get_old_entries()
    all_entries = self.get_all_entries()
    return filter(lambda entry: entry not in old_entries, all_entries)

  def get_all_entries(self):
    content = self._feed_service.read_feed()
    self._feed_storage.store(content)
    return self._parse_rss(content)

  def _get_old_entries(self):
    old_entries = []
    if self._feed_storage.feed_exists():
      old_entries = self._parse_rss(self._feed_storage.get())
    return old_entries

  def _parse_rss(self, rss):
    data = feedparser.parse(rss)
    return [self.entry_factory_method(entry) for entry in data.entries]

