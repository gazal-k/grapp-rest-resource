prepareUrl = (url, params = {}, id = null, action = null) ->
  params = JSON.parse(params) if typeof(params) == 'string'
  for name, value of params
    url = url.replace ":#{name}", value
  url = url.replace ':id', id || ''
  url = url.replace /\/\/+/g, '/'
  url = url.replace /^(\w+):\//, '$1://'
  url = url.replace /\/$/, ''
  if action
    url += "/#{action}"
  url


Polymer 'grapp-rest-resource',

  created: ->
    @headers = {}
    self = @

    @resource =
      index: (success, error) ->
        self.$.xhr.request
          url: prepareUrl self.indexUrl || self.url, self.params
          headers: self.prepareHeaders()
          callback: (data, response) ->
            json = (if data.trim() != '' then JSON.parse data else {})
            switch response.status
              when 200 then success? json
              when 401 then self.fire 'grapp-authentication-error'
              else
                error? json

      show: (id, success, error) ->
        self.$.xhr.request
          url: prepareUrl self.showUrl || self.url, self.params, id
          headers: self.prepareHeaders()
          callback: (data, response) ->
            json = (if data.trim() != '' then JSON.parse data else {})
            switch response.status
              when 200 then success? json
              when 401 then self.fire 'grapp-authentication-error'
              else
                error? json

      new: (success, error) ->
        self.$.xhr.request
          url: prepareUrl self.newUrl || self.url, self.params, null, 'new'
          headers: self.prepareHeaders()
          callback: (data, response) ->
            json = (if data.trim() != '' then JSON.parse data else {})
            switch response.status
              when 200 then success? json
              when 401 then self.fire 'grapp-authentication-error'
              else
                error? json

      create: (data, success, error) ->
        self.$.xhr.request
          method: 'POST'
          url: prepareUrl self.createUrl || self.url, self.params
          headers: self.prepareHeaders()
          body: JSON.stringify data
          callback: (data, response) ->
            json = (if data.trim() != '' then JSON.parse data else {})
            switch response.status
              when 200 then success? json
              when 401 then self.fire 'grapp-authentication-error'
              else
                error? json

      update: (id, data, success, error) ->
        self.$.xhr.request
          method: 'PUT'
          url: prepareUrl self.updateUrl || self.url, self.params, id
          headers: self.prepareHeaders()
          body: JSON.stringify data
          callback: (data, response) ->
            json = (if data.trim() != '' then JSON.parse data else {})
            switch response.status
              when 200 then success? json
              when 401 then self.fire 'grapp-authentication-error'
              else
                error? json

      delete: (id, success, error) ->
        self.$.xhr.request
          method: 'DELETE'
          url: prepareUrl self.deleteUrl || self.url, self.params, id
          headers: self.prepareHeaders()
          callback: (data, response) ->
            json = (if data.trim() != '' then JSON.parse data else {})
            switch response.status
              when 200 then success? json
              when 401 then self.fire 'grapp-authentication-error'
              else
                error? json

      memberAction: (id, action, success, error) ->
        self.$.xhr.request
          method: 'PUT'
          url: prepareUrl self.memberUrl || self.url, self.params, id, action
          headers: self.prepareHeaders()
          callback: (data, response) ->
            switch response.status
              when 200 then success?()
              when 401 then self.fire 'grapp-authentication-error'
              else
                error?()

  prepareHeaders: ->
    h = {'Accept': 'application/json'}
    for key, val of @headers
      h[key] = val
    h['Authorization'] = @token if @token
    h
