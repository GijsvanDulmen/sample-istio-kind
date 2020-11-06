#!/bin/bash
kubectl -n default apply -f ./gateway.yml
kubectl -n default apply -f ./virtualservice.yml

cd simple-deployment
./install.sh

cd ..
cd rocksolid
./install.sh

cd ..
kubectl -n default apply -f ./needhelp
kubectl -n default apply -f ./security

./run.sh