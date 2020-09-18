# BitBucket PR comment Step

This is a BitRise step for adding a comment to a pull request in BitBucket.

It uses Basic Auth over HTTPS and will require you to enable the API for your instance and provide the following:

* The Bitbucket API host / port
* A username
* A password
* The PR's id, repo and owner - these can all be taken from the default Bitrise variables
* The comment to be posted
* A debug flag for more verbose logging

You should probably create a specific user for this type of activity to prevent user credentials leaking.
