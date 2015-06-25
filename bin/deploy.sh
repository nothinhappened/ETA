#!/bin/bash
#
#
DEPLOY_DIR="/var/seng499/deploy/seng499"
DEPLOY_LOG="stdout.log"
APP_ENVIRONMENT="staging"

echo "accessing deployment directory..."
cd $DEPLOY_DIR

unset GIT_DIR

echo "discarding any local changes..."
git checkout -- .

echo "fixing permissions..."
sudo chmod -R g+w $DEPLOY_DIR

echo "pulling from git repo..."
git pull >> $DEPLOY_LOG

echo "fixing permissions..."
sudo chmod -R g+w $DEPLOY_DIR

echo "applying any pending database migrations..."
ruby ./bin/rake db:migrate RAILS_ENV=$APP_ENVIRONMENT

echo "executing rails server..."

ruby ./bin/rails server -e $APP_ENVIRONMENT -d -b 0.0.0.0 >> $DEPLOY_LOG

echo "done"

exit 0
