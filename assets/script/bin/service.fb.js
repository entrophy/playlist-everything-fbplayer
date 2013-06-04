// Generated by CoffeeScript 1.6.2
(function() {
  this.FBService = (function() {
    function FBService() {
      this._posts = [];
      this._url = null;
      this._nextUrl = null;
    }

    FBService.prototype.setPageUrl = function(url) {
      return this._url = $.trim(url);
    };

    FBService.prototype.getPageUrl = function() {
      return this._url;
    };

    FBService.prototype.getPostUrl = function() {
      return this._url + '/posts';
    };

    FBService.prototype.getNextPostUrl = function() {
      if (this._nextUrl) {
        return this._nextUrl;
      } else {
        return this._url + '/posts';
      }
    };

    FBService.prototype.getPage = function(callback) {
      var err, page,
        _this = this;

      err = null;
      page = null;
      if (this.getPageUrl()) {
        return FB.api(this.getPostUrl(), function(response) {
          console.log(response);
          if (response.error) {
            switch (response.error.code) {
              case 803:
                err = "invalid";
                break;
              case 104:
                err = "private";
            }
            console.log("HER FØRST");
            return callback(err, page);
          } else {
            return FB.api(_this.getPageUrl(), function(response) {
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
                console.log("HER BAGEFTER");
                return callback(err, page);
              }
            });
          }
        });
      }
    };

    FBService.prototype.getPosts = function(callback) {
      var err, posts,
        _this = this;

      err = null;
      posts = [];
      return FB.api(this.getNextPostUrl(), function(response) {
        console.log(response);
        if (response.error) {
          switch (response.error.code) {
            case 803:
              err = "invalid";
              break;
            case 104:
              err = "private";
          }
          return callback(err, posts);
        } else {
          console.log(response.paging);
          if (response.paging) {
            _this._nextUrl = response.paging.next;
          }
          posts = response.data;
          return callback(err, posts);
        }
      });
    };

    FBService.prototype.clear = function() {
      this._posts = [];
      this._url = null;
      return this._nextUrl = null;
    };

    return FBService;

  })();

}).call(this);