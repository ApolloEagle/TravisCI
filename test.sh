# CONTENT="<types>\n<members>`git diff-tree --no-commit-id --name-only -r $TRAVIS_COMMIT`</members>\n<name>Test Name</name>\n</types>"


# C=$(echo $CONTENT | sed 's/\//\\\//g')
# sed "/<\/Package>/ s/.*/${C}\n&/" package.xml

sed "/<types>/,/<\/types>/ s/<members>*<\/members>/<members>`git diff-tree --no-commit-id --name-only -r $TRAVIS_COMMIT`<\/members>/g;" package.xml

# while read -r line;
# do
# 	echo $line
# done < package.xml