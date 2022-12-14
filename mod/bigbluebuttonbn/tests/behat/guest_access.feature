@mod @mod_bigbluebuttonbn
Feature: Guest access allows external users to connect to a meeting

  Background:
    Given a BigBlueButton mock server is configured
    And I enable "bigbluebuttonbn" "mod" plugin
    And the following "courses" exist:
      | fullname      | shortname | category |
      | Test Course 1 | C1        | 0        |
    And the following "activities" exist:
      | activity        | name                    | intro                           | course | idnumber         | type | recordings_imported | guestallowed |
      | bigbluebuttonbn | RoomRecordings          | Test Room Recording description | C1     | bigbluebuttonbn1 | 0    | 0                   | 0            |
      | bigbluebuttonbn | RoomRecordingsWithguest | Test Room with guest            | C1     | bigbluebuttonbn1 | 0    | 0                   | 1            |

  @javascript
  Scenario: I need to enable guest access to see the instance parameters
    Given the following config values are set as admin:
      | bigbluebuttonbn_guestaccess_enabled | 1 |
    When I am on the "RoomRecordings" "bigbluebuttonbn activity editing" page logged in as "admin"
    Then I should see "Guest access"
    Then I log out
    Given the following config values are set as admin:
      | bigbluebuttonbn_guestaccess_enabled | 0 |
    When I am on the "RoomRecordings" "bigbluebuttonbn activity editing" page logged in as "admin"
    Then I should not see "Guest access"
    Then I log out

  @javascript
  Scenario: I should see Guest settings on the module form
    Given the following config values are set as admin:
      | bigbluebuttonbn_guestaccess_enabled | 1 |
    When I am on the "RoomRecordings" "bigbluebuttonbn activity editing" page logged in as "admin"
    Then I should see "Guest access"
    Then I click on "Expand all" "link"
    Then I should see "Allow guest access in the meeting"
    And I should not see "Meeting link"
    And I should not see "Meeting password"
    When I set the field "Allow guest access in the meeting" to "1"
    Then I should see "User must be approved by moderators"
    And I should see "Meeting link"
    And I should see "Meeting password"
    And I should see "Copy link"
    And I should see "Copy password"
    Then I log out

  @javascript
  Scenario: I should be able to invite guest to the meeting
    Given the following config values are set as admin:
      | bigbluebuttonbn_guestaccess_enabled | 1 |
    When I am on the "RoomRecordingsWithguest" "bigbluebuttonbn activity" page logged in as "admin"
    Then I should see "Add guests"
    And I click on "Add guests" "button"
    And I should see "Meeting link"
    And I should see "Meeting password"
    And I should see "Copy link"
    And I should see "Copy password"
    When I set the field "Add guests emails" to "123"
    When I click on "OK" "button" in the "Add guests to this meeting" "dialogue"
    Then I should see "The email 123 is invalid, please correct it."
    When I set the field "Add guests emails" to "testuser@email.com"
    When I click on "OK" "button" in the "Add guests to this meeting" "dialogue"
    Then I should see "An invitation will be sent to guest(s) testuser@email.com via email."
    Then I log out
