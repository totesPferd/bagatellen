def get_authors(result_set, parsed_feed):

   for entry in parsed_feed["entries"]:
      if "authors" in entry.keys():
         for author in entry["authors"]:
            result_set.add(author["name"])
      elif "author" in entry.keys():
         result_set.add(author)
