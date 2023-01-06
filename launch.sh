#!/bin/sh
. config-minecraft.sh
cd $SERVER_ROOT
which git
if [ $? -ne 0 ]; then
    echo "Git n'est pas installé !"
	exit 1
fi
which java
if [ $? -ne 0 ]; then
    echo "Java n'est pas installé !"
	exit 1
fi

ls "${MINECRAFT_JAR}"
if [ $? -ne 0 ]; then
    echo "${MINECRAFT_JAR} n'existe pas !"
	exit 1
fi
git_pull_actionned=0
while [ 1 ]; do
	ls "${MINECRAFT_LOCKFILE}"
	if [ $? -eq 0 ]; then
		echo "Minecraft est déjà lancé sur un autre server !\
		Si vous pensez que c'est une erreur, supprimer le fichier '${MINECRAFT_LOCKFILE}'"
		exit 2
	fi
	if [ $git_pull_actionned -ne 0 ]; then
		break
	fi
	git pull
	git_pull_actionned=1
done

touch "${MINECRAFT_LOCKFILE}"
git add .
git commit -m "server is starting"
git push

start

rm -v "${MINECRAFT_LOCKFILE}"
git add .
git commit -m "server is closing"
git push