#! /bin/bash

API_CHANGED_OVERALL=false
COMPONENTS_CHANGED_OVERALL=false
REACT_CHANGED_OVERALL=false
API_CHANGED=false
COMPONENTS_CHANGED=false
REACT_CHANGED=false

echo "***** Current namespace is: $NAMESPACE"

if [[ $NAMESPACE = "release" ]]; then
  # Get changes since previous tag:
  git diff $(git tag --sort version:refname | tail -n 2 | head -n 1) $(git tag --sort version:refname | tail -n 1) --name-only  >> commit_diff.txt
else
  # Get changes since previous commit:
  git diff HEAD^ HEAD --name-only >> commit_diff.txt
  # Get changes since diverged from master:
  git diff master...$CF_BRANCH --name-only >> overall_diff.txt
fi

echo "***** Changes since previous commit:"
cat commit_diff.txt

echo "***** Changes since diverged from master (overall changes):"
cat overall_diff.txt

grep -P '(packages/api)|(k8s/kustomize/api)' commit_diff.txt && API_CHANGED=true
grep -P '(packages/api)|(k8s/kustomize/api)' overall_diff.txt && API_CHANGED_OVERALL=true

# If components changes, React relies on it, so React changed:
grep -P '(packages/components)|(k8s/kustomize/components)' commit_diff.txt && COMPONENTS_CHANGED=true && REACT_CHANGED=true
grep -P '(packages/components)|(k8s/kustomize/components)' overall_diff.txt && COMPONENTS_CHANGED_OVERALL=true && REACT_CHANGED_OVERALL=true

grep -P '(packages/react)|(k8s/kustomize/react)' commit_diff.txt && REACT_CHANGED=true
grep -P '(packages/react)|(k8s/kustomize/react)' overall_diff.txt && REACT_CHANGED_OVERALL=true

echo "***** Changes since previous commit:"
echo "Api - ${API_CHANGED}"
echo "Components - ${COMPONENTS_CHANGED}"
echo "React - ${REACT_CHANGED}"

echo "***** Changes since diverged from master (overall changes):"
echo "Api - ${API_CHANGED_OVERALL}"
echo "Components - ${COMPONENTS_CHANGED_OVERALL}"
echo "React - ${REACT_CHANGED_OVERALL}"

export API_CHANGED COMPONENTS_CHANGED REACT_CHANGED API_CHANGED_OVERALL COMPONENTS_CHANGED_OVERALL REACT_CHANGED_OVERALL
cf_export API_CHANGED COMPONENTS_CHANGED REACT_CHANGED API_CHANGED_OVERALL COMPONENTS_CHANGED_OVERALL REACT_CHANGED_OVERALL

