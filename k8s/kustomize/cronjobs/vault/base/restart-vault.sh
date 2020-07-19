#!/bin/bash

kubectl rollout restart deployment/vault && kubectl rollout status deployment/vault

