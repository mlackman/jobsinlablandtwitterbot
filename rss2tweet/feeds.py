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

class Feed(object):

  def __init__(self, name, feed_url, old_feed_filename, entry_factory_method=None):
    self.entry_factory_method = entry_factory_method or (lambda rssentry: Entry(rssentry,{"title":str, "link":str, "published":dateutil.parser.parse }))
    self.name = name
    self.feed_url = feed_url
    self.old_feed_filename = old_feed_filename

  def get_new_entries(self):
    old_entries = self._get_old_entries()
    all_entries = self.get_all_entries()
    return filter(lambda entry: entry not in old_entries, all_entries)

  def get_all_entries(self):
    content = self._read_feed()
    self._write_to_disk(content)
    return self._parse_rss(content)

  def _get_old_entries(self):
    old_entries = []
    if os.path.exists(self.old_feed_filename):
      old_entries = self._parse_rss(self._read_feed_from_file())
    return old_entries

  def _write_to_disk(self, content):
    with open(self.old_feed_filename, 'w', encoding='utf-8') as f:
      f.write(content)

  def _parse_rss(self, rss):
    data = feedparser.parse(rss)
    return [self.entry_factory_method(entry) for entry in data.entries]

  def _read_feed_from_file(self):
    with open(self.old_feed_filename, "rt", encoding='utf-8') as f:
      return f.read()

  def _read_feed(self):
    response = requests.get(self.feed_url)
    if response.status_code != 200:
      raise "GOT status %d" % response.status_code
    print(response.text)
    return response.text


