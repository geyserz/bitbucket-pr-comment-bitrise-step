#!/usr/bin/env bash
#set -e
set -o pipefail

if [[ "${is_debug}" == 'yes' ]]; then
	set -x
fi

echo
echo "BitBucket Config:"
echo "- url: $bitbucket_url"
echo "- user: $bitbucket_user"
echo "- password: $(if [ ! -z ${bitbucket_password+x} ]; then echo "****"; fi)"
echo "- owner: ${bitbucket_owner}"
echo "- repo slug: ${bitbucket_repo_slug}"
echo "- PR id: ${bitbucket_pr_id}"
echo "- comment: ${bitbucket_pr_comment}"

# Required input validation
if [[ "${bitbucket_url}" == "" ]]; then
	echo
	echo "No bitbucket_url provided. Terminating..."
	echo
	exit 1
fi

if [[ "${bitbucket_user}" == "" ]]; then
	echo
	echo "No bitbucket_user provided. Terminating..."
	echo
	exit 1
fi

if [[ "${bitbucket_password}" == "" ]]; then
	echo
	echo "No bitbucket_password provided. Terminating..."
	echo
	exit 1
fi

if [[ "${bitbucket_owner}" == "" ]]; then
	echo
	echo "No bitbucket_owner provided. Terminating..."
	echo
	exit 1
fi

if [[ "${bitbucket_repo_slug}" == "" ]]; then
	echo
	echo "No bitbucket_repo_slug provided. Terminating..."
	echo
	exit 1
fi

if [[ "${bitbucket_pr_id}" == "" ]]; then
	echo
	echo "No bitbucket_pr_id provided. Terminating..."
	echo
	exit 1
fi

if [[ "${bitbucket_pr_comment}" == "" ]]; then
	echo
	echo "No bitbucket_pr_comment provided. Terminating..."
	echo
	exit 1
fi

res="$(jq -n -r '{content: { raw: env.bitbucket_pr_comment, markup: "markdown" } }' | curl --write-out %{response_code} --output /dev/null --user "${bitbucket_user}:${bitbucket_password}" -X POST -H "Content-Type: application/json" -d @- https://${bitbucket_url}/2.0/repositories/$bitbucket_owner/$bitbucket_repo_slug/pullrequests/$bitbucket_pr_id/comments)"

if test "$res" == "201"; then
    echo
    echo "--- Posted comment to BitBucket PR successfully"
    echo "---------------------------------------------------"
    exit 0
else
   echo "the curl command failed with: $res"
   exit 1
fi
