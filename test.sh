for file in `git diff-tree --no-commit-id --name-only -r $TRAVIS_COMMIT`
do
	CONTENT="<types>\n<members>$file</members>\n<name>Test Name</name>\n</types>"
done

C = $(echo $CONTENT | sed 's/\//\\\//g')
sed "/<\/Students>/ s/.*/${C}\n&/" package.xml

while read -r line;
do
	echo $line
done < package.xml