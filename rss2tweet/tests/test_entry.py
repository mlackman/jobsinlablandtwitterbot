import unittest
from rss2tweet.feeds import Entry


class TestEntry(unittest.TestCase):

  def test_constructing(self):
    entry = Entry({"title":"mytitle", "age":"5"}, {"title":str, "age":int})
    self.assertEqual(entry.title, "mytitle")
    self.assertEqual(entry.age, 5)

  def test_entries_are_equals(self):
    entry1 = Entry({"title":"mytitle", "age":"5"}, {"title":str, "age":int})
    entry2 = Entry({"title":"mytitle", "age":"5"}, {"title":str, "age":int})
    self.assertEqual(entry1, entry2)

  def test_entries_are_not_equals(self):
    entry1 = Entry({"title":"othertitle", "age":"5"}, {"title":str, "age":int})
    entry2 = Entry({"title":"mytitle", "age":"5"}, {"title":str, "age":int})
    self.assertNotEqual(entry1, entry2)

  def test_presentation(self):
    s = str(Entry({"title":"othertitle", "age":"5"}, {"title":str, "age":int}))
    self.assertEquals(s, "age: 5\ntitle: othertitle\n")





