Feature: `strip` command
  The `strip` command will strip trailing whitespace in all files in the given
  path

  If the path is omitted it will default to using the current directory.

  The `--ignored-paths` flag can be used to specify a list of paths that will be
  ignored. By default the following paths will be ignored: ".git", ".svn" and
  ".hg"

  Scenario: Invoking `strip` with a file containing trailing whitespace
    Given a file named "foo.txt" with:
      """
      foo    
      """
    When I successfully run `ws strip`
    Then the file "foo.txt" should contain:
      """
      foo
      """

  Scenario: Invoking `strip` with a file without trailing whitespace
    Given a file named "foo.txt" with:
      """
      foo
      bar
      """
    When I successfully run `ws strip`
    Then the file "foo.txt" should contain:
      """
      foo
      bar
      """

  Scenario: Invoking `strip` with a file in the `.git` path
    Given a file named ".git/foo.txt" with:
      """
      foo    
      """
    When I successfully run `ws strip`
    Then the file ".git/foo.txt" should contain:
      """
      foo    
      """

  Scenario: Using the `--ignored-paths` flag
    Given a file named "foo/a.txt" with:
      """
      bar    
      """
    And a file named "b.txt" with:
      """
      foo    
      """
    When I successfully run `ws strip --ignored-paths foo`
    Then the file "foo/a.txt" should contain:
      """
      bar    
      """
    And the file "b.txt" should contain:
      """
      foo
      """
