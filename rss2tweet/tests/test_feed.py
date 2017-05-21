import unittest
import yamf
from rss2tweet import feeds
from rss2tweet.tests import sample_feeds


class TestFeed(unittest.TestCase):


  def test_when_no_feed_in_storage_all_entries_in_rss_are_new(self):
    feed_service_mock = yamf.Mock(feeds.FeedService)
    feed_storage_mock = yamf.Mock(feeds.FeedStorage)

    feed_service_mock.read_feed.returns(sample_feeds.feed1)
    feed_storage_mock.feed_exists.returns(False)
    feed = feeds.Feed("feeder", feed_service_mock, feed_storage_mock)

    self.assertEquals(2, len(list(feed.get_new_entries())))




