describe 'Roboconf grammar', ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage('language-roboconf')

    runs ->
      grammar = atom.syntax.grammarForScopeName('source.roboconf.graph')


  describe 'grammar check', ->
    it 'parses the graph grammar', ->
      expect(grammar).toBeTruthy()
      expect(grammar.scopeName).toBe 'source.roboconf.graph'


  describe 'component declaration', ->
    it 'tokenizes a component declaration', ->
      lines = grammar.tokenizeLines '''
        my-component {
          installer: target;
          # this is a comment
          exports: ip, port;  # this is an inline comment
        }
      '''

      expect(lines[0][0]).toEqual value: 'my-component {', scopes: ['source.roboconf.graph']

      expect(lines[1][1]).toEqual value: 'installer:', scopes: ['source.roboconf.graph','keyword.other.graph']
      expect(lines[1][2]).toEqual value: ' target;', scopes: ['source.roboconf.graph']

      expect(lines[2][1]).toEqual value: '#', scopes: ['source.roboconf.graph','comment.line']
      expect(lines[2][2]).toEqual value: ' this is a comment', scopes: ['source.roboconf.graph','comment.line']

      expect(lines[3][1]).toEqual value: 'exports:', scopes: ['source.roboconf.graph','keyword.other.graph']
      expect(lines[3][2]).toEqual value: ' ip, port;  ', scopes: ['source.roboconf.graph']
      expect(lines[3][3]).toEqual value: '#', scopes: ['source.roboconf.graph','comment.line']
      expect(lines[3][4]).toEqual value: ' this is an inline comment', scopes: ['source.roboconf.graph','comment.line']


  describe 'import declaration', ->
    it 'tokenizes an import declaration', ->
      lines = grammar.tokenizeLines '''
        import toto.graph; # in-line comment with import
      '''

      expect(lines[0][0]).toEqual value: 'import', scopes: ['source.roboconf.graph','entity.tag.global']
      expect(lines[0][1]).toEqual value: ' toto.graph; ', scopes: ['source.roboconf.graph']
      expect(lines[0][2]).toEqual value: '#', scopes: ['source.roboconf.graph','comment.line']
      expect(lines[0][3]).toEqual value: ' in-line comment with import', scopes: ['source.roboconf.graph','comment.line']


  describe 'big graph declaration', ->
    it 'tokenizes a big graph declaration', ->
      lines = grammar.tokenizeLines '''
        import toto.graph; # in-line comment with installer keyword

        facet deployable {
          exports: ip, port = 8082;#comment
        }

        # This is a comment

        VM {
          installer   : target;
          children: deployable;
          iMportS: OS.*;
        }
      '''

      expect(lines[0][0]).toEqual value: 'import', scopes: ['source.roboconf.graph','entity.tag.global']
      expect(lines[0][1]).toEqual value: ' toto.graph; ', scopes: ['source.roboconf.graph']
      expect(lines[0][2]).toEqual value: '#', scopes: ['source.roboconf.graph','comment.line']
      expect(lines[0][3]).toEqual value: ' in-line comment with installer keyword', scopes: ['source.roboconf.graph','comment.line']

      expect(lines[2][0]).toEqual value: 'facet', scopes: ['source.roboconf.graph','entity.tag.global']
      expect(lines[2][1]).toEqual value: ' deployable {', scopes: ['source.roboconf.graph']

      expect(lines[3][1]).toEqual value: 'exports:', scopes: ['source.roboconf.graph','keyword.other.graph']
      expect(lines[3][2]).toEqual value: ' ip, port = 8082;', scopes: ['source.roboconf.graph']
      expect(lines[3][3]).toEqual value: '#', scopes: ['source.roboconf.graph','comment.line']
      expect(lines[3][4]).toEqual value: 'comment', scopes: ['source.roboconf.graph','comment.line']

      expect(lines[4][0]).toEqual value: '}', scopes: ['source.roboconf.graph']

      expect(lines[6][0]).toEqual value: '#', scopes: ['source.roboconf.graph','comment.line']
      expect(lines[6][1]).toEqual value: ' This is a comment', scopes: ['source.roboconf.graph','comment.line']

      expect(lines[8][0]).toEqual value: 'VM {', scopes: ['source.roboconf.graph']

      expect(lines[9][1]).toEqual value: 'installer', scopes: ['source.roboconf.graph','keyword.other.graph']
      expect(lines[9][2]).toEqual value: '   : target;', scopes: ['source.roboconf.graph']

      expect(lines[10][1]).toEqual value: 'children:', scopes: ['source.roboconf.graph','keyword.other.graph']
      expect(lines[10][2]).toEqual value: ' deployable;', scopes: ['source.roboconf.graph']

      expect(lines[11][1]).toEqual value: 'iMportS:', scopes: ['source.roboconf.graph','keyword.other.graph']
      expect(lines[11][2]).toEqual value: ' OS.*;', scopes: ['source.roboconf.graph']

      expect(lines[12][0]).toEqual value: '}', scopes: ['source.roboconf.graph']
