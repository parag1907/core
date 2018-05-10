@api
Feature: remove subadmin
As an admin
I want to be able to remove subadmin rights to a user from a group
So that I cam manage administrative access rights for groups

	Background:
		Given using API version "1"

	Scenario: Removing subadmin from a group
		Given user "brand-new-user" has been created
		And group "new-group" has been created
		And user "brand-new-user" has been made a subadmin of group "new-group"
		When user "admin" sends HTTP method "DELETE" to API endpoint "/cloud/users/brand-new-user/subadmins" with body
			| groupid | new-group |
		Then the OCS status code should be "100"
		And the HTTP status code should be "200"

	Scenario: subadmin tries to remove other subadmin in the group
		Given user "subadmin" has been created
		And group "new-group" has been created
		And user "subadmin" has been made a subadmin of group "new-group"
		And user "newsubadmin" has been created
		And user "newsubadmin" has been made a subadmin of group "new-group"
		When user "subadmin" sends HTTP method "DELETE" to API endpoint "/cloud/users/newsubadmin/subadmins" with body
			| groupid | new-group |
		Then the OCS status code should be "997"
		And the HTTP status code should be "401"

	Scenario: normal user tries to remove subadmin in the group
		Given user "subadmin" has been created
		And user "newuser" has been created
		And group "new-group" has been created
		And user "subadmin" has been made a subadmin of group "new-group"
		And user "newuser" has been added to group "new-group"
		When user "newuser" sends HTTP method "DELETE" to API endpoint "/cloud/users/subadmin/subadmins" with body
			| groupid | new-group |
		Then the OCS status code should be "997"
		And the HTTP status code should be "401"