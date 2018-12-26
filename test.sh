echo '<?xml version="1.0" encoding="UTF-8"?>
<Package xmlns="http://soap.sforce.com/2006/04/metadata">
    <version>43.0</version>
</Package>' > src/package.xml

# for files in `git diff-tree --no-commit-id --name-only -r $TRAVIS_COMMIT` #For TravisCI
for files in `git diff --name-only $GIT_PREVIOUS_COMMIT $GIT_COMMIT` #For Jenkins
do
	if [[ $files = *"src/classes/"* ]]
	then
		class=true
		classes+=( ${files#*src/classes/} )
	fi

	if [[ $files = *"src/triggers/"* ]]
	then
		trigger=true
		triggers+=( ${files#*src/triggers/} )
	fi

	if [[ $files = *"src/pages/"* ]]
	then
		page=true
		pages+=( ${files#*src/pages/} )
	fi

	if [[ $files = *"src/objects/"* ]]
	then
		object=true
		objects+=( ${files#*src/objects/} )
	fi
done

if [[ $class ]]; then
	mkdir deploy/classes
	for (( i=0; i<${#classes[@]}; i++)) 	
	do
		cp -r src/classes/${classes[i]} deploy/classes/${classes[i]}
		cp -r src/classes/${classes[i]}-meta.xml deploy/classes/${classes[i]}-meta.xml
	done

	sed -i '/<version>/i \\t<types>\n\t\t<name>ApexClass</name>\n\t</types>' deploy/package.xml
	for (( i=0; i<${#classes[@]}; i++))
	do
		sed -i '/ApexClass/i \\t\t<members>'${classes[$i]:0:-4}'</members>' deploy/package.xml
	done
fi

if [[ $trigger ]]; then
	mkdir deploy/triggers
	for (( i=0; i<${#triggers[@]}; i++)) 	
	do
		cp -r src/triggers/${triggers[i]} deploy/triggers/${triggers[i]}
		cp -r src/triggers/${triggers[i]}-meta.xml deploy/triggers/${triggers[i]}-meta.xml
	done

	sed -i '/<version>/i \\t<types>\n\t\t<name>ApexTrigger</name>\n\t</types>' deploy/package.xml
	for (( i=0; i<${#triggers[@]}; i++))
	do
		sed -i '/ApexTrigger/i \\t\t<members>'${triggers[$i]:0:-8}'</members>' deploy/package.xml
	done
fi

if [[ $page ]]; then
	mkdir deploy/pages
	for (( i=0; i<${#pages[@]}; i++)) 	
	do
		cp -r src/pages/${pages[i]} deploy/pages/${pages[i]}
	done

	sed -i '/<version>/i \\t<types>\n\t\t<name>ApexPage</name>\n\t</types>' deploy/package.xml
	for (( i=0; i<${#pages[@]}; i++))
	do
		sed -i '/ApexPage/i \\t\t<members>'${pages[$i]:0:-5}'</members>' deploy/package.xml
	done
fi

if [[ $object ]]; then
	mkdir deploy/objects
	for (( i=0; i<${#objects[@]}; i++)) 	
	do
		cp -r src/objects/${objects[i]} deploy/objects/${objects[i]}
	done

	sed -i '/<version>/i \\t<types>\n\t\t<name>CustomObject</name>\n\t</types>' deploy/package.xml
	for (( i=0; i<${#objects[@]}; i++))
	do
		sed -i '/CustomObject/i \\t\t<members>'${objects[$i]:0:-7}'</members>' deploy/package.xml
	done
fi