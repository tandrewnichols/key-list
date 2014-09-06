describe 'key-list', ->
  afterEach -> delete @subject.open
  afterEach -> delete @subject.close
  Given -> @subject = require '../lib/key-list'

  context 'default pattern', ->
    Given -> @str = 'some test to be {{ interpolated }} where the interpolation may or may not have {{spaces}}'
    When -> @list = @subject.getKeys @str
    Then -> expect(@list).to.deep.equal ['interpolated', 'spaces']

  context 'mustache', ->
    Given -> @str = 'some test to be {{ interpolated }} where the interpolation may or may not have {{spaces}}'
    When -> @list = @subject.getKeys @str, 'mustache'
    Then -> expect(@list).to.deep.equal ['interpolated', 'spaces']

  context 'ejs', ->
    Given -> @str = 'some test to be <%= interpolated %> where the interpolation may or may not have <%=spaces%>'
    When -> @list = @subject.getKeys @str, 'ejs'
    Then -> expect(@list).to.deep.equal ['interpolated', 'spaces']

  context 'coffee', ->
    Given -> @str = 'some test to be #{ interpolated } where the interpolation may or may not have #{spaces}'
    When -> @list = @subject.getKeys @str, 'coffee'
    Then -> expect(@list).to.deep.equal ['interpolated', 'spaces']

  context 'razor', ->
    Given -> @str = 'some test to be @interpolated where the interpolation does not have @spaces'
    When -> @list = @subject.getKeys @str, 'razor'
    Then -> expect(@list).to.deep.equal ['interpolated', 'spaces']

  context 'custom string pattern', ->
    Given -> @str = 'some test to be @| interpolated | where the interpolation does not have @|spaces|'
    When -> @list = @subject.getKeys @str, '@\\|\\s*([a-zA-Z0-9_\\$]+)\\s*\\|'
    Then -> expect(@list).to.deep.equal ['interpolated', 'spaces']

  context 'custom regex pattern', ->
    Given -> @str = 'some test to be @| interpolated | where the interpolation does not have @|spaces|'
    When -> @list = @subject.getKeys @str, /@\|\s*([a-zA-Z0-9_\$]+)\s*\|/g
    Then -> expect(@list).to.deep.equal ['interpolated', 'spaces']

  context 'with open and close', ->
    Given -> @str = 'some test to be @| interpolated | where the interpolation does not have @|spaces|'
    Given -> @subject.open = '@\\|\\s*'
    Given -> @subject.close = '\\s*\\|'
    When -> @list = @subject.getKeys @str
    Then -> expect(@list).to.deep.equal ['interpolated', 'spaces']

  context 'with open but not close', ->
    Given -> @str = 'some test to be {{ interpolated }} where the interpolation does not have {{spaces}}'
    Given -> @subject.open = '@\\|\\s*'
    When -> @list = @subject.getKeys @str
    Then -> expect(@list).to.deep.equal ['interpolated', 'spaces']
