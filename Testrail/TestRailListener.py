#!/usr/bin/env python
#!/usr/bin/env python
# -*- coding: utf-8 -*-

import json
import re
import requests
import os
from builtins import int
from robot.api import logger
from TestRailAPIClient import TestRailAPIClient


class TestRailListener(object):
    """Fixing of testing results and update test case in [ http://www.gurock.com/testrail/ | TestRail ].

    == Dependencies ==
    | past | https://pypi.org/project/past/ |
    | requests | https://pypi.python.org/pypi/requests |
    | robot framework | http://robotframework.org |

    == Preconditions ==
    1. [ http://docs.gurock.com/testrail-api2/introduction | Enable TestRail API] \n
    2. Create custom field "case_description" with type "text", which corresponds to the Robot Framework's test case documentation.

    == Example ==
    1. Create test case in TestRail with case_id = 10\n
    2. Add it to test run with id run_id = 20\n
    3. Create autotest in Robot Framework
    | *** Settings ***
    | *** Test Cases ***
    | Autotest name
    |    [Documentation]    Autotest documentation
    |    [Tags]    testrailid=10    defects=BUG-1, BUG-2    references=REF-3, REF-4
    |    Fail    Test fail message
    4. Run Robot Framework with listener:\n
    | set ROBOT_SYSLOG_FILE=syslog.txt
    | pybot.bat --listener TestRailListener.py:testrail_server_name:tester_user_name:tester_user_password:20:https:update  autotest.robot
    5. Test with case_id=10 will be marked as failed in TestRail with message "Test fail message" and defects "BUG-1, BUG-2".
    Also title, description and references of this test will be updated in TestRail. Parameter "update" is optional.
    """

    ROBOT_LISTENER_API_VERSION = 2
    #    ROBOT_LISTENER_API_VERSION = 3
    ELAPSED_KEY = 'elapsed'
    TESTRAIL_CASE_TYPE_ID_AUTOMATED = 1
    TESTRAIL_TEST_STATUS_ID_PASSED = 1
    TESTRAIL_TEST_STATUS_ID_FAILED = 5

    def __init__(self, server, user, password, run_id, protocol='http', juggler_disable=None, update=None, hosted=None,
                 project_id=None, suite_id=None, vienna_version=None, device_version=None):
        """Listener initialization.
        *Args:*\n
            _server_ - name of TestRail server;\n
            _user_ - name of TestRail user;\n
            _password_ - password of TestRail user;\n
            _run_id_ - ID of the test run; If set to "new" a new run will be created (requires project_id and suite_id arguments)\n
            _protocol_ - connecting protocol to TestRail server: http or https;\n
            _juggler_disable_ - indicator to disable juggler logic; if exist, then juggler logic will be disabled;\n
            _update_ - indicator to update test case in TestRail; if exist, then test will be updated.\n
            _hosted_ - indicator to not use testrail in API url\n
            _project_id - ID of the test project to create a run under, required if creating a new run.\n
            _suite_id_ - ID of the test suite to create a test run for, required if creating a new run.
        """
        if hosted:
            testrail_url = '{protocol}://{server}/'.format(protocol=protocol, server=server)
        else:
            testrail_url = '{protocol}://{server}/testrail/'.format(protocol=protocol, server=server)
        self._url = testrail_url + 'index.php?/api/v2/'
        self._user = user
        self._password = password
        self.run_id = run_id
        self.juggler_disable = juggler_disable
        self.update = update
        self.vienna_version = vienna_version
        self.device_version = device_version
        self.results = list()

        if hosted:
            self.tr_client = TestRailAPIClient(server, user, password, run_id, protocol, hosted=hosted,
                                               project_id=project_id, suite_id=suite_id)
        else:
            self.tr_client = TestRailAPIClient(server, user, password, run_id, protocol, project_id=project_id,
                                               suite_id=suite_id)
        self.run_id = self.tr_client.run_id
        self._vars_for_report_link = None
        logger.info('[TestRailListener] url: {testrail_url}'.format(testrail_url=testrail_url))
        logger.info('[TestRailListener] user: {user}'.format(user=user))
        logger.info('[TestRailListener] the ID of the test run: {run_id}'.format(run_id=run_id))

    def end_test(self, name, attrs):
        """
        Update test case in TestRail

        *Args:*\n
        _name_ - the name of test case in Robot Framework\n
        _attrs_ - attributes of test case in Robot Framework
        """
        tags_value = self._get_Tags_Value(attrs['tags'])
        case_id = tags_value['testrailid']
        defects = tags_value['defects']
        references = tags_value['references']
        # old_test_status_id = self.tr_client.get_test_status_id_by_case_id(self.run_id, case_id)
        test_result1 = self._prepare_test_result(attrs, defects, '3', case_id)
        if attrs['status'] == 'PASS':
            status_id = 1
        else:
            status_id = 5

        if case_id:
            # Add results to list
            test_result = {
                'case_id': case_id,
                'status_id': status_id,
                'comment': test_result1['comment'],
                'defects': defects
            }
            self.results.append(test_result)
            # Update test case
            if int(self.update) == 1:
                # print(self.update)
                logger.info('[TestRailListener] update of test ' + case_id + ' in TestRail')
                description = attrs['doc'] + '\n' + 'Path to test: ' + attrs['longname']

                result = self.tr_client._send_post(
                    'update_case/' + case_id,
                    {
                        'title': name,
                        'type_id': 1,
                        'custom_case_description': description,
                        'refs': references
                    }
                )
                logger.info(
                    '[TestRailListener] result for method update_case '
                    + json.dumps(result, sort_keys=True, indent=4)
                )
                tag = 'testRailId={case_id}'.format(case_id=case_id)
                logger.info('[TestRailListener] remove tag {tag} from test case report'.format(tag=tag))
                try:
                    self.tr_client._send_post('add_results_for_cases/' + self.run_id, {'results': self.results})
                except:
                    print("Error")

                self.results.clear()

        def end_test(self, name, attrs):
            pass

    ############################# New Function with the latest Testrail Changes ###########################
    def close(self):
        """
        Save test results for all tests in TestRail
        """
        pass
        # self.tr_client._send_post('add_results_for_cases/' + self.run_id, {'results': self.results})

    ############################# New Function with the Latest TestRail Changes ####################
    def _get_Tags_Value(self, tags):
        """
        Get value from robot framework's tags for TestRail.
        """
        attributes = dict()
        matchers = ['testrailid', 'defects', 'references']
        for matcher in matchers:
            for tag in tags:
                match = re.match(matcher, tag)
                if match:
                    split_tag = tag.split('=')
                    tag_value = split_tag[1]
                    attributes[matcher] = tag_value
                    break
                else:
                    attributes[matcher] = None
        return attributes

    def _update_case_description(self, attributes, case_id, name, references):
        """ Update test case description in TestRail

        *Args:* \n
            _attributes_ - attributes of test case in Robot Framework;\n
            _case_id_ - case id;\n
            _name_ - test case name;\n
            _references_ - test references.
        """
        logger.info(u"[TestRailListener] update of test {} in TestRail".format(case_id))
        description = u"{}\nPath to test: {}".format(attributes['doc'], attributes['longname'])
        request_fields = {'title': name, 'type_id': self.TESTRAIL_CASE_TYPE_ID_AUTOMATED,
                          'custom_case_description': description, 'refs': references,
                          'custom_automation': update_automation}
        try:
            json_result = self.tr_client.update_case(case_id, request_fields)
            result = json.dumps(json_result, sort_keys=True, indent=4)
            logger.info(u"[TestRailListener] result for method update_case " + result)
        except requests.HTTPError as error:
            logger.error(u"[TestRailListener] http error, while execute request:\n{0}".format(error))

    def _prepare_test_result(self, attributes, defects, old_test_status_id, case_id):
        """Create json with test result information.

        *Args:* \n
            _attributes_ - attributes of test case in Robot Framework;\n
            _defects_ - list of defects;\n
            _old_test_status_id_ - old test status id;\n
            _case_id_ - test case ID.

        *Returns:*\n
            Dictionary with test results.
        """
        link_to_report = self._get_url_report_by_case_id(case_id)
        test_time = float(attributes['elapsedtime']) / 1000
        comment = u'Autotest name: {0}\nMessage: {1}\nTest time: {2:.3f} s'.format(
            attributes['longname'], attributes['message'], test_time)
        if link_to_report:
            comment += u'\nLink to Report: {}'.format(link_to_report)
        if self.juggler_disable:
            if attributes['status'] == 'PASS':
                new_test_status_id = self.TESTRAIL_TEST_STATUS_ID_PASSED
            else:
                new_test_status_id = self.TESTRAIL_TEST_STATUS_ID_FAILED
        else:
            new_test_status_id = self._prepare_new_test_status_id(attributes['status'], old_test_status_id)
        test_result = {
            'status_id': new_test_status_id,
            'comment': comment
        }
        elapsed_time = TestRailListener._time_span_format(test_time)
        if elapsed_time:
            test_result[TestRailListener.ELAPSED_KEY] = elapsed_time
        if defects:
            test_result['defects'] = defects
        return test_result

    def _prepare_new_test_status_id(self, new_test_status, old_test_status_id):
        """Prepare new test status id by new test status and old test status id.
        Alias of this method is "juggler".
        If new test status is "PASS", new test status id is "passed".
        If new test status is "FAIL" and old test status id is null or "passed" or "failed",
        new test status id is "failed".
        In all other cases new test status id is equal to old test status id.

        *Args:* \n
            _new_test_status_ - new test status;\n
            _old_test_status_id_ - old test status id.

        *Returns:*\n
            New test status id.
        """
        if new_test_status == 'PASS':
            new_test_status_id = self.TESTRAIL_TEST_STATUS_ID_PASSED
        elif (new_test_status == 'FAIL' and
              old_test_status_id in
              (self.TESTRAIL_TEST_STATUS_ID_PASSED, self.TESTRAIL_TEST_STATUS_ID_FAILED, None)):
            new_test_status_id = self.TESTRAIL_TEST_STATUS_ID_FAILED
        else:
            new_test_status_id = old_test_status_id
        return new_test_status_id

    @staticmethod
    def _get_tags_value(tags):
        """ Get value from robot framework's tags for TestRail.

        *Args:* \n
            _tags_ - list of tags.

        *Returns:* \n
            Dict with attributes.
        """
        attributes = dict()
        matchers = ['testrailid', 'defects', 'references']
        print(matchers)
        for matcher in matchers:
            for tag in tags:
                match = re.match(matcher, tag)
                if match:
                    split_tag = tag.split('=')
                    print(split_tag)
                    tag_value = split_tag[1]
                    print(tag_value)
                    attributes[matcher] = tag_value
                    break
                else:
                    attributes[matcher] = None
        return attributes

    @staticmethod
    def _time_span_format(seconds):
        """ Format seconds to time span format.

        *Args:*\n
            _seconds_ - time in seconds.

        *Returns:*\n
            Time formatted in Time span.
        """
        if isinstance(seconds, float):
            seconds = int(seconds)
        elif not isinstance(seconds, int):
            seconds = 0
        if seconds <= 0:
            return ''
        s = seconds % 60
        res = "{}s".format(s)
        seconds -= s
        if seconds >= 60:
            m = (seconds % 60 ** 2) // 60
            res = "{}m {}".format(m, res)
            seconds -= m * 60
        if seconds >= 60 ** 2:
            h = seconds // 60 ** 2
            res = "{}h {}".format(h, res)
        return res

    @staticmethod
    def _get_vars_for_report_link():
        """" Getting value from environment variables for prepare link to report.

        If test cases are started by means of CI, then must define the environment variables
        in the CI configuration settings to getting url to the test case report.
        The following variables are used:
            for Teamcity - TEAMCITY_HOST_URL, TEAMCITY_BUILDTYPE_ID, TEAMCITY_BUILD_ID, REPORT_ARTIFACT_PATH,
            for Jenkins  - JENKINS_BUILD_URL.
        If these variables are not found, then the link to report will not be formed.

        == Example ==
        1. for Teamcity
        |    Changing build configuration settings
        |    REPORT_ARTIFACT_PATH     output
        |    TEAMCITY_BUILD_ID        %teamcity.build.id%
        |    TEAMCITY_BUILDTYPE_ID    %system.teamcity.buildType.id%
        |    TEAMCITY_HOST_URL        https://teamcity.billing.ru

        2. for Jenkins
        |    add to the shell the execution of the docker container parameter
        |    -e "JENKINS_BUILD_URL = ${BUILD_URL}"

        *Returns:*\n
            Dictionary with environment variables results.
        """
        variables = {}
        env_var = os.environ or {}
        if 'TEAMCITY_HOST_URL' in env_var:
            try:
                teamcity_vars = {'TEAMCITY_HOST_URL',
                                 'TEAMCITY_BUILDTYPE_ID',
                                 'TEAMCITY_BUILD_ID',
                                 'REPORT_ARTIFACT_PATH'}
                variables = {var: env_var[var] for var in teamcity_vars}
            except KeyError:
                logger.error(u"[TestRailListener] There are no variables for getting a link to the report by tests.")
        elif 'JENKINS_BUILD_URL' in env_var:
            variables = {'JENKINS_BUILD_URL': env_var['JENKINS_BUILD_URL']}
        return variables

    @property
    def vars_for_report_link(self):
        """Get variables for report link.

        Saves environment variables information once and then returns cached values.

        *Returns:*\n
            Cached variables for report link.
        """
        if not self._vars_for_report_link:
            self._vars_for_report_link = self._get_vars_for_report_link()
        return self._vars_for_report_link

    def _get_url_report_by_case_id(self, case_id):
        """" Getting url for Report by id test case.

        *Args:* \n
            _case_id_ - test case ID.

        *Returns:*\n
            Report URL.
        """
        build_url = ''
        report_uri = 'report.html#search?include=testrailid={case_id}'.format(case_id=case_id)
        if 'TEAMCITY_HOST_URL' in self.vars_for_report_link:
            vars = self.vars_for_report_link
            base_hostname = vars.get('TEAMCITY_HOST_URL')
            buildtype_id = vars.get('TEAMCITY_BUILDTYPE_ID')
            build_id = vars.get('TEAMCITY_BUILD_ID')
            report_artifact_path = vars.get('REPORT_ARTIFACT_PATH')
            build_url = ('{base_hostname}/repository/download/{buildtype_id}'
                         '/{build_id}:id/{report_artifact_path}').format(base_hostname=base_hostname,
                                                                         buildtype_id=buildtype_id,
                                                                         build_id=build_id,
                                                                         report_artifact_path=report_artifact_path)
        elif 'JENKINS_BUILD_URL' in self.vars_for_report_link:
            build_url = self.vars_for_report_link.get('JENKINS_BUILD_URL') + 'robot/report'
        return '{build_url}/{report_uri}'.format(build_url=build_url, report_uri=report_uri) if build_url else None
