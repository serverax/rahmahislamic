# Firestore seed data

Sample documents for each collection. Two ways to use these:

1. **Manual paste in Firebase Console** — copy the JSON object, click
   "Add document" in the relevant collection, and paste the fields
   one-by-one. Tedious but works without any tooling.

2. **Programmatic seed** — point the Python scraper at
   `C:\Users\kalsh\rahma_scraper\database.py` (with `serviceAccountKey.json`
   set up) at these JSON files. Faster.

Each `*.example.json` here contains 1-3 sample documents in the shape
described in `../firestore_schemas/`.
