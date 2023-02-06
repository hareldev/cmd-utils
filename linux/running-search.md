# Useful Linux commands related to SEARCH

## Simple search for file names
[source](https://stackoverflow.com/questions/5905054/how-can-i-recursively-find-all-files-in-current-and-subfolders-based-on-wildcard)

```
find . -name "filename*.txt" 2>/dev/null
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