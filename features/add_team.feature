Feature: A team can register to the game
  In order to show everyone that we are the best
  As a team
  I want to be able to register my team
  
  Scenario: Add team
    Given I want to play the game
    When I submit my team name and the url of my computer
    Then I should see that my team was added
    And I should see my team on the leaderboard
    
  Scenario Outline: Team with wrong url
  	Given I want to play the game
  	When I submit my team name and url "<url>"
  	Then I should see an error message with "<error>"
  	And I should not see my team on the leaderboard
  	
  	Examples:
  	| url		       | error 				|
  	|			       | Please add a URL      |
  	| 10.0.0.2:8080    | must start with http: |
  	| http://localhost |  IP address rather than 'localhost' | 
  
  
  Scenario: When added team receives a link to its log
    Given I submitted my team info
    Then I should receive a link to my market requests log
  
  Scenario: Start receiving questions
    Given I am playing
    Then the game master should start sending me question