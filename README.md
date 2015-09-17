# subunit2sql-box

### What?

A [vagrant](http://docs.vagrantup.com/v2/why-vagrant/index.html) box that after provisioned will provide you with the following:

- [subunit2sql repository] (https://git.openstack.org/cgit/openstack-infra/subunit2sql/) cloned from master or from an specific patch
- development and test dependencies installed
- Mysql and Postgresql databases installed and configured (both needed to run all the tests successfully)

### How?

To run cloning form master:

```
$ bash deploy.sh
```

To run cloning from an specifc patch:

```
$ bash deploy.sh refs/changes/07/224307/3 FETCH_HEAD
```

After it finishes you can connect to the vm and run the tests:

```
$ vagrant ssh
vagrant $ cd subunit2sql
vagrant $ python -m testtools.run discover -t ./ ./subunit2sql/tests
```
