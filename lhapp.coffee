request = require 'request'

BASE_URL = "lighthouseapp.com"


getOptions = (options) ->
    options = options or {}
    options.format = options.format or 'json'
    options.params = options.params or {}
    return options


class Client

    constructor: (@name, @token) ->
        @request = request

    getUrl: (path, options) ->
        options = getOptions(options)
        query = ("#{key}=#{value}" for key, value of options.params).join "&"
        if query
            query = "&#{query}"
        return "http://#{@name}.#{BASE_URL}/#{path}.#{options.format}?_token=#{@token}#{query}"

    getCallback: (options) ->
        return (err, res, body) ->
            if not err
                body = JSON.parse(body)
            options.callback(err, res, body)

    get: (path, options) ->
        options = getOptions(options)
        url = @getUrl path, options
        callback = @getCallback(options)
        @request url, callback

    getProjects: (callback) ->
        @get 'projects', {callback: (err, res, data) ->
            callback((p.project for p in data.projects))
        }

    getProject: (id, callback) ->
        @get "projects/#{id}", {callback: (err, res, data) ->
            callback(data.project)
        }

    getChangesets: (id, callback) ->
        @get "projects/#{id}/changesets", {callback: (err, res, data) ->
            callback((c.changeset for c in data.changesets))
        }

    getTickets: (id, callback, limit=30, page=1, query='') ->
        params = {"limit": limit, "page": page}
        if query
            params.q = query

        @get "projects/#{id}/tickets", {
            callback: (err, res, data) ->
                callback((t.ticket for t in data.tickets))
            "params": params
        }

    getTicket: (id, number, callback) ->
        @get "projects/#{id}/tickets/#{number}", {callback: (err, res, data) ->
            callback(data.ticket)
        }

    getMilestones: (id, callback) ->
        @get "projects/#{id}/milestones", {callback: (err, res, data) ->
            callback((m.milestone for m in data.milestones))
        }

    getMilestone: (id, milestoneId, callback) ->
        @get "projects/#{id}/milestones/#{milestoneId}", {callback: (err, res, data) ->
            callback(data.milestone)
        }

    getProfile: (callback) ->
        @get "profile", {callback: (err, res, data) ->
            callback(data.user)
        }

    getUser: (id, callback) ->
        @get "users/#{id}", {callback: (err, res, data) ->
            callback(data.user)
        }


exports.BASE_URL = BASE_URL
exports.Client = Client

