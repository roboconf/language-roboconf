describe 'Roboconf grammar', ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage('language-roboconf')

    runs ->
      grammar = atom.syntax.grammarForScopeName('source.roboconf.instances')


  describe 'grammar check', ->
    it 'parses the instances grammar', ->
      expect(grammar).toBeTruthy()
      expect(grammar.scopeName).toBe 'source.roboconf.instances'


  describe 'simple instance declaration', ->
    it 'tokenizes a simple instance declaration', ->
      lines = grammar.tokenizeLines '''
        instance of VM {
          name: VM 1; # this is an inline comment
          # this is a comment
        }
      '''

      expect(lines[0][0]).toEqual value: 'instance of', scopes: ['source.roboconf.instances','entity.tag.global']
      expect(lines[0][1]).toEqual value: ' VM {', scopes: ['source.roboconf.instances']

      expect(lines[1][1]).toEqual value: 'name:', scopes: ['source.roboconf.instances','keyword.other.instances']
      expect(lines[1][2]).toEqual value: ' VM 1; ', scopes: ['source.roboconf.instances']
      expect(lines[1][3]).toEqual value: '#', scopes: ['source.roboconf.instances','comment.line']
      expect(lines[1][4]).toEqual value: ' this is an inline comment', scopes: ['source.roboconf.instances','comment.line']

      expect(lines[2][1]).toEqual value: '#', scopes: ['source.roboconf.instances','comment.line']
      expect(lines[2][2]).toEqual value: ' this is a comment', scopes: ['source.roboconf.instances','comment.line']

      expect(lines[3][0]).toEqual value: '}', scopes: ['source.roboconf.instances']


  describe 'import declaration', ->
    it 'tokenizes an import declaration', ->
      lines = grammar.tokenizeLines '''
        import toto.instances; # in-line comment with import
      '''

      expect(lines[0][0]).toEqual value: 'import', scopes: ['source.roboconf.instances','entity.tag.global']
      expect(lines[0][1]).toEqual value: ' toto.instances; ', scopes: ['source.roboconf.instances']
      expect(lines[0][2]).toEqual value: '#', scopes: ['source.roboconf.instances','comment.line']
      expect(lines[0][3]).toEqual value: ' in-line comment with import', scopes: ['source.roboconf.instances','comment.line']


  describe 'big definition of instances', ->
    it 'tokenizes a big definition of instances', ->
      lines = grammar.tokenizeLines '''
        import toto.instances; # in-line comment with name keyword

        instance of Vm {
          name: Vm ;
          count: 7;

          instance of Tomcat {
            name : Tomcat;#comment

            # change the port
            port: 8083;

            insTance of App {
              name: app;
            }
          }
        }
      '''

      expect(lines[0][0]).toEqual value: 'import', scopes: ['source.roboconf.instances','entity.tag.global']
      expect(lines[0][1]).toEqual value: ' toto.instances; ', scopes: ['source.roboconf.instances']
      expect(lines[0][2]).toEqual value: '#', scopes: ['source.roboconf.instances','comment.line']
      expect(lines[0][3]).toEqual value: ' in-line comment with name keyword', scopes: ['source.roboconf.instances','comment.line']

      expect(lines[2][0]).toEqual value: 'instance of', scopes: ['source.roboconf.instances','entity.tag.global']
      expect(lines[2][1]).toEqual value: ' Vm {', scopes: ['source.roboconf.instances']

      expect(lines[3][1]).toEqual value: 'name:', scopes: ['source.roboconf.instances','keyword.other.instances']
      expect(lines[3][2]).toEqual value: ' Vm ;', scopes: ['source.roboconf.instances']

      expect(lines[4][1]).toEqual value: 'count:', scopes: ['source.roboconf.instances','keyword.other.instances']
      expect(lines[4][2]).toEqual value: ' 7;', scopes: ['source.roboconf.instances']

      expect(lines[6][1]).toEqual value: 'instance of', scopes: ['source.roboconf.instances','entity.tag.global']
      expect(lines[6][2]).toEqual value: ' Tomcat {', scopes: ['source.roboconf.instances']

      expect(lines[7][1]).toEqual value: 'name', scopes: ['source.roboconf.instances','keyword.other.instances']
      expect(lines[7][2]).toEqual value: ' : Tomcat;', scopes: ['source.roboconf.instances']
      expect(lines[7][3]).toEqual value: '#', scopes: ['source.roboconf.instances','comment.line']
      expect(lines[7][4]).toEqual value: 'comment', scopes: ['source.roboconf.instances','comment.line']

      expect(lines[9][1]).toEqual value: '#', scopes: ['source.roboconf.instances','comment.line']
      expect(lines[9][2]).toEqual value: ' change the port', scopes: ['source.roboconf.instances','comment.line']

      expect(lines[10][1]).toEqual value: 'port:', scopes: ['source.roboconf.instances','keyword.other.instances']
      expect(lines[10][2]).toEqual value: ' 8083;', scopes: ['source.roboconf.instances']

      expect(lines[12][1]).toEqual value: 'insTance of', scopes: ['source.roboconf.instances','entity.tag.global']
      expect(lines[12][2]).toEqual value: ' App {', scopes: ['source.roboconf.instances']

      expect(lines[13][1]).toEqual value: 'name:', scopes: ['source.roboconf.instances','keyword.other.instances']
      expect(lines[13][2]).toEqual value: ' app;', scopes: ['source.roboconf.instances']

      expect(lines[14][0]).toEqual value: '    }', scopes: ['source.roboconf.instances']
      expect(lines[15][0]).toEqual value: '  }', scopes: ['source.roboconf.instances']
      expect(lines[16][0]).toEqual value: '}', scopes: ['source.roboconf.instances']
