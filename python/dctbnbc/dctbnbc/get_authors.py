def get_authors_entry(result_set, entry):
   if "authors" in entry.keys():
      for author in entry["authors"]:
         if "name" in author.keys():
            result_set.add(author["name"])
   elif "author" in entry.keys():
      result_set.add(author)


def get_authors_feed(result_set, parsed_feed):

   for entry in parsed_feed["entries"]:
      get_authors_entry(result_set, entry)
