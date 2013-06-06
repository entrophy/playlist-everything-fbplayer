this.FBService = (function() {
  function FBService() {
    this.type = null;
    this.url = null;
    this.nextUrl = null;
    this.request = 0;
  }

  FBService.prototype.setType = function(type) {
    this.type = type;
  };

  FBService.prototype.setUrl = function(url) {
    this.url = $.trim(url);
    this.url = this.url.split('?');
    return this.url = this.url.shift();
  };

  FBService.prototype.getUrl = function() {
    return this.url;
  };

  FBService.prototype.getItemUrl = function() {
    return this.url + '/feed';
  };

  FBService.prototype.getNextItemUrl = function() {
    if (this.nextUrl) {
      return this.nextUrl;
    } else {
      return this.url + '/feed';
    }
  };

  FBService.prototype.getPage = function(callback) {
    var err, page,
      _this = this;

    err = null;
    page = null;
    if (this.getUrl()) {
      return (function(r) {
        return FB.api(_this.getItemUrl(), function(response) {
          if (r === _this.request) {
            if (response.error) {
              switch (response.error.code) {
                case 803:
                  err = "invalid";
                  break;
                default:
                  err = "private";
              }
              return callback(err, page);
            } else {
              return (function(r) {
                return FB.api(_this.getUrl(), function(response) {
                  if (r === _this.request) {
                    if (response.error) {
                      switch (response.error.code) {
                        case 803:
                          err = "invalid";
                          break;
                        case 104:
                          err = "private";
                      }
                      return callback(err, page);
                    } else {
                      page = response;
                      return callback(err, page);
                    }
                  }
                });
              })(_this.request);
            }
          }
        });
      })(this.request);
    }
  };

  FBService.prototype.getGroups = function(callback) {
    var err, groups,
      _this = this;

    err = null;
    groups = [];
    return (function(r) {
      return FB.api('/me/groups', function(response) {
        if (r === _this.request) {
          groups = response.data;
          return callback(err, groups);
        }
      });
    })(this.request);
  };

  FBService.prototype.getItems = function(callback) {
    var err, items,
      _this = this;

    err = null;
    items = [];
    return (function(r) {
      return FB.api(_this.getNextItemUrl(), function(response) {
        if (r === _this.request) {
          if (response.error) {
            switch (response.error.code) {
              case 803:
                err = "invalid";
                break;
              default:
                err = "private";
            }
            return callback(err, items);
          } else {
            if (response.paging) {
              _this.nextUrl = response.paging.next;
            }
            items = response.data;
            return callback(err, items);
          }
        }
      });
    })(this.request);
  };

  FBService.prototype.clear = function() {
    this.type = null;
    this.url = null;
    this.nextUrl = null;
    return this.request++;
  };

  return FBService;

})();
