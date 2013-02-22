use inc::Module::Install;

name 'Crontab-Interval';
all_from 'lib/Crontab/Interval.pm';
# requires '';
tests 't/*.t';
author_tests 'xt';
test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
