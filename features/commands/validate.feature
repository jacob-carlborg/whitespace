Feature: `validate` command
  The `validate` command will report all files in the given path which contain
  lines with trailing whitespace. Each line with trailing whitespace will be
  reported with: the filename, the line number and the content. The trailing
  whitespace will be highlighted with a background color.

  If the path is omitted it will default to using the current directory.

  If tailing whitespace are reported it will exit with a non-zero exit code.

  The `--ignored-paths` flag can be used to specify a list of paths that will be
  ignored. By default the following paths will be ignored: ".git", ".svn" and
  ".hg"

  Scenario: Invoking `validate` with a file containing trailing whitespace
    Given a file named "foo.txt" with:
      """
      Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
      tempor incididunt ut labore    
      """
    When I run `ws validate`
    Then the output should contain "foo.txt:2:tempor incididunt ut labore    "
    And the exit status should not be 0

  Scenario: Invoking `validate` with a file without trailing whitespace
    Given a file named "foo.txt" with:
      """
      Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
      tempor incididunt ut labore
      """
    When I run `ws validate`
    Then the output should not contain "foo.txt:2:tempor incididunt ut labore    "
    And the exit status should be 0

  Scenario: Invoking `validate` with a file in the `.git` path
    Given a file named ".git/foo.txt" with:
      """
      Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
      tempor incididunt ut labore    
      """
    When I run `ws validate`
    Then the output should not contain ".git/foo.txt:2:tempor incididunt ut labore    "
    And the exit status should be 0

  Scenario: Using the `--ignored-paths` flag
    Given a file named "foo/a.txt" with:
      """
      bar    
      """
    And a file named "b.txt" with:
      """
      foo    
      """
    When I run `ws validate --ignored-paths foo`
    Then the output should contain "b.txt:1:foo    "
    And the output should not contain "foo/a.txt:1:bar    "

