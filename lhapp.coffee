
BASE_URL = "lighthouseapp.com"


class Client

    constructor: (@name, @token) ->

    get: (path) ->
        return [{id: 1, name: 'Foo'}, {id:2, name: 'Bar'}]

    getUrl: (path, options) ->
        options = options or {}
        format = options.format or 'json'
        params = options.params or {}
        query = ("#{key}=#{value}" for key, value of params).join "&"
        if query
            query = "&#{query}"
        return "http://#{@name}.#{BASE_URL}/#{path}.#{format}?_token=#{@token}#{query}"

    
exports.BASE_URL = BASE_URL
exports.Client = Client

