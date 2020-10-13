def add_author(result_set, data):
   if isinstance(data, dict) and "name" in data:
      result_set.add(data["name"])
   elif isinstance(data, str):
      result_set.add(data)

def get_authors_entry(result_set, entry):
   if "authors" in entry:
      for author in entry["authors"]:
         add_author(result_set, author)

   if "author" in entry:
      add_author(result_set, entry["author"])

   if "author_detail" in entry:
      add_author(result_set, entry["author_detail"])


def get_authors_feed(result_set, parsed_feed):

   for entry in parsed_feed["entries"]:
      get_authors_entry(result_set, entry)
