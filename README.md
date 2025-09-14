# Sample Code for Null Error

This is a sample project to recreate an issue I'm hitting with the [swift-sharing](https://github.com/pointfreeco/swift-sharing) library.

I have 2 tables in SQLite with a one-to-many relationship. I want a collection of all of the `OneRecord` rows, and I want to sort them by the number of `ManyRecord` rows which reference them. But when I launch the application, I get:

```
Caught error: Expected column 2 ("manyCount") to not be NULL: …

SELECT "oneRecords"."id", "oneRecords"."name" AS "one", count("manyRecords"."id") AS "manyCount" FROM "oneRecords" LEFT JOIN "manyRecords" ON ("oneRecords"."id" = "manyRecords"."oneId") ORDER BY count("manyRecords"."id") DESC, "oneRecords"."name"
```
