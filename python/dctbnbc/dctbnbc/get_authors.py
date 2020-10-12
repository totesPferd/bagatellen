def add_author(result_set, data):
   if isinstance(data, dict) and "name" in data.keys():
      result_set.add(data["name"])
   elif isinstance(data, str):
      result_set.add(data)

def get_authors_entry(result_set, entry):
   if "authors" in entry.keys():
      for author in entry["authors"]:
         add_author(result_set, author)
   elif "author" in entry.keys():
      add_author(result_set, author)


def get_authors_feed(result_set, parsed_feed):

   for entry in parsed_feed["entries"]:
      get_authors_entry(result_set, entry)
