request = require 'request'
_ = require 'underscore'

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
            callback(_.map(data.projects, (p) -> p.project))
        }

    getProject: (id, callback) ->
        @get "projects/#{id}", {callback: (err, res, data) ->
            callback(data.project)
        }



exports.BASE_URL = BASE_URL
exports.Client = Client

