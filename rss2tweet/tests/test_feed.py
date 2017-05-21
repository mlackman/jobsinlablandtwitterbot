import unittest
import yamf
from rss2tweet import feeds
from rss2tweet.tests import sample_feeds


class TestFeed(unittest.TestCase):

  def setUp(self):
    self.feed_service_mock = yamf.Mock(feeds.FeedService)
    self.feed_storage_mock = yamf.Mock(feeds.FeedStorage)
    self.feed = feeds.Feed("feeder", self.feed_service_mock, self.feed_storage_mock)

  def test_when_no_feed_in_storage_all_entries_in_rss_are_new(self):
    self.feed_service_mock.read_feed.returns(sample_feeds.feed1)
    self.feed_storage_mock.feed_exists.returns(False)
    self.assertEquals(2, len(list(self.feed.get_new_entries())))

  def test_when_all_feeds_in_storage_then_no_new_feeds(self):
    self.feed_storage_mock.feed_exists.returns(True)
    self.feed_storage_mock.get.returns(sample_feeds.feed1)
    self.feed_service_mock.read_feed.returns(sample_feeds.feed1)
    self.assertEquals(0, len(list(self.feed.get_new_entries())))





