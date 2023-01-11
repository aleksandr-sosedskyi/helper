#!/bin/bash

# Set environment variables
if [ $1 = 'prod' ]; then 
    export $(cat ./environment/prod.env | xargs)
elif [ $1 = 'stage' ]; then
    export $(cat ./environment/stage.env | xargs)
else
    exit 0
fi

./create_dump_expect.sh $sudo_password $1
