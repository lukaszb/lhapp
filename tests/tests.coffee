lhapp = require '../index'
chai = require 'chai'
chai.should()


describe 'lhapp.Client', ->
    client = null

    beforeEach ->
        client = new lhapp.Client('foobar', 'TOKEN')

    describe '.constructor', ->

        it 'should store name', ->
            client.name.should.equal 'foobar'

        it 'should store token', ->
            client.token.should.equal 'TOKEN'

    describe '.getUrl', ->

        it 'should respect given path', ->
            expected = "http://foobar.#{lhapp.BASE_URL}/projects.json?_token=TOKEN"
            client.getUrl('projects').should.equal expected

        it 'should respect format', ->
            expected = "http://foobar.#{lhapp.BASE_URL}/projects.xml?_token=TOKEN"
            client.getUrl('projects', {format: 'xml'}).should.equal expected

        it 'should respect params', ->
            expected = "http://foobar.#{lhapp.BASE_URL}/projects.json?_token=TOKEN&foo=bar&id=102"
            client.getUrl('projects', {params: {foo: 'bar', id: 102}}).should.equal expected

        it 'should respect both format and params', ->
            expected = "http://foobar.#{lhapp.BASE_URL}/projects.xml?_token=TOKEN&foo=bar&id=102"
            client.getUrl('projects', {format: 'xml', params: {foo: 'bar', id: 102}}).should.equal expected

