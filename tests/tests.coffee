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

    describe '.get', ->

        it 'should call request with proper parameters', ->
            calls = []
            client.request = (_url, _callback) -> calls.push [_url, _callback]
            client.getCallback = () -> 'aCallback'
            client.getUrl = (path) -> return path

            client.get 'foobar', {callback: () ->}
            calls.should.deep.equal [['foobar', 'aCallback']]

    describe '.getProjects', ->

        it 'should call .get() with proper path', ->
            path = null
            options = null

            client.get = (_path, _options) ->
                path = _path
                options = _options

            client.getProjects()
            path.should.equal 'projects'

        it 'should call callback for array of projects', ->
            client.request = (url, callback) ->
                callback('err', 'res', {projects: [{project: 1}, {project: 2}]})

            called = []
            client.getProjects (projects) ->
                for project in projects
                    called.push project

            called.should.deep.equal [1, 2]

    describe '.getProject', ->

        it 'should call .get() with proper url/callback', ->
            calls = []
            client.get = (_path, _options) -> calls.push [_path, _options]

            callbackCallsCount = 0
            callback = () -> callbackCallsCount += 1
            client.getProject(1007, callback)
            calls.length.should.equal 1
            calls[0][0].should.equal 'projects/1007'

            callbackCallsCount.should.equal 0
            calls[0][1].callback('err', 'res', {project: {}})
            callbackCallsCount.should.equal 1

    describe '.getChangesets', ->

        it 'should call .get() with proper path', ->
            path = null

            client.get = (_path, _options) -> path = _path

            client.getChangesets(101)
            path.should.equal 'projects/101/changesets'

        it 'should call callback for array of changesets', ->
            client.request = (url, callback) ->
                callback('err', 'res', {changesets: [{changeset: 1}, {changeset: 2}]})

            called = []
            client.getChangesets 101, (changesets) ->
                for changeset in changesets
                    called.push changeset

            called.should.deep.equal [1, 2]

    describe '.getTickets', ->

        it 'should call .get() with proper path/options', ->
            path = null
            options = null

            client.get = (_path, _options) ->
                path = _path
                options = _options

            callback = () ->
            client.getTickets(101, callback, limit=50, page=3, query='state:open')
            path.should.equal 'projects/101/tickets'
            options.params.should.deep.equal {limit: 50, page: 3, q: 'state:open'}

        it 'should call callback for array of tickets', ->
            client.request = (url, callback) ->
                callback('err', 'res', {tickets: [{ticket: 'a'}, {ticket: 'b'}]})

            called = []
            client.getTickets 101, (tickets) ->
                for ticket in tickets
                    called.push ticket

            called.should.deep.equal ['a', 'b']

    describe ".getTicket", ->

        it 'should call .get() with proper path', ->
            path = null
            client.get = (_path, _options) -> path = _path
            client.getTicket 102, 19
            path.should.equal 'projects/102/tickets/19'

        it 'should call callback with proper data', ->
            calls = []
            client.request = (url, callback) ->
                callback 'err', 'res', {ticket: 'foobar'}
            client.getTicket 102, 32, (ticket) ->
                calls.push ticket

            calls.should.deep.equal ['foobar']

    describe '.getMilestones', ->

        it 'should call .get() with proper path', ->
            path = null
            options = null

            client.get = (_path, _options) ->
                path = _path
                options = _options

            client.getMilestones 101, () ->
            path.should.equal 'projects/101/milestones'

        it 'should call callback for array of milestones', ->
            client.request = (url, callback) ->
                callback('err', 'res', {milestones: [{milestone: 'a'}, {milestone: 'b'}]})

            called = []
            client.getMilestones 101, (milestones) ->
                for milestone in milestones
                    called.push milestone

            called.should.deep.equal ['a', 'b']

    describe ".getMilestone", ->

        it 'should call .get() with proper path', ->
            path = null
            client.get = (_path, _options) -> path = _path
            client.getMilestone 102, 19
            path.should.equal 'projects/102/milestones/19'

        it 'should call callback with proper data', ->
            calls = []
            client.request = (url, callback) ->
                callback 'err', 'res', {milestone: 'foobar'}
            client.getMilestone 102, 32, (milestone) ->
                calls.push milestone

            calls.should.deep.equal ['foobar']

    describe ".getProfile", ->

        it 'should call .get() with proper path', ->
            path = null
            client.get = (_path, _options) -> path = _path
            client.getProfile()
            path.should.equal 'profile'

        it 'should call callback with proper data', ->
            calls = []
            client.request = (url, callback) ->
                callback 'err', 'res', {user: 'foobar'}
            client.getProfile (user) ->
                calls.push user

            calls.should.deep.equal ['foobar']

    describe ".getUser", ->

        it 'should call .get() with proper path', ->
            path = null
            client.get = (_path, _options) -> path = _path
            client.getUser 34
            path.should.equal 'users/34'

        it 'should call callback with proper data', ->
            calls = []
            client.request = (url, callback) ->
                callback 'err', 'res', {user: 'foobar'}
            client.getUser 34, (user) ->
                calls.push user

            calls.should.deep.equal ['foobar']

 
