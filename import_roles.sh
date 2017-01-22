#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"

roles_dir="$SCRIPT_DIR/roles"
roles_list=(`cat "$SCRIPT_DIR/roles.list"`)

git_url_matching="^((git|ssh|http(s)?)|(git@[\w\.]+))(:(//)?)"

if [ ! -d $roles_dir ]; then
  mkdir $roles_dir
fi

echo "git cloning roles..."
for role in "${roles_list[@]}"
do 
  if [[ "$role" =~ $git_url_matching ]]; then
    cd "$roles_dir" && git clone $role 
  fi 
done

echo "git update..."
cd "$roles_dir"
for dir in `ls $roles_dir`
do
  echo -n "$dir : " &&  cd $roles_dir/$dir && git pull
done
