files=`git diff-tree --no-commit-id --name-only -r 2a22fa75c9755e302385893bb3c1de684e0579ca`

if [[ $file = *'src/classes/'* ]]; then
	sed "s/\(<members.*>\)[^<>]*\(<\/members.*\)/\1$files\2/" src/package.xml
fi