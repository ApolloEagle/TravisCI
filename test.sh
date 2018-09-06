# for file in `git diff-tree --no-commit-id --name-only -r $TRAVIS_COMMIT`
# do
# 	echo $file
# done

while read -r line;
do
	echo $line
done < package.xml