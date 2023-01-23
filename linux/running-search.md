# Useful Linux commands related to SEARCH

## Simple search for file names

```
find . -name "filename*.txt"
```
## Search for keywords in files - recursively

```
grep -rnw . -e ".*keyword.*"
```
[source](https://stackoverflow.com/questions/16956810/how-to-find-all-files-containing-specific-text-string-on-linux)

```
grep --include=\*.{json,xml} -rnw . -e ".*keyword.*"
```

[source](https://stackoverflow.com/questions/30800963/how-to-search-for-a-text-in-specific-files-in-unix)